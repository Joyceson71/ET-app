import { createClient } from '@/lib/supabase/server';
import { createServiceClient } from '@/lib/supabase/server';
import { NextResponse } from 'next/server';
import { z } from 'zod';

const quizSchema = z.object({
  answers: z.array(z.number().min(0).max(3)).length(3),
  skipQuiz: z.boolean().optional().default(false),
});

export async function POST(
  request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
  const dayId = parseInt(id);
  const supabase = await createClient();

  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });

  const body = await request.json();
  const parsed = quizSchema.safeParse(body);
  if (!parsed.success) return NextResponse.json({ error: 'Invalid request' }, { status: 400 });

  const { answers, skipQuiz } = parsed.data;

  // Handle quiz skip (once per week)
  if (skipQuiz) {
    const weekStart = getWeekStart();
    const { data: existingSkip } = await supabase
      .from('quiz_skips')
      .select('id')
      .eq('user_id', user.id)
      .eq('week_start', weekStart)
      .single();

    if (existingSkip) {
      return NextResponse.json({ error: 'Quiz skip already used this week' }, { status: 400 });
    }

    await supabase.from('quiz_skips').insert({ user_id: user.id, day_id: dayId, week_start: weekStart });
    await unlockNextDay(supabase, user.id, dayId);
    return NextResponse.json({ passed: true, skipped: true, score: 0, xpEarned: 0 });
  }

  // Get quizzes WITH answers (server-side only)
  const serviceClient = await createServiceClient();
  const { data: quizzes } = await serviceClient
    .from('quizzes')
    .select('id, answer')
    .eq('day_id', dayId)
    .order('id');

  if (!quizzes || quizzes.length === 0) {
    return NextResponse.json({ error: 'No quizzes found for this day' }, { status: 404 });
  }

  // Score answers
  let correct = 0;
  for (let i = 0; i < quizzes.length; i++) {
    if (answers[i] === quizzes[i].answer) correct++;
  }

  const passed = correct >= 2; // Pass with 2/3 correct
  const firstTry = await isFirstAttempt(supabase, user.id, quizzes[0].id);

  // Save quiz result
  await supabase.from('quiz_results').insert({
    user_id: user.id,
    day_id: dayId,
    quiz_id: quizzes[0].id,
    passed,
    score: correct,
  });

  if (passed) {
    // Award XP
    let xpEarned = 50; // Base day completion XP
    if (firstTry) xpEarned += 20; // Bonus for first try

    // Update user XP and unlock next day
    await Promise.all([
      supabase.rpc('increment_xp', { user_id_param: user.id, xp_amount: xpEarned }),
      updateDayProgress(supabase, user.id, dayId, xpEarned),
      unlockNextDay(supabase, user.id, dayId),
    ]);

    return NextResponse.json({ passed, score: correct, total: quizzes.length, xpEarned, firstTry });
  }

  return NextResponse.json({ passed, score: correct, total: quizzes.length, xpEarned: 0 });
}

async function isFirstAttempt(supabase: Awaited<ReturnType<typeof createClient>>, userId: string, quizId: string) {
  const { data } = await supabase
    .from('quiz_results')
    .select('id')
    .eq('user_id', userId)
    .eq('quiz_id', quizId)
    .limit(1);
  return !data || data.length === 0;
}

async function updateDayProgress(supabase: Awaited<ReturnType<typeof createClient>>, userId: string, dayId: number, xpEarned: number) {
  await supabase.from('day_progress').upsert({
    user_id: userId,
    day_id: dayId,
    status: 'completed',
    completed_at: new Date().toISOString(),
    xp_earned: xpEarned,
  }, { onConflict: 'user_id,day_id' });
}

async function unlockNextDay(supabase: Awaited<ReturnType<typeof createClient>>, userId: string, currentDayId: number) {
  const nextDayId = currentDayId + 1;
  if (nextDayId > 120) return;

  await supabase.from('day_progress').upsert({
    user_id: userId,
    day_id: nextDayId,
    status: 'available',
  }, { onConflict: 'user_id,day_id', ignoreDuplicates: true });
}

function getWeekStart(): string {
  const now = new Date();
  const day = now.getDay();
  const diff = now.getDate() - day + (day === 0 ? -6 : 1);
  const monday = new Date(now.setDate(diff));
  return monday.toISOString().split('T')[0];
}

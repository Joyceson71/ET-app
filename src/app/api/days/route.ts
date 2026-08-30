import { createClient } from '@/lib/supabase/server';
import { NextResponse } from 'next/server';

export async function GET(request: Request) {
  const supabase = await createClient();
  const { searchParams } = new URL(request.url);
  const page = parseInt(searchParams.get('page') || '1');
  const phase = searchParams.get('phase');
  const limit = 20;
  const from = (page - 1) * limit;

  let query = supabase
    .from('days')
    .select('id, phase, title, lab_url, lab_platform, xp_reward', { count: 'exact' })
    .order('id');

  if (phase) query = query.eq('phase', parseInt(phase));

  const { data, error, count } = await query.range(from, from + limit - 1);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  // Get user progress if authenticated
  const { data: { user } } = await supabase.auth.getUser();
  if (user) {
    const { data: progress } = await supabase
      .from('day_progress')
      .select('day_id, status, lab_done, xp_earned')
      .eq('user_id', user.id);

    const progressMap = Object.fromEntries((progress || []).map(p => [p.day_id, p]));
    const daysWithProgress = (data || []).map(day => ({
      ...day,
      progress: progressMap[day.id] || { status: 'locked', lab_done: false, xp_earned: 0 }
    }));

    return NextResponse.json({ days: daysWithProgress, total: count, page, limit });
  }

  return NextResponse.json({ days: data, total: count, page, limit });
}

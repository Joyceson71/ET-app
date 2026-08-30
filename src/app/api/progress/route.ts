import { createClient } from '@/lib/supabase/server';
import { NextResponse } from 'next/server';
import { PHASE_COLORS, PHASE_TITLES } from '@/types';

export async function GET() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });

  const [userResult, progressResult] = await Promise.all([
    supabase.from('users').select('xp, streak, last_active_date, created_at').eq('id', user.id).single(),
    supabase.from('day_progress').select('day_id, status, completed_at').eq('user_id', user.id),
  ]);

  const userData = userResult.data;
  const progress = progressResult.data || [];

  const completedDays = progress.filter(p => p.status === 'completed').length;
  const inProgressDays = progress.filter(p => p.status === 'in_progress').length;

  // Phase progress
  const phaseProgress = [1, 2, 3, 4, 5, 6].map(phase => {
    const phaseRange = { start: (phase - 1) * 20 + 1, end: phase * 20 };
    const phaseDays = progress.filter(p => p.day_id >= phaseRange.start && p.day_id <= phaseRange.end);
    const phaseCompleted = phaseDays.filter(p => p.status === 'completed').length;
    return {
      phase,
      title: PHASE_TITLES[phase],
      total: 20,
      completed: phaseCompleted,
      color: PHASE_COLORS[phase],
    };
  });

  // Calendar data (last 90 days)
  const calendarData = buildCalendarData(progress, 90);

  // Estimated completion date
  const daysRemaining = 120 - completedDays;
  const commitment = 1; // Default 1 day/day, could be fetched from user profile
  const estimatedCompletion = completedDays > 0
    ? new Date(Date.now() + daysRemaining * commitment * 24 * 60 * 60 * 1000).toISOString().split('T')[0]
    : null;

  return NextResponse.json({
    total_days: 120,
    completed_days: completedDays,
    in_progress_days: inProgressDays,
    total_xp: userData?.xp || 0,
    streak: userData?.streak || 0,
    phase_progress: phaseProgress,
    calendar_data: calendarData,
    estimated_completion: estimatedCompletion,
  });
}

function buildCalendarData(progress: Array<{ day_id: number; status: string; completed_at: string | null }>, days: number) {
  const calendar: Array<{ date: string; status: string }> = [];
  const completedDates = new Set(
    progress
      .filter(p => p.status === 'completed' && p.completed_at)
      .map(p => p.completed_at!.split('T')[0])
  );

  for (let i = days - 1; i >= 0; i--) {
    const date = new Date(Date.now() - i * 24 * 60 * 60 * 1000).toISOString().split('T')[0];
    calendar.push({
      date,
      status: completedDates.has(date) ? 'completed' : 'none',
    });
  }

  return calendar;
}

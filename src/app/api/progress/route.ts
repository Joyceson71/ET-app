import { NextResponse } from "next/server";
import { getServerSession } from "next-auth";
import { authOptions } from "@/lib/auth";
import { prisma } from "@/lib/prisma";
import { PHASE_COLORS, PHASE_TITLES } from "@/types";

export async function GET() {
  const session = await getServerSession(authOptions);
  
  if (!session?.user)
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const [userData, progressResult] = await Promise.all([
    prisma.user.findUnique({
      where: { id: session.user.id },
      select: { xp: true, streak: true, lastActiveDate: true, createdAt: true }
    }),
    prisma.dayProgress.findMany({
      where: { userId: session.user.id },
      select: { dayId: true, status: true, completedAt: true }
    }),
  ]);

  const progress = progressResult.map(p => ({
    day_id: p.dayId,
    status: p.status,
    completed_at: p.completedAt ? p.completedAt.toISOString() : null
  }));

  const completedDays = progress.filter((p) => p.status === "completed").length;
  const inProgressDays = progress.filter(
    (p) => p.status === "in_progress",
  ).length;

  // Phase progress
  const phaseProgress = [1, 2, 3, 4, 5, 6].map((phase) => {
    const phaseRange = { start: (phase - 1) * 20 + 1, end: phase * 20 };
    const phaseDays = progress.filter(
      (p) => p.day_id >= phaseRange.start && p.day_id <= phaseRange.end,
    );
    const phaseCompleted = phaseDays.filter(
      (p) => p.status === "completed",
    ).length;
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
  const estimatedCompletion =
    completedDays > 0
      ? new Date(Date.now() + daysRemaining * commitment * 24 * 60 * 60 * 1000)
          .toISOString()
          .split("T")[0]
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

function buildCalendarData(
  progress: Array<{
    day_id: number;
    status: string;
    completed_at: string | null;
  }>,
  days: number,
) {
  const calendar: Array<{ date: string; status: string }> = [];
  const completedDates = new Set(
    progress
      .filter((p) => p.status === "completed" && p.completed_at)
      .map((p) => p.completed_at!.split("T")[0]),
  );

  for (let i = days - 1; i >= 0; i--) {
    const date = new Date(Date.now() - i * 24 * 60 * 60 * 1000)
      .toISOString()
      .split("T")[0];
    calendar.push({
      date,
      status: completedDates.has(date) ? "completed" : "none",
    });
  }

  return calendar;
}

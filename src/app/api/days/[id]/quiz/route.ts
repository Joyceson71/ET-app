import { NextResponse } from "next/server";
import { getServerSession } from "next-auth";
import { authOptions } from "@/lib/auth";
import { prisma } from "@/lib/prisma";
import { z } from "zod";
import { updateUserStreak } from "@/lib/streak";

const quizSchema = z.object({
  answers: z.array(z.number().min(0).max(3)),
  skipQuiz: z.boolean().optional().default(false),
});

export async function POST(
  request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const { id } = await params;
  const dayId = parseInt(id);

  const session = await getServerSession(authOptions);
  
  if (!session?.user)
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const userId = session.user.id;
  const body = await request.json();
  const parsed = quizSchema.safeParse(body);
  
  if (!parsed.success)
    return NextResponse.json({ error: "Invalid request" }, { status: 400 });

  const { answers, skipQuiz } = parsed.data;

  // Handle quiz skip (once per week)
  if (skipQuiz) {
    const weekStart = getWeekStart();
    const existingSkip = await prisma.quizSkip.findUnique({
      where: {
        userId_weekStart: {
          userId: userId,
          weekStart: weekStart,
        }
      }
    });

    if (existingSkip) {
      return NextResponse.json(
        { error: "Quiz skip already used this week" },
        { status: 400 },
      );
    }

    await prisma.quizSkip.create({
      data: { userId, dayId, weekStart }
    });
    
    await unlockNextDay(userId, dayId);
    
    return NextResponse.json({
      passed: true,
      skipped: true,
      score: 0,
      xpEarned: 0,
    });
  }

  // Get quizzes WITH answers
  const quizzes = await prisma.quiz.findMany({
    where: { dayId },
    select: { id: true, answer: true },
    orderBy: { id: "asc" }
  });

  if (!quizzes || quizzes.length === 0) {
    return NextResponse.json(
      { error: "No quizzes found for this day" },
      { status: 404 },
    );
  }

  // Score answers
  let correct = 0;
  for (let i = 0; i < quizzes.length; i++) {
    if (answers[i] === quizzes[i].answer) correct++;
  }

  const passingScore = Math.max(1, Math.ceil(quizzes.length * 0.66));
  const passed = correct >= passingScore;
  const firstTry = await isFirstAttempt(userId, quizzes[0].id);

  // Save quiz result
  await prisma.quizResult.create({
    data: {
      userId,
      dayId,
      quizId: quizzes[0].id,
      passed,
      score: correct,
    }
  });

  if (passed) {
    // Award XP
    let xpEarned = 50; // Base day completion XP
    if (firstTry) xpEarned += 20; // Bonus for first try

    // Update user XP and unlock next day
    await Promise.all([
      prisma.user.update({
        where: { id: userId },
        data: { xp: { increment: xpEarned } }
      }),
      updateDayProgress(userId, dayId, xpEarned),
      unlockNextDay(userId, dayId),
      updateUserStreak(userId),
    ]);

    return NextResponse.json({
      passed,
      score: correct,
      total: quizzes.length,
      xpEarned,
      firstTry,
    });
  }

  return NextResponse.json({
    passed,
    score: correct,
    total: quizzes.length,
    xpEarned: 0,
  });
}

async function isFirstAttempt(
  userId: string,
  quizId: number,
) {
  const result = await prisma.quizResult.findFirst({
    where: { userId, quizId }
  });
  return !result;
}

async function updateDayProgress(
  userId: string,
  dayId: number,
  xpEarned: number,
) {
  await prisma.dayProgress.upsert({
    where: {
      userId_dayId: { userId, dayId }
    },
    update: {
      status: "completed",
      completedAt: new Date(),
      xpEarned, // This might just set it, but we can do increment if we want. The original code just set it.
    },
    create: {
      userId,
      dayId,
      status: "completed",
      completedAt: new Date(),
      xpEarned,
    }
  });
}

async function unlockNextDay(
  userId: string,
  currentDayId: number,
) {
  const nextDayId = currentDayId + 1;
  if (nextDayId > 120) return;

  // We use upsert to only create if it doesn't exist, or just leave it if it does
  await prisma.dayProgress.upsert({
    where: {
      userId_dayId: { userId, dayId: nextDayId }
    },
    update: {}, // Do nothing if it already exists
    create: {
      userId,
      dayId: nextDayId,
      status: "available",
    }
  });
}

function getWeekStart(): string {
  const now = new Date();
  const day = now.getDay();
  const diff = now.getDate() - day + (day === 0 ? -6 : 1);
  const monday = new Date(now.setDate(diff));
  return monday.toISOString().split("T")[0];
}

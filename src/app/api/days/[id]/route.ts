import { NextResponse } from "next/server";
import { getServerSession } from "next-auth";
import { authOptions } from "@/lib/auth";
import { prisma } from "@/lib/prisma";

export async function GET(
  _request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const { id } = await params;
  const dayId = parseInt(id);

  if (isNaN(dayId)) {
    return NextResponse.json({ error: "Invalid day ID" }, { status: 400 });
  }

  // Get day with resources and quizzes
  const dayResult = await prisma.day.findUnique({
    where: { id: dayId },
    include: {
      resources: {
        include: {
          resource: true,
        },
      },
      quizzes: {
        select: {
          id: true,
          question: true,
          options: true,
          dayId: true,
          // Exclude answer!
        },
      },
    },
  });

  if (!dayResult)
    return NextResponse.json({ error: "Day not found" }, { status: 404 });

  const session = await getServerSession(authOptions);
  let progress = null;
  let notes = null;

  if (session?.user) {
    const [progressResult, notesResult] = await Promise.all([
      prisma.dayProgress.findUnique({
        where: {
          userId_dayId: {
            userId: session.user.id,
            dayId: dayId
          }
        }
      }),
      prisma.note.findUnique({
        where: {
          userId_dayId: {
            userId: session.user.id,
            dayId: dayId
          }
        }
      })
    ]);
    
    if (progressResult) {
      progress = {
        ...progressResult,
        user_id: progressResult.userId,
        day_id: progressResult.dayId,
        lab_done: progressResult.labDone,
        xp_earned: progressResult.xpEarned,
        completed_at: progressResult.completedAt?.toISOString() || null
      };
    }
    
    if (notesResult) {
      notes = [
        {
          ...notesResult,
          user_id: notesResult.userId,
          day_id: notesResult.dayId,
          created_at: notesResult.createdAt.toISOString(),
          updated_at: notesResult.updatedAt.toISOString(),
        }
      ]; // UI expects array based on DayWithExtras type notes: Note[]
    }
  }

  const formattedDay = {
    ...dayResult,
    lab_url: dayResult.labUrl,
    lab_platform: dayResult.labPlatform,
    xp_reward: dayResult.xpReward,
  };

  return NextResponse.json({
    ...formattedDay,
    resources: dayResult.resources.map((r) => ({
      ...r.resource,
      is_free: r.resource.isFree,
    })),
    quizzes: dayResult.quizzes.map(q => ({
      ...q,
      day_id: q.dayId,
      options: JSON.parse(q.options)
    })),
    progress,
    notes: notes || [],
  });
}

import { NextResponse } from "next/server";
import { getServerSession } from "next-auth";
import { authOptions } from "@/lib/auth";
import { prisma } from "@/lib/prisma";

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const page = parseInt(searchParams.get("page") || "1");
  const phase = searchParams.get("phase");
  const limit = 20;
  const skip = (page - 1) * limit;

  const whereClause: any = {};
  if (phase) whereClause.phase = parseInt(phase);

  try {
    const [data, count] = await Promise.all([
      prisma.day.findMany({
        where: whereClause,
        select: {
          id: true,
          phase: true,
          title: true,
          labUrl: true,
          labPlatform: true,
          xpReward: true,
        },
        orderBy: { id: "asc" },
        skip,
        take: limit,
      }),
      prisma.day.count({ where: whereClause })
    ]);

    const formattedData = data.map(day => ({
      id: day.id,
      phase: day.phase,
      title: day.title,
      lab_url: day.labUrl,
      lab_platform: day.labPlatform,
      xp_reward: day.xpReward,
    }));

    // Get user progress if authenticated
    const session = await getServerSession(authOptions);
    if (session?.user) {
      const progress = await prisma.dayProgress.findMany({
        where: { userId: session.user.id },
        select: { dayId: true, status: true, labDone: true, xpEarned: true }
      });

      const progressMap = Object.fromEntries(
        progress.map((p) => [
          p.dayId,
          {
            day_id: p.dayId,
            status: p.status,
            lab_done: p.labDone,
            xp_earned: p.xpEarned,
          }
        ])
      );

      const daysWithProgress = formattedData.map((day) => ({
        ...day,
        progress: progressMap[day.id] || {
          status: "locked",
          lab_done: false,
          xp_earned: 0,
        },
      }));

      return NextResponse.json({
        days: daysWithProgress,
        total: count,
        page,
        limit,
      });
    }

    return NextResponse.json({ days: formattedData, total: count, page, limit });
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}

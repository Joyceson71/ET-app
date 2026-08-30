import { NextResponse } from "next/server";
import { getServerSession } from "next-auth";
import { authOptions } from "@/lib/auth";
import { prisma } from "@/lib/prisma";
import { labScenarios } from "@/lib/labScenarios";

export async function POST(
  req: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const session = await getServerSession(authOptions);
    if (!session?.user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { id } = await params;
    const dayId = parseInt(id);
    const body = await req.json();
    const { flag } = body;

    if (!flag) {
      return NextResponse.json({ error: "Flag is required" }, { status: 400 });
    }

    const scenario = labScenarios[dayId];
    if (!scenario) {
      return NextResponse.json({ error: "No lab scenario exists for this day" }, { status: 404 });
    }

    if (flag !== scenario.flag) {
      return NextResponse.json({ error: "Incorrect flag" }, { status: 400 });
    }

    // Flag is correct, update DayProgress
    let progress = await prisma.dayProgress.findUnique({
      where: {
        userId_dayId: {
          userId: session.user.id,
          dayId: dayId,
        },
      },
    });

    if (progress && progress.labDone) {
      return NextResponse.json({ message: "Lab already completed!" });
    }

    if (!progress) {
      progress = await prisma.dayProgress.create({
        data: {
          userId: session.user.id,
          dayId: dayId,
          status: "in_progress",
          labDone: true,
          xpEarned: 25,
        }
      });
    } else {
      progress = await prisma.dayProgress.update({
        where: {
          userId_dayId: {
            userId: session.user.id,
            dayId: dayId,
          },
        },
        data: {
          labDone: true,
          xpEarned: progress.xpEarned + 25,
        },
      });
    }

    // Update user's total XP
    await prisma.user.update({
      where: { id: session.user.id },
      data: { xp: { increment: 25 } },
    });

    return NextResponse.json({ message: "Flag accepted! Lab complete. +25 XP", success: true });
  } catch (error) {
    console.error("Flag submission error:", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}

import { NextResponse } from "next/server";
import { getServerSession } from "next-auth";
import { authOptions } from "@/lib/auth";
import { prisma } from "@/lib/prisma";

export async function GET() {
  const [nodesResult, edgesResult] = await Promise.all([
    prisma.skillNode.findMany(),
    prisma.skillPrerequisite.findMany(),
  ]);

  const session = await getServerSession(authOptions);
  let userProgress: Record<number, string> = {};

  if (session?.user) {
    const progress = await prisma.dayProgress.findMany({
      where: { userId: session.user.id },
      select: { dayId: true, status: true }
    });

    if (progress) {
      userProgress = Object.fromEntries(
        progress.map((p) => [p.dayId, p.status]),
      );
    }
  }

  // Calculate node status based on linked days
  const nodes = nodesResult.map((node) => {
    let dayIds: number[] = [];
    try {
      dayIds = JSON.parse(node.dayIds) as number[];
    } catch(e) {
      dayIds = [];
    }
    
    if (dayIds.length === 0) {
      return { 
        ...node, 
        xp_value: node.xpValue,
        estimated_hours: node.estimatedHours,
        day_ids: dayIds,
        status: "locked" 
      };
    }

    const completedCount = dayIds.filter(
      (id) => userProgress[id] === "completed",
    ).length;
    const inProgressCount = dayIds.filter(
      (id) => userProgress[id] === "in_progress",
    ).length;
    const availableCount = dayIds.filter(
      (id) => userProgress[id] === "available",
    ).length;

    let status = "locked";
    if (completedCount === dayIds.length) status = "completed";
    else if (inProgressCount > 0) status = "in_progress";
    else if (availableCount > 0) status = "available";

    return { 
      ...node, 
      xp_value: node.xpValue,
      estimated_hours: node.estimatedHours,
      day_ids: dayIds,
      status 
    };
  });

  const validNodeIds = new Set(nodesResult.map(n => n.id));
  const edges = edgesResult
    .filter(edge => validNodeIds.has(edge.nodeId) && validNodeIds.has(edge.prerequisiteId))
    .map((edge) => ({
      source: edge.prerequisiteId,
      target: edge.nodeId,
    }));

  return NextResponse.json({
    nodes,
    edges,
  });
}

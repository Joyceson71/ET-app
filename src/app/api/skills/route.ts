import { createClient } from "@/lib/supabase/server";
import { NextResponse } from "next/server";

export async function GET() {
  const supabase = await createClient();

  const [nodesResult, edgesResult] = await Promise.all([
    supabase.from("skill_nodes").select("*"),
    supabase.from("skill_edges").select("*"),
  ]);

  // Get user progress to determine node status
  const {
    data: { user },
  } = await supabase.auth.getUser();
  let userProgress: Record<number, string> = {};

  if (user) {
    const { data: progress } = await supabase
      .from("day_progress")
      .select("day_id, status")
      .eq("user_id", user.id);

    if (progress) {
      userProgress = Object.fromEntries(
        progress.map((p) => [p.day_id, p.status]),
      );
    }
  }

  // Calculate node status based on linked days
  const nodes = (nodesResult.data || []).map((node) => {
    const dayIds: number[] = node.day_ids || [];
    if (dayIds.length === 0) return { ...node, status: "locked" };

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

    return { ...node, status };
  });

  return NextResponse.json({
    nodes,
    edges: nodesResult.error ? [] : edgesResult.data || [],
  });
}

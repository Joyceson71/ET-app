import { createClient } from "@/lib/supabase/server";
import { NextResponse } from "next/server";

export async function GET(
  _request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const { id } = await params;
  const dayId = parseInt(id);
  const supabase = await createClient();

  // Get day with resources and quizzes
  const [dayResult, resourcesResult, quizzesResult] = await Promise.all([
    supabase.from("days").select("*").eq("id", dayId).single(),
    supabase
      .from("day_resources")
      .select("resource_id, resources(*)")
      .eq("day_id", dayId),
    supabase
      .from("quizzes")
      .select("id, question, options, day_id") // exclude answer!
      .eq("day_id", dayId),
  ]);

  if (dayResult.error)
    return NextResponse.json({ error: "Day not found" }, { status: 404 });

  const {
    data: { user },
  } = await supabase.auth.getUser();
  let progress = null;
  let notes = null;

  if (user) {
    const [progressResult, notesResult] = await Promise.all([
      supabase
        .from("day_progress")
        .select("*")
        .eq("user_id", user.id)
        .eq("day_id", dayId)
        .single(),
      supabase
        .from("notes")
        .select("*")
        .eq("user_id", user.id)
        .eq("day_id", dayId)
        .single(),
    ]);
    progress = progressResult.data;
    notes = notesResult.data;
  }

  return NextResponse.json({
    ...dayResult.data,
    resources: (resourcesResult.data || []).map((r) => r.resources),
    quizzes: quizzesResult.data || [],
    progress,
    notes,
  });
}

import { createClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";
import DayClient from "./DayClient";

export default async function DayPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const dayId = parseInt(id);

  if (isNaN(dayId)) redirect("/curriculum");

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) redirect("/login");

  // Verify access (locked days shouldn't be viewable)
  if (dayId > 1) {
    const { data: progress } = await supabase
      .from("day_progress")
      .select("status")
      .eq("user_id", user.id)
      .eq("day_id", dayId)
      .single();

    if (
      !progress ||
      (progress.status !== "available" &&
        progress.status !== "completed" &&
        progress.status !== "in_progress")
    ) {
      // Day is locked
      redirect("/curriculum");
    }
  }

  // Pre-fetch day data to pass to client
  // Fetch day detail via API (we do this in the client but we could SSR it here. For simplicity, we just pass ID to client component)
  return <DayClient dayId={dayId} />;
}

import { NextResponse } from "next/server";
import { getServerSession } from "next-auth";
import { authOptions } from "@/lib/auth";
import { prisma } from "@/lib/prisma";

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const type = searchParams.get("type");
  const difficulty = searchParams.get("difficulty");
  const isFree = searchParams.get("free");
  const q = searchParams.get("q");

  const whereClause: any = {};
  if (type) whereClause.type = type;
  if (difficulty) whereClause.difficulty = difficulty;
  if (isFree !== null) whereClause.isFree = isFree === "true";
  if (q) whereClause.title = { contains: q };

  try {
    const data = await prisma.resource.findMany({
      where: whereClause,
      orderBy: { title: "asc" },
      include: {
        dayResources: true,
      }
    });

    const session = await getServerSession(authOptions);
    let bookmarkSet = new Set<number>();

    if (session?.user) {
      const bookmarks = await prisma.bookmark.findMany({
        where: { userId: session.user.id },
        select: { resourceId: true }
      });
      bookmarkSet = new Set(bookmarks.map((b) => b.resourceId));
    }

    const resourcesFormatted = data.map((r) => ({
      ...r,
      is_free: r.isFree,
      day_ids: r.dayResources.map((dr) => dr.dayId),
      is_bookmarked: bookmarkSet.has(r.id),
    }));

    return NextResponse.json(resourcesFormatted);
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}

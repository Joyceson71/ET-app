import { NextResponse } from "next/server";
import { getServerSession } from "next-auth";
import { authOptions } from "@/lib/auth";
import { prisma } from "@/lib/prisma";

export async function POST(
  _request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const { id } = await params;
  const resourceId = parseInt(id, 10);
  
  if (isNaN(resourceId)) {
    return NextResponse.json({ error: "Invalid resource ID" }, { status: 400 });
  }

  const session = await getServerSession(authOptions);
  
  if (!session?.user)
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  // Check if bookmarked
  const existing = await prisma.bookmark.findUnique({
    where: {
      userId_resourceId: {
        userId: session.user.id,
        resourceId: resourceId
      }
    }
  });

  if (existing) {
    await prisma.bookmark.delete({
      where: {
        userId_resourceId: {
          userId: session.user.id,
          resourceId: resourceId
        }
      }
    });
    return NextResponse.json({ bookmarked: false });
  } else {
    await prisma.bookmark.create({
      data: {
        userId: session.user.id,
        resourceId: resourceId
      }
    });
    return NextResponse.json({ bookmarked: true });
  }
}

import { NextResponse } from "next/server";
import { getServerSession } from "next-auth";
import { authOptions } from "@/lib/auth";
import { prisma } from "@/lib/prisma";
import { z } from "zod";
import DOMPurify from "isomorphic-dompurify";

const noteSchema = z.object({
  day_id: z.number().int().min(1).max(120).optional(),
  content: z.string().max(50000),
});

export async function GET(request: Request) {
  const session = await getServerSession(authOptions);
  
  if (!session?.user)
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { searchParams } = new URL(request.url);
  const q = searchParams.get("q");
  const dayId = searchParams.get("day_id");

  const whereClause: any = { userId: session.user.id };
  if (q) whereClause.content = { contains: q };
  if (dayId) whereClause.dayId = parseInt(dayId);

  try {
    const data = await prisma.note.findMany({
      where: whereClause,
      orderBy: { updatedAt: "desc" },
    });

    const formattedData = data.map(note => ({
      ...note,
      user_id: note.userId,
      day_id: note.dayId,
      created_at: note.createdAt.toISOString(),
      updated_at: note.updatedAt.toISOString(),
    }));

    return NextResponse.json(formattedData);
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}

export async function POST(request: Request) {
  const session = await getServerSession(authOptions);
  
  if (!session?.user)
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  try {
    const body = await request.json();
    const parsed = noteSchema.safeParse(body);
    if (!parsed.success)
      return NextResponse.json({ error: "Invalid request" }, { status: 400 });

    // Sanitize content to prevent XSS
    const sanitized = DOMPurify.sanitize(parsed.data.content);

    let data;
    
    if (parsed.data.day_id) {
      data = await prisma.note.upsert({
        where: {
          userId_dayId: {
            userId: session.user.id,
            dayId: parsed.data.day_id,
          }
        },
        update: { content: sanitized },
        create: {
          userId: session.user.id,
          dayId: parsed.data.day_id,
          content: sanitized,
        }
      });
    } else {
      // General note (no dayId) - just create a new one or you might need a different unique constraint
      // But the original had onConflict="user_id,day_id". If day_id is null, supabase might fail.
      data = await prisma.note.create({
        data: {
          userId: session.user.id,
          content: sanitized,
        }
      });
    }

    const formattedData = {
      ...data,
      user_id: data.userId,
      day_id: data.dayId,
      created_at: data.createdAt.toISOString(),
      updated_at: data.updatedAt.toISOString(),
    };

    return NextResponse.json(formattedData);
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}

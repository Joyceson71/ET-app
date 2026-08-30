import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';
import { prisma } from '@/lib/prisma';
import { z } from 'zod';

const updateSchema = z.object({
  name: z.string().optional(),
  experience_level: z.string().optional(),
  goal: z.string().optional(),
  daily_commitment: z.number().int().optional(),
  onboarding_done: z.boolean().optional(),
});

export async function GET() {
  const session = await getServerSession(authOptions);
  if (!session?.user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const user = await prisma.user.findUnique({
    where: { id: session.user.id },
  });

  if (!user) return NextResponse.json({ error: 'Not found' }, { status: 404 });

  // Map to the format expected by frontend
  const mappedUser = {
    ...user,
    experience_level: user.experienceLevel,
    daily_commitment: user.dailyCommitment,
    onboarding_done: user.onboardingDone,
    avatar_url: user.avatarUrl,
    last_active_date: user.lastActiveDate,
    created_at: user.createdAt,
  };

  return NextResponse.json(mappedUser);
}

export async function PATCH(request: Request) {
  const session = await getServerSession(authOptions);
  if (!session?.user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  try {
    const body = await request.json();
    const data = updateSchema.parse(body);

    const updateData: any = {};
    if (data.name !== undefined) updateData.name = data.name;
    if (data.experience_level !== undefined) updateData.experienceLevel = data.experience_level;
    if (data.goal !== undefined) updateData.goal = data.goal;
    if (data.daily_commitment !== undefined) updateData.dailyCommitment = data.daily_commitment;
    if (data.onboarding_done !== undefined) updateData.onboardingDone = data.onboarding_done;

    const user = await prisma.user.update({
      where: { id: session.user.id },
      data: updateData,
    });

    const mappedUser = {
      ...user,
      experience_level: user.experienceLevel,
      daily_commitment: user.dailyCommitment,
      onboarding_done: user.onboardingDone,
      avatar_url: user.avatarUrl,
      last_active_date: user.lastActiveDate,
      created_at: user.createdAt,
    };

    return NextResponse.json(mappedUser);
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 400 });
  }
}

import { prisma } from "./prisma";

export async function updateUserStreak(userId: string) {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    select: { streak: true, lastActiveDate: true }
  });

  if (!user) return;

  const now = new Date();
  const today = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()));
  
  let newStreak = user.streak;

  if (user.lastActiveDate) {
    const lastActive = new Date(user.lastActiveDate);
    const lastActiveDay = new Date(Date.UTC(lastActive.getUTCFullYear(), lastActive.getUTCMonth(), lastActive.getUTCDate()));
    
    const diffTime = today.getTime() - lastActiveDay.getTime();
    const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));
    
    if (diffDays === 1) {
      // Last active was yesterday, increment streak
      newStreak += 1;
    } else if (diffDays > 1) {
      // Missed a day, reset streak
      newStreak = 1;
    }
    // If diffDays === 0, they already got their streak today
  } else {
    // First time getting XP
    newStreak = 1;
  }

  await prisma.user.update({
    where: { id: userId },
    data: {
      streak: newStreak,
      lastActiveDate: now,
    }
  });
}

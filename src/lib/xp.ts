import { getLevel, getLevelProgress } from '@/types';

// XP reward constants
export const XP_REWARDS = {
  COMPLETE_DAY: 50,
  QUIZ_FIRST_TRY: 20,
  COMPLETE_LAB: 75,
  SEVEN_DAY_STREAK: 100,
  COMPLETE_PHASE: 200,
} as const;

// Badge unlock conditions
export const BADGE_CONDITIONS = {
  FIRST_BLOOD: (completedDays: number) => completedDays >= 1,
  WEEK_WARRIOR: (streak: number) => streak >= 7,
  QUIZ_MASTER: (perfectQuizzes: number) => perfectQuizzes >= 10,
  NOTE_TAKER: (noteCount: number) => noteCount >= 50,
  FULL_SEND: (completedDays: number) => completedDays >= 120,
} as const;

export function calculateXPForDayCompletion(
  firstTryQuiz: boolean,
  labCompleted: boolean
): number {
  let xp = XP_REWARDS.COMPLETE_DAY;
  if (firstTryQuiz) xp += XP_REWARDS.QUIZ_FIRST_TRY;
  if (labCompleted) xp += XP_REWARDS.COMPLETE_LAB;
  return xp;
}

export function calculateStreakBonus(streak: number): number {
  if (streak > 0 && streak % 7 === 0) {
    return XP_REWARDS.SEVEN_DAY_STREAK;
  }
  return 0;
}

export function getNextLevelXP(xp: number): number {
  const level = getLevel(xp);
  if (level.max === Infinity) return Infinity;
  return level.max + 1;
}

export function getLevelInfo(xp: number) {
  const level = getLevel(xp);
  const progress = getLevelProgress(xp);
  const nextLevelXP = level.max === Infinity ? xp : level.max + 1;
  const currentLevelXP = level.min;
  const xpInLevel = xp - currentLevelXP;
  const xpNeeded = level.max === Infinity ? 0 : nextLevelXP - currentLevelXP;

  return {
    title: level.title,
    color: level.color,
    progress,
    xpInLevel,
    xpNeeded,
    isMaxLevel: level.max === Infinity,
  };
}

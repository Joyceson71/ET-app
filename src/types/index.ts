import "next-auth";

declare module "next-auth" {
  interface Session {
    user: {
      id: string;
      name?: string | null;
      email?: string | null;
      image?: string | null;
    }
  }

  interface User {
    id: string;
  }
}

// HackPath — Shared TypeScript types
// Mirrors the database schema using Supabase client (no Prisma)

export type ExperienceLevel = 'beginner' | 'some_it' | 'developer';
export type UserGoal = 'bug_bounty' | 'pentest' | 'ctf' | 'security_engineer';
export type DailyCommitment = '30min' | '1hour' | '2plus';
export type DayStatus = 'locked' | 'available' | 'in_progress' | 'completed';
export type ResourceType = 'video' | 'article' | 'tool' | 'book' | 'platform' | 'cheatsheet';
export type ResourceDifficulty = 'beginner' | 'intermediate' | 'advanced';

export interface User {
  id: string;
  email: string;
  name?: string;
  avatar_url?: string;
  experience_level?: ExperienceLevel;
  goal?: UserGoal;
  daily_commitment?: DailyCommitment;
  xp: number;
  streak: number;
  last_active_date?: string;
  created_at: string;
}

export interface Day {
  id: number;
  phase: number;
  title: string;
  concept: string;
  lab_url?: string;
  lab_platform?: string;
  xp_reward: number;
}

export interface DayWithExtras extends Day {
  resources: Resource[];
  quizzes: Quiz[];
  progress?: DayProgress;
  notes?: Note[];
}

export interface DayProgress {
  id: string;
  user_id: string;
  day_id: number;
  status: DayStatus;
  lab_done: boolean;
  completed_at?: string;
  xp_earned: number;
}

export interface Quiz {
  id: string;
  day_id: number;
  question: string;
  options: string[];
  answer: number;
}

export interface QuizResult {
  id: string;
  user_id: string;
  quiz_id: string;
  passed: boolean;
  attempts: number;
  created_at: string;
}

export interface Resource {
  id: string;
  title: string;
  url: string;
  type: ResourceType;
  difficulty: ResourceDifficulty;
  description?: string;
  is_free: boolean;
  source?: string;
  day_ids?: number[];
}

export interface Note {
  id: string;
  user_id: string;
  day_id?: number;
  content: string;
  updated_at: string;
  created_at: string;
}

export interface Bookmark {
  user_id: string;
  resource_id: string;
  saved_at: string;
  resource?: Resource;
}

export interface Badge {
  id: string;
  name: string;
  description: string;
  icon: string;
}

export interface UserBadge {
  user_id: string;
  badge_id: string;
  earned_at: string;
  badge?: Badge;
}

export interface SkillNode {
  id: string;
  name: string;
  category: string;
  description: string;
  xp_value: number;
  estimated_hours: number;
  day_ids: number[];
  prerequisites: string[];
  status?: 'locked' | 'available' | 'in_progress' | 'completed';
  x?: number;
  y?: number;
}

export interface SkillEdge {
  source: string;
  target: string;
}

// Progress summary for the dashboard
export interface ProgressSummary {
  total_days: number;
  completed_days: number;
  in_progress_days: number;
  total_xp: number;
  streak: number;
  phase_progress: PhaseProgress[];
  calendar_data: CalendarDay[];
  estimated_completion?: string;
}

export interface PhaseProgress {
  phase: number;
  title: string;
  total: number;
  completed: number;
  color: string;
}

export interface CalendarDay {
  date: string;
  status: 'completed' | 'partial' | 'skipped' | 'none';
}

// XP Level system
export const XP_LEVELS = [
  { min: 0, max: 499, title: 'Script Kiddie', color: '#5A6070' },
  { min: 500, max: 999, title: 'Recon Specialist', color: '#00D4FF' },
  { min: 1000, max: 1999, title: 'Exploit Rookie', color: '#7B61FF' },
  { min: 2000, max: 2999, title: 'Pentester', color: '#FF6B35' },
  { min: 3000, max: 3999, title: 'Red Team Operator', color: '#FF3B9A' },
  { min: 4000, max: Infinity, title: 'Elite Hacker', color: '#00FF9C' },
] as const;

export function getLevel(xp: number) {
  return XP_LEVELS.find(l => xp >= l.min && xp <= l.max) ?? XP_LEVELS[0];
}

export function getLevelProgress(xp: number) {
  const level = getLevel(xp);
  if (level.max === Infinity) return 100;
  const range = level.max - level.min + 1;
  const progress = xp - level.min;
  return Math.round((progress / range) * 100);
}

export const PHASE_COLORS: Record<number, string> = {
  1: '#00FF9C',
  2: '#00D4FF',
  3: '#FF6B35',
  4: '#7B61FF',
  5: '#FF3B9A',
  6: '#FFD700',
};

export const PHASE_TITLES: Record<number, string> = {
  1: 'Foundations',
  2: 'Reconnaissance',
  3: 'Exploitation Basics',
  4: 'Web App Hacking',
  5: 'Advanced Techniques',
  6: 'Real-World Practice',
};

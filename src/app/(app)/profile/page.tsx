"use client";

import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { useAppStore } from "@/store/app-store";
import {
  Trophy,
  Flame,
  Calendar,
  Award,
  GitBranch,
  Zap,
  Target,
  BookOpen,
} from "lucide-react";
import { getLevelInfo } from "@/lib/xp";

export default function ProfilePage() {
  const { user } = useAppStore();

  const { data: progress, isLoading } = useQuery({
    queryKey: ["progress-summary"],
    queryFn: async () => {
      const res = await fetch("/api/progress");
      if (!res.ok) throw new Error("Failed to fetch progress");
      return res.json();
    },
  });

  if (!user || isLoading) {
    return (
      <div className="animate-pulse text-text-muted">Loading profile...</div>
    );
  }

  const levelInfo = getLevelInfo(user.xp);
  const joinedDate = new Date(user.created_at).toLocaleDateString("en-US", {
    month: "long",
    year: "numeric",
  });

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      {/* Header / Identity */}
      <div className="card p-8 relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-64 bg-accent-primary/5 rounded-full blur-3xl -translate-y-1/2 translate-x-1/4 pointer-events-none" />

        <div className="flex flex-col sm:flex-row items-center gap-6 relative z-10">
          <div
            className="w-24 h-24 rounded-2xl bg-surface-light border-2 flex items-center justify-center text-4xl font-mono font-bold shrink-0 shadow-lg"
            style={{
              borderColor: levelInfo.color,
              color: levelInfo.color,
              boxShadow: `0 0 20px ${levelInfo.color}20`,
            }}
          >
            {user.name?.[0]?.toUpperCase() || "U"}
          </div>

          <div className="text-center sm:text-left flex-1">
            <h1 className="text-3xl font-mono font-bold mb-1">{user.name}</h1>
            <div className="flex flex-wrap items-center justify-center sm:justify-start gap-4 text-sm text-text-muted font-mono">
              <span className="flex items-center gap-1">
                <Calendar size={14} /> Joined {joinedDate}
              </span>
              <span className="flex items-center gap-1">
                <Target size={14} /> {user.goal || "No goal set"}
              </span>
            </div>

            <div
              className="mt-4 inline-flex items-center gap-2 px-3 py-1.5 rounded-full border bg-background"
              style={{
                borderColor: `${levelInfo.color}40`,
                color: levelInfo.color,
              }}
            >
              <Zap size={14} />
              <span className="text-sm font-bold font-mono">
                {levelInfo.title}
              </span>
            </div>
          </div>
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div className="card p-5 text-center">
          <Trophy size={20} className="mx-auto text-[#FFD700] mb-2" />
          <div className="text-2xl font-mono font-bold">
            {user.xp.toLocaleString()}
          </div>
          <div className="text-xs text-text-muted font-mono">Total XP</div>
        </div>
        <div className="card p-5 text-center">
          <Flame size={20} className="mx-auto text-warning mb-2" />
          <div className="text-2xl font-mono font-bold">{user.streak}</div>
          <div className="text-xs text-text-muted font-mono">Day Streak</div>
        </div>
        <div className="card p-5 text-center">
          <BookOpen size={20} className="mx-auto text-accent-secondary mb-2" />
          <div className="text-2xl font-mono font-bold">
            {progress?.completed_days || 0}
          </div>
          <div className="text-xs text-text-muted font-mono">Missions Done</div>
        </div>
        <div className="card p-5 text-center">
          <GitBranch size={20} className="mx-auto text-accent-primary mb-2" />
          <div className="text-2xl font-mono font-bold">0</div>
          <div className="text-xs text-text-muted font-mono">Badges Earned</div>
        </div>
      </div>

      {/* Next Level Progress */}
      <div className="card p-6">
        <div className="flex justify-between items-end mb-4">
          <div>
            <h3 className="font-mono font-bold text-lg mb-1">
              Rank Progression
            </h3>
            <p className="text-sm text-text-muted">
              Earn {levelInfo.xpNeeded} more XP to rank up
            </p>
          </div>
          <div
            className="text-xl font-mono font-bold"
            style={{ color: levelInfo.color }}
          >
            {levelInfo.progress}%
          </div>
        </div>

        <div className="h-3 w-full bg-surface-light rounded-full overflow-hidden border border-border">
          <div
            className="h-full rounded-full transition-all duration-1000"
            style={{
              width: `${levelInfo.progress}%`,
              backgroundColor: levelInfo.color,
              boxShadow: `0 0 10px ${levelInfo.color}`,
            }}
          />
        </div>

        <div className="flex justify-between mt-2 text-xs text-text-muted font-mono">
          <span>{levelInfo.title}</span>
          <span>{levelInfo.isMaxLevel ? "Max Rank" : "Next Rank"}</span>
        </div>
      </div>
    </div>
  );
}

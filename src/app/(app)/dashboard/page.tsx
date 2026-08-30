"use client";

import { useQuery } from "@tanstack/react-query";
import { motion } from "framer-motion";
import {
  Activity,
  Flame,
  Trophy,
  Calendar,
  Target,
  Clock,
  ArrowRight,
  CheckCircle2,
  Sparkles,
} from "lucide-react";
import Link from "next/link";

export default function DashboardPage() {
  const { data: progress, isLoading } = useQuery({
    queryKey: ["progress-summary"],
    queryFn: async () => {
      const res = await fetch("/api/progress");
      if (!res.ok) throw new Error("Failed to fetch progress");
      return res.json();
    },
  });

  if (isLoading) {
    return (
      <div className="flex-1 flex items-center justify-center min-h-[500px]">
        <div className="flex flex-col items-center gap-4">
          <Activity className="animate-spin text-accent-primary" size={32} />
          <span className="font-mono text-sm text-text-muted animate-pulse">
            Loading intelligence...
          </span>
        </div>
      </div>
    );
  }

  const daysCompleted = progress?.completed_days || 0;
  const nextDay = daysCompleted + 1;

  return (
    <div className="max-w-6xl mx-auto space-y-8 animate-in fade-in duration-500">
      <div>
        <h1 className="text-2xl font-mono font-bold">Dashboard</h1>
        <p className="text-text-muted">
          Welcome back. Here is your current training status.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 xl:grid-cols-4 auto-rows-[minmax(160px,auto)] gap-6">
        
        {/* HERO WIDGET - Next Objective */}
        <div className="clay-card ultra-glow col-span-1 md:col-span-2 xl:col-span-2 row-span-2 p-8 flex flex-col justify-between">
          {nextDay <= 120 ? (
            <>
              <div>
                <div className="flex items-center justify-between mb-4">
                  <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-accent-primary/10 text-accent-primary text-xs font-mono font-bold">
                    <Sparkles size={14} /> ACTIVE MISSION
                  </div>
                  <span className="text-text-muted font-mono text-sm">DAY {nextDay}</span>
                </div>
                <h3 className="text-3xl font-bold mb-4">Continue Training Phase</h3>
                <p className="text-text-muted text-lg max-w-md">
                  You are cleared to proceed with Day {nextDay}. Ensure you have your lab environment ready for deployment.
                </p>
              </div>
              <div className="mt-8">
                <Link
                  href={`/curriculum/${nextDay}`}
                  className="btn-primary w-full md:w-auto"
                >
                  Launch Mission <ArrowRight size={18} />
                </Link>
              </div>
            </>
          ) : (
            <div className="flex flex-col items-center justify-center h-full text-center">
              <Trophy size={64} className="text-accent-secondary mb-6 drop-shadow-[0_0_15px_rgba(123,97,255,0.5)]" />
              <h3 className="text-3xl font-bold mb-2">Curriculum Complete</h3>
              <p className="text-text-muted">You have successfully conquered all 120 days of training.</p>
            </div>
          )}
        </div>

        {/* PROGRESS WIDGET */}
        <div className="clay-card col-span-1 md:col-span-1 xl:col-span-1 row-span-1 p-6 flex flex-col justify-between group">
          <div className="flex items-center gap-3 text-text-muted">
            <div className="p-2 rounded-xl bg-accent-primary/10 text-accent-primary group-hover:bg-accent-primary group-hover:text-background transition-colors">
              <Target size={20} />
            </div>
            <span className="font-mono text-sm font-semibold tracking-wide">PROGRESS</span>
          </div>
          <div>
            <div className="text-4xl font-mono font-bold mb-2 text-accent-primary">
              {daysCompleted} <span className="text-xl text-text-muted">/ 120</span>
            </div>
            <div className="xp-bar h-2 bg-surface-2 rounded-full overflow-hidden">
              <div
                className="h-full bg-accent-primary rounded-full"
                style={{ width: `${(daysCompleted / 120) * 100}%`, boxShadow: '0 0 10px rgba(0,255,156,0.5)' }}
              />
            </div>
          </div>
        </div>

        {/* XP WIDGET */}
        <div className="clay-card col-span-1 md:col-span-1 xl:col-span-1 row-span-1 p-6 flex flex-col justify-between group">
          <div className="flex items-center gap-3 text-text-muted">
            <div className="p-2 rounded-xl bg-[#FFD700]/10 text-[#FFD700] group-hover:bg-[#FFD700] group-hover:text-background transition-colors">
              <Trophy size={20} />
            </div>
            <span className="font-mono text-sm font-semibold tracking-wide">TOTAL XP</span>
          </div>
          <div className="text-4xl font-mono font-bold text-[#FFD700]">
            {progress?.total_xp?.toLocaleString() || 0}
          </div>
        </div>

        {/* STREAK WIDGET */}
        <div className="clay-card col-span-1 md:col-span-1 xl:col-span-1 row-span-1 p-6 flex flex-col justify-between group">
          <div className="flex items-center gap-3 text-text-muted">
            <div className="p-2 rounded-xl bg-warning/10 text-warning group-hover:bg-warning group-hover:text-background transition-colors">
              <Flame size={20} />
            </div>
            <span className="font-mono text-sm font-semibold tracking-wide">STREAK</span>
          </div>
          <div className="text-4xl font-mono font-bold text-warning">
            {progress?.streak || 0} <span className="text-xl text-warning/60">Days</span>
          </div>
        </div>

        {/* ETA WIDGET */}
        <div className="clay-card col-span-1 md:col-span-2 xl:col-span-1 row-span-1 p-6 flex flex-col justify-between group">
          <div className="flex items-center gap-3 text-text-muted">
            <div className="p-2 rounded-xl bg-accent-secondary/10 text-accent-secondary group-hover:bg-accent-secondary group-hover:text-background transition-colors">
              <Clock size={20} />
            </div>
            <span className="font-mono text-sm font-semibold tracking-wide">ETA</span>
          </div>
          <div className="text-2xl font-mono font-bold text-accent-secondary">
            {progress?.estimated_completion
              ? new Date(progress.estimated_completion).toLocaleDateString()
              : "N/A"}
          </div>
        </div>

        {/* PHASE BREAKDOWN - Wide Widget */}
        <div className="clay-card col-span-1 md:col-span-3 xl:col-span-2 row-span-2 p-6 flex flex-col">
          <h2 className="text-lg font-mono font-bold mb-6 flex items-center gap-2 text-text-muted">
            PHASE BREAKDOWN
          </h2>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 flex-1">
            {progress?.phase_progress?.map((phase: any) => (
              <div key={phase.phase} className="p-4 rounded-2xl bg-surface-2 border border-white/5">
                <div className="flex justify-between items-center mb-3">
                  <span className="text-sm font-bold" style={{ color: phase.color }}>
                    {phase.title}
                  </span>
                  <span className="text-xs text-text-muted font-mono font-semibold">
                    {phase.completed} / {phase.total}
                  </span>
                </div>
                <div className="h-2 w-full bg-background rounded-full overflow-hidden shadow-inner">
                  <div
                    className="h-full rounded-full transition-all duration-1000"
                    style={{
                      width: `${(phase.completed / phase.total) * 100}%`,
                      backgroundColor: phase.color,
                      boxShadow: `0 0 10px ${phase.color}80`
                    }}
                  />
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* ACTIVITY HEATMAP - Wide Widget */}
        <div className="clay-card col-span-1 md:col-span-3 xl:col-span-2 row-span-2 p-6 flex flex-col">
          <div className="flex items-center justify-between mb-6 text-text-muted">
            <h2 className="text-lg font-mono font-bold">ACTIVITY LOG</h2>
            <div className="flex items-center gap-2">
              <Calendar size={18} />
              <span className="text-sm font-semibold">90 Days</span>
            </div>
          </div>

          <div className="flex-1 flex flex-col justify-center">
            <div className="flex flex-wrap gap-1.5 justify-start">
              {progress?.calendar_data?.map((day: any, i: number) => (
                <div
                  key={day.date}
                  className={`w-3.5 h-3.5 rounded-sm transition-transform hover:scale-150 cursor-pointer ${day.status === "completed" ? "bg-accent-primary shadow-[0_0_8px_rgba(0,255,156,0.6)]" : "bg-surface-2"}`}
                  title={`${day.date}: ${day.status}`}
                />
              ))}
            </div>
            
            <div className="flex items-center gap-4 mt-6 text-xs text-text-muted justify-end font-mono font-semibold">
              <div className="flex items-center gap-1.5">
                <div className="w-3 h-3 rounded-sm bg-surface-2" /> INACTIVE
              </div>
              <div className="flex items-center gap-1.5">
                <div className="w-3 h-3 rounded-sm bg-accent-primary shadow-[0_0_5px_rgba(0,255,156,0.5)]" /> ACTIVE
              </div>
            </div>
          </div>
        </div>
        
      </div>
    </div>
  );
}

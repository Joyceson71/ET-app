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

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="card p-5">
          <div className="flex items-center gap-3 mb-2 text-text-muted">
            <Target size={18} className="text-accent-primary" />
            <span className="font-mono text-sm">Mission Progress</span>
          </div>
          <div className="text-3xl font-mono font-bold">
            {daysCompleted}{" "}
            <span className="text-lg text-text-muted">/ 120</span>
          </div>
          <div className="xp-bar mt-3">
            <div
              className="xp-bar-fill"
              style={{ width: `${(daysCompleted / 120) * 100}%` }}
            />
          </div>
        </div>

        <div className="card p-5">
          <div className="flex items-center gap-3 mb-2 text-text-muted">
            <Trophy size={18} className="text-[#FFD700]" />
            <span className="font-mono text-sm">Total XP</span>
          </div>
          <div className="text-3xl font-mono font-bold">
            {progress?.total_xp?.toLocaleString() || 0}
          </div>
        </div>

        <div className="card p-5">
          <div className="flex items-center gap-3 mb-2 text-text-muted">
            <Flame size={18} className="text-warning" />
            <span className="font-mono text-sm">Active Streak</span>
          </div>
          <div className="text-3xl font-mono font-bold">
            {progress?.streak || 0}{" "}
            <span className="text-lg text-text-muted">Days</span>
          </div>
        </div>

        <div className="card p-5">
          <div className="flex items-center gap-3 mb-2 text-text-muted">
            <Clock size={18} className="text-accent-secondary" />
            <span className="font-mono text-sm">Est. Completion</span>
          </div>
          <div className="text-xl font-mono font-bold mt-2">
            {progress?.estimated_completion
              ? new Date(progress.estimated_completion).toLocaleDateString()
              : "N/A"}
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Next Mission */}
        <div className="lg:col-span-2 space-y-4">
          <h2 className="text-lg font-mono font-semibold flex items-center gap-2">
            <span className="text-accent-primary">{">"}</span> Next Objective
          </h2>
          {nextDay <= 120 ? (
            <div className="card p-6 border-accent-primary/20 bg-accent-primary/5">
              <div className="flex justify-between items-start mb-4">
                <div>
                  <div className="text-xs font-mono text-accent-primary mb-1">
                    DAY {nextDay}
                  </div>
                  <h3 className="text-xl font-semibold">
                    Continue Training Phase
                  </h3>
                </div>
              </div>
              <p className="text-text-muted mb-6">
                You are cleared to proceed with Day {nextDay}. Ensure you have
                your lab environment ready.
              </p>
              <Link
                href={`/curriculum/${nextDay}`}
                className="btn-primary py-2 px-6 inline-flex items-center gap-2"
              >
                Launch Mission <ArrowRight size={16} />
              </Link>
            </div>
          ) : (
            <div className="card p-6 border-accent-secondary/20 bg-accent-secondary/5 text-center">
              <Trophy
                size={48}
                className="mx-auto text-accent-secondary mb-4"
              />
              <h3 className="text-2xl font-bold mb-2">Curriculum Complete</h3>
              <p className="text-text-muted">
                You have successfully completed all 120 days of training.
              </p>
            </div>
          )}

          {/* Phase Progress */}
          <h2 className="text-lg font-mono font-semibold flex items-center gap-2 mt-8">
            <span className="text-accent-primary">{">"}</span> Phase Breakdown
          </h2>
          <div className="grid sm:grid-cols-2 gap-4">
            {progress?.phase_progress?.map((phase: any) => (
              <div key={phase.phase} className="card p-4">
                <div className="flex justify-between items-center mb-2">
                  <span
                    className="text-sm font-mono font-semibold"
                    style={{ color: phase.color }}
                  >
                    {phase.title}
                  </span>
                  <span className="text-xs text-text-muted font-mono">
                    {phase.completed} / {phase.total}
                  </span>
                </div>
                <div className="h-1.5 w-full bg-surface-light rounded-full overflow-hidden">
                  <div
                    className="h-full rounded-full transition-all duration-1000"
                    style={{
                      width: `${(phase.completed / phase.total) * 100}%`,
                      backgroundColor: phase.color,
                    }}
                  />
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Activity Heatmap */}
        <div className="space-y-4">
          <h2 className="text-lg font-mono font-semibold flex items-center gap-2">
            <span className="text-accent-primary">{">"}</span> Activity Log
          </h2>
          <div className="card p-6">
            <div className="flex items-center gap-2 mb-6">
              <Calendar size={18} className="text-text-muted" />
              <span className="text-sm text-text-muted">Last 90 Days</span>
            </div>

            <div className="flex flex-wrap gap-1">
              {progress?.calendar_data?.map((day: any, i: number) => (
                <div
                  key={day.date}
                  className={`w-3 h-3 rounded-sm ${day.status === "completed" ? "bg-accent-primary" : "bg-surface-light"}`}
                  title={`${day.date}: ${day.status}`}
                />
              ))}
            </div>

            <div className="flex items-center gap-4 mt-6 text-xs text-text-muted justify-end font-mono">
              <div className="flex items-center gap-1">
                <div className="w-3 h-3 rounded-sm bg-surface-light" /> Inactive
              </div>
              <div className="flex items-center gap-1">
                <div className="w-3 h-3 rounded-sm bg-accent-primary" /> Active
              </div>
            </div>
          </div>

          <div className="card p-6 mt-4">
            <h3 className="text-sm font-mono font-semibold mb-4 text-text-muted">
              Recent Achievements
            </h3>
            <div className="space-y-3">
              {daysCompleted > 0 ? (
                <div className="flex items-start gap-3">
                  <CheckCircle2
                    size={16}
                    className="text-accent-primary mt-0.5"
                  />
                  <div>
                    <div className="text-sm font-medium">
                      Day {daysCompleted} Completed
                    </div>
                    <div className="text-xs text-text-muted font-mono">
                      Earned XP
                    </div>
                  </div>
                </div>
              ) : (
                <div className="text-sm text-text-muted text-center py-4">
                  No recent activity. Start Day 1!
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

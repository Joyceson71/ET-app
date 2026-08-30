"use client";

import { useState } from "react";
import { useQuery } from "@tanstack/react-query/build/modern";
import Link from "next/link";
import {
  Lock,
  Unlock,
  CheckCircle2,
  Play,
  Search,
  Filter,
  Trophy,
} from "lucide-react";
import { PHASE_COLORS, PHASE_TITLES } from "@/types";

export default function CurriculumPage() {
  const [activePhase, setActivePhase] = useState<number | null>(null);

  const { data, isLoading } = useQuery({
    queryKey: ["days", activePhase],
    queryFn: async () => {
      const url = activePhase ? `/api/days?phase=${activePhase}` : "/api/days";
      const res = await fetch(url);
      if (!res.ok) throw new Error("Failed to fetch days");
      return res.json();
    },
  });

  const phases = [1, 2, 3, 4, 5, 6];

  return (
    <div className="max-w-6xl mx-auto space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8">
        <div>
          <h1 className="text-2xl font-mono font-bold">Curriculum</h1>
          <p className="text-text-muted">
            120 days. 6 phases. Complete each day to unlock the next.
          </p>
        </div>
      </div>

      {/* Phase Filters */}
      <div className="flex flex-wrap gap-2 mb-8">
        <button
          onClick={() => setActivePhase(null)}
          className={`px-4 py-2 rounded-md text-sm font-mono border transition-colors ${
            activePhase === null
              ? "bg-surface border-text-muted text-text-primary"
              : "bg-transparent border-border text-text-muted hover:bg-surface/50"
          }`}
        >
          All Phases
        </button>
        {phases.map((phase) => (
          <button
            key={phase}
            onClick={() => setActivePhase(phase)}
            className={`px-4 py-2 rounded-md text-sm font-mono border transition-colors flex items-center gap-2`}
            style={{
              borderColor:
                activePhase === phase ? PHASE_COLORS[phase] : "var(--border)",
              backgroundColor:
                activePhase === phase
                  ? `${PHASE_COLORS[phase]}15`
                  : "transparent",
              color:
                activePhase === phase
                  ? PHASE_COLORS[phase]
                  : "var(--text-muted)",
            }}
          >
            P{phase}{" "}
            <span className="hidden sm:inline">- {PHASE_TITLES[phase]}</span>
          </button>
        ))}
      </div>

      {/* Days Grid */}
      {isLoading ? (
        <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
          {[1, 2, 3, 4, 5, 6].map((i) => (
            <div
              key={i}
              className="h-32 bg-surface animate-pulse rounded-lg border border-border"
            />
          ))}
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
          {data?.days?.map((day: any) => {
            const isCompleted = day.progress?.status === "completed";
            const isAvailable =
              day.progress?.status === "available" || day.id === 1; // Day 1 always available
            const isLocked = !isCompleted && !isAvailable;

            const color = PHASE_COLORS[day.phase as keyof typeof PHASE_COLORS];

            return (
              <Link
                key={day.id}
                href={isLocked ? "#" : `/curriculum/${day.id}`}
                className={`card p-5 flex flex-col h-full transition-all duration-200 ${
                  isLocked
                    ? "opacity-50 cursor-not-allowed grayscale"
                    : "hover:border-opacity-100 hover:-translate-y-1"
                }`}
                style={{
                  borderColor: isAvailable
                    ? `${color}40`
                    : isCompleted
                      ? `${color}20`
                      : "var(--border)",
                  backgroundColor: isAvailable ? `${color}05` : undefined,
                }}
              >
                <div className="flex justify-between items-start mb-4">
                  <div
                    className="px-2 py-1 rounded text-xs font-mono font-bold"
                    style={{ backgroundColor: `${color}15`, color }}
                  >
                    DAY {day.id}
                  </div>

                  <div>
                    {isCompleted ? (
                      <CheckCircle2 size={18} className="text-accent-primary" />
                    ) : isAvailable ? (
                      <Unlock size={18} style={{ color }} />
                    ) : (
                      <Lock size={18} className="text-text-muted" />
                    )}
                  </div>
                </div>

                <h3 className="font-semibold text-lg mb-2 line-clamp-2 leading-tight">
                  {day.title}
                </h3>

                <div className="mt-auto pt-4 flex items-center justify-between text-xs text-text-muted font-mono">
                  <span>
                    {PHASE_TITLES[day.phase as keyof typeof PHASE_TITLES]}
                  </span>
                  <span className="flex items-center gap-1">
                    <Trophy size={12} /> {day.xp_reward} XP
                  </span>
                </div>

                {isAvailable && !isCompleted && (
                  <div className="absolute inset-0 bg-gradient-to-t from-background/80 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity flex items-end justify-center pb-4 pointer-events-none">
                    <span
                      className="flex items-center gap-2 text-sm font-mono font-bold"
                      style={{ color }}
                    >
                      <Play size={14} /> Start Mission
                    </span>
                  </div>
                )}
              </Link>
            );
          })}
        </div>
      )}
    </div>
  );
}

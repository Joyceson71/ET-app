"use client";

import { useState, useEffect } from "react";
import {
  useQuery,
  useMutation,
  useQueryClient,
} from "@tanstack/react-query/build/modern";
import { motion, AnimatePresence } from "framer-motion";
import {
  ChevronLeft,
  Terminal,
  ExternalLink,
  BookOpen,
  PenTool,
  CheckCircle2,
  AlertTriangle,
  Lock,
  Award,
  ShieldAlert,
} from "lucide-react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import ReactMarkdown from "react-markdown";
import { PHASE_COLORS, PHASE_TITLES } from "@/types";

export default function DayClient({ dayId }: { dayId: number }) {
  const router = useRouter();
  const queryClient = useQueryClient();
  const [activeTab, setActiveTab] = useState<"concept" | "lab" | "quiz">(
    "concept",
  );
  const [quizAnswers, setQuizAnswers] = useState<number[]>([0, 0, 0]);
  const [notes, setNotes] = useState("");

  const { data: day, isLoading } = useQuery({
    queryKey: ["day", dayId],
    queryFn: async () => {
      const res = await fetch(`/api/days/${dayId}`);
      if (!res.ok) throw new Error("Failed to fetch day");
      return res.json();
    },
  });

  const { data: notesData } = useQuery({
    queryKey: ["notes", dayId],
    queryFn: async () => {
      const res = await fetch(`/api/notes?day_id=${dayId}`);
      if (!res.ok) return [];
      return res.json();
    },
  });

  useEffect(() => {
    if (notesData && notesData.length > 0) {
      setNotes(notesData[0].content);
    }
  }, [notesData]);

  const saveNotes = useMutation({
    mutationFn: async (content: string) => {
      const res = await fetch("/api/notes", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ day_id: dayId, content }),
      });
      if (!res.ok) throw new Error("Failed to save notes");
      return res.json();
    },
  });

  const submitQuiz = useMutation({
    mutationFn: async ({
      answers,
      skipQuiz,
    }: {
      answers: number[];
      skipQuiz?: boolean;
    }) => {
      const res = await fetch(`/api/days/${dayId}/quiz`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ answers, skipQuiz }),
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || "Quiz failed");
      return data;
    },
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: ["day", dayId] });
      queryClient.invalidateQueries({ queryKey: ["progress-summary"] });
      queryClient.invalidateQueries({ queryKey: ["days"] });

      if (data.passed) {
        alert(
          data.skipped
            ? "Quiz skipped! Next day unlocked."
            : `Quiz passed! Score: ${data.score}/${data.total}. +${data.xpEarned} XP!`,
        );
      } else {
        alert(`Quiz failed. Score: ${data.score}/${data.total}. Try again!`);
      }
    },
    onError: (err: any) => {
      alert(err.message);
    },
  });

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[500px]">
        <div className="animate-spin text-accent-primary">
          <Terminal size={32} />
        </div>
      </div>
    );
  }

  if (!day) return <div>Day not found</div>;

  const color = PHASE_COLORS[day.phase as keyof typeof PHASE_COLORS];
  const isCompleted = day.progress?.status === "completed";

  return (
    <div className="max-w-6xl mx-auto space-y-6 pb-20">
      {/* Header */}
      <div className="flex items-center gap-4 mb-6">
        <Link href="/curriculum" className="btn-ghost p-2 rounded-full">
          <ChevronLeft size={20} />
        </Link>
        <div>
          <div
            className="text-xs font-mono font-bold tracking-wider mb-1"
            style={{ color }}
          >
            PHASE {day.phase}:{" "}
            {PHASE_TITLES[day.phase as keyof typeof PHASE_TITLES].toUpperCase()}
          </div>
          <h1 className="text-2xl md:text-3xl font-mono font-bold flex items-center gap-3">
            Day {day.id}: {day.title}
            {isCompleted && (
              <CheckCircle2 className="text-accent-primary" size={24} />
            )}
          </h1>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex border-b border-border mb-6">
        {[
          { id: "concept", label: "Briefing", icon: BookOpen },
          { id: "lab", label: "Lab Exercise", icon: Terminal },
          { id: "quiz", label: "Knowledge Check", icon: ShieldAlert },
        ].map((tab) => {
          const Icon = tab.icon;
          return (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id as any)}
              className={`flex items-center gap-2 px-6 py-3 font-mono text-sm border-b-2 transition-colors ${
                activeTab === tab.id
                  ? "border-accent-primary text-accent-primary bg-accent-primary/5"
                  : "border-transparent text-text-muted hover:text-text-primary hover:bg-surface"
              }`}
            >
              <Icon size={16} />
              {tab.label}
            </button>
          );
        })}
      </div>

      {/* Content Area */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <div className="lg:col-span-2">
          {activeTab === "concept" && (
            <motion.div
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              className="card p-6 md:p-8 prose prose-invert prose-pre:bg-[#0D0F14] prose-pre:border prose-pre:border-border max-w-none"
            >
              <ReactMarkdown>{day.concept}</ReactMarkdown>
            </motion.div>
          )}

          {activeTab === "lab" && (
            <motion.div
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              className="space-y-6"
            >
              <div
                className="card p-8 border-l-4"
                style={{ borderLeftColor: color }}
              >
                <h2 className="text-xl font-mono font-bold mb-2">
                  Practical Application
                </h2>
                <p className="text-text-muted mb-6">
                  Apply today's concepts in a sandboxed environment on{" "}
                  {day.lab_platform}.
                </p>

                <div className="flex flex-col sm:flex-row gap-4 items-center p-6 bg-surface-light rounded-lg border border-border">
                  <div className="w-12 h-12 bg-[#1f2330] rounded-lg flex items-center justify-center shrink-0">
                    <Terminal size={24} style={{ color }} />
                  </div>
                  <div className="flex-1 text-center sm:text-left">
                    <h3 className="font-semibold">{day.lab_platform} Room</h3>
                    <p className="text-sm text-text-muted">
                      Target room is ready for deployment.
                    </p>
                  </div>
                  <a
                    href={day.lab_url}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="btn-primary py-2 px-6 flex items-center gap-2 w-full sm:w-auto justify-center"
                    style={{ backgroundColor: color, color: "#000" }}
                  >
                    Deploy Machine <ExternalLink size={16} />
                  </a>
                </div>
              </div>

              {day.resources && day.resources.length > 0 && (
                <div className="card p-6">
                  <h3 className="text-lg font-mono font-bold mb-4">
                    Required Reading / Tools
                  </h3>
                  <div className="space-y-3">
                    {day.resources.map((res: any) => (
                      <a
                        key={res.id}
                        href={res.url}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="flex items-start gap-3 p-3 rounded-md hover:bg-surface-light border border-transparent hover:border-border transition-colors"
                      >
                        <BookOpen
                          size={18}
                          className="text-text-muted mt-0.5 shrink-0"
                        />
                        <div>
                          <div className="font-medium text-sm text-accent-primary hover:underline">
                            {res.title}
                          </div>
                          <div className="text-xs text-text-muted line-clamp-1">
                            {res.description}
                          </div>
                        </div>
                      </a>
                    ))}
                  </div>
                </div>
              )}
            </motion.div>
          )}

          {activeTab === "quiz" && (
            <motion.div
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              className="space-y-6"
            >
              <div className="card p-6 md:p-8">
                <div className="flex justify-between items-start mb-6">
                  <div>
                    <h2 className="text-xl font-mono font-bold">
                      Knowledge Check
                    </h2>
                    <p className="text-sm text-text-muted">
                      Pass this quiz to unlock tomorrow's mission. (Requires 2/3
                      correct)
                    </p>
                  </div>
                  {isCompleted && (
                    <div className="px-3 py-1 rounded bg-accent-primary/10 border border-accent-primary/30 text-accent-primary text-xs font-mono flex items-center gap-2">
                      <CheckCircle2 size={14} /> Passed
                    </div>
                  )}
                </div>

                {day.quizzes?.length > 0 ? (
                  <div className="space-y-8">
                    {day.quizzes.map((quiz: any, index: number) => {
                      // Options are stored as JSON string arrays in DB
                      const options =
                        typeof quiz.options === "string"
                          ? JSON.parse(quiz.options)
                          : quiz.options;

                      return (
                        <div key={quiz.id} className="space-y-4">
                          <h3 className="font-medium text-text-primary">
                            <span className="text-text-muted mr-2">
                              {index + 1}.
                            </span>
                            {quiz.question}
                          </h3>
                          <div className="space-y-2 pl-6">
                            {options.map((opt: string, optIndex: number) => (
                              <label
                                key={optIndex}
                                className="flex items-start gap-3 p-3 rounded border border-border bg-surface-light hover:bg-surface cursor-pointer transition-colors"
                              >
                                <input
                                  type="radio"
                                  name={`quiz-${quiz.id}`}
                                  className="mt-1 accent-accent-primary"
                                  checked={quizAnswers[index] === optIndex}
                                  onChange={() => {
                                    const newAnswers = [...quizAnswers];
                                    newAnswers[index] = optIndex;
                                    setQuizAnswers(newAnswers);
                                  }}
                                />
                                <span className="text-sm">{opt}</span>
                              </label>
                            ))}
                          </div>
                        </div>
                      );
                    })}

                    <div className="pt-6 border-t border-border flex items-center justify-between">
                      <button
                        onClick={() => {
                          if (
                            confirm(
                              "Skip quiz? You can only do this once per week. You will earn no XP.",
                            )
                          ) {
                            submitQuiz.mutate({
                              answers: quizAnswers,
                              skipQuiz: true,
                            });
                          }
                        }}
                        className="text-sm text-text-muted hover:text-warning transition-colors underline"
                        disabled={submitQuiz.isPending}
                      >
                        Skip Quiz (Once per week)
                      </button>

                      <button
                        onClick={() =>
                          submitQuiz.mutate({ answers: quizAnswers })
                        }
                        disabled={submitQuiz.isPending}
                        className="btn-primary py-2 px-8"
                        style={{ backgroundColor: color, color: "#000" }}
                      >
                        {submitQuiz.isPending
                          ? "Validating..."
                          : "Submit Answers"}
                      </button>
                    </div>
                  </div>
                ) : (
                  <div className="text-center py-8 text-text-muted">
                    No quiz data available for this day.
                  </div>
                )}
              </div>
            </motion.div>
          )}
        </div>

        {/* Sidebar - Notes */}
        <div className="lg:col-span-1">
          <div className="card p-5 h-full flex flex-col min-h-[500px] sticky top-24">
            <div className="flex justify-between items-center mb-4">
              <h3 className="font-mono font-bold flex items-center gap-2">
                <PenTool size={16} className="text-accent-secondary" /> Field
                Notes
              </h3>
              {saveNotes.isPending && (
                <span className="text-xs text-text-muted animate-pulse">
                  Saving...
                </span>
              )}
              {saveNotes.isSuccess && !saveNotes.isPending && (
                <span className="text-xs text-accent-primary">Saved</span>
              )}
            </div>

            <textarea
              className="flex-1 w-full bg-surface-light border border-border rounded-md p-3 text-sm focus:outline-none focus:border-accent-secondary resize-none font-mono"
              placeholder="Take notes here. They are automatically saved and available in your global notebook..."
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              onBlur={() => saveNotes.mutate(notes)}
            />

            <div className="mt-4 pt-4 border-t border-border">
              <div className="text-xs text-text-muted mb-2 font-mono">
                Mission Rewards
              </div>
              <div className="flex items-center gap-2 bg-surface-light px-3 py-2 rounded border border-border">
                <Award size={16} className="text-[#FFD700]" />
                <span className="text-sm font-bold">+{day.xp_reward} XP</span>
                <span className="text-xs text-text-muted ml-auto">On Pass</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

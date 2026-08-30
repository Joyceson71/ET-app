"use client";

import { useState } from "react";
import { useAppStore } from "@/store/app-store";
import { useMutation } from "@tanstack/react-query";
import { Save, User, Target, Clock, Shield } from "lucide-react";

export default function SettingsPage() {
  const { user, setUser } = useAppStore();
  const [formData, setFormData] = useState({
    name: user?.name || "",
    goal: user?.goal || "",
    experience_level: user?.experience_level || "beginner",
    daily_commitment: user?.daily_commitment || 1,
  });
  const [msg, setMsg] = useState({ type: "", text: "" });

  const updateProfile = useMutation({
    mutationFn: async (data: typeof formData) => {
      const res = await fetch("/api/user/me", {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data),
      });
      if (!res.ok) throw new Error("Failed to update profile");
      return res.json();
    },
    onSuccess: (data) => {
      setUser(data);
      setMsg({ type: "success", text: "Settings updated successfully." });
      setTimeout(() => setMsg({ type: "", text: "" }), 3000);
    },
    onError: (err: any) => {
      setMsg({ type: "error", text: err.message });
    },
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    updateProfile.mutate(formData);
  };

  if (!user) return null;

  return (
    <div className="max-w-3xl mx-auto space-y-6">
      <div>
        <h1 className="text-2xl font-mono font-bold">Settings</h1>
        <p className="text-text-muted">
          Configure your learning preferences and profile.
        </p>
      </div>

      <div className="card p-6">
        <form onSubmit={handleSubmit} className="space-y-6">
          {msg.text && (
            <div
              className={`p-3 rounded-md text-sm font-mono border ${msg.type === "success" ? "bg-[#00FF9C]/10 text-[#00FF9C] border-[#00FF9C]/30" : "bg-warning/10 text-warning border-warning/30"}`}
            >
              {msg.text}
            </div>
          )}

          <div className="space-y-4">
            <h2 className="text-lg font-mono font-semibold flex items-center gap-2 border-b border-border pb-2">
              <User size={18} /> Public Profile
            </h2>

            <div className="space-y-1">
              <label className="text-sm font-mono text-text-muted">
                Handle (Name)
              </label>
              <input
                type="text"
                value={formData.name}
                onChange={(e) =>
                  setFormData({ ...formData, name: e.target.value })
                }
                className="w-full bg-surface-light border border-border rounded-md px-4 py-2 text-sm focus:border-accent-primary focus:outline-none transition-colors"
                required
              />
            </div>
          </div>

          <div className="space-y-4 pt-4">
            <h2 className="text-lg font-mono font-semibold flex items-center gap-2 border-b border-border pb-2">
              <Target size={18} /> Learning Path
            </h2>

            <div className="space-y-1">
              <label className="text-sm font-mono text-text-muted">
                Primary Goal
              </label>
              <select
                value={formData.goal}
                onChange={(e) =>
                  setFormData({ ...formData, goal: e.target.value })
                }
                className="w-full bg-surface-light border border-border rounded-md px-4 py-2 text-sm focus:border-accent-primary focus:outline-none transition-colors appearance-none"
              >
                <option value="">Select a goal</option>
                <option value="Get a job as a Pentester">
                  Get a job as a Pentester
                </option>
                <option value="Pass OSCP">Pass OSCP</option>
                <option value="Bug Bounty Hunting">Bug Bounty Hunting</option>
                <option value="General Knowledge">General Knowledge</option>
              </select>
            </div>

            <div className="space-y-1">
              <label className="text-sm font-mono text-text-muted">
                Initial Experience Level
              </label>
              <select
                value={formData.experience_level}
                onChange={(e) =>
                  setFormData({
                    ...formData,
                    experience_level: e.target.value as any,
                  })
                }
                className="w-full bg-surface-light border border-border rounded-md px-4 py-2 text-sm focus:border-accent-primary focus:outline-none transition-colors appearance-none"
              >
                <option value="beginner">
                  Complete Beginner (No IT experience)
                </option>
                <option value="some_it">
                  IT/Dev Background (New to Security)
                </option>
                <option value="developer">Developer</option>
              </select>
            </div>
          </div>

          <div className="space-y-4 pt-4">
            <h2 className="text-lg font-mono font-semibold flex items-center gap-2 border-b border-border pb-2">
              <Clock size={18} /> Cadence
            </h2>

            <div className="space-y-1">
              <label className="text-sm font-mono text-text-muted">
                Daily Commitment (Missions per day)
              </label>
              <input
                type="number"
                min="1"
                max="5"
                value={Number.isNaN(formData.daily_commitment) ? "" : formData.daily_commitment}
                onChange={(e) =>
                  setFormData({
                    ...formData,
                    daily_commitment: e.target.value === "" ? NaN : parseInt(e.target.value),
                  })
                }
                className="w-full bg-surface-light border border-border rounded-md px-4 py-2 text-sm focus:border-accent-primary focus:outline-none transition-colors"
              />
              <p className="text-xs text-text-muted mt-1">
                Used to calculate your estimated completion date. Default is 1
                mission/day.
              </p>
            </div>
          </div>

          <div className="pt-6 flex justify-end">
            <button
              type="submit"
              className="btn-primary py-2 px-6 flex items-center gap-2"
              disabled={updateProfile.isPending}
            >
              <Save size={16} />
              {updateProfile.isPending ? "Saving..." : "Save Settings"}
            </button>
          </div>
        </form>
      </div>

      <div className="card p-6 border-warning/30 bg-warning/5">
        <h2 className="text-lg font-mono font-semibold text-warning flex items-center gap-2 mb-2">
          <Shield size={18} /> Danger Zone
        </h2>
        <p className="text-sm text-text-muted mb-4">
          Resetting your progress is irreversible. All XP, notes, and
          completions will be lost.
        </p>
        <button className="px-4 py-2 bg-transparent border border-warning/50 text-warning hover:bg-warning/10 rounded-md text-sm font-mono transition-colors">
          Reset All Progress
        </button>
      </div>
    </div>
  );
}

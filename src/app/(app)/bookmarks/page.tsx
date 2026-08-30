"use client";

import { useState } from "react";
import {
  useQuery,
  useMutation,
  useQueryClient,
} from "@tanstack/react-query";
import { Search, ExternalLink, Bookmark, Trash2, PenTool } from "lucide-react";
import Link from "next/link";
import ReactMarkdown from "react-markdown";

export default function BookmarksPage() {
  const [activeTab, setActiveTab] = useState<"resources" | "notes">(
    "resources",
  );
  const queryClient = useQueryClient();

  const { data: resources, isLoading: resLoading } = useQuery({
    queryKey: ["bookmarked-resources"],
    queryFn: async () => {
      // For MVP, just fetch all and filter client-side, or we could add a dedicated endpoint.
      // Since our GET /api/resources returns is_bookmarked, we'll just use that.
      const res = await fetch("/api/resources");
      if (!res.ok) throw new Error("Failed to fetch resources");
      const all = await res.json();
      return all.filter((r: any) => r.is_bookmarked);
    },
  });

  const { data: notes, isLoading: notesLoading } = useQuery({
    queryKey: ["all-notes"],
    queryFn: async () => {
      const res = await fetch("/api/notes");
      if (!res.ok) throw new Error("Failed to fetch notes");
      return res.json();
    },
  });

  const toggleBookmark = useMutation({
    mutationFn: async (id: number) => {
      const res = await fetch(`/api/resources/${id}/bookmark`, {
        method: "POST",
      });
      if (!res.ok) throw new Error("Failed to toggle bookmark");
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["bookmarked-resources"] });
      queryClient.invalidateQueries({ queryKey: ["resources"] });
    },
  });

  return (
    <div className="max-w-6xl mx-auto space-y-6">
      <div>
        <h1 className="text-2xl font-mono font-bold">Saved Intelligence</h1>
        <p className="text-text-muted">
          Your bookmarked resources and field notes.
        </p>
      </div>

      <div className="flex border-b border-border">
        <button
          onClick={() => setActiveTab("resources")}
          className={`flex items-center gap-2 px-6 py-3 font-mono text-sm border-b-2 transition-colors ${
            activeTab === "resources"
              ? "border-accent-primary text-accent-primary bg-accent-primary/5"
              : "border-transparent text-text-muted hover:text-text-primary hover:bg-surface"
          }`}
        >
          <Bookmark size={16} /> Bookmarked Resources
        </button>
        <button
          onClick={() => setActiveTab("notes")}
          className={`flex items-center gap-2 px-6 py-3 font-mono text-sm border-b-2 transition-colors ${
            activeTab === "notes"
              ? "border-accent-primary text-accent-primary bg-accent-primary/5"
              : "border-transparent text-text-muted hover:text-text-primary hover:bg-surface"
          }`}
        >
          <PenTool size={16} /> Field Notes
        </button>
      </div>

      {activeTab === "resources" && (
        <div>
          {resLoading ? (
            <div className="text-center py-12 text-text-muted animate-pulse">
              Loading...
            </div>
          ) : resources?.length > 0 ? (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {resources.map((resource: any) => (
                <div
                  key={resource.id}
                  className="card p-5 flex flex-col h-full hover:border-text-muted transition-colors"
                >
                  <div className="flex justify-between items-start mb-3">
                    <h3 className="font-semibold text-lg mb-1 pr-4">
                      {resource.title}
                    </h3>
                    <button
                      onClick={() => toggleBookmark.mutate(resource.id)}
                      className="p-1.5 rounded-full text-accent-primary bg-accent-primary/10 hover:bg-warning/10 hover:text-warning transition-colors shrink-0"
                      title="Remove bookmark"
                    >
                      <Trash2 size={16} />
                    </button>
                  </div>
                  <p className="text-sm text-text-muted mb-4 line-clamp-3 flex-1">
                    {resource.description}
                  </p>
                  <div className="flex items-center justify-between mt-auto pt-4 border-t border-border">
                    <span className="px-2 py-0.5 rounded text-[10px] uppercase font-mono bg-surface-light text-text-muted border border-border">
                      {resource.type}
                    </span>
                    <a
                      href={resource.url}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="text-text-muted hover:text-accent-primary transition-colors"
                    >
                      <ExternalLink size={18} />
                    </a>
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <div className="text-center py-12 card bg-surface-light border-dashed">
              <Bookmark
                size={32}
                className="mx-auto text-text-muted mb-4 opacity-50"
              />
              <p className="text-text-muted">
                You haven't bookmarked any resources yet.
              </p>
              <Link
                href="/resources"
                className="text-accent-primary hover:underline text-sm mt-2 inline-block"
              >
                Browse Library
              </Link>
            </div>
          )}
        </div>
      )}

      {activeTab === "notes" && (
        <div className="space-y-4">
          {notesLoading ? (
            <div className="text-center py-12 text-text-muted animate-pulse">
              Loading...
            </div>
          ) : notes?.length > 0 ? (
            notes.map((note: any) => (
              <div key={note.id} className="card p-6">
                <div className="flex justify-between items-center mb-4 pb-4 border-b border-border">
                  <Link
                    href={`/curriculum/${note.day_id}`}
                    className="text-accent-primary hover:underline font-mono text-sm flex items-center gap-2"
                  >
                    DAY {note.day_id} <ExternalLink size={14} />
                  </Link>
                  <span className="text-xs text-text-muted font-mono">
                    Updated: {new Date(note.updated_at).toLocaleDateString()}
                  </span>
                </div>
                <div className="prose prose-invert prose-sm max-w-none prose-pre:bg-[#0D0F14] prose-pre:border prose-pre:border-border font-mono">
                  <ReactMarkdown>{note.content}</ReactMarkdown>
                </div>
              </div>
            ))
          ) : (
            <div className="text-center py-12 card bg-surface-light border-dashed">
              <PenTool
                size={32}
                className="mx-auto text-text-muted mb-4 opacity-50"
              />
              <p className="text-text-muted">
                You haven't taken any field notes yet.
              </p>
              <p className="text-sm text-text-muted mt-2">
                Notes taken during daily missions will appear here.
              </p>
            </div>
          )}
        </div>
      )}
    </div>
  );
}

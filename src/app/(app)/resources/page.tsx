"use client";

import { useState } from "react";
import {
  useQuery,
  useMutation,
  useQueryClient,
} from "@tanstack/react-query/build/modern";
import {
  Search,
  Filter,
  ExternalLink,
  Bookmark,
  ShieldAlert,
  BookOpen,
  Terminal,
  Code,
  Wrench,
  Shield,
  Video,
  Flame,
} from "lucide-react";
import Link from "next/link";

const TYPE_ICONS = {
  tool: Wrench,
  book: BookOpen,
  platform: Terminal,
  cheatsheet: Code,
  video: Video,
  article: BookOpen,
};

export default function ResourcesPage() {
  const [search, setSearch] = useState("");
  const [typeFilter, setTypeFilter] = useState("");
  const queryClient = useQueryClient();

  const { data: resources, isLoading } = useQuery({
    queryKey: ["resources", typeFilter],
    queryFn: async () => {
      let url = "/api/resources";
      if (typeFilter) url += `?type=${typeFilter}`;
      const res = await fetch(url);
      if (!res.ok) throw new Error("Failed to fetch resources");
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
      queryClient.invalidateQueries({ queryKey: ["resources"] });
    },
  });

  const filteredResources = (resources || []).filter(
    (r: any) =>
      r.title.toLowerCase().includes(search.toLowerCase()) ||
      r.description.toLowerCase().includes(search.toLowerCase()),
  );

  return (
    <div className="max-w-6xl mx-auto space-y-6">
      <div>
        <h1 className="text-2xl font-mono font-bold">Intelligence Library</h1>
        <p className="text-text-muted">
          Curated tools, platforms, and reading materials.
        </p>
      </div>

      {/* Filters & Search */}
      <div className="flex flex-col sm:flex-row gap-4 justify-between">
        <div className="relative w-full sm:w-96">
          <Search
            size={18}
            className="absolute left-3 top-1/2 -translate-y-1/2 text-text-muted"
          />
          <input
            type="text"
            placeholder="Search library..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="w-full bg-surface border border-border rounded-md pl-10 pr-4 py-2 text-sm focus:border-accent-primary focus:outline-none transition-colors"
          />
        </div>

        <div className="flex gap-2 overflow-x-auto pb-2 sm:pb-0 hide-scrollbar">
          <button
            onClick={() => setTypeFilter("")}
            className={`px-4 py-2 rounded-md text-sm font-mono border whitespace-nowrap ${!typeFilter ? "bg-surface border-text-muted text-text-primary" : "border-border text-text-muted hover:bg-surface/50"}`}
          >
            All
          </button>
          {["tool", "platform", "book", "cheatsheet", "video", "article"].map(
            (type) => (
              <button
                key={type}
                onClick={() => setTypeFilter(type)}
                className={`px-4 py-2 rounded-md text-sm font-mono border whitespace-nowrap capitalize ${typeFilter === type ? "bg-surface border-text-muted text-text-primary" : "border-border text-text-muted hover:bg-surface/50"}`}
              >
                {type}s
              </button>
            ),
          )}
        </div>
      </div>

      {/* Resource Grid */}
      {isLoading ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {[1, 2, 3, 4, 5, 6].map((i) => (
            <div
              key={i}
              className="h-40 bg-surface animate-pulse rounded-lg border border-border"
            />
          ))}
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {filteredResources.map((resource: any) => {
            const Icon =
              TYPE_ICONS[resource.type as keyof typeof TYPE_ICONS] || BookOpen;

            return (
              <div
                key={resource.id}
                className="card p-5 flex flex-col h-full hover:border-text-muted transition-colors group"
              >
                <div className="flex justify-between items-start mb-3">
                  <div className="p-2 rounded bg-surface-light text-text-muted group-hover:text-accent-primary transition-colors">
                    <Icon size={20} />
                  </div>
                  <div className="flex items-center gap-2">
                    <button
                      onClick={() => toggleBookmark.mutate(resource.id)}
                      className={`p-1.5 rounded-full transition-colors ${resource.is_bookmarked ? "text-accent-primary bg-accent-primary/10" : "text-text-muted hover:bg-surface-light"}`}
                      title={
                        resource.is_bookmarked ? "Remove bookmark" : "Bookmark"
                      }
                    >
                      <Bookmark
                        size={16}
                        fill={resource.is_bookmarked ? "currentColor" : "none"}
                      />
                    </button>
                  </div>
                </div>

                <h3 className="font-semibold text-lg mb-1">{resource.title}</h3>
                <p className="text-sm text-text-muted mb-4 line-clamp-2 flex-1">
                  {resource.description}
                </p>

                <div className="flex items-center justify-between mt-auto pt-4 border-t border-border">
                  <div className="flex gap-2">
                    <span className="px-2 py-0.5 rounded text-[10px] uppercase font-mono bg-surface-light text-text-muted border border-border">
                      {resource.type}
                    </span>
                    <span
                      className={`px-2 py-0.5 rounded text-[10px] uppercase font-mono border ${
                        resource.difficulty === "beginner"
                          ? "text-[#00FF9C] border-[#00FF9C]/30 bg-[#00FF9C]/10"
                          : resource.difficulty === "intermediate"
                            ? "text-[#00D4FF] border-[#00D4FF]/30 bg-[#00D4FF]/10"
                            : "text-[#FF6B35] border-[#FF6B35]/30 bg-[#FF6B35]/10"
                      }`}
                    >
                      {resource.difficulty}
                    </span>
                  </div>
                  <a
                    href={resource.url}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-text-muted hover:text-accent-primary transition-colors"
                    title="Open Resource"
                  >
                    <ExternalLink size={18} />
                  </a>
                </div>
              </div>
            );
          })}

          {filteredResources.length === 0 && (
            <div className="col-span-full py-12 text-center text-text-muted">
              No resources found matching your search.
            </div>
          )}
        </div>
      )}
    </div>
  );
}

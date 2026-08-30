// @ts-nocheck
"use client";

import { useEffect, useRef } from "react";
import { useQuery } from "@tanstack/react-query/build/modern";
import * as d3 from "d3";
import { PHASE_COLORS } from "@/types";

type Node = {
  id: string;
  label: string;
  category: string;
  status: "completed" | "available" | "in_progress" | "locked";
  day_ids: number[];
  x?: number;
  y?: number;
};

type Edge = {
  source_id: string;
  target_id: string;
};

export default function SkillTreeClient() {
  const svgRef = useRef<SVGSVGElement>(null);
  const containerRef = useRef<HTMLDivElement>(null);

  const { data, isLoading } = useQuery({
    queryKey: ["skill-tree"],
    queryFn: async () => {
      const res = await fetch("/api/skills");
      if (!res.ok) throw new Error("Failed to fetch skill tree");
      return res.json();
    },
    staleTime: 5 * 60 * 1000,
  });

  useEffect(() => {
    if (!data || !svgRef.current || !containerRef.current) return;

    const width = containerRef.current.clientWidth;
    const height = containerRef.current.clientHeight;

    // Clear previous
    d3.select(svgRef.current).selectAll("*").remove();

    const svg = d3
      .select(svgRef.current)
      .attr("width", width)
      .attr("height", height)
      .call(
        d3
          .zoom<SVGSVGElement, unknown>()
          .scaleExtent([0.1, 4])
          .on("zoom", (event) => {
            g.attr("transform", event.transform);
          }),
      );

    const g = svg.append("g");

    // Create copies of data for D3 simulation
    const nodes: d3.SimulationNodeDatum[] & Node[] = data.nodes.map(
      (d: any) => ({ ...d }),
    );
    const links: d3.SimulationLinkDatum<d3.SimulationNodeDatum & Node>[] =
      data.edges.map((d: any) => ({
        source: d.source_id,
        target: d.target_id,
      }));

    // Define simulation
    const simulation = d3
      .forceSimulation(nodes)
      .force(
        "link",
        d3
          .forceLink(links)
          .id((d: any) => d.id)
          .distance(120),
      )
      .force("charge", d3.forceManyBody().strength(-800))
      .force("center", d3.forceCenter(width / 2, height / 2))
      .force("collide", d3.forceCollide().radius(60));

    // Draw links
    const link = g
      .append("g")
      .selectAll("line")
      .data(links)
      .join("line")
      .attr("stroke", (d: any) => {
        // Highlight path if source is completed
        return d.source.status === "completed"
          ? "rgba(0, 255, 156, 0.4)"
          : "rgba(255, 255, 255, 0.1)";
      })
      .attr("stroke-width", (d: any) =>
        d.source.status === "completed" ? 2 : 1,
      )
      .attr("stroke-dasharray", (d: any) =>
        d.target.status === "locked" ? "5,5" : "none",
      );

    // Node group
    const node = g
      .append("g")
      .selectAll("g")
      .data(nodes)
      .join("g")
      .call(
        d3
          .drag<SVGGElement, d3.SimulationNodeDatum & Node>()
          .on("start", dragstarted)
          .on("drag", dragged)
          .on("end", dragended),
      );

    // Node circles
    node
      .append("circle")
      .attr("r", 30)
      .attr("fill", (d) => {
        if (d.status === "completed") return "rgba(0, 255, 156, 0.15)";
        if (d.status === "available") return "rgba(255, 255, 255, 0.05)";
        if (d.status === "in_progress") return "rgba(0, 212, 255, 0.15)";
        return "rgba(0, 0, 0, 0.3)";
      })
      .attr("stroke", (d) => {
        if (d.status === "completed") return "#00FF9C";
        if (d.status === "available") return "#5A6070";
        if (d.status === "in_progress") return "#00D4FF";
        return "#1F2330";
      })
      .attr("stroke-width", 2);

    // Node icons/text (simplified to first letter for visual)
    node
      .append("text")
      .text((d) => d.label.substring(0, 2).toUpperCase())
      .attr("text-anchor", "middle")
      .attr("dy", ".3em")
      .attr("fill", (d) => (d.status === "locked" ? "#5A6070" : "#E8EAF0"))
      .attr("font-family", "var(--font-inter)")
      .attr("font-size", "14px")
      .attr("font-weight", "bold");

    // Label text outside circle
    node
      .append("text")
      .text((d) => d.label)
      .attr("text-anchor", "middle")
      .attr("dy", 45)
      .attr("fill", (d) => (d.status === "locked" ? "#5A6070" : "#E8EAF0"))
      .attr("font-family", "var(--font-inter)")
      .attr("font-size", "12px");

    // Tooltip implementation (basic title for now)
    node
      .append("title")
      .text(
        (d) =>
          `${d.label}\nCategory: ${d.category}\nStatus: ${d.status.toUpperCase()}\nDays: ${d.day_ids.join(", ")}`,
      );

    simulation.on("tick", () => {
      link
        .attr("x1", (d: any) => d.source.x)
        .attr("y1", (d: any) => d.source.y)
        .attr("x2", (d: any) => d.target.x)
        .attr("y2", (d: any) => d.target.y);

      node.attr("transform", (d: any) => `translate(${d.x},${d.y})`);
    });

    // Drag functions
    function dragstarted(event: any, d: any) {
      if (!event.active) simulation.alphaTarget(0.3).restart();
      d.fx = d.x;
      d.fy = d.y;
    }

    function dragged(event: any, d: any) {
      d.fx = event.x;
      d.fy = event.y;
    }

    function dragended(event: any, d: any) {
      if (!event.active) simulation.alphaTarget(0);
      d.fx = null;
      d.fy = null;
    }

    return () => {
      simulation.stop();
    };
  }, [data]);

  if (isLoading) {
    return (
      <div className="absolute inset-0 flex items-center justify-center text-text-muted font-mono animate-pulse">
        Initializing graph...
      </div>
    );
  }

  return (
    <div ref={containerRef} className="w-full h-full">
      <svg
        ref={svgRef}
        className="w-full h-full cursor-grab active:cursor-grabbing"
      />

      {/* Legend */}
      <div className="absolute bottom-4 left-4 bg-background/80 backdrop-blur border border-border rounded-md p-3 text-xs font-mono space-y-2">
        <div className="flex items-center gap-2">
          <div className="w-3 h-3 rounded-full border-2 border-[#00FF9C] bg-[#00FF9C]/20" />
          <span>Mastered</span>
        </div>
        <div className="flex items-center gap-2">
          <div className="w-3 h-3 rounded-full border-2 border-[#00D4FF] bg-[#00D4FF]/20" />
          <span>In Progress</span>
        </div>
        <div className="flex items-center gap-2">
          <div className="w-3 h-3 rounded-full border-2 border-[#5A6070] bg-transparent" />
          <span>Unlocked</span>
        </div>
        <div className="flex items-center gap-2 opacity-50">
          <div className="w-3 h-3 rounded-full border-2 border-border bg-black" />
          <span>Locked</span>
        </div>
      </div>
    </div>
  );
}

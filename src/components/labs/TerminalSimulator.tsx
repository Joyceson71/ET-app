"use client";

import { useState, useRef, useEffect } from "react";
import { labScenarios } from "@/lib/labScenarios";

interface TerminalLine {
  type: "input" | "output";
  content: string;
}

export default function TerminalSimulator({ dayId }: { dayId: number }) {
  const scenario = labScenarios[dayId] || {
    id: dayId,
    welcomeMessage: [
      `Welcome to HackPath Simulated Lab (Day ${dayId}).`,
      "Target IP: 10.10.10.X",
      "Type 'help' for available commands."
    ],
    expectedCommands: [
      {
        command: "help",
        output: [
          "Available commands:",
          "  help     - Show this message",
          "  clear    - Clear terminal",
          "  whoami   - Print current user",
        ]
      },
      {
        command: "whoami",
        output: ["root"]
      }
    ],
    flag: "FLAG{generic_flag}"
  };

  const [lines, setLines] = useState<TerminalLine[]>(
    scenario.welcomeMessage.map((msg) => ({ type: "output", content: msg }))
  );
  const [currentInput, setCurrentInput] = useState("");
  const [currentStage, setCurrentStage] = useState(0);
  const bottomRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [lines]);

  const handleCommand = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === "Enter") {
      const cmd = currentInput.trim();
      setCurrentInput("");

      if (!cmd) {
        setLines((prev) => [...prev, { type: "input", content: "" }]);
        return;
      }

      const newLines: TerminalLine[] = [...lines, { type: "input", content: cmd }];

      if (cmd.toLowerCase() === "clear") {
        setLines([]);
        return;
      }

      // Check against scenario
      const matchedCommand = scenario.expectedCommands.find(
        (c) => c.command === cmd
      );

      if (matchedCommand) {
        if (matchedCommand.requiresStage !== undefined && currentStage < matchedCommand.requiresStage) {
           newLines.push({ type: "output", content: `bash: ${cmd.split(" ")[0]}: Connection timed out or prerequisites not met.` });
        } else {
           matchedCommand.output.forEach((outLine) => {
             newLines.push({ type: "output", content: outLine });
           });
           if (matchedCommand.unlocksStage !== undefined && matchedCommand.unlocksStage > currentStage) {
             setCurrentStage(matchedCommand.unlocksStage);
           }
        }
      } else {
        newLines.push({ type: "output", content: `bash: ${cmd.split(" ")[0]}: command not found or not supported in this lab` });
      }

      setLines(newLines);
    }
  };

  return (
    <div className="w-full h-[500px] bg-[#0D0F14] border border-border rounded-xl flex flex-col font-mono text-sm shadow-[0_8px_32px_rgba(0,0,0,0.8)] overflow-hidden">
      {/* Terminal Header */}
      <div className="bg-[#1A1F2E] px-4 py-2 border-b border-border flex items-center gap-2">
        <div className="flex gap-1.5">
          <div className="w-3 h-3 rounded-full bg-red-500/80" />
          <div className="w-3 h-3 rounded-full bg-yellow-500/80" />
          <div className="w-3 h-3 rounded-full bg-green-500/80" />
        </div>
        <div className="text-text-muted text-xs mx-auto">root@hackpath:~</div>
      </div>

      {/* Terminal Body */}
      <div className="flex-1 p-4 overflow-y-auto text-text-primary" onClick={() => document.getElementById("terminal-input")?.focus()}>
        {lines.map((line, i) => (
          <div key={i} className="mb-1 leading-relaxed">
            {line.type === "input" ? (
              <div className="flex text-accent-primary">
                <span className="mr-2">root@hackpath:~$</span>
                <span>{line.content}</span>
              </div>
            ) : (
              <div className="text-[#E8EAF0] whitespace-pre-wrap">{line.content}</div>
            )}
          </div>
        ))}
        <div className="flex text-accent-primary mt-1 items-center">
          <span className="mr-2">root@hackpath:~$</span>
          <input
            id="terminal-input"
            type="text"
            value={currentInput}
            onChange={(e) => setCurrentInput(e.target.value)}
            onKeyDown={handleCommand}
            className="flex-1 bg-transparent outline-none border-none text-text-primary"
            autoFocus
            autoComplete="off"
            spellCheck="false"
          />
        </div>
        <div ref={bottomRef} />
      </div>
    </div>
  );
}

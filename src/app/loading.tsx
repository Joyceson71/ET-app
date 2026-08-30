import { Terminal } from 'lucide-react';

export default function Loading() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-background">
      <div className="flex flex-col items-center gap-4">
        <div className="animate-spin text-accent-primary">
          <Terminal size={40} />
        </div>
        <div className="font-mono text-text-muted animate-pulse">
          Initializing environment<span className="text-accent-primary animate-blink-cursor">_</span>
        </div>
      </div>
    </div>
  );
}

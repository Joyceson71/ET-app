'use client';

import { useEffect } from 'react';
import Link from 'next/link';
import { ShieldAlert, RotateCcw } from 'lucide-react';

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    // Log the error to an error reporting service
    console.error(error);
  }, [error]);

  return (
    <div className="min-h-screen flex items-center justify-center bg-background p-4 terminal-grid">
      <div className="card p-8 max-w-md w-full text-center border-warning/30 bg-warning/5">
        <ShieldAlert size={48} className="mx-auto text-warning mb-6" />
        <h1 className="text-2xl font-mono font-bold text-text-primary mb-2">System Failure</h1>
        <p className="text-sm text-text-muted mb-6 font-mono">
          [ERROR]: {error.message || 'An unexpected error occurred during execution.'}
        </p>
        <div className="flex flex-col gap-3">
          <button
            onClick={() => reset()}
            className="btn-primary py-2.5 flex items-center justify-center gap-2"
          >
            <RotateCcw size={16} /> Retry Execution
          </button>
          <Link href="/dashboard" className="btn-secondary py-2.5">
            Return to Base
          </Link>
        </div>
      </div>
    </div>
  );
}

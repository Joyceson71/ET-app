import Link from 'next/link';
import { SearchX, Home } from 'lucide-react';

export default function NotFound() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-background p-4 terminal-grid">
      <div className="card p-8 max-w-md w-full text-center">
        <SearchX size={48} className="mx-auto text-accent-primary mb-6" />
        <h1 className="text-4xl font-mono font-bold text-text-primary mb-2">404</h1>
        <p className="text-sm text-text-muted mb-6 font-mono">
          [NOT_FOUND]: The requested endpoint does not exist.
        </p>
        <Link href="/" className="btn-primary py-2.5 flex items-center justify-center gap-2 w-full">
          <Home size={16} /> Return to Homepage
        </Link>
      </div>
    </div>
  );
}

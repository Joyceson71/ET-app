'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { createClient } from '@/lib/supabase/client';
import Link from 'next/link';
import { Terminal, Lock, Mail } from 'lucide-react';
import { motion } from 'framer-motion';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    const supabase = createClient();
    const { error: authError } = await supabase.auth.signInWithPassword({ email, password });
    
    if (authError) {
      setError(authError.message);
      setLoading(false);
    } else {
      router.push('/dashboard');
      router.refresh();
    }
  };

  const demoLogin = async () => {
    setEmail('demo@hackpath.io');
    setPassword('password123');
    const supabase = createClient();
    setLoading(true);
    const { error } = await supabase.auth.signInWithPassword({ email: 'demo@hackpath.io', password: 'password123' });
    if (!error) {
      router.push('/dashboard');
      router.refresh();
    } else {
      setLoading(false);
      setError('Demo account error. Try creating a new account.');
    }
  };

  return (
    <div className="min-h-screen bg-background flex flex-col items-center justify-center p-4 terminal-grid">
      <Link href="/" className="absolute top-8 left-8 flex items-center gap-2">
        <Terminal size={20} className="text-accent-primary" />
        <span className="font-mono font-bold text-text-primary">HackPath_</span>
      </Link>

      <motion.div 
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="w-full max-w-md"
      >
        <div className="card p-8">
          <h1 className="text-2xl font-mono font-bold mb-2">Authenticate</h1>
          <p className="text-text-muted text-sm mb-6">Enter your credentials to access the curriculum.</p>

          <form onSubmit={handleLogin} className="space-y-4">
            {error && (
              <div className="p-3 bg-warning/10 border border-warning/30 rounded-md text-warning text-sm font-mono">
                [ERROR] {error}
              </div>
            )}
            
            <div className="space-y-1">
              <label className="text-sm font-mono text-text-muted">Email</label>
              <div className="relative">
                <Mail size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-text-muted" />
                <input 
                  type="email" 
                  value={email}
                  onChange={e => setEmail(e.target.value)}
                  className="w-full bg-surface border border-border rounded-md pl-10 pr-3 py-2 text-sm focus:border-accent-primary focus:outline-none transition-colors"
                  required
                  placeholder="hacker@example.com"
                />
              </div>
            </div>

            <div className="space-y-1">
              <label className="text-sm font-mono text-text-muted">Password</label>
              <div className="relative">
                <Lock size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-text-muted" />
                <input 
                  type="password" 
                  value={password}
                  onChange={e => setPassword(e.target.value)}
                  className="w-full bg-surface border border-border rounded-md pl-10 pr-3 py-2 text-sm focus:border-accent-primary focus:outline-none transition-colors"
                  required
                  placeholder="••••••••"
                />
              </div>
            </div>

            <button 
              type="submit" 
              className="w-full btn-primary py-2.5 mt-2 flex justify-center items-center"
              disabled={loading}
            >
              {loading ? <span className="animate-pulse">Authenticating...</span> : 'Login'}
            </button>
          </form>

          <div className="mt-6">
            <button onClick={demoLogin} className="w-full btn-secondary py-2 border-dashed border-text-muted/30">
              Quick Login: Demo Account
            </button>
          </div>

          <div className="mt-6 text-center text-sm text-text-muted">
            Don't have an account? <Link href="/signup" className="text-accent-primary hover:underline">Sign up</Link>
          </div>
        </div>
      </motion.div>
    </div>
  );
}

"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Terminal, Lock, Mail, User } from "lucide-react";
import { motion } from "framer-motion";
import { signIn } from "next-auth/react";

export default function SignupPage() {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  const handleSignup = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError("");

    const res = await fetch("/api/auth/register", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ name, email, password }),
    });

    const data = await res.json();

    if (!res.ok) {
      setError(data.error || "Failed to create account");
      setLoading(false);
    } else {
      const signInRes = await signIn("credentials", {
        email,
        password,
        redirect: false,
      });
      if (!signInRes?.error) {
        router.push("/dashboard");
        router.refresh();
      } else {
        router.push("/login?message=Check your email to verify");
      }
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
          <h1 className="text-2xl font-mono font-bold mb-2">
            Initialize Profile
          </h1>
          <p className="text-text-muted text-sm mb-6">
            Create your account to start the 120-day curriculum.
          </p>

          <form onSubmit={handleSignup} className="space-y-4">
            {error && (
              <div className="p-3 bg-warning/10 border border-warning/30 rounded-md text-warning text-sm font-mono">
                [ERROR] {error}
              </div>
            )}

            <div className="space-y-1">
              <label className="text-sm font-mono text-text-muted">
                Handle (Name)
              </label>
              <div className="relative">
                <User
                  size={16}
                  className="absolute left-3 top-1/2 -translate-y-1/2 text-text-muted"
                />
                <input
                  type="text"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  className="w-full bg-surface border border-border rounded-md pl-10 pr-3 py-2 text-sm focus:border-accent-primary focus:outline-none transition-colors"
                  required
                  placeholder="zero_cool"
                />
              </div>
            </div>

            <div className="space-y-1">
              <label className="text-sm font-mono text-text-muted">Email</label>
              <div className="relative">
                <Mail
                  size={16}
                  className="absolute left-3 top-1/2 -translate-y-1/2 text-text-muted"
                />
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="w-full bg-surface border border-border rounded-md pl-10 pr-3 py-2 text-sm focus:border-accent-primary focus:outline-none transition-colors"
                  required
                  placeholder="hacker@example.com"
                />
              </div>
            </div>

            <div className="space-y-1">
              <label className="text-sm font-mono text-text-muted">
                Password
              </label>
              <div className="relative">
                <Lock
                  size={16}
                  className="absolute left-3 top-1/2 -translate-y-1/2 text-text-muted"
                />
                <input
                  type="password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="w-full bg-surface border border-border rounded-md pl-10 pr-3 py-2 text-sm focus:border-accent-primary focus:outline-none transition-colors"
                  required
                  minLength={8}
                  placeholder="••••••••"
                />
              </div>
            </div>

            <button
              type="submit"
              className="w-full btn-primary py-2.5 mt-2 flex justify-center items-center"
              disabled={loading}
            >
              {loading ? (
                <span className="animate-pulse">Executing...</span>
              ) : (
                "Create Account"
              )}
            </button>
          </form>

          <div className="mt-6 text-center text-sm text-text-muted">
            Already have an account?{" "}
            <Link href="/login" className="text-accent-primary hover:underline">
              Login
            </Link>
          </div>
        </div>
      </motion.div>
    </div>
  );
}

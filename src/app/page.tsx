"use client";

import Link from 'next/link';
import { Shield, ChevronRight, Zap, GitBranch, Trophy, BookOpen, Lock, Unlock, Activity, Download } from 'lucide-react';
import { motion } from 'framer-motion';

const phases = [
  { phase: 1, title: 'Foundations', days: '1–20', desc: 'Networking, Linux, web fundamentals', color: '#00FF9C' },
  { phase: 2, title: 'Reconnaissance', days: '21–40', desc: 'OSINT, Nmap, Shodan, Google Dorking', color: '#00D4FF' },
  { phase: 3, title: 'Exploitation', days: '41–60', desc: 'Metasploit, SQLi, XSS, buffer overflows', color: '#FF6B35' },
  { phase: 4, title: 'Web App Hacking', days: '61–80', desc: 'OWASP Top 10, Burp Suite, API hacking', color: '#7B61FF' },
  { phase: 5, title: 'Advanced Techniques', days: '81–100', desc: 'Active Directory, pivoting, privilege escalation', color: '#FF3B9A' },
  { phase: 6, title: 'Real-World Practice', days: '101–120', desc: 'CTF challenges, bug bounty, mock pentest', color: '#FFD700' },
];

const features = [
  {
    icon: GitBranch,
    title: 'Living Skill Tree',
    desc: 'Interactive D3.js graph where completed skills unlock dependencies — watch your expertise grow visually.',
    color: '#00FF9C',
  },
  {
    icon: BookOpen,
    title: '120-Day Curriculum',
    desc: 'Real cybersecurity content: concepts, curated videos, labs on TryHackMe/HackTheBox, and quizzes.',
    color: '#7B61FF',
  },
  {
    icon: Trophy,
    title: 'XP & Badges',
    desc: 'Earn XP for completing days, labs, and quizzes. Level up from Script Kiddie to Elite Hacker.',
    color: '#FF6B35',
  },
  {
    icon: Activity,
    title: 'Progress Dashboard',
    desc: 'GitHub-style streak calendar, phase progress bars, estimated completion date, and weekly reports.',
    color: '#00D4FF',
  },
  {
    icon: Lock,
    title: 'Structured Unlocks',
    desc: 'Each day unlocks the next only when you pass the quiz. One skip allowed per week for honest learning.',
    color: '#FF3B9A',
  },
  {
    icon: Unlock,
    title: 'Resource Library',
    desc: '80+ curated tools, books, platforms, and cheatsheets — filterable by type, difficulty, and phase.',
    color: '#FFD700',
  },
];

const containerVariants = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: { staggerChildren: 0.1 }
  }
};

const itemVariants = {
  hidden: { opacity: 0, y: 20 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.5, ease: "easeOut" } }
};

export default function LandingPage() {
  return (
    <div className="min-h-screen bg-background terminal-grid overflow-hidden">
      {/* Dynamic Background Effects */}
      <div className="fixed inset-0 pointer-events-none" aria-hidden="true">
        <div className="absolute top-[-10%] left-[-10%] w-[50%] h-[50%] bg-accent-primary/10 rounded-full blur-[120px] animate-pulse" />
        <div className="absolute bottom-[-10%] right-[-10%] w-[50%] h-[50%] bg-accent-secondary/10 rounded-full blur-[120px] animate-pulse" style={{ animationDelay: '2s' }} />
      </div>

      {/* Header */}
      <header className="relative z-50 border-b border-border/50 bg-background/60 backdrop-blur-md sticky top-0">
        <div className="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
          <motion.div 
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            className="flex items-center gap-2"
          >
            <span className="font-mono font-bold text-2xl text-text-primary">
              Hack<span className="text-accent-primary">Path</span>
              <span className="text-accent-primary animate-blink-cursor">_</span>
            </span>
          </motion.div>
          <motion.nav 
            initial={{ opacity: 0, y: -10 }}
            animate={{ opacity: 1, y: 0 }}
            className="hidden md:flex items-center gap-6" aria-label="Site navigation"
          >
            <a href="#phases" className="text-text-muted hover:text-accent-primary text-sm font-medium transition-colors">Curriculum</a>
            <a href="#features" className="text-text-muted hover:text-accent-primary text-sm font-medium transition-colors">Features</a>
            <Link href="/login" className="btn-ghost text-sm uppercase tracking-wider">Sign In</Link>
            <a href="/hackpath.apk" download className="btn-secondary text-sm flex items-center gap-2 font-mono uppercase tracking-wider">
              <Download size={16} /> App
            </a>
            <Link href="/signup" className="btn-primary text-sm font-mono uppercase tracking-wider shadow-[0_0_15px_rgba(0,255,156,0.4)]" id="hero-cta-nav">
              Initialize
            </Link>
          </motion.nav>
        </div>
      </header>

      <main>
        {/* Hero Section */}
        <section className="relative z-10 max-w-7xl mx-auto px-6 pt-32 pb-24 text-center" aria-labelledby="hero-heading">
          <motion.div 
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.5 }}
            className="inline-flex items-center gap-2 px-4 py-2 rounded-full border border-accent-primary/30 bg-accent-primary/10 text-accent-primary text-sm font-mono mb-8 backdrop-blur-sm"
          >
            <Shield size={14} aria-hidden="true" />
            <span>Zero to Job-Ready Pentester in 120 Days</span>
          </motion.div>

          <motion.h1 
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.1, duration: 0.6 }}
            id="hero-heading" className="text-6xl md:text-8xl font-mono font-black text-text-primary mb-6 leading-tight tracking-tight"
          >
            Master{' '}
            <span className="text-transparent bg-clip-text bg-gradient-to-r from-accent-primary to-accent-secondary drop-shadow-[0_0_20px_rgba(0,255,156,0.3)]">Ethical Hacking</span>
            <br />
            <span className="text-text-muted/80 text-5xl md:text-6xl font-sans">The Right Way</span>
          </motion.h1>

          <motion.p 
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.3 }}
            className="text-xl text-text-muted max-w-2xl mx-auto mb-12 font-sans leading-relaxed"
          >
            Stop watching random tutorials. Follow a strictly guided 120-day curriculum with embedded state-machine labs, an interactive skill tree, and XP gamification.
          </motion.p>

          <motion.div 
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.4 }}
            className="flex flex-wrap items-center justify-center gap-6"
          >
            <Link href="/signup" id="hero-cta-main" className="group relative inline-flex items-center justify-center px-8 py-4 font-mono font-bold text-background bg-accent-primary rounded-md overflow-hidden transition-all hover:scale-105 shadow-[0_0_30px_rgba(0,255,156,0.5)]">
              <span className="absolute w-0 h-0 transition-all duration-500 ease-out bg-white rounded-full group-hover:w-56 group-hover:h-56 opacity-10"></span>
              <span className="relative flex items-center gap-2">Start Your Journey <ChevronRight size={20} className="group-hover:translate-x-1 transition-transform" /></span>
            </Link>
            <a href="/hackpath.apk" download className="group relative inline-flex items-center justify-center px-8 py-4 font-mono font-bold text-text-primary bg-surface border border-border rounded-md overflow-hidden transition-all hover:bg-surface-light hover:border-text-muted">
              <span className="relative flex items-center gap-2"><Download size={20} className="group-hover:-translate-y-1 transition-transform" /> Download APK</span>
            </a>
          </motion.div>

          {/* Stats row */}
          <motion.div 
            variants={containerVariants}
            initial="hidden"
            animate="visible"
            className="mt-20 grid grid-cols-2 md:grid-cols-4 gap-6 max-w-4xl mx-auto"
          >
            {[
              { value: '120', label: 'Daily Missions' },
              { value: '360', label: 'Quiz Questions' },
              { value: '50+', label: 'Skill Nodes' },
              { value: '80+', label: 'Resources' },
            ].map(({ value, label }) => (
              <motion.div key={label} variants={itemVariants} className="clay-card ultra-glow p-6 text-center hover:-translate-y-1 transition-transform duration-300">
                <div className="text-4xl font-mono font-black text-accent-primary mb-2 drop-shadow-[0_0_10px_rgba(0,255,156,0.8)]">{value}</div>
                <div className="text-sm font-semibold text-text-muted uppercase tracking-widest">{label}</div>
              </motion.div>
            ))}
          </motion.div>
        </section>

        {/* Phases Section */}
        <section id="phases" className="relative z-10 max-w-7xl mx-auto px-6 py-24 border-t border-border/50" aria-labelledby="phases-heading">
          <div className="text-center mb-16">
            <h2 id="phases-heading" className="text-3xl md:text-5xl font-mono font-bold text-text-primary mb-4">The 120-Day Path</h2>
            <p className="text-text-muted max-w-2xl mx-auto">A battle-tested progression from absolute basics to advanced red teaming.</p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {phases.map((p) => (
              <motion.div 
                key={p.phase} 
                whileHover={{ scale: 1.02 }}
                className="card p-8 border-l-4 group transition-colors duration-300 hover:bg-surface-light" 
                style={{ borderLeftColor: p.color }}
              >
                <div className="text-sm font-mono font-bold mb-2 opacity-80" style={{ color: p.color }}>Phase {p.phase} • Days {p.days}</div>
                <h3 className="text-xl font-bold mb-3 text-text-primary group-hover:text-white transition-colors">{p.title}</h3>
                <p className="text-text-muted text-sm leading-relaxed">{p.desc}</p>
              </motion.div>
            ))}
          </div>
        </section>

        {/* Features Section */}

            <div className="flex flex-wrap justify-center gap-3">
              {[
                { title: 'Script Kiddie', xp: '0–499 XP', color: '#5A6070' },
                { title: 'Recon Specialist', xp: '500–999 XP', color: '#00D4FF' },
                { title: 'Exploit Rookie', xp: '1K–1.9K XP', color: '#7B61FF' },
                { title: 'Pentester', xp: '2K–2.9K XP', color: '#FF6B35' },
                { title: 'Red Team Operator', xp: '3K–3.9K XP', color: '#FF3B9A' },
                { title: 'Elite Hacker', xp: '4,000+ XP', color: '#00FF9C' },
              ].map(({ title, xp, color }) => (
                <div
                  key={title}
                  className="px-4 py-2.5 rounded-lg border text-sm font-mono"
                  style={{ borderColor: `${color}40`, background: `${color}10`, color }}
                >
                  {title}
                  <span className="block text-xs opacity-60 font-sans mt-0.5">{xp}</span>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* CTA */}
        <section className="relative z-10 max-w-4xl mx-auto px-6 py-20 text-center" aria-labelledby="cta-heading">
          <div
            className="clay-card ultra-glow p-12"
            style={{ background: 'linear-gradient(135deg, #00FF9C08 0%, #7B61FF08 100%)', borderColor: '#00FF9C20' }}
          >
            <h2 id="cta-heading" className="text-3xl md:text-4xl font-mono font-bold text-text-primary mb-4">
              Ready to Start?
            </h2>
            <p className="text-text-muted font-sans mb-8 max-w-lg mx-auto">
              Day 1 is waiting. No prerequisites. No prior experience needed.
              Just consistency and curiosity.
            </p>
            <Link href="/signup" id="cta-final-btn" className="btn-primary text-base px-10 py-3">
              Begin HackPath — Day 1
              <ChevronRight size={18} aria-hidden="true" />
            </Link>
          </div>
        </section>
      </main>

      {/* Footer */}
      <footer className="relative z-10 border-t border-border mt-8">
        <div className="max-w-7xl mx-auto px-6 py-8 flex flex-col md:flex-row items-center justify-between gap-4">
          <span className="font-mono text-text-muted text-sm">
            HackPath<span className="text-accent-primary">_</span> © {new Date().getFullYear()}
          </span>
          <p className="text-text-muted text-xs font-sans text-center">
            For educational purposes only. Always obtain written authorization before testing.
          </p>
        </div>
      </footer>
    </div>
  );
}

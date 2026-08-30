import type { Metadata } from 'next';
import Link from 'next/link';
import { Shield, ChevronRight, Zap, GitBranch, Trophy, BookOpen, Lock, Unlock, Activity, Download } from 'lucide-react';

export const metadata: Metadata = {
  title: 'HackPath — 120-Day Ethical Hacking Mastery Program',
  description: 'Go from complete beginner to job-ready penetration tester in 120 days. Structured curriculum, hands-on labs, skill tree visualization, and gamified XP system.',
};

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

export default function LandingPage() {
  return (
    <div className="min-h-screen bg-background terminal-grid">
      {/* Glow effects */}
      <div className="fixed inset-0 pointer-events-none overflow-hidden" aria-hidden="true">
        <div className="absolute top-0 left-1/4 w-96 h-96 bg-accent-primary/5 rounded-full blur-3xl" />
        <div className="absolute bottom-0 right-1/4 w-96 h-96 bg-accent-secondary/5 rounded-full blur-3xl" />
      </div>

      {/* Header */}
      <header className="relative z-10 border-b border-border/50 bg-surface/50 backdrop-blur-sm">
        <div className="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <span className="font-mono font-bold text-xl text-text-primary">
              Hack<span className="text-accent-primary">Path</span>
              <span className="text-accent-primary animate-blink-cursor">_</span>
            </span>
          </div>
          <nav className="hidden md:flex items-center gap-6" aria-label="Site navigation">
            <a href="#phases" className="text-text-muted hover:text-text-primary text-sm transition-colors">Curriculum</a>
            <a href="#features" className="text-text-muted hover:text-text-primary text-sm transition-colors">Features</a>
            <Link href="/login" className="btn-ghost text-sm">Sign In</Link>
            <Link href="/signup" className="btn-primary text-sm" id="hero-cta-nav">Start Free</Link>
            <a href="/hackpath.apk" download className="btn-secondary text-sm hidden sm:flex items-center gap-2">
              <Download size={16} />
              App
            </a>
          </nav>
        </div>
      </header>

      <main>
        {/* Hero Section */}
        <section className="relative z-10 max-w-7xl mx-auto px-6 pt-24 pb-20 text-center" aria-labelledby="hero-heading">
          <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full border border-accent-primary/30 bg-accent-primary/5 text-accent-primary text-sm font-mono mb-8">
            <Shield size={14} aria-hidden="true" />
            <span>Zero to Job-Ready Pentester in 120 Days</span>
          </div>

          <h1 id="hero-heading" className="text-5xl md:text-7xl font-mono font-bold text-text-primary mb-6 leading-tight">
            Master{' '}
            <span className="text-gradient-green">Ethical Hacking</span>
            <br />
            <span className="text-text-muted text-4xl md:text-5xl">The Right Way</span>
          </h1>

          <p className="text-lg text-text-muted max-w-2xl mx-auto mb-12 font-sans leading-relaxed">
            A structured 120-day curriculum with hands-on labs, an interactive skill tree, XP gamification,
            and real cybersecurity content — not a content dump. A guided path.
          </p>

          <div className="flex flex-wrap items-center justify-center gap-4">
            <Link href="/signup" id="hero-cta-main" className="btn-primary text-base px-8 py-3">
              Start Your Journey
              <ChevronRight size={18} aria-hidden="true" />
            </Link>
            <Link href="/login" className="btn-secondary text-base px-8 py-3" id="hero-demo-btn">
              Demo: demo@hackpath.io
            </Link>
            <a href="/hackpath.apk" download className="btn-secondary text-base px-8 py-3 flex items-center gap-2">
              <Download size={18} />
              Download APK
            </a>
          </div>

          {/* Stats row */}
          <div className="mt-16 grid grid-cols-2 md:grid-cols-4 gap-6 max-w-3xl mx-auto">
            {[
              { value: '120', label: 'Daily Missions' },
              { value: '360', label: 'Quiz Questions' },
              { value: '50+', label: 'Skill Nodes' },
              { value: '80+', label: 'Resources' },
            ].map(({ value, label }) => (
              <div key={label} className="clay-card ultra-glow px-4 py-5 text-center">
                <div className="text-3xl font-mono font-bold text-accent-primary mb-1">{value}</div>
                <div className="text-xs text-text-muted">{label}</div>
              </div>
            ))}
          </div>
        </section>

        {/* Phases Section */}
        <section id="phases" className="relative z-10 max-w-7xl mx-auto px-6 py-20" aria-labelledby="phases-heading">
          <div className="text-center mb-12">
            <h2 id="phases-heading" className="text-3xl md:text-4xl font-mono font-bold text-text-primary mb-4">
              <span className="text-accent-primary">{'>'}_</span> 6 Phases. 120 Missions.
            </h2>
            <p className="text-text-muted font-sans">Every day is a self-contained mission with a concept, lab, and quiz.</p>
          </div>

          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
            {phases.map(({ phase, title, days, desc, color }) => (
              <div
                key={phase}
                className="clay-card p-6 group hover:border-opacity-60 transition-all duration-300"
                style={{ '--phase-color': color } as React.CSSProperties}
              >
                <div className="flex items-start gap-4">
                  <div
                    className="w-10 h-10 rounded-lg flex items-center justify-center font-mono font-bold text-sm flex-shrink-0"
                    style={{ background: `${color}20`, color, border: `1px solid ${color}30` }}
                  >
                    P{phase}
                  </div>
                  <div>
                    <div className="font-mono font-semibold text-text-primary mb-0.5">
                      {title}
                    </div>
                    <div className="text-xs font-mono text-text-muted mb-2">Days {days}</div>
                    <p className="text-sm text-text-muted font-sans">{desc}</p>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </section>

        {/* Features Section */}
        <section id="features" className="relative z-10 max-w-7xl mx-auto px-6 py-20" aria-labelledby="features-heading">
          <div className="text-center mb-12">
            <h2 id="features-heading" className="text-3xl md:text-4xl font-mono font-bold text-text-primary mb-4">
              Built for{' '}
              <span className="text-gradient-violet">Serious Learners</span>
            </h2>
            <p className="text-text-muted font-sans">Not another video course. A guided, gamified, accountable learning system.</p>
          </div>

          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {features.map(({ icon: Icon, title, desc, color }) => (
              <div key={title} className="clay-card p-6 group">
                <div
                  className="w-10 h-10 rounded-lg flex items-center justify-center mb-4"
                  style={{ background: `${color}15`, border: `1px solid ${color}30` }}
                  aria-hidden="true"
                >
                  <Icon size={20} style={{ color }} />
                </div>
                <h3 className="font-mono font-semibold text-text-primary mb-2">{title}</h3>
                <p className="text-sm text-text-muted font-sans leading-relaxed">{desc}</p>
              </div>
            ))}
          </div>
        </section>

        {/* XP Level Progression */}
        <section className="relative z-10 max-w-7xl mx-auto px-6 py-20" aria-labelledby="levels-heading">
          <div className="clay-card p-8 text-center">
            <h2 id="levels-heading" className="text-2xl font-mono font-bold text-text-primary mb-2">
              <Zap size={20} className="inline mr-2 text-accent-secondary" aria-hidden="true" />
              Level Progression
            </h2>
            <p className="text-text-muted text-sm mb-8 font-sans">Earn XP by completing missions, labs, quizzes, and maintaining streaks</p>

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

'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { motion, AnimatePresence } from 'framer-motion';
import {
  LayoutDashboard, BookOpen, GitBranch, Library, Bookmark,
  User, Settings, ChevronLeft, ChevronRight, Flame, Zap, Terminal
} from 'lucide-react';
import { useAppStore } from '@/store/app-store';
import { getLevelInfo } from '@/lib/xp';
import { cn } from '@/lib/utils';

const navItems = [
  { href: '/dashboard', label: 'Dashboard', icon: LayoutDashboard },
  { href: '/curriculum', label: 'Curriculum', icon: BookOpen },
  { href: '/skill-tree', label: 'Skill Tree', icon: GitBranch },
  { href: '/resources', label: 'Resources', icon: Library },
  { href: '/bookmarks', label: 'Bookmarks', icon: Bookmark },
  { href: '/profile', label: 'Profile', icon: User },
  { href: '/settings', label: 'Settings', icon: Settings },
];

export default function Sidebar() {
  const pathname = usePathname();
  const { sidebarCollapsed, toggleSidebar, user } = useAppStore();
  const levelInfo = user ? getLevelInfo(user.xp) : null;

  return (
    <motion.aside
      animate={{ width: sidebarCollapsed ? 64 : 240 }}
      transition={{ duration: 0.2, ease: 'easeInOut' }}
      className="fixed left-0 top-0 bottom-0 z-40 flex flex-col bg-surface border-r border-border overflow-hidden"
    >
      {/* Logo */}
      <div className="flex items-center justify-between px-4 py-5 border-b border-border min-h-[64px]">
        <AnimatePresence>
          {!sidebarCollapsed && (
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              className="flex items-center gap-2"
            >
              <Terminal size={18} className="text-accent-primary flex-shrink-0" />
              <span className="font-mono font-bold text-lg text-text-primary">
                Hack<span className="text-accent-primary">Path</span>
                <span className="text-accent-primary animate-blink-cursor">_</span>
              </span>
            </motion.div>
          )}
        </AnimatePresence>
        {sidebarCollapsed && (
          <Terminal size={20} className="text-accent-primary mx-auto" />
        )}
        <button
          onClick={toggleSidebar}
          className="btn-ghost p-1.5 ml-auto flex-shrink-0"
          aria-label={sidebarCollapsed ? 'Expand sidebar' : 'Collapse sidebar'}
        >
          {sidebarCollapsed
            ? <ChevronRight size={14} />
            : <ChevronLeft size={14} />
          }
        </button>
      </div>

      {/* Navigation */}
      <nav className="flex-1 py-4 px-2 space-y-1 overflow-y-auto" role="navigation" aria-label="Main navigation">
        {navItems.map(({ href, label, icon: Icon }) => {
          const isActive = pathname === href || pathname.startsWith(href + '/');
          return (
            <Link
              key={href}
              href={href}
              className={cn('nav-item', isActive && 'active')}
              aria-current={isActive ? 'page' : undefined}
              title={sidebarCollapsed ? label : undefined}
            >
              <Icon size={18} className="flex-shrink-0" aria-hidden="true" />
              <AnimatePresence>
                {!sidebarCollapsed && (
                  <motion.span
                    initial={{ opacity: 0, width: 0 }}
                    animate={{ opacity: 1, width: 'auto' }}
                    exit={{ opacity: 0, width: 0 }}
                    className="text-sm overflow-hidden whitespace-nowrap"
                  >
                    {label}
                  </motion.span>
                )}
              </AnimatePresence>
            </Link>
          );
        })}
      </nav>

      {/* XP & Level Bar */}
      {user && (
        <div className="px-3 py-4 border-t border-border space-y-2">
          {/* Streak */}
          <div className={cn('flex items-center gap-2', sidebarCollapsed && 'justify-center')}>
            <Flame size={14} className="text-warning flex-shrink-0" />
            <AnimatePresence>
              {!sidebarCollapsed && (
                <motion.span
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  exit={{ opacity: 0 }}
                  className="text-xs text-text-muted font-mono"
                >
                  {user.streak} day streak
                </motion.span>
              )}
            </AnimatePresence>
          </div>

          {/* XP Level */}
          {levelInfo && (
            <div className="space-y-1">
              <div className={cn('flex items-center gap-2', sidebarCollapsed && 'justify-center')}>
                <Zap size={14} style={{ color: levelInfo.color }} className="flex-shrink-0" />
                <AnimatePresence>
                  {!sidebarCollapsed && (
                    <motion.div
                      initial={{ opacity: 0 }}
                      animate={{ opacity: 1 }}
                      exit={{ opacity: 0 }}
                      className="flex-1 min-w-0"
                    >
                      <div className="flex justify-between items-center">
                        <span className="text-xs font-mono truncate" style={{ color: levelInfo.color }}>
                          {levelInfo.title}
                        </span>
                        <span className="text-xs text-text-muted font-mono ml-2 flex-shrink-0">
                          {user.xp} XP
                        </span>
                      </div>
                      <div className="xp-bar mt-1">
                        <motion.div
                          className="xp-bar-fill"
                          initial={{ width: 0 }}
                          animate={{ width: `${levelInfo.progress}%` }}
                          transition={{ duration: 0.8, ease: 'easeOut' }}
                        />
                      </div>
                    </motion.div>
                  )}
                </AnimatePresence>
              </div>
            </div>
          )}
        </div>
      )}
    </motion.aside>
  );
}

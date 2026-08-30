'use client';

import { Menu, Search, LogOut } from 'lucide-react';
import { useAppStore } from '@/store/app-store';
import { signOut } from 'next-auth/react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';

export default function TopBar() {
  const { toggleSidebar, user, setUser } = useAppStore();
  const router = useRouter();
  const [dropdownOpen, setDropdownOpen] = useState(false);

  const handleSignOut = async () => {
    await signOut({ redirect: false });
    setUser(null);
    router.push('/');
  };

  return (
    <header className="h-16 border-b border-border bg-surface/50 backdrop-blur-xl sticky top-0 z-30 px-4 flex items-center justify-between">
      <div className="flex items-center gap-4">
        <button
          onClick={toggleSidebar}
          className="md:hidden btn-ghost p-2"
          aria-label="Toggle Menu"
        >
          <Menu size={20} />
        </button>

        {/* Global Search */}
        <div className="hidden sm:flex items-center relative w-72 group">
          <Search size={16} className="absolute left-3 text-text-muted group-focus-within:text-accent-primary transition-colors z-10" />
          <div className="absolute inset-0 bg-accent-primary/20 blur-xl opacity-0 group-focus-within:opacity-100 transition-opacity duration-500 rounded-lg pointer-events-none" />
          <input
            type="text"
            placeholder="Search curriculum, resources..."
            className="w-full bg-surface-2/80 border border-border rounded-lg pl-9 pr-4 py-2 text-sm focus:outline-none focus:border-accent-primary focus:ring-1 focus:ring-accent-primary transition-all placeholder:text-text-muted relative z-0"
          />
        </div>
      </div>

      <div className="flex items-center gap-4">
        {/* User Menu */}
        <div 
          className="relative"
          onMouseEnter={() => setDropdownOpen(true)}
          onMouseLeave={() => setDropdownOpen(false)}
        >
          <button className="flex items-center gap-2 btn-ghost px-2 py-1.5 rounded-md hover:bg-surface-2 transition-colors">
            <div className="w-8 h-8 rounded-full bg-accent-primary/10 flex items-center justify-center font-mono font-bold text-accent-primary text-sm border border-accent-primary/30 shadow-[0_0_10px_rgba(0,255,156,0.2)]">
              {user?.name?.[0]?.toUpperCase() || 'U'}
            </div>
            <span className="text-sm font-medium hidden sm:block tracking-wide">{user?.name || 'User'}</span>
          </button>
          
          <AnimatePresence>
            {dropdownOpen && (
              <motion.div
                initial={{ opacity: 0, y: 10, scale: 0.95 }}
                animate={{ opacity: 1, y: 0, scale: 1 }}
                exit={{ opacity: 0, y: 10, scale: 0.95 }}
                transition={{ duration: 0.15, ease: "easeOut" }}
                className="absolute right-0 mt-2 w-52 bg-surface/90 backdrop-blur-xl border border-border/50 rounded-xl shadow-[0_8px_32px_rgba(0,0,0,0.8)] overflow-hidden z-50"
              >
                <div className="py-2">
                  <Link href="/profile" className="block px-4 py-2 text-sm text-text-primary hover:bg-accent-primary/10 hover:text-accent-primary transition-colors w-full text-left">
                    Profile Dashboard
                  </Link>
                  <Link href="/settings" className="block px-4 py-2 text-sm text-text-primary hover:bg-accent-primary/10 hover:text-accent-primary transition-colors w-full text-left">
                    Preferences
                  </Link>
                  <div className="h-px bg-border/50 my-1.5 mx-2" />
                  <button
                    onClick={handleSignOut}
                    className="w-full text-left px-4 py-2 text-sm text-warning hover:bg-warning/10 flex items-center gap-2 transition-colors"
                  >
                    <LogOut size={14} />
                    Terminate Session
                  </button>
                </div>
              </motion.div>
            )}
          </AnimatePresence>
        </div>
      </div>
    </header>
  );
}

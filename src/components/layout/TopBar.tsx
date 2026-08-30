'use client';

import { Menu, Search, LogOut } from 'lucide-react';
import { useAppStore } from '@/store/app-store';
import { createClient } from '@/lib/supabase/client';
import { useRouter } from 'next/navigation';
import Link from 'next/link';

export default function TopBar() {
  const { toggleSidebar, user, setUser } = useAppStore();
  const router = useRouter();

  const handleSignOut = async () => {
    const supabase = createClient();
    await supabase.auth.signOut();
    setUser(null);
    router.push('/');
  };

  return (
    <header className="h-16 border-b border-border bg-surface/50 backdrop-blur-md sticky top-0 z-30 px-4 flex items-center justify-between">
      <div className="flex items-center gap-4">
        <button
          onClick={toggleSidebar}
          className="md:hidden btn-ghost p-2"
          aria-label="Toggle Menu"
        >
          <Menu size={20} />
        </button>

        {/* Global Search - Visual only for MVP */}
        <div className="hidden sm:flex items-center relative w-64 group">
          <Search size={16} className="absolute left-3 text-text-muted group-focus-within:text-accent-primary transition-colors" />
          <input
            type="text"
            placeholder="Search curriculum, resources..."
            className="w-full bg-background border border-border rounded-md pl-9 pr-4 py-1.5 text-sm focus:outline-none focus:border-accent-primary transition-colors placeholder:text-text-muted"
          />
        </div>
      </div>

      <div className="flex items-center gap-4">
        {/* User Menu */}
        <div className="relative group">
          <button className="flex items-center gap-2 btn-ghost px-2 py-1.5 rounded-md">
            <div className="w-7 h-7 rounded-full bg-accent-primary/10 flex items-center justify-center font-mono font-bold text-accent-primary text-xs border border-accent-primary/30">
              {user?.name?.[0]?.toUpperCase() || 'U'}
            </div>
            <span className="text-sm font-medium hidden sm:block">{user?.name || 'User'}</span>
          </button>
          
          <div className="absolute right-0 mt-1 w-48 bg-surface border border-border rounded-md shadow-lg opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all transform origin-top-right scale-95 group-hover:scale-100 z-50 py-1">
            <Link href="/profile" className="block px-4 py-2 text-sm text-text-primary hover:bg-white/5 w-full text-left">
              Profile
            </Link>
            <Link href="/settings" className="block px-4 py-2 text-sm text-text-primary hover:bg-white/5 w-full text-left">
              Settings
            </Link>
            <div className="h-px bg-border my-1" />
            <button
              onClick={handleSignOut}
              className="w-full text-left px-4 py-2 text-sm text-warning hover:bg-warning/10 flex items-center gap-2"
            >
              <LogOut size={14} />
              Sign Out
            </button>
          </div>
        </div>
      </div>
    </header>
  );
}

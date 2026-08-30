import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import type { User } from '@/types';

interface AppState {
  user: User | null;
  sidebarCollapsed: boolean;
  currentDay: number;
  
  setUser: (user: User | null) => void;
  updateXP: (xp: number) => void;
  updateStreak: (streak: number) => void;
  toggleSidebar: () => void;
  setSidebarCollapsed: (collapsed: boolean) => void;
  setCurrentDay: (day: number) => void;
}

export const useAppStore = create<AppState>()(
  persist(
    (set) => ({
      user: null,
      sidebarCollapsed: false,
      currentDay: 1,

      setUser: (user) => set({ user }),
      updateXP: (xp) => set((state) => ({
        user: state.user ? { ...state.user, xp } : null,
      })),
      updateStreak: (streak) => set((state) => ({
        user: state.user ? { ...state.user, streak } : null,
      })),
      toggleSidebar: () => set((state) => ({ sidebarCollapsed: !state.sidebarCollapsed })),
      setSidebarCollapsed: (collapsed) => set({ sidebarCollapsed: collapsed }),
      setCurrentDay: (day) => set({ currentDay: day }),
    }),
    {
      name: 'hackpath-store',
      partialize: (state) => ({ sidebarCollapsed: state.sidebarCollapsed }),
    }
  )
);

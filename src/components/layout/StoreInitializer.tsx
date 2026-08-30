'use client';

import { useEffect } from 'react';
import { useAppStore } from '@/store/app-store';
import type { User } from '@/types';

export function StoreInitializer({ user }: { user: User | null }) {
  const setUser = useAppStore(s => s.setUser);

  useEffect(() => {
    if (user) setUser(user);
  }, [user, setUser]);

  return null;
}

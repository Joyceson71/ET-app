import Sidebar from '@/components/layout/Sidebar';
import TopBar from '@/components/layout/TopBar';
import { StoreInitializer } from '@/components/layout/StoreInitializer';
import { createClient } from '@/lib/supabase/server';
import { redirect } from 'next/navigation';

export default async function AppLayout({ children }: { children: React.ReactNode }) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect('/login');

  // Fetch user profile
  const { data: profile } = await supabase
    .from('users')
    .select('*')
    .eq('id', user.id)
    .single();

  return (
    <>
      <StoreInitializer user={profile} />
      <div className="flex min-h-screen bg-background">
        <Sidebar />
        <div className="flex-1 flex flex-col transition-all duration-200 pl-16 md:pl-60">
          <TopBar />
          <main id="main-content" className="flex-1 p-6 overflow-auto">
            {children}
          </main>
        </div>
      </div>
    </>
  );
}

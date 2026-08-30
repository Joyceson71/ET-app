import Sidebar from "@/components/layout/Sidebar";
import TopBar from "@/components/layout/TopBar";
import PageTransition from "@/components/layout/PageTransition";
import { StoreInitializer } from "@/components/layout/StoreInitializer";
import { getServerSession } from "next-auth";
import { authOptions } from "@/lib/auth";
import { prisma } from "@/lib/prisma";
import { redirect } from "next/navigation";
import { User } from "@/types";

export default async function AppLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const session = await getServerSession(authOptions);
  
  if (!session?.user) redirect("/login");

  // Fetch user profile
  const userRecord = await prisma.user.findUnique({
    where: { id: session.user.id },
  });
  
  if (!userRecord) redirect("/login");

  const profile: User = {
    ...userRecord,
    name: userRecord.name || undefined,
    goal: userRecord.goal as any || undefined,
    experience_level: userRecord.experienceLevel as any,
    daily_commitment: userRecord.dailyCommitment as any,
    avatar_url: userRecord.avatarUrl || undefined,
    last_active_date: userRecord.lastActiveDate?.toISOString(),
    created_at: userRecord.createdAt.toISOString(),
  };

  return (
    <>
      <StoreInitializer user={profile} />
      {/* Dynamic Background Effect */}
      <div className="fixed inset-0 z-[-1] pointer-events-none bg-background terminal-grid opacity-30 animate-pulse-glow" />
      <div className="fixed inset-0 z-[-1] pointer-events-none bg-glow-green opacity-20 mix-blend-screen" />
      
      <div className="flex min-h-screen bg-transparent">
        <Sidebar />
        <div className="flex-1 flex flex-col transition-all duration-200 pl-16 md:pl-60 relative z-0">
          <TopBar />
          <main id="main-content" className="flex-1 p-6 overflow-auto">
            <PageTransition>
              {children}
            </PageTransition>
          </main>
        </div>
      </div>
    </>
  );
}

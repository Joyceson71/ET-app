import Sidebar from "@/components/layout/Sidebar";
import TopBar from "@/components/layout/TopBar";
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

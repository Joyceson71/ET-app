import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';
import { ReactQueryProvider } from '@/providers/query-provider';

const inter = Inter({ subsets: ['latin'], variable: '--font-inter' });

export const metadata: Metadata = {
  title: {
    default: 'HackPath — 120-Day Ethical Hacking Mastery',
    template: '%s | HackPath',
  },
  description: 'A structured 120-day ethical hacking curriculum that takes you from complete beginner to job-ready penetration tester. With progress tracking, skill tree visualization, hands-on labs, and gamified learning.',
  keywords: ['ethical hacking', 'penetration testing', 'cybersecurity', 'OSCP', 'bug bounty', 'learning platform'],
  authors: [{ name: 'HackPath' }],
  openGraph: {
    title: 'HackPath — 120-Day Ethical Hacking Mastery',
    description: 'Structured 120-day curriculum from beginner to job-ready pentester. Skill tree, labs, quizzes, XP system.',
    type: 'website',
    siteName: 'HackPath',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'HackPath — 120-Day Ethical Hacking Mastery',
    description: 'Structured 120-day curriculum from beginner to job-ready pentester.',
  },
  robots: { index: true, follow: true },
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" className="dark">
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500;600;700&family=Inter:wght@300;400;500;600;700&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet" />
      </head>
      <body className={`${inter.variable} antialiased bg-background text-text-primary`}>
        <ReactQueryProvider>
          {children}
        </ReactQueryProvider>
      </body>
    </html>
  );
}

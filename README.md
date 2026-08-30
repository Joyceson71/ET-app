# HackPath — 120-Day Ethical Hacking Mastery Program

HackPath is a structured, gamified, and self-paced 120-day ethical hacking learning platform built with Next.js and Supabase. It takes users from complete beginners to job-ready penetration testers.

## Features

- **120-Day Curriculum**: Comprehensive path covering fundamentals to advanced topics.
- **Interactive Skill Tree**: Visualize progress and unlocked skills using D3.js.
- **Gamified Learning**: Earn XP, levels, badges, and streaks.
- **Dark Terminal UI**: Hacker aesthetic inspired by modern IDEs and Notion.
- **Resource Library**: Curated list of tools, platforms, books, and videos.

## Tech Stack

- **Framework**: Next.js 14 (App Router)
- **Database / Auth**: Supabase
- **Styling**: Tailwind CSS
- **Animations**: Framer Motion
- **Data Visualization**: D3.js
- **State Management**: Zustand
- **Data Fetching**: React Query

## Setup Instructions

### 1. Database Setup (Supabase)

1. Create a new [Supabase](https://supabase.com/) project.
2. Go to the SQL Editor in your Supabase dashboard.
3. Run the following files in this exact order to set up the schema and seed data:
   - `supabase/schema.sql` (Tables and functions)
   - `supabase/rls.sql` (Row Level Security policies)
   - `supabase/seed_part1.sql` (Initial skills and resources)
   - `supabase/seed_days_phase1.sql` (Days 1-20)
   - `supabase/seed_days_phase2.sql` (Days 21-40)
   - `supabase/seed_days_phases3to6.sql` (Days 41-120)
   - `supabase/seed_quizzes.sql` (Quiz questions for all 120 days)

### 2. Environment Variables

1. Copy the `.env.example` file to `.env.local`:
   ```bash
   cp .env.example .env.local
   ```
2. Fill in the values from your Supabase project settings (Settings > API):
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_ROLE_KEY` (Required for server-side scoring of quizzes without exposing answers)

### 3. Local Development

1. Install dependencies:
   ```bash
   npm install
   ```
2. Start the development server:
   ```bash
   npm run dev
   ```
3. Open `http://localhost:3000` in your browser.

## Deployment

This app is optimized for deployment on [Vercel](https://vercel.com/). Connect your GitHub repository and add the environment variables in the Vercel dashboard.

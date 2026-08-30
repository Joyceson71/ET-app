-- HackPath — Row Level Security Policies
-- Run AFTER schema.sql

-- ============================================================
-- ENABLE RLS on all tables
-- ============================================================
alter table public.users enable row level security;
alter table public.day_progress enable row level security;
alter table public.quiz_results enable row level security;
alter table public.notes enable row level security;
alter table public.bookmarks enable row level security;
alter table public.user_badges enable row level security;
alter table public.quiz_skips enable row level security;

-- Public read tables (no RLS needed, but still set)
alter table public.days enable row level security;
alter table public.resources enable row level security;
alter table public.day_resources enable row level security;
alter table public.quizzes enable row level security;
alter table public.badges enable row level security;
alter table public.skill_nodes enable row level security;
alter table public.skill_edges enable row level security;

-- ============================================================
-- USERS policies
-- ============================================================
create policy "Users can view own profile"
  on public.users for select
  using (auth.uid() = id);

create policy "Users can update own profile"
  on public.users for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- ============================================================
-- DAYS — public read
-- ============================================================
create policy "Anyone can read days"
  on public.days for select
  using (true);

-- ============================================================
-- RESOURCES — public read
-- ============================================================
create policy "Anyone can read resources"
  on public.resources for select
  using (true);

create policy "Anyone can read day_resources"
  on public.day_resources for select
  using (true);

-- ============================================================
-- QUIZZES — public read (no answers exposed via RLS — answer filtered in API)
-- ============================================================
create policy "Anyone can read quizzes"
  on public.quizzes for select
  using (true);

-- ============================================================
-- BADGES — public read
-- ============================================================
create policy "Anyone can read badges"
  on public.badges for select
  using (true);

-- ============================================================
-- SKILL NODES & EDGES — public read
-- ============================================================
create policy "Anyone can read skill_nodes"
  on public.skill_nodes for select
  using (true);

create policy "Anyone can read skill_edges"
  on public.skill_edges for select
  using (true);

-- ============================================================
-- DAY PROGRESS — user-scoped
-- ============================================================
create policy "Users can read own progress"
  on public.day_progress for select
  using (auth.uid() = user_id);

create policy "Users can insert own progress"
  on public.day_progress for insert
  with check (auth.uid() = user_id);

create policy "Users can update own progress"
  on public.day_progress for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- ============================================================
-- QUIZ RESULTS — user-scoped
-- ============================================================
create policy "Users can read own quiz results"
  on public.quiz_results for select
  using (auth.uid() = user_id);

create policy "Users can insert own quiz results"
  on public.quiz_results for insert
  with check (auth.uid() = user_id);

-- ============================================================
-- NOTES — user-scoped
-- ============================================================
create policy "Users can read own notes"
  on public.notes for select
  using (auth.uid() = user_id);

create policy "Users can insert own notes"
  on public.notes for insert
  with check (auth.uid() = user_id);

create policy "Users can update own notes"
  on public.notes for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "Users can delete own notes"
  on public.notes for delete
  using (auth.uid() = user_id);

-- ============================================================
-- BOOKMARKS — user-scoped
-- ============================================================
create policy "Users can read own bookmarks"
  on public.bookmarks for select
  using (auth.uid() = user_id);

create policy "Users can insert own bookmarks"
  on public.bookmarks for insert
  with check (auth.uid() = user_id);

create policy "Users can delete own bookmarks"
  on public.bookmarks for delete
  using (auth.uid() = user_id);

-- ============================================================
-- USER BADGES — user-scoped read, service-role write
-- ============================================================
create policy "Users can read own badges"
  on public.user_badges for select
  using (auth.uid() = user_id);

-- ============================================================
-- QUIZ SKIPS — user-scoped
-- ============================================================
create policy "Users can read own skips"
  on public.quiz_skips for select
  using (auth.uid() = user_id);

create policy "Users can insert own skips"
  on public.quiz_skips for insert
  with check (auth.uid() = user_id);

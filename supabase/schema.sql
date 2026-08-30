-- HackPath — Supabase Database Schema
-- Run this in the Supabase SQL editor or via supabase db push

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ============================================================
-- USERS (extends auth.users)
-- ============================================================
create table if not exists public.users (
  id              uuid references auth.users(id) on delete cascade primary key,
  email           text unique not null,
  name            text,
  avatar_url      text,
  experience_level text check (experience_level in ('beginner', 'some_it', 'developer')),
  goal            text check (goal in ('bug_bounty', 'pentest', 'ctf', 'security_engineer')),
  daily_commitment text check (daily_commitment in ('30min', '1hour', '2plus')),
  xp              integer default 0 not null,
  streak          integer default 0 not null,
  last_active_date date,
  onboarding_done boolean default false,
  created_at      timestamptz default now() not null
);

-- ============================================================
-- DAYS (120 curriculum days)
-- ============================================================
create table if not exists public.days (
  id            integer primary key,
  phase         integer not null check (phase between 1 and 6),
  title         text not null,
  concept       text not null,
  lab_url       text,
  lab_platform  text,
  xp_reward     integer default 50 not null
);

-- ============================================================
-- RESOURCES
-- ============================================================
create table if not exists public.resources (
  id          uuid primary key default uuid_generate_v4(),
  title       text not null,
  url         text not null,
  type        text not null check (type in ('video','article','tool','book','platform','cheatsheet')),
  difficulty  text not null check (difficulty in ('beginner','intermediate','advanced')),
  description text,
  is_free     boolean default true not null,
  source      text
);

-- ============================================================
-- DAY_RESOURCES (many-to-many)
-- ============================================================
create table if not exists public.day_resources (
  day_id      integer references public.days(id) on delete cascade,
  resource_id uuid references public.resources(id) on delete cascade,
  primary key (day_id, resource_id)
);

-- ============================================================
-- QUIZZES
-- ============================================================
create table if not exists public.quizzes (
  id       uuid primary key default uuid_generate_v4(),
  day_id   integer references public.days(id) on delete cascade not null,
  question text not null,
  options  text[] not null,
  answer   integer not null -- 0-indexed correct option
);

-- ============================================================
-- DAY PROGRESS (per-user)
-- ============================================================
create table if not exists public.day_progress (
  id           uuid primary key default uuid_generate_v4(),
  user_id      uuid references public.users(id) on delete cascade not null,
  day_id       integer references public.days(id) on delete cascade not null,
  status       text default 'locked' check (status in ('locked','available','in_progress','completed')),
  lab_done     boolean default false,
  completed_at timestamptz,
  xp_earned    integer default 0,
  unique (user_id, day_id)
);

-- ============================================================
-- QUIZ RESULTS
-- ============================================================
create table if not exists public.quiz_results (
  id         uuid primary key default uuid_generate_v4(),
  user_id    uuid references public.users(id) on delete cascade not null,
  quiz_id    uuid references public.quizzes(id) on delete cascade not null,
  day_id     integer not null,
  passed     boolean not null,
  score      integer not null, -- correct answers out of 3
  attempts   integer default 1,
  created_at timestamptz default now()
);

-- ============================================================
-- NOTES
-- ============================================================
create table if not exists public.notes (
  id         uuid primary key default uuid_generate_v4(),
  user_id    uuid references public.users(id) on delete cascade not null,
  day_id     integer references public.days(id) on delete cascade,
  content    text not null default '',
  updated_at timestamptz default now(),
  created_at timestamptz default now()
);

-- ============================================================
-- BOOKMARKS
-- ============================================================
create table if not exists public.bookmarks (
  user_id     uuid references public.users(id) on delete cascade,
  resource_id uuid references public.resources(id) on delete cascade,
  saved_at    timestamptz default now(),
  primary key (user_id, resource_id)
);

-- ============================================================
-- BADGES
-- ============================================================
create table if not exists public.badges (
  id          uuid primary key default uuid_generate_v4(),
  name        text unique not null,
  description text not null,
  icon        text not null,
  xp_reward   integer default 0
);

create table if not exists public.user_badges (
  user_id   uuid references public.users(id) on delete cascade,
  badge_id  uuid references public.badges(id) on delete cascade,
  earned_at timestamptz default now(),
  primary key (user_id, badge_id)
);

-- ============================================================
-- SKILL TREE
-- ============================================================
create table if not exists public.skill_nodes (
  id               text primary key,
  name             text not null,
  category         text not null,
  description      text not null,
  xp_value         integer default 0,
  estimated_hours  numeric default 1,
  day_ids          integer[] default '{}',
  pos_x            numeric default 0,
  pos_y            numeric default 0
);

create table if not exists public.skill_edges (
  source text references public.skill_nodes(id) on delete cascade,
  target text references public.skill_nodes(id) on delete cascade,
  primary key (source, target)
);

-- ============================================================
-- SKIP QUIZ USES (once per week)
-- ============================================================
create table if not exists public.quiz_skips (
  id         uuid primary key default uuid_generate_v4(),
  user_id    uuid references public.users(id) on delete cascade not null,
  day_id     integer not null,
  week_start date not null, -- ISO week start (Monday)
  created_at timestamptz default now(),
  unique (user_id, week_start)
);

-- ============================================================
-- INDEXES for performance
-- ============================================================
create index if not exists idx_day_progress_user on public.day_progress(user_id);
create index if not exists idx_day_progress_day on public.day_progress(day_id);
create index if not exists idx_quiz_results_user on public.quiz_results(user_id);
create index if not exists idx_notes_user on public.notes(user_id);
create index if not exists idx_notes_day on public.notes(day_id);
create index if not exists idx_bookmarks_user on public.bookmarks(user_id);
create index if not exists idx_user_badges_user on public.user_badges(user_id);
create index if not exists idx_days_phase on public.days(phase);
create index if not exists idx_resources_type on public.resources(type);
create index if not exists idx_resources_difficulty on public.resources(difficulty);

-- ============================================================
-- UPDATED_AT trigger for notes
-- ============================================================
create or replace function public.handle_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger notes_updated_at
  before update on public.notes
  for each row execute procedure public.handle_updated_at();

-- ============================================================
-- Auto-create user profile on auth signup
-- ============================================================
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.users (id, email, name, avatar_url)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data->>'full_name',
    new.raw_user_meta_data->>'avatar_url'
  );
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

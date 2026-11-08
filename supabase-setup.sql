-- Mystery Club: Supabase schema
-- Run this whole script in Supabase -> SQL Editor -> New query -> Run.

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default '',
  updated_at timestamptz not null default now()
);

create table if not exists public.quests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  genre text not null default '',
  difficulty text not null default '',
  duration text not null default '',
  format text not null default '',
  description text not null default '',
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.quests enable row level security;

grant select, insert, update on public.profiles to authenticated;
grant select, insert, update, delete on public.quests to authenticated;

drop policy if exists "Users can view own profile" on public.profiles;
create policy "Users can view own profile"
on public.profiles for select to authenticated
using ((select auth.uid()) = id);

drop policy if exists "Users can create own profile" on public.profiles;
create policy "Users can create own profile"
on public.profiles for insert to authenticated
with check ((select auth.uid()) = id);

drop policy if exists "Users can update own profile" on public.profiles;
create policy "Users can update own profile"
on public.profiles for update to authenticated
using ((select auth.uid()) = id)
with check ((select auth.uid()) = id);

drop policy if exists "Users can view own quests" on public.quests;
create policy "Users can view own quests"
on public.quests for select to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "Users can create own quests" on public.quests;
create policy "Users can create own quests"
on public.quests for insert to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "Users can update own quests" on public.quests;
create policy "Users can update own quests"
on public.quests for update to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "Users can delete own quests" on public.quests;
create policy "Users can delete own quests"
on public.quests for delete to authenticated
using ((select auth.uid()) = user_id);

-- Mystery Club: enable public quest publishing.
-- Run this file once in Supabase -> SQL Editor -> Run.
-- Existing quests stay private because is_published defaults to false.

alter table public.quests
  add column if not exists is_published boolean not null default false;

grant select on public.quests to anon;

drop policy if exists "Anyone can view published quests" on public.quests;
create policy "Anyone can view published quests"
on public.quests
for select
to anon, authenticated
using (is_published = true or (select auth.uid()) = user_id);

-- Mystery Club: undo public community publishing.
-- Run once in Supabase -> SQL Editor -> Run.
-- This keeps all quests private to their owners.

drop policy if exists "Anyone can view published quests" on public.quests;
revoke select on public.quests from anon;

-- Make sure no existing record is left publicly marked as published.
update public.quests set is_published = false where is_published = true;

-- Run this once in the Supabase SQL editor (Dashboard → SQL Editor → New query).
-- Creates a tiny, harmless table that the anon key can SELECT from.
-- The keepalive workflow queries this table daily to generate real
-- database activity, which is what resets Supabase's 7-day inactivity clock.

create table if not exists public.keepalive (
  id bigint generated always as identity primary key,
  pinged_at timestamptz not null default now()
);

alter table public.keepalive enable row level security;

-- Allow the anon (public) key to read this table.
create policy "Allow anon select on keepalive"
  on public.keepalive
  for select
  to anon
  using (true);

-- Seed one row so the SELECT actually returns data.
insert into public.keepalive default values;

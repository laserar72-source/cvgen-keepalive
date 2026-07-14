create table if not exists public.keepalive (
  id bigint generated always as identity primary key,
  pinged_at timestamptz not null default now()
);

alter table public.keepalive enable row level security;

create policy "Allow anon select on keepalive"
  on public.keepalive
  for select
  to anon
  using (true);

insert into public.keepalive default values;

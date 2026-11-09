-- Maurushoeve kalender - uitbreiding; bestaande tabellen blijven ongewijzigd.
create table if not exists public.mh_calendar_allocations (
 id bigint generated always as identity primary key,
 project_number text not null unique,
 booking_scope text not null default 'volledig' check (booking_scope in ('volledig','gedeeltelijk')),
 rooms text[] not null default array['Schuur','Crypte','Hoeve']::text[],
 notes text not null default '',
 updated_at timestamptz not null default now()
);
create table if not exists public.mh_calendar_closures (
 id bigint generated always as identity primary key,
 start_date date not null,
 end_date date not null,
 label text not null default 'Gesloten',
 notes text not null default '',
 created_at timestamptz not null default now(),
 constraint mh_calendar_closures_dates check (end_date >= start_date)
);
create index if not exists mh_calendar_closures_range_idx on public.mh_calendar_closures(start_date,end_date);
alter table public.mh_calendar_allocations enable row level security;
alter table public.mh_calendar_closures enable row level security;
-- Volg dezelfde toegangsstrategie als de bestaande Maurushoeve-tabellen: alleen aangemelde gebruikers.
drop policy if exists mh_calendar_allocations_auth on public.mh_calendar_allocations;
create policy mh_calendar_allocations_auth on public.mh_calendar_allocations for all to authenticated using (true) with check (true);
drop policy if exists mh_calendar_closures_auth on public.mh_calendar_closures;
create policy mh_calendar_closures_auth on public.mh_calendar_closures for all to authenticated using (true) with check (true);

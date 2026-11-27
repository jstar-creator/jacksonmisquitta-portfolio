-- Last Draft public product page and early-access list.
create table if not exists public.lastdraft_settings (
  id integer primary key default 1 check (id = 1),
  title text not null default 'Last Draft',
  tagline text not null default 'Design Intelligence, Crafted for Creators',
  show_coming_soon boolean not null default true,
  hero_subtitle text not null default 'Technology should understand design — not replace designers.',
  vision_heading text not null default 'A creative platform that learns how professional designers think.',
  vision_description text not null default 'Unlike image generation tools, Last Draft studies decades of design knowledge and converts it into practical creative tools.',
  goal_quote text not null default 'Last Draft is building the Creative Intelligence Layer for Design.',
  goal_description text not null default 'Not an image generator. Not another tool. A system that understands how great design is composed — and helps professionals reach their best work faster while keeping every creative decision in human hands.',
  show_signup boolean not null default true,
  updated_at timestamptz not null default now()
);
insert into public.lastdraft_settings (id) values (1) on conflict (id) do nothing;

create table if not exists public.lastdraft_subscribers (
  id uuid primary key default gen_random_uuid(),
  email text not null unique,
  created_at timestamptz not null default now()
);

alter table public.lastdraft_settings enable row level security;
alter table public.lastdraft_subscribers enable row level security;
drop policy if exists "Last Draft settings are public" on public.lastdraft_settings;
create policy "Last Draft settings are public" on public.lastdraft_settings for select using (true);
drop policy if exists "Authenticated admins manage Last Draft settings" on public.lastdraft_settings;
create policy "Authenticated admins manage Last Draft settings" on public.lastdraft_settings for all to authenticated using (public.is_portfolio_admin()) with check (public.is_portfolio_admin());
drop policy if exists "Anyone can join Last Draft list" on public.lastdraft_subscribers;
create policy "Anyone can join Last Draft list" on public.lastdraft_subscribers for insert to anon, authenticated with check (length(email) between 5 and 320 and position('@' in email) > 1);

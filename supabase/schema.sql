-- Fresh-project schema for the Jackson Misquitta portfolio.
create extension if not exists pgcrypto;

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  slug text not null unique,
  category text not null default 'Video Editing',
  year text default extract(year from now())::text,
  excerpt text default '',
  description text default '',
  cover_url text default '',
  video_url text default '',
  gallery_urls text[] not null default '{}',
  tools text[] not null default '{}',
  role text default '',
  client text default '',
  status text not null default 'In progress'
    check (status in ('Completed','In progress','Concept','Experiment','Sample')),
  featured boolean not null default false,
  published boolean not null default false,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.site_settings (
  id integer primary key default 1 check (id = 1),
  hero_kicker text default 'VIDEO EDITOR · MOTION DESIGNER · CREATIVE TOOL BUILDER',
  hero_title text default 'Stories in motion.',
  hero_intro text default 'I’m Jackson Misquitta — a video editor and motion graphics artist exploring the space between visual storytelling and creative technology.',
  about_title text default 'Still figuring it out.',
  about_body text default 'I’ve been making things independently since 2018 and working professionally since December 2022. My work moves between editing, motion design and building small tools that make creative workflows better.',
  contact_email text default 'thunderclap714@gmail.com',
  github_url text default 'https://github.com/jstar-creator',
  instagram_url text default 'https://www.instagram.com/commonjacksonw.in/',
  about_image_url text default '',
  updated_at timestamptz not null default now()
);
insert into public.site_settings (id) values (1) on conflict (id) do nothing;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade
);
alter table public.admin_users enable row level security;

create or replace function public.is_portfolio_admin()
returns boolean
language sql stable security definer
set search_path = public
as $$
  select exists (select 1 from public.admin_users where user_id = auth.uid());
$$;
revoke all on function public.is_portfolio_admin() from public;
grant execute on function public.is_portfolio_admin() to authenticated;

alter table public.projects enable row level security;
alter table public.site_settings enable row level security;

drop policy if exists "Published projects are public" on public.projects;
create policy "Published projects are public"
on public.projects for select using (published = true);
drop policy if exists "Authenticated admins manage projects" on public.projects;
create policy "Authenticated admins manage projects"
on public.projects for all to authenticated
using (public.is_portfolio_admin()) with check (public.is_portfolio_admin());

drop policy if exists "Site settings are public" on public.site_settings;
create policy "Site settings are public"
on public.site_settings for select using (true);
drop policy if exists "Authenticated admins manage settings" on public.site_settings;
create policy "Authenticated admins manage settings"
on public.site_settings for all to authenticated
using (public.is_portfolio_admin()) with check (public.is_portfolio_admin());

insert into storage.buckets
(id, name, public, file_size_limit, allowed_mime_types)
values ('portfolio-media','portfolio-media',true,52428800,
  array['image/jpeg','image/png','image/webp','image/gif','video/mp4','video/webm'])
on conflict (id) do update set
 public=true, file_size_limit=52428800,
 allowed_mime_types=excluded.allowed_mime_types;

drop policy if exists "Portfolio media is public" on storage.objects;
create policy "Portfolio media is public"
on storage.objects for select using (bucket_id = 'portfolio-media');
drop policy if exists "Authenticated users upload portfolio media" on storage.objects;
drop policy if exists "Authenticated admins upload portfolio media" on storage.objects;
create policy "Authenticated admins upload portfolio media"
on storage.objects for insert to authenticated
with check (bucket_id = 'portfolio-media' and public.is_portfolio_admin());
drop policy if exists "Authenticated users update portfolio media" on storage.objects;
drop policy if exists "Authenticated admins update portfolio media" on storage.objects;
create policy "Authenticated admins update portfolio media"
on storage.objects for update to authenticated
using (bucket_id = 'portfolio-media' and public.is_portfolio_admin())
with check (bucket_id = 'portfolio-media' and public.is_portfolio_admin());
drop policy if exists "Authenticated users delete portfolio media" on storage.objects;
drop policy if exists "Authenticated admins delete portfolio media" on storage.objects;
create policy "Authenticated admins delete portfolio media"
on storage.objects for delete to authenticated
using (bucket_id = 'portfolio-media' and public.is_portfolio_admin());

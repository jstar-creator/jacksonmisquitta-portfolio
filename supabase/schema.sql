-- Run this in Supabase SQL Editor.
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
  featured boolean not null default false,
  published boolean not null default false,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create table if not exists public.site_settings (
  id integer primary key default 1 check (id = 1),
  hero_kicker text default 'INDEPENDENT CREATIVE · INDIA',
  hero_title text default 'Making ideas move.',
  hero_intro text default 'Video editor, motion graphics artist and builder of tools for creative workflows.',
  about_title text default 'Craft meets curiosity.',
  about_body text default 'I move between the edit timeline and the code editor — looking for better ways to bring ideas to life.',
  contact_email text default 'thunderclap714@gmail.com',
  github_url text default 'https://github.com/jstar-creator',
  updated_at timestamptz not null default now()
);
insert into public.site_settings (id) values (1) on conflict (id) do nothing;

alter table public.projects enable row level security;
alter table public.site_settings enable row level security;
drop policy if exists "Published projects are public" on public.projects;
create policy "Published projects are public" on public.projects for select using (published = true);
drop policy if exists "Authenticated admins manage projects" on public.projects;
create policy "Authenticated admins manage projects" on public.projects for all to authenticated using (true) with check (true);
drop policy if exists "Site settings are public" on public.site_settings;
create policy "Site settings are public" on public.site_settings for select using (true);
drop policy if exists "Authenticated admins manage settings" on public.site_settings;
create policy "Authenticated admins manage settings" on public.site_settings for all to authenticated using (true) with check (true);

-- Create a PUBLIC storage bucket named portfolio-media in Storage.
-- Public read policy:
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('portfolio-media','portfolio-media',true,52428800,array['image/jpeg','image/png','image/webp','image/gif','video/mp4','video/webm'])
on conflict (id) do update set public = true;
drop policy if exists "Portfolio media is public" on storage.objects;
create policy "Portfolio media is public" on storage.objects for select using (bucket_id = 'portfolio-media');
drop policy if exists "Authenticated users upload portfolio media" on storage.objects;
create policy "Authenticated users upload portfolio media" on storage.objects for insert to authenticated with check (bucket_id = 'portfolio-media');
drop policy if exists "Authenticated users update portfolio media" on storage.objects;
create policy "Authenticated users update portfolio media" on storage.objects for update to authenticated using (bucket_id = 'portfolio-media') with check (bucket_id = 'portfolio-media');
drop policy if exists "Authenticated users delete portfolio media" on storage.objects;
create policy "Authenticated users delete portfolio media" on storage.objects for delete to authenticated using (bucket_id = 'portfolio-media');
-- Portfolio expansion: case studies, software release details and external project links.
-- Safe to run on the existing portfolio database; all additions are nullable or have defaults.
alter table public.projects
  add column if not exists challenge text not null default '',
  add column if not exists process text not null default '',
  add column if not exists outcome text not null default '',
  add column if not exists compatibility text not null default '',
  add column if not exists version text not null default '',
  add column if not exists platform text not null default '',
  add column if not exists installation text not null default '',
  add column if not exists release_notes text not null default '',
  add column if not exists links jsonb not null default '[]'::jsonb;

-- Ensure the public read policy remains limited to published projects.
-- Admin writes continue to use the existing allow-list function.
drop policy if exists "Published projects are public" on public.projects;
create policy "Published projects are public"
on public.projects for select
using (published = true or public.is_portfolio_admin());

-- Keep public site settings readable, but editable only by allow-listed admins.
drop policy if exists "Site settings are public" on public.site_settings;
create policy "Site settings are public"
on public.site_settings for select using (true);
drop policy if exists "Authenticated admins manage settings" on public.site_settings;
create policy "Authenticated admins manage settings"
on public.site_settings for all to authenticated
using (public.is_portfolio_admin())
with check (public.is_portfolio_admin());

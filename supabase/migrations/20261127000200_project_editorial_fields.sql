-- Additional editorial fields for richer project and software case studies.
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

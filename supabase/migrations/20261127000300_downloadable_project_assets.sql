-- Dedicated downloadable assets for software releases and project resources.
alter table public.projects
  add column if not exists download_url text not null default '',
  add column if not exists download_label text not null default 'DOWNLOAD';

-- Keep the existing public media bucket and its 50 MB limit, but permit common
-- archive, installer, script, document and data file types used by portfolio releases.
update storage.buckets
set allowed_mime_types = array[
  'image/jpeg','image/png','image/webp','image/gif',
  'video/mp4','video/webm',
  'application/zip','application/x-zip-compressed','application/octet-stream',
  'application/x-msdownload','application/pdf','application/json','text/plain'
]
where id = 'portfolio-media';

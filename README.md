# Jackson Misquitta — Portfolio

A cinematic, responsive portfolio for video editing, motion graphics and creative software experiments. Built with React, Vite and Supabase.

## Cloudflare Pages

- Framework preset: **Vite**
- Build command: `npm run build`
- Build output directory: `dist`
- Root directory: `/`
- Production branch: `main`

Set these variables for both Production and Preview:
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY` (Supabase publishable key is accepted)

## Supabase setup

1. Run `supabase/schema.sql` in the SQL Editor for a fresh project.
2. Create your account in **Authentication → Users**.
3. Add your user to `public.admin_users` using the SQL Editor:
   ```sql
   insert into public.admin_users (user_id)
   select id from auth.users where email = 'YOUR_ADMIN_EMAIL'
   on conflict (user_id) do nothing;
   ```
4. Disable public sign-ups in Authentication settings.
5. Add the Cloudflare environment variables above and redeploy.

For the already-created project, run `supabase/personalize-and-seed.sql` once. It adds project status, tightens write permissions to the admin allow-list and inserts the portfolio entries with honest status labels. Apply migrations in `supabase/migrations/` in filename order as new editor capabilities are added.

Never put a Supabase secret/service-role key in the browser.

## Admin

Visit `/admin`. Sign in with the Supabase user added to `admin_users`. The CMS supports project CRUD, status, categories, publishing, featured ordering, media uploads and site settings.

## About image

The About page expects the supplied image at `public/images/who-am-i.webp`. Add the image there in the repository (create `public/images` if needed). It will be served at `/images/who-am-i.webp`.

## Project status

Projects are explicitly labelled **Completed**, **In progress**, **Concept** or **Experiment**. Do not interpret a concept or experiment as a released product.

## Content brought into the portfolio

The content seed includes the existing creative-work and software-project entries, including The All Rounder, ProxyLink, SubCorrect, Smart Release Pro, Guardian, One Piece Interactive Map, BGMI Account Estimator and Maps of Past. It also includes LastDraft as an in-progress product concept. Its description distinguishes the stated vision and roadmap from released functionality.

The portfolio keeps its own visual design and navigation. The added capabilities are limited to searchable project discovery and richer project pages/editor fields; no JackHacks homepage, layout or component system is copied.


## Software downloads

Project pages can publish a direct download URL or a file uploaded from the admin editor. Supported release assets include ZIP archives, Adobe scripts/packages, installers, PDFs and data files. The public download action appears only when a project has a `download_url`. The `portfolio-media` bucket is public for downloads and previews, while uploads and mutations remain admin-only. The current per-file storage limit is 50 MB.

For an existing Supabase project, apply `supabase/migrations/20261127000300_downloadable_project_assets.sql` before adding downloadable files. Fresh installations get the same fields and storage MIME types from `supabase/schema.sql`.

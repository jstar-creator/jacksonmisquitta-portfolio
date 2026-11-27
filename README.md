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

For the already-created project, run `supabase/personalize-and-seed.sql` once. It adds project status, tightens write permissions to the admin allow-list and inserts the portfolio entries with honest status labels.

Never put a Supabase secret/service-role key in the browser.

## Admin

Visit `/admin`. Sign in with the Supabase user added to `admin_users`. The CMS supports project CRUD, status, categories, publishing, featured ordering, media uploads and site settings.

## About image

The About page expects the supplied image at `public/images/who-am-i.webp`. Add the image there in the repository (create `public/images` if needed). It will be served at `/images/who-am-i.webp`.

## Project status

Projects are explicitly labelled **Completed**, **In progress**, **Concept** or **Experiment**. Do not interpret a concept or experiment as a released product.

## Portfolio case studies and software details

The project editor supports:
- Case-study sections for the brief/challenge, approach and outcome/learning.
- Software/plugin compatibility, version or release status, platform, installation notes and release notes.
- External project links, video embeds, cover media and gallery images.
- Archive search across project names, descriptions and tools.

For an existing Supabase database, run `supabase/migrations/20261127000100_portfolio_case_studies.sql` in the Supabase SQL Editor after the original setup. Fresh databases created with `supabase/schema.sql` already include these fields.

Project statuses remain explicit: Completed, In progress, Concept, Experiment or Sample. Only published projects appear publicly; drafts remain available to allow-listed admins.

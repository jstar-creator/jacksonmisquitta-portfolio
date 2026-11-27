# Jackson Misquitta — Portfolio

A cinematic, responsive portfolio for video editing, motion graphics and independent software tools. Built with React, Vite and Supabase.

## Cloudflare Pages deployment

- Framework preset: **Vite**
- Build command: `npm run build`
- Build output directory: `dist`
- Root directory: `/`
- Production branch: `main` (after merging the rebuild PR)

The `public/_redirects` file enables client-side routes on Cloudflare Pages.

## Supabase setup (required for CMS)

1. Create a Supabase project.
2. Open **SQL Editor** and run all of `supabase/schema.sql`.
3. In Authentication settings, disable public sign-ups. Create your own admin user manually in **Authentication → Users → Add user**.
4. Copy the Project URL and anon/publishable key from Project Settings → API.
5. Add these Cloudflare Pages environment variables for Production and Preview:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
6. Trigger a new deployment.

The SQL creates the projects and site settings tables, RLS policies and public `portfolio-media` bucket. Public visitors can read published projects and site settings. Authenticated users can manage content. **Keep public sign-ups disabled** so visitors cannot create accounts and gain CMS access.

## Admin

Visit `/admin` and sign in with the admin user you created in Supabase. You can create, edit, publish, unpublish, feature and delete projects; upload cover images and small MP4/WebM videos (50 MB limit); add video embeds and gallery image URLs; and update homepage/about/contact settings.

For larger video work, use a YouTube or Vimeo URL instead of uploading the master file. The Supabase anon key is intended for browser use; security comes from RLS and disabling public registration. Never put a Supabase service-role key in the frontend.

## Notes

The initial project entries are demo records until you connect Supabase and add your real work. No sample video footage or fabricated client work is included.

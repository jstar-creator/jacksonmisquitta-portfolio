-- Portfolio content and security alignment for the existing Supabase project.
-- Run once in Supabase SQL Editor after the original schema.sql.
alter table public.projects add column if not exists status text not null default 'In progress';
alter table public.site_settings add column if not exists instagram_url text default 'https://www.instagram.com/commonjacksonw.in/';
update public.site_settings set instagram_url='https://www.instagram.com/commonjacksonw.in/' where id=1 and (instagram_url is null or instagram_url='');
alter table public.projects drop constraint if exists projects_status_check;
alter table public.projects add constraint projects_status_check
  check (status in ('Completed','In progress','Concept','Experiment','Sample'));

-- Admin-only writes. Public visitors can still read published projects/settings.
drop policy if exists "Authenticated admins manage projects" on public.projects;
create policy "Authenticated admins manage projects"
on public.projects for all to authenticated
using (public.is_portfolio_admin())
with check (public.is_portfolio_admin());

drop policy if exists "Authenticated admins manage settings" on public.site_settings;
create policy "Authenticated admins manage settings"
on public.site_settings for all to authenticated
using (public.is_portfolio_admin())
with check (public.is_portfolio_admin());

drop policy if exists "Authenticated users upload portfolio media" on storage.objects;
create policy "Authenticated admins upload portfolio media"
on storage.objects for insert to authenticated
with check (bucket_id = 'portfolio-media' and public.is_portfolio_admin());

drop policy if exists "Authenticated users update portfolio media" on storage.objects;
create policy "Authenticated admins update portfolio media"
on storage.objects for update to authenticated
using (bucket_id = 'portfolio-media' and public.is_portfolio_admin())
with check (bucket_id = 'portfolio-media' and public.is_portfolio_admin());

drop policy if exists "Authenticated users delete portfolio media" on storage.objects;
create policy "Authenticated admins delete portfolio media"
on storage.objects for delete to authenticated
using (bucket_id = 'portfolio-media' and public.is_portfolio_admin());

-- Seed real, accurately-labelled work and experiments. Re-running updates these entries.
insert into public.projects
(title,slug,category,year,excerpt,description,tools,role,status,featured,published,sort_order)
values
('The All Rounder','the-all-rounder','Software','2026','In development — automatic time tracking for Adobe creative workflows.','A time-tracking extension concept for Adobe Premiere Pro, After Effects, Photoshop, Illustrator and Media Encoder. The intended workflow records time against the active project and syncs summaries to Google Sheets, with idle-time awareness and a compact dashboard.',array['Adobe CEP','JavaScript','Google Sheets','Netlify'], 'Product design & development','In progress',true,true,1),
('ProxyLink','proxylink','Software','2026','In development — project-wide proxy matching for Premiere Pro.','A Premiere Pro workflow tool exploring recursive project/bin scanning, matching media against a central proxy folder, review states and safer batch attachment. The current work is focused on reliability and diagnostics.',array['Premiere Pro','UXP','JavaScript'], 'Product design & development','In progress',true,true,2),
('SubCorrect','subcorrect','Software','2026','An experimental grammar-checking workflow for Premiere transcripts and subtitles.','A Premiere Pro utility experiment using Gemini with LanguageTool as a fallback to help review transcript language and subtitle text. Presented as an experiment, not a released product.',array['Premiere Pro','Gemini','LanguageTool','JavaScript'], 'Concept & development','Experiment',false,true,3),
('FlowDeck','flowdeck','Software','2026','A creative workflow tool concept.','An independent software concept exploring a more organised way to manage creative workflows. Details and implementation are still evolving.',array['JavaScript','Web technologies'], 'Concept','Concept',false,true,4),
('Smart Release Pro','smart-release-pro','Software','2026','An Illustrator workflow concept for releasing objects to sequence.','A proposed Illustrator utility around the “release to sequence” workflow. This is an idea under exploration, not a published extension.',array['Adobe Illustrator','JavaScript'], 'Concept','Concept',false,true,5),
('Guardian','guardian','Software','2026','A parent-child transform linking concept for After Effects.','An After Effects plugin concept exploring linked parent-child transforms and a more direct way to manage relationships between layers.',array['After Effects','Expressions','JavaScript'], 'Concept','Concept',false,true,6),
('One Piece Interactive Map','one-piece-interactive-map','Experiments','2026','An interactive map experiment covering 180+ islands.','A personal web experiment exploring an interactive One Piece world map with more than 180 islands and a Google Sheets-backed content workflow.',array['JavaScript','Google Sheets','Web'], 'Independent web experiment','Experiment',true,true,7),
('BGMI Account Estimator','bgmi-account-estimator','Experiments','2026','A web utility concept for estimating BGMI account value.','A personal web project exploring an account-estimation interface for BGMI. Presented as an independent experiment.',array['Web development','JavaScript'], 'Independent web experiment','Experiment',false,true,8),
('Maps of Past','maps-of-past','Experiments','2026','A YouTube channel idea exploring maps and history.','A content-channel concept focused on maps, places and stories from the past. This is a channel idea rather than a completed production.',array['Research','Video editing','Motion graphics'], 'Channel concept','Concept',false,true,9),
('Personal Portfolio System','personal-portfolio-system','Software','2026','A self-managed portfolio and content system.','A personal portfolio system built around a React front end and Supabase-backed content management, with the goal of updating work and site content without editing code.',array['React','Vite','Supabase','Cloudflare Pages'], 'Design & development','In progress',false,true,10),
('Event Film — Layout Preview','sample-event-film','Video Editing','2026','Sample project card to preview the event-film layout. Replace this with a real event recap.','LAYOUT PREVIEW ONLY — This is placeholder copy to demonstrate how an event film project page will look. Replace the description, cover image, video and credits with your actual project before presenting this as finished work.',array['Premiere Pro','After Effects'], 'Replace with your actual role','Sample',true,true,11),
('Sports Reel — Layout Preview','sample-sports-reel','Video Editing','2026','Sample project card to preview a high-energy sports reel. Replace with your actual edit.','LAYOUT PREVIEW ONLY — This sample shows where a sports reel synopsis, edit breakdown, footage and final video will appear. It is not a claim of a completed client project.',array['Premiere Pro','After Effects','Sound design'], 'Replace with your actual role','', 'Sample',true,true,12),
('Motion Design Study — Layout Preview','sample-motion-design','Motion Graphics','2026','Sample project card for typography, transitions and motion design.','LAYOUT PREVIEW ONLY — Replace this with a real motion graphics piece, process notes, stills and final video. This sample exists only to preview the portfolio layout.',array['After Effects','Illustrator'], 'Replace with your actual role','', 'Sample',true,true,13)
on conflict (slug) do update set
 title=excluded.title, category=excluded.category, year=excluded.year,
 excerpt=excluded.excerpt, description=excluded.description, tools=excluded.tools,
 role=excluded.role, status=excluded.status, featured=excluded.featured,
 published=excluded.published, sort_order=excluded.sort_order,
 updated_at=now();

-- شغّل هذا الملف مرة واحدة في Supabase > SQL Editor (لصور الأصناف)

insert into storage.buckets (id, name, public)
values ('menu-images', 'menu-images', true)
on conflict (id) do nothing;

drop policy if exists "menu images read"   on storage.objects;
drop policy if exists "menu images insert" on storage.objects;
drop policy if exists "menu images update" on storage.objects;
drop policy if exists "menu images delete" on storage.objects;

create policy "menu images read"   on storage.objects for select using (bucket_id = 'menu-images');
create policy "menu images insert" on storage.objects for insert to authenticated with check (bucket_id = 'menu-images');
create policy "menu images update" on storage.objects for update to authenticated using (bucket_id = 'menu-images');
create policy "menu images delete" on storage.objects for delete to authenticated using (bucket_id = 'menu-images');

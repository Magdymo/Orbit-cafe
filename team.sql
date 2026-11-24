-- شغّل هذا الملف مرة واحدة في Supabase > SQL Editor (بعد setup.sql و storage.sql)
-- يضيف: جدول الفريق + صلاحيات (مدير / موظف) + تسجيل من تعامل مع الطلب

create table if not exists staff(
  email text primary key check (email = lower(email)),
  name text not null,
  role text not null default 'staff' check (role in ('owner','staff')),
  created_at timestamptz not null default now()
);

alter table orders add column if not exists handled_by text;

create or replace function public.is_staff() returns boolean
language sql security definer set search_path = public stable as $$
  select exists(select 1 from staff where email = lower(auth.jwt()->>'email'))
$$;

create or replace function public.is_owner() returns boolean
language sql security definer set search_path = public stable as $$
  select exists(select 1 from staff where email = lower(auth.jwt()->>'email') and role = 'owner')
$$;

-- أول حساب أُنشئ في Authentication يصبح المدير
insert into staff(email, name, role)
select lower(email), 'المدير', 'owner' from auth.users order by created_at limit 1
on conflict (email) do nothing;

alter table staff enable row level security;
drop policy if exists "staff read"  on staff;
drop policy if exists "staff write" on staff;
create policy "staff read"  on staff for select to authenticated
  using (is_owner() or email = lower(auth.jwt()->>'email'));
create policy "staff write" on staff for all to authenticated
  using (is_owner()) with check (is_owner());

-- المنيو: التعديل للمدير فقط
drop policy if exists "menu write" on menu_items;
create policy "menu write" on menu_items for all to authenticated
  using (is_owner()) with check (is_owner());

-- الطلبات: أي فرد من الفريق يرى ويحدّث، والحذف للمدير
drop policy if exists "orders read"   on orders;
drop policy if exists "orders update" on orders;
drop policy if exists "orders delete" on orders;
create policy "orders read"   on orders for select to authenticated using (is_staff());
create policy "orders update" on orders for update to authenticated using (is_staff()) with check (is_staff());
create policy "orders delete" on orders for delete to authenticated using (is_owner());

-- صور المنيو: الرفع للمدير فقط
drop policy if exists "menu images insert" on storage.objects;
drop policy if exists "menu images update" on storage.objects;
drop policy if exists "menu images delete" on storage.objects;
create policy "menu images insert" on storage.objects for insert to authenticated
  with check (bucket_id = 'menu-images' and is_owner());
create policy "menu images update" on storage.objects for update to authenticated
  using (bucket_id = 'menu-images' and is_owner());
create policy "menu images delete" on storage.objects for delete to authenticated
  using (bucket_id = 'menu-images' and is_owner());

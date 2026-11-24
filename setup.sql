-- شغّل هذا الملف كله مرة واحدة في Supabase > SQL Editor

create table if not exists menu_items(
  id bigint generated always as identity primary key,
  category text not null,
  name text not null,
  price numeric not null check (price >= 0),
  available boolean not null default true,
  sort int not null default 0,
  image_url text
);

create table if not exists orders(
  id bigint generated always as identity primary key,
  table_no text not null check (length(table_no) <= 10),
  items jsonb not null check (jsonb_typeof(items) = 'array'),
  total numeric not null check (total >= 0),
  status text not null default 'new' check (status in ('new','preparing','done')),
  created_at timestamptz not null default now()
);

alter table menu_items enable row level security;
alter table orders enable row level security;

-- المنيو: الكل يقرأ، الإدارة فقط تعدّل
create policy "menu read"   on menu_items for select using (true);
create policy "menu write"  on menu_items for all to authenticated using (true) with check (true);

-- الطلبات: الزبون يضيف فقط، الإدارة تقرأ وتحدّث
create policy "orders insert" on orders for insert to anon, authenticated
  with check (status = 'new');
create policy "orders read"   on orders for select to authenticated using (true);
create policy "orders update" on orders for update to authenticated using (true) with check (true);
create policy "orders delete" on orders for delete to authenticated using (true);

-- تفعيل التحديث اللحظي للطلبات (صوت التنبيه في لوحة الإدارة)
alter publication supabase_realtime add table orders;

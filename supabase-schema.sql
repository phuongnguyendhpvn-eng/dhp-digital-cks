-- DHP DIGITAL schema
create extension if not exists pgcrypto;
create table if not exists public.admins (
 user_id uuid primary key references auth.users(id) on delete cascade,
 created_at timestamptz not null default now()
);
create or replace function public.is_dhp_admin()
returns boolean language sql stable security definer set search_path=public
as $$ select exists(select 1 from public.admins where user_id=auth.uid()); $$;
grant execute on function public.is_dhp_admin() to anon, authenticated;

create table if not exists public.products (
 id uuid primary key default gen_random_uuid(),
 provider text not null,
 name text not null,
 kind text not null check(kind in ('new','renew')),
 duration text,
 price numeric(14,0) not null default 0,
 description text,
 active boolean not null default true,
 sort_order integer not null default 0,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table if not exists public.posts (
 id uuid primary key default gen_random_uuid(),
 title text not null,
 body text not null,
 published boolean not null default false,
 created_at timestamptz not null default now()
);
alter table public.admins enable row level security;
alter table public.products enable row level security;
alter table public.posts enable row level security;
drop policy if exists "admins read own admin row" on public.admins;
create policy "admins read own admin row" on public.admins for select to authenticated using (user_id=auth.uid());
drop policy if exists "public read active products" on public.products;
create policy "public read active products" on public.products for select to anon,authenticated using (active=true or public.is_dhp_admin());
drop policy if exists "admin manage products" on public.products;
create policy "admin manage products" on public.products for all to authenticated using (public.is_dhp_admin()) with check (public.is_dhp_admin());
drop policy if exists "public read published posts" on public.posts;
create policy "public read published posts" on public.posts for select to anon,authenticated using (published=true or public.is_dhp_admin());
drop policy if exists "admin manage posts" on public.posts;
create policy "admin manage posts" on public.posts for all to authenticated using (public.is_dhp_admin()) with check (public.is_dhp_admin());

insert into public.products(provider,name,kind,duration,price,description,active,sort_order)
select v.provider,v.name,v.kind,v.duration,v.price,v.description,true,v.ord
from (values
 ('Viettel-CA','Gói 1 năm','new','12 tháng',1200000::numeric,'Gói minh họa - vui lòng cập nhật giá chính thức.',1),
 ('Viettel-CA','Gói 3 năm','new','36 tháng',2200000::numeric,'Gói minh họa - vui lòng cập nhật giá chính thức.',2),
 ('VNPT-CA','Gia hạn 1 năm','renew','12 tháng',900000::numeric,'Gói minh họa - vui lòng cập nhật giá chính thức.',1),
 ('FPT-CA','Gói 2 năm','new','24 tháng',1650000::numeric,'Gói minh họa - vui lòng cập nhật giá chính thức.',1)
) as v(provider,name,kind,duration,price,description,ord)
where not exists(select 1 from public.products p where p.provider=v.provider and p.name=v.name and p.kind=v.kind);

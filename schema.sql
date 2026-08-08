-- Financeiro pessoal — tabelas + RLS
-- Cole este arquivo inteiro no SQL Editor do Supabase e rode.

create table if not exists fin_lancamentos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  data date not null,
  tipo text not null check (tipo in ('entrada','saida')),
  valor numeric(12,2) not null check (valor >= 0),
  categoria text not null default 'outros',
  descricao text,
  pago boolean not null default true,
  necessidade text check (necessidade in ('necessario','superfluo')),
  conta_fixa_id uuid,
  atualizado_em timestamptz not null default now()
);

alter table fin_lancamentos add column if not exists necessidade text check (necessidade in ('necessario','superfluo'));

create table if not exists fin_contas_fixas (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  nome text not null,
  valor numeric(12,2) not null check (valor >= 0),
  tipo text not null default 'saida' check (tipo in ('entrada','saida')),
  dia_vencimento int not null check (dia_vencimento between 1 and 31),
  categoria text not null default 'outros',
  ativa boolean not null default true
);

create table if not exists fin_metas (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  nome text not null,
  valor_alvo numeric(12,2) not null check (valor_alvo >= 0),
  valor_guardado numeric(12,2) not null default 0,
  prazo date
);

alter table fin_lancamentos enable row level security;
alter table fin_contas_fixas enable row level security;
alter table fin_metas enable row level security;

drop policy if exists "fin_lancamentos_dono" on fin_lancamentos;
create policy "fin_lancamentos_dono" on fin_lancamentos
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists "fin_contas_fixas_dono" on fin_contas_fixas;
create policy "fin_contas_fixas_dono" on fin_contas_fixas
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists "fin_metas_dono" on fin_metas;
create policy "fin_metas_dono" on fin_metas
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

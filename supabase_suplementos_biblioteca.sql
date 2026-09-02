-- ============================================================
-- Biblioteca de suplementos: recuerda los nombres de suplementos ya
-- usados (para cualquier alumno), junto con la última dosis y momento
-- del día que se le cargó. Sirve para que, al armar una dieta nueva, el
-- campo "Suplemento" sugiera nombres ya usados y, al elegir uno,
-- autocomplete la dosis y el momento (siempre editables a mano).
-- Ejecutar en el SQL Editor de Supabase (una sola vez)
-- ============================================================

create table if not exists public.suplementos_biblioteca (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  nombre_normalizado text not null unique,
  dosis text,
  momento text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.suplementos_biblioteca enable row level security;

-- Mismo criterio que el resto de las tablas de biblioteca (alimentos,
-- grupo_muscular_imagenes): cualquiera logueado en la app puede leer y
-- escribir, ya que solo el coach usa esta pantalla.
create policy "suplementos_biblioteca_select" on public.suplementos_biblioteca
  for select using (auth.role() = 'authenticated');
create policy "suplementos_biblioteca_insert" on public.suplementos_biblioteca
  for insert with check (auth.role() = 'authenticated');
create policy "suplementos_biblioteca_update" on public.suplementos_biblioteca
  for update using (auth.role() = 'authenticated');

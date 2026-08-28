-- ============================================================
-- Enfoque muscular de rutina: campo + imagen de referencia
-- Ejecutar en el SQL Editor de Supabase (una sola vez)
-- ============================================================

-- 1) Campo "enfoque" en rutinas y en las plantillas de rutina
alter table public.rutinas add column if not exists enfoque text;
alter table public.rutina_plantillas add column if not exists enfoque text;

-- 2) Tabla con la imagen de referencia de cada enfoque (push, pull, legs,
--    upper, lower, full_body, descanso). Una fila por enfoque; el coach la
--    sube/reemplaza desde la app y esto queda para siempre, sin volver a
--    tocar código.
create table if not exists public.enfoque_imagenes (
  enfoque text primary key,
  url text not null,
  updated_at timestamptz not null default now()
);

alter table public.enfoque_imagenes enable row level security;

-- Cualquiera que esté logueado en la app (alumno o coach) puede VER las
-- imágenes ya subidas.
create policy "enfoque_imagenes_select" on public.enfoque_imagenes
  for select using (auth.role() = 'authenticated');

-- Cualquiera logueado puede subir/actualizar. Si tu tabla "ejercicio_imagenes"
-- ya restringe esto solo al coach (por ejemplo comparando auth.uid() contra
-- una tabla de coaches), reemplazá estas dos policies por la misma condición
-- que usaste ahí, para mantenerlo consistente.
create policy "enfoque_imagenes_insert" on public.enfoque_imagenes
  for insert with check (auth.role() = 'authenticated');
create policy "enfoque_imagenes_update" on public.enfoque_imagenes
  for update using (auth.role() = 'authenticated');

-- 3) Bucket de Storage público para esas imágenes (mismo patrón que ya usa
--    "ejercicios-imagenes")
insert into storage.buckets (id, name, public)
  values ('enfoque-imagenes', 'enfoque-imagenes', true)
  on conflict (id) do nothing;

create policy "enfoque_imagenes_storage_read" on storage.objects
  for select using (bucket_id = 'enfoque-imagenes');
create policy "enfoque_imagenes_storage_insert" on storage.objects
  for insert with check (bucket_id = 'enfoque-imagenes' and auth.role() = 'authenticated');
create policy "enfoque_imagenes_storage_update" on storage.objects
  for update using (bucket_id = 'enfoque-imagenes' and auth.role() = 'authenticated');

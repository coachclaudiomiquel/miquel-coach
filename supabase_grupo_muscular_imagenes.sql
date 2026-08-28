-- ============================================================
-- Grupo muscular de rutina (texto libre) + imagen de referencia
-- Ejecutar en el SQL Editor de Supabase (una sola vez)
--
-- OJO: esto reemplaza el enfoque anterior (campo "enfoque" fijo con
-- Push/Pull/Legs/etc). Si ya habías corrido "supabase_enfoque_imagenes.sql",
-- podés dejar esas tablas ahí sin usar, o borrarlas primero con:
--   drop table if exists public.enfoque_imagenes;
--   alter table public.rutinas drop column if exists enfoque;
--   alter table public.rutina_plantillas drop column if exists enfoque;
--   -- y borrar el bucket "enfoque-imagenes" desde Storage en el dashboard
-- ============================================================

-- 1) Campo de texto libre para el grupo muscular del día (ej: "Femoral",
--    "Pecho", "Espalda alta"... lo que el coach quiera escribir)
alter table public.rutinas add column if not exists grupo_muscular text;
alter table public.rutina_plantillas add column if not exists grupo_muscular text;

-- 2) Imagen de referencia por grupo muscular: se busca por nombre
--    normalizado (minúsculas, sin tildes), así que "Femoral", "femoral" o
--    "FEMORAL" calzan con la misma imagen ya subida.
create table if not exists public.grupo_muscular_imagenes (
  nombre_normalizado text primary key,
  nombre_original text not null,
  url text not null,
  updated_at timestamptz not null default now()
);

alter table public.grupo_muscular_imagenes enable row level security;

-- Cualquiera logueado en la app puede VER las imágenes ya subidas.
create policy "grupo_muscular_imagenes_select" on public.grupo_muscular_imagenes
  for select using (auth.role() = 'authenticated');

-- Cualquiera logueado puede subir/actualizar. Si tu tabla "ejercicio_imagenes"
-- ya restringe esto solo al coach, reemplazá estas dos policies por la misma
-- condición que usaste ahí, para mantenerlo consistente.
create policy "grupo_muscular_imagenes_insert" on public.grupo_muscular_imagenes
  for insert with check (auth.role() = 'authenticated');
create policy "grupo_muscular_imagenes_update" on public.grupo_muscular_imagenes
  for update using (auth.role() = 'authenticated');

-- 3) Bucket de Storage público (mismo patrón que "ejercicios-imagenes")
insert into storage.buckets (id, name, public)
  values ('grupo-muscular-imagenes', 'grupo-muscular-imagenes', true)
  on conflict (id) do nothing;

create policy "grupo_muscular_imagenes_storage_read" on storage.objects
  for select using (bucket_id = 'grupo-muscular-imagenes');
create policy "grupo_muscular_imagenes_storage_insert" on storage.objects
  for insert with check (bucket_id = 'grupo-muscular-imagenes' and auth.role() = 'authenticated');
create policy "grupo_muscular_imagenes_storage_update" on storage.objects
  for update using (bucket_id = 'grupo-muscular-imagenes' and auth.role() = 'authenticated');

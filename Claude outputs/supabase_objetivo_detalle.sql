-- ============================================================
-- Agrega la columna para guardar el texto libre cuando el alumno elige
-- "Otro" como objetivo principal en la Anamnesis (o el coach lo corrige
-- desde el perfil del alumno).
--
-- Ejecutar en el SQL Editor de Supabase (una sola vez). No borra ni
-- modifica ningún dato existente de ningún alumno.
-- ============================================================

alter table if exists public.usuarios
  add column if not exists objetivo_detalle text;

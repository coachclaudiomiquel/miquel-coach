-- ============================================================
-- Ajustes: unidades simplificadas en "alimentos" + nivel de actividad
-- física (1-10) en "usuarios", para la calculadora de objetivo.
-- Ejecutar en el SQL Editor de Supabase (una sola vez)
--
-- OJO: esto reemplaza "tipo_medida" + "unidad_nombre" (de
-- supabase_alimentos_dietas.sql) por un solo campo "unidad" con 4
-- opciones fijas: g, ml, und, scoop. Como todavía no cargaste ningún
-- alimento real en la biblioteca, no hay nada que migrar -- si en algún
-- momento ya tenés alimentos cargados antes de correr esto, avisame y
-- te preparo un UPDATE que convierta los datos existentes en vez de
-- este script simple.
-- ============================================================

alter table public.alimentos add column if not exists unidad text not null default 'g';
alter table public.alimentos drop constraint if exists alimentos_unidad_check;
alter table public.alimentos add constraint alimentos_unidad_check check (unidad in ('g', 'ml', 'und', 'scoop'));

alter table public.alimentos drop column if exists tipo_medida;
alter table public.alimentos drop column if exists unidad_nombre;

-- Nivel de actividad física general del alumno (1 = muy sedentario, 10 =
-- muy activo), autoevaluado en la anamnesis con una barrita, y editable
-- después por el coach. Se usa como referencia para la calculadora de
-- objetivo calórico (Mifflin-St Jeor).
alter table public.usuarios add column if not exists nivel_actividad integer;
alter table public.usuarios drop constraint if exists usuarios_nivel_actividad_check;
alter table public.usuarios add constraint usuarios_nivel_actividad_check check (nivel_actividad is null or (nivel_actividad between 1 and 10));

-- ============================================================
-- Músculo principal de cada ejercicio, para calcular el volumen semanal
-- por grupo muscular en la ficha del alumno. Mismo patrón que la imagen y
-- la reseña de técnica: se guarda una sola vez por nombre normalizado del
-- ejercicio (tabla "ejercicio_imagenes") y sirve para cualquier rutina,
-- presente o futura, que use ese mismo ejercicio.
-- Es opcional -- los ejercicios sin músculo asignado simplemente no entran
-- en el conteo de volumen hasta que se clasifiquen.
-- Ejecutar en el SQL Editor de Supabase (una sola vez)
-- ============================================================

alter table public.ejercicio_imagenes add column if not exists musculo_principal text;

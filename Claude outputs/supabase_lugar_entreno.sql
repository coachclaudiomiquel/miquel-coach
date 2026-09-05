-- ============================================================
-- "Dónde entrena" en la Anamnesis: gimnasio / en casa / parque o aire
-- libre / otro, con un detalle libre (nombre del gimnasio, o la
-- especificación de "otro"). Sirve para que el coach sepa qué máquinas
-- tiene disponibles el alumno en su gimnasio actual.
-- Ejecutar en el SQL Editor de Supabase (una sola vez)
-- ============================================================

alter table public.usuarios add column if not exists lugar_entreno text;
alter table public.usuarios add column if not exists lugar_entreno_detalle text;

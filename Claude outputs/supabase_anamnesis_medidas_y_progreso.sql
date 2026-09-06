-- ============================================================
-- 1) Medidas iniciales (cintura, cadera, brazo, pecho, pierna), que ahora
--    también se piden en la Anamnesis (antes solo se pedían en el Reporte
--    de seguimiento cada 4 semanas).
--
-- 2) Progreso de la Anamnesis: si un alumno cierra la app antes de
--    terminarla (por ejemplo, porque quiere medirse más tarde), estas dos
--    columnas permiten que la próxima vez que inicie sesión retome
--    exactamente donde quedó, en vez de empezar de cero.
--    - anamnesis_paso: en qué paso (1 a 4) quedó.
--    - anamnesis_completada: true solo cuando de verdad terminó y envió
--      el formulario completo. Reemplaza la lógica anterior, que asumía
--      "completa" con solo tener el nombre guardado -- ya no sirve porque
--      ahora el nombre se guarda desde el primer paso.
--
-- Ejecutar en el SQL Editor de Supabase (una sola vez). No borra ni
-- modifica ningún dato existente de ningún alumno.
-- ============================================================

alter table if exists public.usuarios
  add column if not exists cintura_inicial numeric,
  add column if not exists cadera_inicial numeric,
  add column if not exists brazo_inicial numeric,
  add column if not exists pecho_inicial numeric,
  add column if not exists pierna_inicial numeric,
  add column if not exists anamnesis_paso integer default 1,
  add column if not exists anamnesis_completada boolean default false;

-- Backfill: todos los alumnos que ya tienen nombre guardado hoy en día
-- terminaron su anamnesis con el flujo anterior (que solo guardaba al
-- final) -- se los marca como completados para que sigan apareciendo
-- normalmente en el panel del coach.
update public.usuarios
set anamnesis_completada = true, anamnesis_paso = 4
where nombre is not null and (anamnesis_completada is distinct from true);

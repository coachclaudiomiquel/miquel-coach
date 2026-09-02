-- ============================================================
-- Rutina por defecto según sexo: marca qué plantillas arman el split que
-- se le puede asignar de una a un alumno nuevo, según su sexo (campo
-- "usuarios.sexo": "Masculino" | "Femenino" | "Otro").
--
-- Se marca desde el mismo formulario "💾 Guardar como plantilla" en
-- RutinaCoach, con un select "Default para: Ninguno / Mujeres / Hombres".
-- Ejecutar en el SQL Editor de Supabase (una sola vez)
-- ============================================================

alter table public.rutina_plantillas add column if not exists default_para text;
alter table public.rutina_plantillas drop constraint if exists rutina_plantillas_default_para_check;
alter table public.rutina_plantillas add constraint rutina_plantillas_default_para_check check (default_para is null or default_para in ('Femenino', 'Masculino'));

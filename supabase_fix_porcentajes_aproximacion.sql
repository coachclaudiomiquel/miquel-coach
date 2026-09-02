-- ============================================================
-- Corrige series de "aproximación" donde el % Desde quedó cargado más
-- alto que el % Hasta (ej: se ve "90-85% de tu efectiva" en vez de
-- "85-90%") -- barre toda la base, tanto ejercicios de rutinas ya
-- asignadas como plantillas guardadas, e invierte los dos valores donde
-- corresponda. No toca nada donde Desde ya es menor o igual a Hasta, así
-- que es seguro correrlo aunque ya no queden casos así (no hace nada).
--
-- Ejecutar en el SQL Editor de Supabase (una sola vez)
-- ============================================================

-- 1) Ejercicios de rutinas ya asignadas a alumnos (tabla "ejercicios",
--    columna "series": array con series de aproximación y efectivas
--    mezcladas, cada una con su "tipo").
update public.ejercicios
set series = (
  select jsonb_agg(
    case
      when elem->>'tipo' = 'aproximacion'
        and (elem->>'pctDesde') ~ '^[0-9.]+$' and (elem->>'pctHasta') ~ '^[0-9.]+$'
        and (elem->>'pctDesde')::numeric > (elem->>'pctHasta')::numeric
      then elem || jsonb_build_object('pctDesde', elem->>'pctHasta', 'pctHasta', elem->>'pctDesde')
      else elem
    end
  )
  from jsonb_array_elements(series) as elem
)
where series is not null
  and exists (
    select 1 from jsonb_array_elements(series) as e
    where e->>'tipo' = 'aproximacion'
      and (e->>'pctDesde') ~ '^[0-9.]+$' and (e->>'pctHasta') ~ '^[0-9.]+$'
      and (e->>'pctDesde')::numeric > (e->>'pctHasta')::numeric
  );

-- 2) Plantillas guardadas (tabla "rutina_plantillas", columna
--    "ejercicios": array de ejercicios, cada uno con su propio array
--    "seriesAproximacion").
update public.rutina_plantillas
set ejercicios = (
  select jsonb_agg(
    ej || jsonb_build_object(
      'seriesAproximacion', (
        select coalesce(jsonb_agg(
          case
            when (s->>'pctDesde') ~ '^[0-9.]+$' and (s->>'pctHasta') ~ '^[0-9.]+$'
              and (s->>'pctDesde')::numeric > (s->>'pctHasta')::numeric
            then s || jsonb_build_object('pctDesde', s->>'pctHasta', 'pctHasta', s->>'pctDesde')
            else s
          end
        ), '[]'::jsonb)
        from jsonb_array_elements(coalesce(ej->'seriesAproximacion', '[]'::jsonb)) as s
      )
    )
  )
  from jsonb_array_elements(ejercicios) as ej
)
where ejercicios is not null
  and exists (
    select 1
    from jsonb_array_elements(ejercicios) as ej2,
         jsonb_array_elements(coalesce(ej2->'seriesAproximacion', '[]'::jsonb)) as s2
    where (s2->>'pctDesde') ~ '^[0-9.]+$' and (s2->>'pctHasta') ~ '^[0-9.]+$'
      and (s2->>'pctDesde')::numeric > (s2->>'pctHasta')::numeric
  );

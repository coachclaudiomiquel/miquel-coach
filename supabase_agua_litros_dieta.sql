-- Agrega el override manual del "agua de hoy" a las dietas ya asignadas a
-- un alumno. Por defecto el alumno ve el agua calculada automáticamente
-- (peso actual × 35 ml, redondeado a los 0.5 L más cercanos, +1 L extra los
-- días que tiene rutina asignada). Esta columna permite al coach forzar un
-- valor manual cuando haga falta (ej: fase de diuresis pre-competencia,
-- donde el agua se sube o baja a mano).
--
-- No se agrega a "dieta_plantillas": es un valor propio de la situación
-- puntual de cada alumno (igual criterio que los "días" de la dieta), no
-- algo que tenga sentido reutilizar como plantilla para otro alumno.

alter table dietas
  add column if not exists agua_litros numeric;

-- Agrega "hábitos generales" como campo editable por dieta (mismo patrón
-- que "notas"): viene precargado con el texto estándar pero el coach lo
-- puede editar libremente por alumno (ej: agregar algo puntual). Si queda
-- vacío/null, el alumno sigue viendo el texto estándar (definido en el
-- código, HABITOS_DIETA_DEFAULT) — no hace falta migrar las dietas ya
-- creadas para que sigan mostrando lo mismo que mostraban antes.
--
-- Se agrega a "dietas" (planes ya asignados a un alumno) y a
-- "dieta_plantillas" (plantillas reutilizables), igual que "notas".

alter table dietas
  add column if not exists habitos text;

alter table dieta_plantillas
  add column if not exists habitos text;

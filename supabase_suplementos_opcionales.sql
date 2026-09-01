-- Agrega la columna de "Suplementación opcional/ideal": una lista libre que
-- el coach arma por alumno (a diferencia de "suplementos", que es fija y
-- obligatoria). Cada ítem es { nombre, dosis, momento }, con momento en
-- "manana" | "pre_entreno" | "post_entreno" | "dormir".
-- Se agrega a "dietas" (planes ya asignados a un alumno) y a
-- "dieta_plantillas" (plantillas reutilizables), para que ambas puedan
-- cargarla y usarla como base al crear un plan nuevo.

alter table dietas
  add column if not exists suplementos_opcionales jsonb not null default '[]'::jsonb;

alter table dieta_plantillas
  add column if not exists suplementos_opcionales jsonb not null default '[]'::jsonb;

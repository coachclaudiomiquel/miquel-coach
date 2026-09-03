-- ============================================================
-- Días de descanso configurables por día/alumno: agrega una columna
-- "es_descanso" a la tabla "rutinas". Una rutina marcada como descanso
-- funciona igual que cualquier otra (mismo "dia", mismo "meta_pasos" y
-- "cardio" que ya existían), pero sin ejercicios -- el alumno la ve en
-- su Entreno de hoy con una imagen y su meta de pasos/cardio en vez de
-- una lista de ejercicios vacía.
--
-- No se necesita ninguna otra migración: "meta_pasos" y "cardio" ya
-- existen en la tabla "rutinas" desde antes.
--
-- Ejecutar en el SQL Editor de Supabase (una sola vez)
-- ============================================================

alter table public.rutinas add column if not exists es_descanso boolean not null default false;

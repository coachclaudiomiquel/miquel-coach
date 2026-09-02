-- ============================================================
-- Grupo alimenticio (Proteína / Carbohidrato / Grasa / Fruta / Verdura) en
-- la biblioteca de alimentos, para poder calcular equivalencias automáticas:
-- dos alimentos del mismo grupo se pueden intercambiar igualando su macro
-- principal (proteína con proteína, carbohidrato con carbohidrato, grasa
-- con grasa, fruta con fruta -- por carbohidratos, pero separado del grupo
-- "Carbohidrato" para no mezclar frutas con arroz/pan/papa). "Verdura" es
-- solo para clasificar (ensaladas, hojas verdes, tomate, etc.) -- no calcula
-- equivalencias entre verduras.
-- Es opcional por alimento -- los que no tengan grupo simplemente no
-- muestran sugerencias de equivalencia automática.
-- Ejecutar en el SQL Editor de Supabase (una sola vez)
-- ============================================================

alter table public.alimentos add column if not exists grupo text;
alter table public.alimentos drop constraint if exists alimentos_grupo_check;
alter table public.alimentos add constraint alimentos_grupo_check check (grupo is null or grupo in ('proteina', 'carbohidrato', 'grasa', 'fruta', 'verdura'));

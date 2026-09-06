-- ============================================================
-- Renombra la tabla "checkins" a "reportes" para que el nombre en la base
-- de datos combine con el término que ahora se usa en toda la app
-- ("Reporte" en vez de "Check-in"). Postgres/Supabase preserva todas las
-- filas tal cual están -- este cambio es solo de nombre, no borra ni
-- modifica ningún dato de ningún alumno.
--
-- IMPORTANTE: el código de la app (App.jsx ya actualizado) apunta a
-- "reportes" desde ahora. Para no dejar la app sin poder guardar/leer
-- reportes ni un minuto, conviene ejecutar este script y hacer el
-- "git push" del código nuevo lo más seguido posible uno del otro.
-- Ejecutar en el SQL Editor de Supabase (una sola vez).
-- ============================================================

alter table if exists public.checkins rename to reportes;

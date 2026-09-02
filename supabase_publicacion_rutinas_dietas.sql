-- ============================================================
-- Publicación de rutinas y dietas: el alumno solo ve las que tienen
-- "publicada" en true. Por defecto queda en true (así nada de lo que ya
-- está asignado hoy desaparece al correr este SQL) -- pero toda rutina o
-- dieta NUEVA que se cree desde la app (a mano, con "Usar plantilla", o
-- con "Asignar rutina por defecto") arranca en false (borrador), y el
-- coach la publica con su propio botón "📤 Cargar" cuando terminó de
-- revisarla. Editar una rutina/dieta que el alumno ya ve no la vuelve a
-- ocultar -- el borrador es solo para lo que todavía no se publicó nunca.
--
-- Ejecutar en el SQL Editor de Supabase (una sola vez)
-- ============================================================

alter table public.rutinas add column if not exists publicada boolean not null default true;
alter table public.dietas add column if not exists publicada boolean not null default true;

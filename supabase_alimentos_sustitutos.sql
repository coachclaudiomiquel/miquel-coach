-- ============================================================
-- Sustitutos curados a mano por alimento (equivalencias automáticas
-- editables). Reemplaza a la sección manual "EQUIVALENCIAS PERMITIDAS"
-- que armaba el coach por dieta: ahora, la lista de hasta 3 sustitutos
-- automáticos (más parecidos en calorías, dentro del mismo grupo) se
-- puede ajustar a mano desde el mismo desplegable "🔁 Ver equivalencias"
-- al armar una dieta -- y esa lista queda guardada en el propio alimento,
-- como default para cualquier dieta futura de cualquier alumno que use
-- ese alimento.
--
-- Si esta columna es NULL, se sigue mostrando la lista automática (los 3
-- más parecidos en calorías). Si tiene una lista (aunque sea vacía), esa
-- lista manda tal cual, en ese orden.
--
-- Ejecutar en el SQL Editor de Supabase (una sola vez)
-- ============================================================

alter table public.alimentos add column if not exists sustitutos_ids uuid[];

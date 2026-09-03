-- ============================================================
-- Carga masiva de alimentos a la biblioteca, a partir del reporte de
-- FatSecret adjuntado (alimentos.pdf). Son 80 alimentos.
--
-- Los macros de cada fila del PDF vienen "por la porción que se comió"
-- (ej: por 65g, por 1 lámina, por 1 taza) -- este script los normaliza
-- todos a "por 100g" / "por 100ml" / "por 1 unidad", que es como los
-- guarda la biblioteca de la app. El campo "grupo" (para las
-- equivalencias automáticas) y "estado_preparacion" son una propuesta
-- mía en base al nombre de cada alimento -- se pueden corregir en
-- cualquier momento desde "Editar" en la Biblioteca de alimentos.
--
-- Es seguro correrlo más de una vez: cada fila se salta si ya existe
-- un alimento con ese mismo nombre normalizado (no duplica).
--
-- Este archivo incluye primero la migración que habilita los grupos
-- "fruta" y "verdura" (ya la tenías en supabase_alimentos_grupo.sql, pero
-- se agrega también acá para que este archivo se pueda correr solo, sin
-- depender del orden en que se ejecuten los dos). Si ya corriste
-- supabase_alimentos_grupo.sql antes, este bloque no hace nada nuevo
-- (usa "if not exists" / reemplaza la misma restricción).
--
-- El campo "fuente" de estas 80 filas queda como 'manual' (igual que
-- cualquier alimento que agregas a mano desde la app): la tabla tiene una
-- restricción (alimentos_fuente_check) que no incluye 'fatsecret_import',
-- así que se usa el valor que ya está permitido -- no cambia nada en
-- cómo funciona la biblioteca, "fuente" es solo informativo.
--
-- Ejecutar en el SQL Editor de Supabase (una sola vez)
-- ============================================================

alter table public.alimentos add column if not exists grupo text;
alter table public.alimentos drop constraint if exists alimentos_grupo_check;
alter table public.alimentos add constraint alimentos_grupo_check check (grupo is null or grupo in ('proteina', 'carbohidrato', 'grasa', 'fruta', 'verdura'));

insert into public.alimentos
  (nombre, nombre_normalizado, estado_preparacion, grupo, unidad,
   calorias_base, proteinas_base, carbos_base, grasas_base, fuente)
select v.nombre, v.nombre_normalizado, v.estado_preparacion, v.grupo, v.unidad,
       v.calorias_base, v.proteinas_base, v.carbos_base, v.grasas_base, v.fuente
from (values
  ('Castaño Pan de Molde Multigrano Proteína', 'castano pan de molde multigrano proteina', NULL, 'carbohidrato', 'g', 261.54, 16.0, 38.62, 4.46, 'manual'),
  ('Kingsbury Pan Integral Hi Low', 'kingsbury pan integral hi low', NULL, 'carbohidrato', 'g', 204.84, 17.26, 19.19, 6.45, 'manual'),
  ('Yema de Huevo (1 grande)', 'yema de huevo (1 grande)', NULL, 'proteina', 'und', 55.0, 2.7, 0.61, 4.51, 'manual'),
  ('Clara de Huevo (1 unidad grande)', 'clara de huevo (1 unidad grande)', NULL, 'proteina', 'und', 17.0, 3.6, 0.24, 0.06, 'manual'),
  ('Lider Pangasius', 'lider pangasius', NULL, 'proteina', 'g', 79.0, 17.2, 0.1, 1.1, 'manual'),
  ('Garbanzos Cocidos', 'garbanzos cocidos', 'cocido', 'carbohidrato', 'g', 164.0, 8.86, 27.42, 2.59, 'manual'),
  ('Frijoles Cocidos', 'frijoles cocidos', 'cocido', 'carbohidrato', 'g', 151.0, 5.54, 21.39, 5.15, 'manual'),
  ('Porotos', 'porotos', NULL, 'carbohidrato', 'g', 340.0, 22.47, 61.41, 1.45, 'manual'),
  ('Lentejas Cocidas', 'lentejas cocidas', 'cocido', 'carbohidrato', 'g', 165.0, 8.39, 18.73, 6.76, 'manual'),
  ('Lentejas', 'lentejas', NULL, 'carbohidrato', 'g', 353.0, 25.8, 60.08, 1.06, 'manual'),
  ('Papa al Horno (Comiéndose la Cáscara)', 'papa al horno (comiendose la cascara)', NULL, 'carbohidrato', 'g', 109.0, 2.43, 20.53, 2.2, 'manual'),
  ('Boniato Asado', 'boniato asado', 'cocido', 'carbohidrato', 'g', 101.0, 1.48, 23.98, 0.13, 'manual'),
  ('Camote', 'camote', NULL, 'carbohidrato', 'g', 114.0, 1.94, 19.97, 3.26, 'manual'),
  ('Papa Asada (sin Grasa Añadida)', 'papa asada (sin grasa anadida)', 'cocido', 'carbohidrato', 'g', 95.0, 2.49, 21.52, 0.11, 'manual'),
  ('Papa Cocida', 'papa cocida', 'cocido', 'carbohidrato', 'g', 80.0, 2.16, 18.22, 0.11, 'manual'),
  ('Patata Cruda', 'patata cruda', 'crudo', 'carbohidrato', 'g', 70.0, 1.68, 15.71, 0.1, 'manual'),
  ('Tucapel Harina de Arroz', 'tucapel harina de arroz', NULL, 'carbohidrato', 'g', 350.0, 5.6, 79.8, 1.0, 'manual'),
  ('Vivo Avena Instantánea', 'vivo avena instantanea', NULL, 'carbohidrato', 'g', 372.0, 11.0, 60.0, 9.1, 'manual'),
  ('Lucchetti Spaghetti 5', 'lucchetti spaghetti 5', NULL, 'carbohidrato', 'g', 338.0, 10.0, 70.0, 3.0, 'manual'),
  ('Espaguetis de Trigo (Cocidos)', 'espaguetis de trigo (cocidos)', 'cocido', 'carbohidrato', 'g', 124.0, 5.33, 26.54, 0.54, 'manual'),
  ('Tucapel Arroz Blanco Grado 2', 'tucapel arroz blanco grado 2', NULL, 'carbohidrato', 'g', 328.0, 7.2, 72.4, 1.0, 'manual'),
  ('Arroz Blanco Cocido', 'arroz blanco cocido', 'cocido', 'carbohidrato', 'g', 129.0, 2.5, 28.18, 0.23, 'manual'),
  ('Carne de Soya', 'carne de soya', NULL, 'proteina', 'g', 246.0, 55.5, 10.16, 1.46, 'manual'),
  ('Ultimate Nutrition Prostar 100% Whey', 'ultimate nutrition prostar 100% whey', NULL, 'proteina', 'scoop', 120.0, 25.0, 2.0, 1.0, 'manual'),
  ('Surlat Leche Proteina', 'surlat leche proteina', NULL, 'proteina', 'ml', 38.0, 4.5, 4.7, 0.1, 'manual'),
  ('Soprole Leche Protein+', 'soprole leche protein+', NULL, 'proteina', 'ml', 55.0, 6.0, 4.9, 1.3, 'manual'),
  ('Loncoleche Protein Milk Extra Proteina', 'loncoleche protein milk extra proteina', NULL, 'proteina', 'ml', 41.0, 4.6, 5.1, 0.2, 'manual'),
  ('Loncoleche Yoghurt Protein', 'loncoleche yoghurt protein', NULL, 'proteina', 'g', 65.0, 8.79, 5.93, 0.71, 'manual'),
  ('Soprole Yogurt Protein + Natural', 'soprole yogurt protein + natural', NULL, 'proteina', 'g', 67.74, 6.58, 6.32, 1.81, 'manual'),
  ('Soprole Yogurt Protein + Vainilla', 'soprole yogurt protein + vainilla', NULL, 'proteina', 'g', 67.74, 6.58, 6.32, 1.81, 'manual'),
  ('Nestlé Goodnes Probióticos', 'nestle goodnes probioticos', NULL, 'proteina', 'g', 72.14, 5.21, 7.79, 1.93, 'manual'),
  ('Nestlé Goodnes Protein', 'nestle goodnes protein', NULL, 'proteina', 'g', 81.43, 7.14, 8.79, 1.93, 'manual'),
  ('Lider Choritos en Agua', 'lider choritos en agua', NULL, 'proteina', 'g', 70.0, 10.4, 3.8, 1.6, 'manual'),
  ('Camarones', 'camarones', NULL, 'proteina', 'g', 144.0, 27.59, 1.24, 2.35, 'manual'),
  ('Lomo de Cerdo Asado', 'lomo de cerdo asado', 'cocido', 'proteina', 'g', 247.0, 26.98, 0.0, 14.59, 'manual'),
  ('Lomo de Cerdo', 'lomo de cerdo', NULL, 'proteina', 'g', 136.0, 20.54, 0.0, 5.41, 'manual'),
  ('Soprole Queso Gauda (16,6g)', 'soprole queso gauda (16,6g)', NULL, 'proteina', 'g', 384.0, 23.49, 1.99, 26.51, 'manual'),
  ('Quillayes Queso Cottage', 'quillayes queso cottage', NULL, 'proteina', 'g', 83.0, 11.0, 0.33, 4.0, 'manual'),
  ('Sopraval Pechuga de Pavo Cocida', 'sopraval pechuga de pavo cocida', 'cocido', 'proteina', 'g', 85.0, 18.0, 0.5, 1.0, 'manual'),
  ('Carne de Pavo (Cocida, Asada)', 'carne de pavo (cocida, asada)', 'cocido', 'proteina', 'g', 170.0, 29.32, 0.0, 4.97, 'manual'),
  ('Reineta', 'reineta', NULL, 'proteina', 'g', 84.0, 17.21, 0.0, 1.22, 'manual'),
  ('Merluza', 'merluza', NULL, 'proteina', 'g', 132.0, 21.38, 0.41, 4.38, 'manual'),
  ('Salmón', 'salmon', NULL, 'proteina', 'g', 146.0, 21.62, 0.0, 5.93, 'manual'),
  ('San Jose Lomos Jurel al Natural', 'san jose lomos jurel al natural', NULL, 'proteina', 'g', 123.0, 24.0, 0.0, 3.0, 'manual'),
  ('Lider Atún Lomitos en Agua', 'lider atun lomitos en agua', NULL, 'proteina', 'g', 107.69, 25.05, 0.0, 0.88, 'manual'),
  ('El Buen Corte Posta Paleta', 'el buen corte posta paleta', NULL, 'proteina', 'g', 108.0, 24.4, 0.5, 1.1, 'manual'),
  ('Pechuga de Pollo sin Piel', 'pechuga de pollo sin piel', NULL, 'proteina', 'g', 110.0, 23.09, 0.0, 1.24, 'manual'),
  ('Aceitunas', 'aceitunas', NULL, 'grasa', 'g', 117.0, 0.92, 5.4, 11.27, 'manual'),
  ('Lider Aceite de Oliva Extra Virgen', 'lider aceite de oliva extra virgen', NULL, 'grasa', 'ml', 821.0, 0.0, 0.0, 91.0, 'manual'),
  ('Cuisine & Co Mantequilla de Maní', 'cuisine & co mantequilla de mani', NULL, 'grasa', 'g', 585.0, 26.0, 10.0, 49.0, 'manual'),
  ('Maní', 'mani', NULL, 'grasa', 'g', 567.0, 25.8, 16.13, 49.24, 'manual'),
  ('Almendras', 'almendras', NULL, 'grasa', 'g', 578.0, 21.26, 19.74, 50.64, 'manual'),
  ('Nueces', 'nueces', NULL, 'grasa', 'g', 654.0, 15.23, 13.71, 65.21, 'manual'),
  ('Palta Hass', 'palta hass', NULL, 'grasa', 'g', 160.0, 2.0, 8.53, 14.66, 'manual'),
  ('Cacao en Polvo', 'cacao en polvo', NULL, NULL, 'g', 229.0, 19.6, 54.3, 13.7, 'manual'),
  ('Marco Polo Chocolate Amargo', 'marco polo chocolate amargo', NULL, NULL, 'g', 400.0, 26.2, 40.0, 15.0, 'manual'),
  ('Coliflor', 'coliflor', NULL, 'verdura', 'g', 25.0, 1.98, 5.3, 0.1, 'manual'),
  ('Betarraga', 'betarraga', NULL, 'verdura', 'g', 43.0, 1.61, 9.56, 0.17, 'manual'),
  ('Acelga', 'acelga', NULL, 'verdura', 'g', 19.0, 1.8, 3.74, 0.2, 'manual'),
  ('Espinacas', 'espinacas', NULL, 'verdura', 'g', 23.0, 2.86, 3.63, 0.39, 'manual'),
  ('Tomates', 'tomates', NULL, 'verdura', 'g', 18.0, 0.88, 3.92, 0.2, 'manual'),
  ('Zanahoria', 'zanahoria', NULL, 'verdura', 'g', 41.0, 0.93, 9.58, 0.24, 'manual'),
  ('Cebollas', 'cebollas', NULL, 'verdura', 'g', 42.0, 0.92, 10.11, 0.08, 'manual'),
  ('Pimentón', 'pimenton', NULL, 'verdura', 'g', 29.0, 0.8, 6.68, 0.41, 'manual'),
  ('Espárragos', 'esparragos', NULL, 'verdura', 'g', 20.0, 2.2, 3.88, 0.12, 'manual'),
  ('Apio', 'apio', NULL, 'verdura', 'g', 14.0, 0.69, 2.97, 0.17, 'manual'),
  ('Brócoli', 'brocoli', NULL, 'verdura', 'g', 34.0, 2.82, 6.64, 0.37, 'manual'),
  ('Repollo', 'repollo', NULL, 'verdura', 'g', 24.0, 1.44, 5.58, 0.12, 'manual'),
  ('Lechuga', 'lechuga', NULL, 'verdura', 'g', 14.0, 0.9, 2.97, 0.14, 'manual'),
  ('Sandía', 'sandia', NULL, 'fruta', 'g', 30.0, 0.61, 7.55, 0.15, 'manual'),
  ('Mangos', 'mangos', NULL, 'fruta', 'g', 65.0, 0.51, 17.0, 0.27, 'manual'),
  ('Naranjas', 'naranjas', NULL, 'fruta', 'g', 47.0, 0.94, 11.75, 0.12, 'manual'),
  ('Kiwi', 'kiwi', NULL, 'fruta', 'g', 61.0, 1.14, 14.66, 0.52, 'manual'),
  ('Frambuesas Congeladas sin Endulzante', 'frambuesas congeladas sin endulzante', NULL, 'fruta', 'g', 52.0, 1.2, 11.94, 0.65, 'manual'),
  ('Frambuesas', 'frambuesas', NULL, 'fruta', 'g', 52.0, 1.2, 11.94, 0.65, 'manual'),
  ('Arándanos', 'arandanos', NULL, 'fruta', 'g', 57.0, 0.74, 14.49, 0.33, 'manual'),
  ('Manzana Roja', 'manzana roja', NULL, 'fruta', 'g', 52.0, 0.26, 13.81, 0.17, 'manual'),
  ('Piña', 'pina', NULL, 'fruta', 'g', 48.0, 0.54, 12.63, 0.12, 'manual'),
  ('Manzana Verde', 'manzana verde', NULL, 'fruta', 'g', 55.0, 0.24, 14.48, 0.25, 'manual'),
  ('Plátano', 'platano', NULL, 'fruta', 'g', 89.0, 1.09, 22.84, 0.33, 'manual')
) as v(nombre, nombre_normalizado, estado_preparacion, grupo, unidad,
       calorias_base, proteinas_base, carbos_base, grasas_base, fuente)
where not exists (
  select 1 from public.alimentos a where a.nombre_normalizado = v.nombre_normalizado
);

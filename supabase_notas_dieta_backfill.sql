-- Actualiza el texto de "Notas del Coach" en dietas y plantillas VIEJAS que
-- todavía tienen alguna versión anterior del texto por defecto, para que
-- pasen a mostrar el texto final que definimos. Es un reemplazo QUIRÚRGICO:
-- solo toca filas cuyo campo "notas" coincide EXACTAMENTE, carácter por
-- carácter, con alguna de las cuatro versiones anteriores del default
-- (identificadas en el historial del código y en lo reportado por Claudio).
-- Cualquier nota que hayas
-- escrito o editado a mano para un alumno en particular NO coincide con
-- estos textos exactos, así que queda intacta.
--
-- Después de correr esto, las dietas que ya tenían cualquier versión del
-- default (incluida la que hasta ahora era la "actual") van a mostrar el
-- texto final; las dietas con notas personalizadas no cambian.

update dietas
set notas = 'Completa todas las comidas para cumplir con los macros y calorías propuestas. Si te saltas alguna, puedes juntarla con otra durante el día.
Para reemplazar alimentos, utiliza las equivalencias permitidas y respeta las cantidades indicadas para mantener los aportes nutricionales.
Mantén la constancia y adherencia al plan día a día, ya que la regularidad es clave para alcanzar tus objetivos.
Ante cualquier duda, consulta directamente con tu Coach.'
where notas in (
  'Respeta todas las comidas del plan. Si te saltas alguna, puedes juntarla con la siguiente. Para reemplazar un alimento, revisa primero las equivalencias permitidas. Ante cualquier duda, consulta directamente con tu coach.',
  'Respeta todas las comidas del plan. Si te saltas alguna, puedes juntarla con la siguiente; si dos comidas coinciden, haz las dos juntas para llegar a los macros del día. Para reemplazar un alimento, revisa primero las equivalencias permitidas. Ante cualquier duda, consulta directamente con tu coach.',
  'Completa todas las comidas del plan para alcanzar las calorías y macronutrientes propuestos. Si no puedes realizar alguna, puedes juntarla con otra durante el día.
Para reemplazar alimentos, utiliza las equivalencias permitidas y respeta las cantidades indicadas para mantener los aportes nutricionales.
La constancia es clave: cumple el plan diariamente y mantén una buena hidratación.
Ante cualquier duda, consulta directamente con tu coach.',
  'Respeta todas las comidas del plan: es clave completarlas todas para llegar a los macros y las calorías propuestas. Si te saltas alguna, puedes juntarla con otra para no perderlos. Para reemplazar un alimento, revisa primero las equivalencias permitidas. Ante cualquier duda, consulta directamente con tu coach.'
);

update dieta_plantillas
set notas = 'Completa todas las comidas para cumplir con los macros y calorías propuestas. Si te saltas alguna, puedes juntarla con otra durante el día.
Para reemplazar alimentos, utiliza las equivalencias permitidas y respeta las cantidades indicadas para mantener los aportes nutricionales.
Mantén la constancia y adherencia al plan día a día, ya que la regularidad es clave para alcanzar tus objetivos.
Ante cualquier duda, consulta directamente con tu Coach.'
where notas in (
  'Respeta todas las comidas del plan. Si te saltas alguna, puedes juntarla con la siguiente. Para reemplazar un alimento, revisa primero las equivalencias permitidas. Ante cualquier duda, consulta directamente con tu coach.',
  'Respeta todas las comidas del plan. Si te saltas alguna, puedes juntarla con la siguiente; si dos comidas coinciden, haz las dos juntas para llegar a los macros del día. Para reemplazar un alimento, revisa primero las equivalencias permitidas. Ante cualquier duda, consulta directamente con tu coach.',
  'Completa todas las comidas del plan para alcanzar las calorías y macronutrientes propuestos. Si no puedes realizar alguna, puedes juntarla con otra durante el día.
Para reemplazar alimentos, utiliza las equivalencias permitidas y respeta las cantidades indicadas para mantener los aportes nutricionales.
La constancia es clave: cumple el plan diariamente y mantén una buena hidratación.
Ante cualquier duda, consulta directamente con tu coach.',
  'Respeta todas las comidas del plan: es clave completarlas todas para llegar a los macros y las calorías propuestas. Si te saltas alguna, puedes juntarla con otra para no perderlos. Para reemplazar un alimento, revisa primero las equivalencias permitidas. Ante cualquier duda, consulta directamente con tu coach.'
);

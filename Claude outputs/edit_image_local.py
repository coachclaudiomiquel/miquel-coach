import os
import sys
from google import genai
from google.genai import types

# Usa la variable de entorno GEMINI_API_KEY que ya configuraste en Windows.
api_key = os.environ.get("GEMINI_API_KEY")
if not api_key:
    print("No encuentro GEMINI_API_KEY en el entorno. Abri una terminal nueva y probá: echo $env:GEMINI_API_KEY")
    sys.exit(1)

src_path = sys.argv[1] if len(sys.argv) > 1 else "rodilla_original.png"
out_path = sys.argv[2] if len(sys.argv) > 2 else "rodilla_adelante.png"

client = genai.Client(api_key=api_key)

with open(src_path, "rb") as f:
    img_bytes = f.read()

prompt = (
    "Edit this exact reference image. Keep the identical art style (grey anatomical "
    "muscle-study 3D render), identical background (pure black), identical two-figure "
    "side-by-side layout, identical blue foam pads, identical blue dashed vertical "
    "measurement line on the right figure, identical camera angle and lighting. "
    "The ONLY change: adjust the front leg's knee position on BOTH figures so the knee "
    "travels further forward, clearly past the tip of the front foot (knee past the toes), "
    "consistent with a deep knee-over-toe lunge stretch. Keep the rest of the pose, "
    "proportions, and composition the same. Do not add text or labels."
)

response = client.models.generate_content(
    model="gemini-2.5-flash-image",
    contents=[
        types.Part.from_bytes(data=img_bytes, mime_type="image/png"),
        prompt,
    ],
)

saved = False
for part in response.candidates[0].content.parts:
    if getattr(part, "inline_data", None) is not None:
        with open(out_path, "wb") as f:
            f.write(part.inline_data.data)
        saved = True
        break

if not saved:
    print("No se recibió imagen. Respuesta del modelo:")
    for part in response.candidates[0].content.parts:
        if getattr(part, "text", None):
            print(part.text)
    sys.exit(1)

print("Listo:", out_path)

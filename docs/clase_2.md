# Clase 2 — RAG: Darle Conocimiento Propio al Agente

## El Objetivo

Entender qué es RAG, por qué existe y cómo se implementa técnicamente. El objetivo no era solo cargar documentos — era comprender por qué un agente con RAG es fundamentalmente diferente a uno sin él.

---

## ¿Por Qué RAG y No Solo un LLM?

Esta fue la pregunta más importante de la clase. Un modelo de lenguaje como Cohere o GPT-4 conoce mucho sobre el mundo en general, pero no conoce:

- Los manuales técnicos específicos de cultivo de café en México
- Las variedades locales y sus características
- Las prácticas orgánicas permitidas para certificación Fair Trade
- El calendario de siembra por altitud de la Sierra Madre

RAG resuelve esto: en lugar de que el modelo "sepa" todo de memoria, le damos un mecanismo para **buscar** en documentos específicos antes de responder. El resultado es un agente que responde con conocimiento del dominio, no con generalidades.

La diferencia se nota en la práctica: sin RAG, el agente diría "la roya es una enfermedad fúngica del café". Con RAG, diría "según la guía técnica, en zonas de más de 1,200 msnm la presión de roya disminuye, y el tratamiento recomendado es caldo bordelés cada 21 días durante el período de lluvias".

---

## Los 5 Documentos del Conocimiento

Se crearon cinco documentos técnicos que cubren los temas más consultados por un productor de café:

| Documento | Por Qué Es Importante |
|---|---|
| `manual_cafe_arabica.txt` | Las variedades, la nutrición y la poda son la base del manejo agronómico |
| `guia_plagas_organicas.txt` | El diagnóstico de plagas es la consulta más urgente y frecuente |
| `calendario_siembra_altitud.txt` | La altitud determina épocas de cosecha — crítico para México |
| `normas_fair_trade.txt` | Las certificaciones cambian el precio que recibe el productor |
| `guia_postcosecha.txt` | El beneficiado puede representar hasta el 40% de la calidad final |

Estos documentos se subieron a GitHub y se acceden desde n8n via URL directa. Eso permitió entender la diferencia entre una URL de blob (que devuelve HTML) y una URL raw (que devuelve el texto puro) — un error real que ocurrió durante el desarrollo.

---

## Cómo Funciona el Vector Store

El proceso de cargar un documento al Vector Store involucra tres transformaciones:

```
Texto plano (.txt)
       ↓
Dividir en chunks (fragmentos de ~500 caracteres)
       ↓
Convertir cada chunk a vector (Cohere embed-multilingual-v3.0)
       ↓
Almacenar texto + vector en PostgreSQL/pgvector
```

Lo que se aprendió aquí es que **el chunk size importa**. Si los fragmentos son muy pequeños, pierden contexto. Si son muy grandes, diluyen el significado y la búsqueda se vuelve imprecisa. 500 caracteres con 50 de solapamiento resultó ser un buen balance para textos técnicos agrícolas.

---

## Lo que Aprendí Sobre Embeddings

Un embedding es la transformación más importante del sistema: convierte texto en números.

El modelo `embed-multilingual-v3.0` de Cohere fue elegido por una razón específica: está optimizado para múltiples idiomas, incluyendo español. Eso importa porque la terminología agrícola en español tiene sus particularidades — "roya", "broca", "beneficiado", "mucílago" — y un modelo entrenado principalmente en inglés no los representa igual de bien.

El resultado son vectores de 1,024 dimensiones. Cada dimensión captura algún aspecto del significado. Cuando se hace una búsqueda, la pregunta del productor también se convierte en un vector, y se buscan los vectores del Vector Store que estén matemáticamente más cerca.

Esto es lo que hace posible que el agente encuentre información sobre roya cuando el productor pregunta por "hojas con polvo naranja" — son conceptos similares aunque usen palabras diferentes.

---

## El Resultado

Después de procesar los 5 documentos, el Vector Store quedó con **142 chunks** indexados en la tabla `agroasistente_vectors` de PostgreSQL. Cada chunk tiene:
- El texto original
- Los metadatos (fuente, posición)
- El vector de 1,024 dimensiones

Cuando el agente busca, recupera los 5 chunks más relevantes (`topK: 5`) y los usa como contexto para su respuesta.

---

## El Error Más Revelador de Esta Clase

El nodo de embeddings en n8n se llama `embeddingsCohere` (plural) y su parámetro se llama `modelName`, no `model`. Son detalles pequeños que causaron el primer error grave del proyecto.

Lo que ese error enseñó es que en sistemas de IA construidos con múltiples herramientas integradas, la precisión en los nombres importa tanto como la lógica. Un carácter de diferencia entre `embedding` y `embeddings` puede hacer que todo el flujo falle.

---

## El Aprendizaje Central de Esta Clase

RAG no es magia — es un mecanismo elegante de búsqueda + generación. Entender sus partes (chunking, embeddings, búsqueda vectorial, recuperación) permite diseñar sistemas más efectivos: elegir mejores documentos, mejores tamaños de chunk, mejores modelos de embeddings.

El resultado de esta clase fue que el agente dejó de responder con generalidades y empezó a responder con el conocimiento exacto que está en los documentos técnicos. Eso es un salto cualitativo enorme.

---

*Continúa con [Clase 3 — El Agente Principal](clase_3.md)*

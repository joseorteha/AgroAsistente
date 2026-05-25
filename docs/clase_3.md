# Clase 3 — El Agente Principal: Conectar Todo

## El Objetivo

Construir el agente que une todas las piezas: Telegram, el guardrail, el RAG, MySQL y la memoria de conversación. El objetivo era entender cómo un agente de IA toma decisiones sobre qué herramientas usar y en qué orden.

---

## Lo que Aprendí Sobre los Agentes de IA

Un agente es fundamentalmente diferente a un chatbot simple. Un chatbot recibe una pregunta y genera una respuesta. Un agente recibe una pregunta, **razona** sobre qué necesita para responderla, usa herramientas para obtener esa información, y luego genera la respuesta.

En este proyecto, el agente tiene tres herramientas disponibles:
1. **RAG** — para buscar en los documentos técnicos
2. **MySQL** — para obtener datos reales de la finca del productor
3. **Memoria** — para recordar el contexto de la conversación

La decisión de cuándo usar cada herramienta la toma el LLM en tiempo real, basándose en la pregunta del productor y las descripciones de cada herramienta. Eso es lo que hace al sistema inteligente: no sigue un flujo fijo, sino que razona.

---

## El Guardrail: Por Qué Existe

Un guardrail es un filtro previo que clasifica si el mensaje entrante es apropiado para el agente antes de enviárselo. Su propósito es doble:

1. **Eficiencia:** evitar que el agente principal procese preguntas que no le corresponden
2. **Enfoque:** mantener la experiencia del usuario coherente con el dominio del asistente

Lo que aprendí sobre guardrails es que el prompt de clasificación es delicado. La primera versión rechazaba saludos como "Hola, soy Martín" porque el criterio era demasiado estricto. Un guardrail efectivo necesita cubrir todos los casos válidos — incluyendo los que parecen obvios — no solo los casos centrales.

La versión final aprendió a distinguir: un saludo, una presentación, una consulta agrícola o una pregunta sobre la finca son SÍ. Solo son NO los temas completamente ajenos al dominio.

---

## El System Prompt: La Instrucción que Define al Agente

El system prompt es probablemente la parte más importante del agente. Define su personalidad, su flujo de razonamiento y sus reglas. Los aprendizajes más importantes sobre system prompts en este proyecto:

**La especificidad funciona mejor que la generalidad.** Decirle al agente "busca al productor en MySQL" es vago. Decirle exactamente qué query ejecutar y en qué orden funcionó mucho mejor.

**Las reglas de SQL deben estar en el prompt.** El LLM genera SQL dinámicamente, y sin reglas explícitas puede generar queries incorrectas. Una de las reglas más importantes que se aprendió: nunca usar `as` como alias de tabla en MySQL porque es una palabra reservada del lenguaje — algo que un humano probablemente tampoco sabría de memoria.

**La personalización es el valor diferencial.** El agente no debe dar información genérica si tiene datos específicos de la finca. Eso se logra instruyendo al agente explícitamente: "si tienes datos del lote, úsalos en tu respuesta".

---

## Lo que Aprendí Sobre la Memoria de Conversación

La memoria permite al agente recordar el contexto entre mensajes. Si el productor dice "soy Martín Ospina" en el primer mensaje, el agente debe recordarlo en el quinto sin que el productor lo repita.

Técnicamente, la memoria funciona almacenando los últimos N mensajes de la conversación y enviándolos junto con cada nuevo mensaje al LLM. El identificador de la sesión es el `chat.id` de Telegram — único por usuario, permanente.

Lo que aprendí al debuggear el nodo de memoria: la versión del nodo y la configuración de `sessionIdType` son críticas. Una versión desactualizada o una configuración faltante hace que el nodo falle silenciosamente — el agente responde pero sin memoria real.

---

## Los Errores que Más Enseñaron

### El alias `as` en MySQL

El error más interesante del proyecto fue cuando el agente generó una query SQL compleja con JOIN de cinco tablas y usó `as` como alias para la tabla `alertas_sanitarias`. El mensaje de error fue:

```
near 'ON l.id = as.lote_id WHERE p.nombre = 'Martín Ospina Ríos' GROUP B'
```

Dos problemas en una línea: `as` es una palabra reservada de MySQL (no puede usarse como nombre de tabla o alias), y `GROUP B` era una query truncada — el texto era tan largo que el LLM la cortó antes de terminar.

La solución fue entender que los LLMs necesitan restricciones explícitas cuando generan código. No basta con decirle "escribe un SQL correcto" — hay que decirle exactamente qué aliases usar, qué evitar y que prefiera queries simples a JOINs complejos. Eso es ingeniería de prompts aplicada a generación de código.

### Nombres de Columnas Incorrectos

El agente generaba queries con nombres de columnas que no existían: `certificacion` en lugar de `sistema_certificacion`, `etapa_fenologica` en lugar de `etapa`, `tipo_cafe` en lugar de `producto`. El origen del problema era que la descripción de la herramienta MySQL tenía los nombres equivocados.

La lección: el texto que el LLM ve cuando decide qué SQL escribir debe tener el esquema exacto. Un alias incorrecto en la documentación del tool se convierte en un error en producción.

### CommonJS vs ESM

El SDK de n8n requiere sintaxis de módulos ES (import/export), no la sintaxis de CommonJS (require). Al inicio del proyecto se usaba `const { workflow } = require(...)` y todo fallaba. Entender la diferencia entre estos dos sistemas de módulos de JavaScript fue una lección de fundamentos que va más allá de n8n.

### El Botón Publish

En n8n Cloud, editar un workflow no activa los cambios automáticamente. Hay que hacer clic en "Publish" explícitamente para que la versión editada sea la que responde en producción. Este detalle causó confusión múltiples veces: los cambios se aplicaban, el bot seguía fallando, y la causa era simplemente que el workflow editado no había sido publicado.

---

## El Proceso de Debugging Completo

El bot pasó por 8 iteraciones antes de funcionar correctamente:

```
Error CommonJS → Error nombre nodo embeddings → Error prompt chainLlm
→ Error versión memoria → Guardrail muy estricto → Error columnas MySQL
→ Error alias 'as' en SQL → ✅ Funciona
```

Cada error enseñó algo diferente. Ese proceso iterativo es, en sí mismo, la forma en que se aprende a construir sistemas de IA en producción.

---

## El Aprendizaje Central de Esta Clase

La parte más difícil de construir un agente no es la IA — es la ingeniería alrededor de ella. Los prompts que definen el comportamiento, los nombres exactos de las herramientas, las restricciones del SQL generado, la configuración de la memoria: todo eso requiere precisión y pensamiento sistemático.

Lo que distingue a un agente que funciona de uno que falla casi siempre no es el modelo de IA que usa, sino la calidad de las instrucciones que lo guían y la solidez de la infraestructura que lo soporta.

---

## El Resultado Final

Un agente que:
- Identifica a cada productor por nombre usando MySQL
- Carga los datos reales de su finca (lotes, etapas, inventario, alertas)
- Busca conocimiento técnico agrícola en el RAG
- Cruza ambas fuentes para dar respuestas personalizadas
- Recuerda el contexto de la conversación
- Rechaza preguntas fuera del dominio agrícola
- Responde 24/7 por Telegram

Y detrás de ese resultado: un aprendizaje profundo de cómo funcionan los agentes de IA, las bases de datos vectoriales, los embeddings, la ingeniería de prompts y la depuración de sistemas complejos.

---

*[← Volver al README](../README.md)*

# Introducción — AgroAsistente y la Inmersión ONE de Agentes de IA

## El Certificado

El 20 de mayo de 2026, completé la **ONE | Inmersión Agentes de IA** de Alura LATAM en alianza con Oracle Next Education. Este proyecto — AgroAsistente — es la aplicación práctica de todo lo aprendido, pero con una idea propia y con un propósito real.

---

## El Contexto del Curso

La inmersión enseñó a construir agentes de inteligencia artificial usando una arquitectura específica:

- **n8n** como orquestador visual
- **RAG** para dar al agente acceso a conocimiento propio
- **Vector Store** para almacenar y buscar ese conocimiento
- **MySQL** para datos estructurados
- **Telegram** como canal de comunicación
- **LLMs** para generar respuestas

El proyecto del curso fue **HR Buddy**, un asistente de recursos humanos para una empresa ficticia. La decisión aquí fue aplicar exactamente la misma arquitectura, pero a un problema real con impacto social genuino.

---

## La Idea: ¿Por Qué AgroAsistente?

En Veracruz, miles de pequeños productores cafetaleros enfrentan a diario situaciones como:

- Una plaga que no saben identificar
- Dudas sobre fertilización según la etapa del cultivo
- Incertidumbre sobre los precios del mercado
- No tener acceso a un ingeniero agrónomo
- Conectividad limitada — pero sí tienen Telegram o WhatsApp

La pregunta que dio origen al proyecto fue simple: *¿qué herramienta podría ayudar a un caficultor en una zona remota a tomar mejores decisiones sobre su cultivo?*

La respuesta fue un agente de IA que combina conocimiento técnico agrícola con los datos reales de la finca de cada productor, accesible por Telegram.

---

## Qué se Quería Lograr

El objetivo no era solo replicar el proyecto del curso — era entender **por qué funciona** cada parte de la arquitectura y aplicarla a un contexto diferente.

Al terminar:
- Entender qué es RAG y por qué es superior a solo usar un LLM
- Saber cómo estructurar una base de datos para que un agente la use bien
- Comprender cómo funciona un Vector Store y los embeddings
- Poder construir un agente con múltiples herramientas en n8n
- Entender el rol del guardrail y por qué es necesario

---

## Lo Más Valioso del Aprendizaje

La diferencia entre el proyecto del curso y este fue que **todo salió mal antes de salir bien**. Cada error obligó a entender más profundo:

- Un nombre de columna incorrecto en MySQL enseñó la importancia de documentar el esquema exacto
- Un error de alias en SQL enseñó que los LLMs generan código que puede romper con palabras reservadas
- Un guardrail demasiado estricto enseñó que los prompts de clasificación necesitan cubrir casos límite
- Los errores de conexión entre servicios cloud enseñaron cómo funciona la red pública vs interna en Railway

Ese proceso de debugging fue en sí mismo la clase más valiosa.

---

## La Arquitectura en Una Imagen

```
Conocimiento Técnico          Datos de la Finca
(5 documentos .txt)           (MySQL Railway)
       ↓                             ↓
  [Cohere Embeddings]         [productores, lotes,
  [pgvector Railway]           fenología, inventario,
  142 chunks indexados]        precios, alertas]
       ↓                             ↓
       └──────── [n8n AI Agent] ─────┘
                      ↓
               [Telegram Bot]
                      ↓
           [Caficultor en México]
```

---

*Continúa con [Clase 1 — Bases de Datos en la Nube](clase_1.md)*

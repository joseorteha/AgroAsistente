# 🌿 AgroAsistente — Consultor Agrónomo Virtual con IA

> Proyecto desarrollado durante la **ONE | Inmersión Agentes de IA** de Alura LATAM + Oracle Next Education  
> Certificado obtenido el 20 de mayo de 2026 — Jose Bernardino Tlehuactle Ortega

---

## ¿Qué es AgroAsistente?

**AgroAsistente** es un agente de inteligencia artificial que actúa como consultor agrónomo virtual para pequeños productores de café en zonas rurales de México. Responde preguntas por **Telegram**, personaliza cada respuesta con los datos reales de la finca del productor y combina dos fuentes de conocimiento:

- **RAG (Retrieval-Augmented Generation):** documentos técnicos almacenados en una base de datos vectorial
- **MySQL:** datos reales de la finca (lotes, etapas fenológicas, inventario de insumos, precios del mercado, alertas sanitarias)

La idea nació de una pregunta real: *¿qué pasa cuando un caficultor en zona rural tiene una plaga y no hay un agrónomo disponible?*

---

## Arquitectura General

```
[Productor en zona rural]
        |
   [Telegram]
        |
   [n8n Cloud]
   ┌────────────────────────────────────────┐
   │  Webhook Telegram → Guardrail LLM      │
   │       ↓                                │
   │  ¿Es consulta agrícola? (IF)           │
   │       ↓ SÍ           ↓ NO             │
   │  [AI Agent]     [Mensaje rechazo]      │
   │   ├── RAG Tool (pgvector Railway)      │
   │   ├── MySQL Tool (MySQL Railway)       │
   │   └── Memoria de conversación          │
   │       ↓                                │
   │  [Respuesta Telegram]                  │
   └────────────────────────────────────────┘
```

---

## Stack Tecnológico

| Componente | Tecnología | Rol |
|---|---|---|
| Orquestador | **n8n Cloud** | Conecta todos los servicios |
| LLM principal | **Cohere command-a-03-2025** | Genera las respuestas |
| Embeddings | **Cohere embed-multilingual-v3.0** | Vectoriza documentos y preguntas |
| Vector Store | **PostgreSQL + pgvector** (Railway) | Almacena conocimiento técnico |
| Base de datos | **MySQL** (Railway) | Datos reales de cada finca |
| Mensajería | **Telegram Bot API** | Interfaz con el productor |
| Control de versiones | **GitHub** | Almacena documentos RAG |

---

## Estructura del Proyecto

```
AgroAsistente/
├── README.md
├── system_prompt_agroasistente.txt
├── MySQL/
│   └── agroasistente_setup.sql
├── RAG/
│   ├── manual_cafe_arabica.txt
│   ├── guia_plagas_organicas.txt
│   ├── calendario_siembra_altitud.txt
│   ├── normas_fair_trade.txt
│   └── guia_postcosecha.txt
└── docs/
    ├── introduccion.md
    ├── clase_1.md
    ├── clase_2.md
    └── clase_3.md
```

---

## Documentación por Clases

| Archivo | Contenido |
|---|---|
| [Introducción](docs/introduccion.md) | El porqué del proyecto y la arquitectura |
| [Clase 1](docs/clase_1.md) | Lo aprendido sobre bases de datos en la nube |
| [Clase 2](docs/clase_2.md) | Lo aprendido sobre RAG y Vector Stores |
| [Clase 3](docs/clase_3.md) | Lo aprendido construyendo el agente principal |

---

## Mensajes de Prueba (Telegram)

```
Hola, soy Martín Ospina Ríos
Las hojas de mi café tienen polvo naranja por debajo
¿Cuánto está pagando el café hoy?
¿En qué etapa están mis lotes?
¿Qué abono le echo a mi lote?
```

---

*Desarrollado con ❤️ durante la Inmersión ONE | Agentes de IA — Alura LATAM + Oracle Next Education*

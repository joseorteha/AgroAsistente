# Clase 1 — Bases de Datos en la Nube: MySQL y pgvector

## El Objetivo

Entender cómo desplegar y conectar dos bases de datos en la nube que sirven propósitos distintos dentro de un sistema de IA:
- **MySQL** para los datos estructurados de cada finca
- **PostgreSQL con pgvector** para el conocimiento técnico en formato vectorial

---

## Lo que Aprendí Sobre Railway

Railway es una plataforma de hosting en la nube orientada a desarrolladores. Permite desplegar bases de datos con un clic y expone dos tipos de conexión:

- **Red interna** (`.railway.internal`): solo accesible desde servicios dentro del mismo proyecto Railway. Rápida y sin costo de latencia.
- **Red pública** (TCP Proxy): accesible desde internet. Es la que se necesita para conectar herramientas externas como n8n Cloud o DBeaver.

Este concepto de red interna vs red pública es fundamental en arquitecturas cloud. El error más común al empezar es intentar conectarse con el host interno desde una herramienta que está fuera de Railway — y aprender eso a través del error fue mucho más efectivo que leerlo en una documentación.

---

## El Esquema MySQL: Por Qué Siete Tablas

El diseño de la base de datos para AgroAsistente refleja la realidad del trabajo de un caficultor:

```
productores       → quién es el productor
lotes             → qué parcelas tiene
registro_fenologico → en qué etapa está cada lote (floración, cuaje, cosecha...)
inventario_insumos  → qué productos ha aplicado y cuándo
precios_mercado   → cuánto vale el café en el mercado
ventas            → qué ha vendido y a quién
alertas_sanitarias → qué problemas han ocurrido en los lotes
```

La parte más importante de esta clase no fue crear las tablas, sino entender que **los nombres exactos de las columnas son críticos** cuando un LLM va a generar SQL dinámicamente. Si el agente cree que la columna se llama `certificacion` pero en realidad se llama `sistema_certificacion`, el query falla. Eso ocurrió en producción y obligó a revisar el esquema completo con cuidado.

---

## Lo que Aprendí Sobre DBeaver

DBeaver es un cliente SQL visual que permite conectarse a cualquier base de datos. La razón por la que se usó fue práctica: la consola web de Railway tiene limitaciones al ejecutar scripts SQL largos con múltiples instrucciones.

Lo que más me enseñó DBeaver no fue la interfaz — fue entender por qué fallaba la conexión. El error de `allowPublicKeyRetrieval` con MySQL 8 enseñó que este motor de base de datos tiene mecanismos de seguridad más estrictos que versiones anteriores, y que los clientes necesitan configurarse explícitamente para trabajar con él.

El error de `self-signed certificate` con PostgreSQL enseñó que Railway usa certificados propios que no están en las autoridades certificadoras reconocidas por defecto. La solución no es eliminar la seguridad, sino indicarle al cliente que confíe en ese certificado.

---

## pgvector: La Extensión que Convierte PostgreSQL en una BD Vectorial

La instalación de pgvector fue un momento clave de comprensión. Una línea de SQL:

```sql
CREATE EXTENSION IF NOT EXISTS vector;
```

...convierte una base de datos relacional tradicional en un sistema capaz de almacenar y buscar vectores de alta dimensión. Eso es todo lo que se necesita.

Lo interesante es entender **qué es un vector** en este contexto: es una representación matemática del *significado* de un texto. Dos textos sobre roya del café estarán "cerca" en el espacio vectorial aunque usen palabras diferentes. Eso es lo que hace posible la búsqueda semántica.

---

## Lo que Aprendí Sobre Conectar n8n con Railway

n8n Cloud está en internet. Railway está en internet. Pero la conexión no es trivial porque:

1. SSL y certificados autofirmados pueden bloquear la conexión
2. El puerto interno (3306, 5432) no es accesible desde fuera
3. Las credenciales de MySQL necesitan configuración diferente a PostgreSQL

La diferencia entre las dos bases de datos en cuanto a SSL fue reveladora: MySQL manejó mejor la conexión sin SSL, PostgreSQL la requería pero con la opción de ignorar errores de certificado. Dos tecnologías similares con comportamientos distintos — algo que en producción real importa mucho.

---

## El Aprendizaje Central de Esta Clase

La infraestructura no es "lo aburrido" antes de la IA. Es la base que determina si el agente funciona o falla. Un nombre de columna mal documentado, un puerto incorrecto o un certificado mal configurado puede hacer que todo un sistema falle en producción, aunque la lógica del agente sea perfecta.

Aprender a leer errores de conexión, entender qué significa cada variable de Railway y saber cuándo usar red interna vs red pública son habilidades reales de desarrollo que este proyecto puso en práctica.

---

*Continúa con [Clase 2 — RAG y Vector Stores](clase_2.md)*

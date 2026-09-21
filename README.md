# Proyecto

Toolkit local para estandarizar, validar y adecuar proyectos técnicos reduciendo trabajo repetitivo y consumo innecesario de IA.

## Versión actual

**Proyecto CLI v0.2.2**

Estado: versión promovida a `proyecto.ps1` y validada mediante el comando oficial `proyecto`.

## Objetivo

Proyecto convierte criterios técnicos repetitivos en contratos, plantillas, scripts, componentes y Agent Skills reutilizables. La IA se reserva para tareas que realmente requieren interpretación.

Principio operativo:

- Proyecto / Agent = **QUÉ**: contexto, objetivos, arquitectura, reglas, ambientes, estado y Definition of Done.
- Skill = **CÓMO**: capacidad técnica reutilizable.
- Scripts y configuración = trabajo determinístico que no requiere razonamiento de IA.
- Prompts = procedimientos estandarizados para casos que sí requieren interpretación.
- Git = memoria técnica durable del proyecto.

## Regla de adecuación

Adecuar un proyecto no significa reestructurarlo. Proyecto aprende y valida una estructura existente cuando está técnicamente justificada. Los cambios físicos sólo se realizan cuando existe una razón concreta, evidencia de impacto y autorización explícita.

## Núcleo de un proyecto

- `README.md`: documentación general.
- `.gitignore`: exclusiones locales y sensibles.
- `AGENTS.md`: contrato operativo permanente para agentes.
- `CONTEXT.md`: contexto operativo persistente y punto de continuación.
- `.agents/skills/<skill>/SKILL.md`: capacidades reutilizables instaladas cuando son necesarias.

`.agents/skills` no se crea vacío. Aparece únicamente al instalar la primera Skill.

## Relación AGENTS.md / CONTEXT.md

`AGENTS.md` debe conocer explícitamente `CONTEXT.md`. Los agentes deben leer el contexto antes de trabajo relevante y mantenerlo cuando cambien decisiones, arquitectura, estado, bloqueos, riesgos o el punto de continuación. Nunca deben almacenarse secretos, contraseñas, tokens o claves API en `CONTEXT.md`.

Proyecto conserva archivos existentes y sólo integra el contrato necesario. No reemplaza indiscriminadamente `AGENTS.md` ni `CONTEXT.md`.

## Directorio de trabajo

Actualmente, Proyecto utiliza `C:\\dev` como directorio raíz para los proyectos administrados por el CLI.

Este directorio debe existir previamente en el sistema y, por el momento, debe crearse manualmente si aún no está disponible:

```powershell
New-Item -ItemType Directory -Path C:\dev
```

Los proyectos creados o administrados por Proyecto se ubican bajo esta raíz. Por ejemplo:

```text
C:\dev\mi-proyecto
C:\dev\otro-proyecto
```

En la versión actual (`v0.2.2`), la detección, creación y configuración automática de un directorio raíz alternativo todavía no forman parte del CLI.

## CLI

```text
proyecto -h
proyecto install
proyecto uninstall
proyecto init <proyecto>
proyecto valida <proyecto>
proyecto list
proyecto add <proyecto> <componente|skill>
proyecto prompt <proyecto>
proyecto actualiza <proyecto>
```

### Componentes determinísticos

`proyecto list` publica actualmente:

```text
agents
context
gitignore
```

`add agents` y `add context` garantizan conjuntamente la existencia e integración de `AGENTS.md` y `CONTEXT.md` sin sobrescribir contenido válido existente. `add gitignore` instala la plantilla Proyecto si el archivo no existe. Estas operaciones fueron probadas como idempotentes.

### Skills

Skill piloto disponible:

```text
diagnostico-entorno
```

Las Skills se instalan bajo `.agents/skills` únicamente cuando el proyecto las necesita.

## Wiki técnica y línea de investigación

El `README.md` funciona como índice operativo del proyecto. Las decisiones, investigaciones y diseños extensos se mantienen en `docs/` para conservar trazabilidad sin convertir el README en documentación monolítica.

### Bootstrap inicial de contexto

Proyecto incorpora un bootstrap para la primera interacción relevante con IA: el agente inspecciona primero el repositorio y, sólo para cubrir vacíos, realiza una entrevista adaptativa de **hasta 10 preguntas, siempre una por vez**. Puede terminar antes cuando ya exista contexto suficiente.

Tras una síntesis y confirmación humana, el conocimiento se consolida principalmente en `CONTEXT.md`; sólo las reglas operativas estables se proponen para `AGENTS.md`. El estado `PENDIENTE | COMPLETADO` evita repetir la entrevista en sesiones posteriores.

El bootstrap no expone un comando adicional. En la primera ejecución de `proyecto valida <proyecto>`, si `CONTEXT.md` continúa en estado `PENDIENTE`, Proyecto activa internamente la entrevista. Una vez confirmado y marcado `COMPLETADO`, las siguientes ejecuciones de `valida` continúan directamente con la validación normal. Su validación end-to-end local queda pendiente.

**Documento de referencia:** [Bootstrap inicial de contexto](docs/bootstrap-contexto.md)

### Skill Supply Chain

Proyecto está evaluando una evolución desde un catálogo de Skills exclusivamente propias hacia un modelo de **descubrimiento, evaluación, adopción y adaptación controlada de Agent Skills existentes**.

Principio propuesto:

```text
necesidad
  ↓
buscar Skill existente
  ↓
evaluar compatibilidad + licencia + seguridad + calidad
  ↓
stage + tests
  ↓
adoptar / adaptar / crear sólo si no existe alternativa adecuada
  ↓
registrar procedencia + versión + integridad
  ↓
Git
```

El objetivo es reutilizar capacidades del ecosistema sin perder control técnico ni trazabilidad. Una Skill podrá clasificarse como **PROPIA**, **ADOPTADA**, **ADAPTADA** o **DERIVADA**.

La investigación actual toma **Agent Skills / `SKILL.md`** como candidato a formato canónico interno, buscando portabilidad entre GitHub Copilot, OpenAI Codex y agentes/harnesses locales. Ollama se considera principalmente un runtime/proveedor de modelos y no un catálogo de Skills.

La incorporación de Skills externas deberá conservar, según corresponda, URL y repositorio de origen, path original, commit/tag inmutable, licencia, atribuciones, fecha de importación, modificaciones locales y evidencia de revisión. Se estudian como extensiones propias `SOURCE.md`, `skills.lock.yaml`, pruebas y niveles de riesgo para recursos ejecutables.

**Documento de referencia:** [Investigación: Skill Supply Chain](docs/investigacion-skill-supply-chain.md)

Fuentes de referencia principales:

- [Agent Skills Specification](https://agentskills.io/specification)
- [GitHub Awesome Copilot](https://github.com/github/awesome-copilot)
- [Anthropic Skills](https://github.com/anthropics/skills)
- [Hugging Face Skills](https://github.com/huggingface/skills)
- [OpenAI Codex Skills](https://developers.openai.com/codex/skills)
- [Ollama](https://ollama.com/)

> **Estado:** línea de investigación y arquitectura candidata. No implica que Proyecto v0.2.2 ya implemente importación, auditoría o actualización de Skills externas.

## Estados de validación

- **VALIDO**: no existen faltantes ni elementos pendientes de adecuación.
- **PENDIENTE**: el núcleo está completo, pero existen elementos EXTRA que Proyecto todavía debe aprender o clasificar.
- **INVALIDO**: existen requisitos determinísticos faltantes; puede coexistir con elementos EXTRA.

Los elementos `EXTRA` no se consideran incorrectos automáticamente. Son elementos todavía no incluidos en el estándar o contrato aprendido del proyecto.

## Flujo recomendado

```text
valida
  ↓
si bootstrap PENDIENTE → inspección + entrevista inicial + confirmación
  ↓
validación normal
  ↓
resolver faltantes determinísticos con add
  ↓
valida
  ↓
si quedan EXTRA → prompt
  ↓
análisis IA
  ↓
adecuacion.md
  ↓
revisión humana
  ↓
actualiza
  ↓
contract.json
  ↓
valida
```

La IA entra únicamente cuando quedan elementos que requieren interpretación. Los faltantes conocidos se resuelven de forma determinística.

## Contrato aprendido

Las decisiones permanentes aceptadas por `actualiza` se almacenan en:

```text
projects/<proyecto>/contract.json
```

Estados persistibles previstos: `LEGITIMO`, `LOCAL` y `SENSIBLE`.

El contrato aprendido se suma al estándar base y, posteriormente, a los contratos aportados por las Skills instaladas.

## Plantillas

```text
templates/project/AGENTS.md
templates/project/CONTEXT.md
templates/project/AGENTS-CONTEXT.md
templates/project/.gitignore
```

Las plantillas operativas están redactadas en español. Los nombres técnicos estándar se conservan cuando corresponde.

## Pruebas realizadas en v0.2.2

### Proyecto nuevo

`proyecto init prueba-v022` creó correctamente el núcleo. Se verificó:

- `.gitignore` creado desde plantilla con contenido.
- `.agents/skills` no creado artificialmente.
- `AGENTS.md` y `CONTEXT.md` presentes.
- `proyecto valida prueba-v022` → `VALIDO - Cumple Proyecto 0.2.2`.

## Decisiones vigentes

- No existe comando `adopt`: adecuar estructuras arbitrarias requiere interpretación.
- Proyecto no reorganiza automáticamente proyectos existentes.
- No se crean carpetas vacías sin necesidad funcional.
- `AGENTS.md` es el punto de entrada común para agentes.
- `CONTEXT.md` es una convención operativa de Proyecto.
- Las Skills reutilizables utilizan `.agents/skills`.
- Las correcciones determinísticas deben realizarse antes de consumir IA.
- El bootstrap inicial es una fase interna de `valida`: inspecciona antes de preguntar, limita la entrevista a un máximo de 10 preguntas, una por vez, y deja de ejecutarse al quedar `COMPLETADO`.

## Pendientes conocidos

- Permitir configurar el directorio raíz de proyectos y gestionar su creación durante la instalación.
- Implementar tolerancia controlada a errores humanos de escritura en nombres de componentes y Skills cuando la coincidencia sea inequívoca.
- Revisar la separación definitiva de responsabilidades entre `add` y `actualiza` para evitar lógica duplicada.
- Revisar `actualiza` heredado antes de ampliar su uso en nuevos proyectos.
- Evolucionar el catálogo de Skills hacia un modelo de Skill Supply Chain: buscar, evaluar, adoptar/adaptar y crear sólo cuando sea necesario.
- Añadir scripts determinísticos a `diagnostico-entorno`.
- Ampliar pruebas automatizadas del CLI.
- Evaluar contratos aportados por Skills como parte del contrato efectivo del proyecto.

## Catálogo de Skills previsto

1. diagnostico-entorno
2. desarrollo-etl
3. gestion-data-warehouse
4. calidad-datos
5. orquestacion-procesos
6. publicacion-bi
7. empaquetado-entornos
8. entrega-operaciones
9. validacion-release
10. evidencia-documentacion-tecnica

## Última actualización

2026-09-21 - Incorporado bootstrap conversacional inicial; validación local pendiente.

2026-09-19 - Cierre y promoción de Proyecto v0.2.2.



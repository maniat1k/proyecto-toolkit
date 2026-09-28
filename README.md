# Proyecto

Toolkit local para estandarizar, validar y adecuar proyectos técnicos reduciendo trabajo repetitivo y consumo innecesario de IA.

## Versión actual

**Proyecto CLI v0.2.2**

Estado: versión promovida a `proyecto.ps1` y validada mediante el comando oficial `proyecto`.

## Qué es Proyecto

Proyecto convierte criterios técnicos repetitivos en contratos, plantillas, scripts, componentes y Agent Skills reutilizables. La IA se reserva para tareas que realmente requieren interpretación.

Principio operativo:

- Proyecto / Agent = **QUÉ**: contexto, objetivos, arquitectura, reglas, ambientes, estado y Definition of Done.
- Skill = **CÓMO**: capacidad técnica reutilizable.
- Scripts y configuración = trabajo determinístico que no requiere razonamiento de IA.
- Prompts = procedimientos estandarizados para casos que sí requieren interpretación.
- Git = memoria técnica durable del proyecto.

## Uso rápido

### 1. Instalar el CLI

Desde el repositorio de Proyecto:

```powershell
.\proyecto.ps1 install
```

Luego puede utilizarse:

```powershell
proyecto -h
```

### 2. Crear o validar un proyecto

Para crear un proyecto nuevo:

```powershell
proyecto init <proyecto>
```

Para comprobar un proyecto existente:

```powershell
proyecto valida <proyecto>
```

En la primera validación, si falta contexto operativo, `valida` puede activar internamente el bootstrap conversacional.

### 3. Resolver faltantes conocidos

Consultar el catálogo local:

```powershell
proyecto list
```

Agregar un componente o una Skill ya disponible localmente:

```powershell
proyecto add <proyecto> <componente|skill>
```

`add` realiza únicamente operaciones determinísticas conocidas por Proyecto.

### 4. Buscar una capacidad reutilizable antes de crearla

```powershell
proyecto skill search "etl"
```

`skill search` consulta catálogos externos y muestra candidatos mediante `NAME` y `DESCRIPTION`.

La búsqueda es exclusivamente de descubrimiento:

- no instala Skills;
- no ejecuta código de las Skills encontradas;
- no incorpora archivos externos al proyecto;
- no modifica el proyecto consultado.

La regla es **buscar y evaluar antes de crear una Skill nueva**.

Actualmente el primer proveedor operativo es **GitHub Awesome Copilot**. La incorporación de otros proveedores se realizará de forma incremental sin cambiar la interfaz de búsqueda.

### 5. Adecuar elementos que requieren interpretación

Cuando `valida` encuentra elementos que Proyecto todavía no puede clasificar determinísticamente:

```powershell
proyecto prompt <proyecto>
```

La IA puede inspeccionar y proponer una adecuación, pero no decide por sí sola qué se incorpora al contrato.

Después de la revisión humana de `adecuacion.md`:

```powershell
proyecto actualiza <proyecto>
proyecto valida <proyecto>
```

`actualiza` persiste únicamente decisiones humanas aprobadas.

## Dos circuitos distintos

Proyecto separa explícitamente la **adecuación de proyectos** de la **gestión de Skills**.

### Adecuación de un proyecto

```text
proyecto valida
      ↓
¿falta algo determinístico?
      ├── sí → proyecto add → valida
      │
      └── no
           ↓
¿hay elementos que requieren interpretación?
      ├── sí → prompt → análisis IA → revisión humana
      │                         ↓
      │                     actualiza
      │                         ↓
      └────────────────────── valida
```

### Adquisición de una Skill

```text
necesidad
   ↓
skill search                  IMPLEMENTADO
   ↓
inspect                       ROADMAP
   ↓
stage                         ROADMAP
   ↓
audit / test                  ROADMAP
   ↓
adoptar / adaptar / derivar
   ↓
import                        ROADMAP
```

Internet nunca alimenta directamente `proyecto add`. `add` trabaja con componentes y Skills ya disponibles y aprobados localmente.

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

Actualmente, Proyecto utiliza `C:\dev` como directorio raíz para los proyectos administrados por el CLI.

Este directorio debe existir previamente y, por el momento, debe crearse manualmente si aún no está disponible:

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
proyecto skill search <consulta>
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

### Skills locales

Skill piloto disponible:

```text
diagnostico-entorno
```

Las Skills se instalan bajo `.agents/skills` únicamente cuando el proyecto las necesita.

`proyecto list` representa el catálogo local aprobado. `proyecto add` instala desde ese catálogo local.

### Descubrimiento externo de Skills

`proyecto skill search <consulta>` busca candidatos externos sin incorporarlos al catálogo local.

Ejemplo:

```powershell
proyecto skill search "etl"
```

La implementación inicial:

- consulta GitHub Awesome Copilot;
- normaliza nombre y descripción;
- puntúa coincidencias por nombre y descripción;
- ordena los resultados por relevancia;
- limita la salida a los primeros candidatos;
- muestra únicamente `NAME` y `DESCRIPTION`;
- falla explícitamente si no puede realizar la consulta;
- no tiene efectos laterales sobre los proyectos.

La procedencia, licencia, versión, integridad y seguridad no se ocultan conceptualmente: se tratarán en las siguientes fases de la Skill Supply Chain (`inspect`, `stage`, `audit/test`), antes de permitir una incorporación.

## Wiki técnica

El `README.md` funciona como entrada operativa e índice del proyecto. Las decisiones, investigaciones y diseños extensos se mantienen en `docs/` para conservar trazabilidad sin convertir este archivo en documentación monolítica.

### Bootstrap inicial de contexto

Proyecto incorpora un bootstrap para la primera interacción relevante con IA: el agente inspecciona primero el repositorio y, sólo para cubrir vacíos, realiza una entrevista adaptativa de **hasta 10 preguntas, siempre una por vez**. Puede terminar antes cuando ya exista contexto suficiente.

Tras una síntesis y confirmación humana, el conocimiento se consolida principalmente en `CONTEXT.md`; sólo las reglas operativas estables se proponen para `AGENTS.md`. El estado `PENDIENTE | COMPLETADO` evita repetir la entrevista en sesiones posteriores.

El bootstrap no expone un comando adicional. En la primera ejecución de `proyecto valida <proyecto>`, si `CONTEXT.md` continúa en estado `PENDIENTE`, Proyecto activa internamente la entrevista. Una vez confirmado y marcado `COMPLETADO`, las siguientes ejecuciones de `valida` continúan directamente con la validación normal.

**Documento de referencia:** [Bootstrap inicial de contexto](docs/bootstrap-contexto.md)

## Skill Supply Chain

Proyecto ya inició la evolución desde un catálogo exclusivamente propio hacia un modelo de **descubrimiento, evaluación, adopción y adaptación controlada de Agent Skills existentes**.

Principio operativo:

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

La primera fase, `skill search`, está implementada y validada. Las fases posteriores permanecen en roadmap.

| Fase | Estado |
|---|---|
| `search` | Implementado y validado |
| `inspect` | Roadmap |
| `stage` | Roadmap |
| `audit` / `test` | Roadmap |
| `import` | Roadmap |
| procedencia / lock / update | Roadmap |

El objetivo es reutilizar capacidades del ecosistema sin perder control técnico ni trazabilidad. Una Skill podrá clasificarse como:

- **PROPIA**: creada específicamente para Proyecto.
- **ADOPTADA**: importada sin cambios funcionales.
- **ADAPTADA**: importada y modificada.
- **DERIVADA**: reconstruida usando una o más fuentes como referencia.

La investigación toma **Agent Skills / `SKILL.md`** como formato canónico interno candidato, buscando portabilidad entre GitHub Copilot, OpenAI Codex y agentes/harnesses locales. Ollama se considera principalmente un runtime/proveedor de modelos y no un catálogo de Skills.

La incorporación de Skills externas deberá conservar, según corresponda, URL y repositorio de origen, path original, commit/tag inmutable, licencia, atribuciones, fecha de importación, modificaciones locales y evidencia de revisión. Se estudian como extensiones propias `SOURCE.md`, `skills.lock.yaml`, pruebas y niveles de riesgo para recursos ejecutables.

**Documento de referencia:** [Investigación: Skill Supply Chain](docs/investigacion-skill-supply-chain.md)

Fuentes de referencia identificadas:

- [Agent Skills Specification](https://agentskills.io/specification)
- [GitHub Awesome Copilot](https://github.com/github/awesome-copilot) — primer proveedor operativo de `search`.
- [Anthropic Skills](https://github.com/anthropics/skills) — siguiente proveedor a validar.
- [Hugging Face Skills](https://github.com/huggingface/skills)
- [OpenAI Codex Skills](https://developers.openai.com/codex/skills)
- [Ollama](https://ollama.com/)

> **Estado:** `search` está implementado. Proyecto v0.2.2 todavía no implementa inspección, staging, auditoría, importación ni actualización automática de Skills externas.

## Estados de validación

- **VALIDO**: no existen faltantes ni elementos pendientes de adecuación.
- **PENDIENTE**: el núcleo está completo, pero existen elementos EXTRA que Proyecto todavía debe aprender o clasificar.
- **INVALIDO**: existen requisitos determinísticos faltantes; puede coexistir con elementos EXTRA.

Los elementos `EXTRA` no se consideran incorrectos automáticamente. Son elementos todavía no incluidos en el estándar o contrato aprendido del proyecto.

## Flujo de adecuación recomendado

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

Las decisiones permanentes aceptadas por `actualiza` se almacenan localmente en:

```text
projects/<proyecto>/contract.json
```

`projects/` representa estado aprendido local y está excluido del repositorio público del toolkit.

Estados persistibles: `LEGITIMO`, `LOCAL` y `SENSIBLE`.

`actualiza` sólo procesa decisiones aprobadas dentro de la sección `## adecuacion.txt`; no modifica físicamente el proyecto que está aprendiendo.

El contrato aprendido se suma al estándar base y, posteriormente, podrá complementarse con contratos aportados por las Skills instaladas.

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

### Contrato aprendido

Se validó el circuito de `actualiza` con un proyecto real:

- lectura limitada a la sección `## adecuacion.txt`;
- aceptación únicamente de estados `LEGITIMO`, `LOCAL` y `SENSIBLE`;
- rechazo de entradas inválidas o ausencia de decisiones aprobadas;
- persistencia local en `projects/<proyecto>/contract.json`;
- sin modificación física del proyecto analizado.

El estado local `projects/` quedó explícitamente fuera del Git público.

### Búsqueda de Agent Skills

Se validó end-to-end:

```powershell
proyecto skill search "etl"
```

La búsqueda:

- se ejecuta desde el launcher instalado `proyecto`;
- consulta el primer proveedor externo;
- devuelve candidatos ordenados mediante `NAME` y `DESCRIPTION`;
- no instala ni ejecuta Skills;
- no modifica proyectos.

La consulta `etl` encontró un candidato relacionado con reconciliación/validación de tablas SQL Server. El resultado demostró el funcionamiento del mecanismo, pero también la necesidad de incorporar proveedores adicionales para mejorar cobertura antes de decidir si una capacidad como `desarrollo-etl` debe adoptarse, adaptarse, derivarse o crearse.

## Decisiones vigentes

- No existe comando `adopt`: adecuar estructuras arbitrarias requiere interpretación.
- Proyecto no reorganiza automáticamente proyectos existentes.
- No se crean carpetas vacías sin necesidad funcional.
- `AGENTS.md` es el punto de entrada común para agentes.
- `CONTEXT.md` es una convención operativa de Proyecto.
- Las Skills reutilizables utilizan `.agents/skills`.
- Las correcciones determinísticas deben realizarse antes de consumir IA.
- El bootstrap inicial es una fase interna de `valida`.
- `add` trabaja con componentes y Skills conocidos localmente.
- `skill search` descubre candidatos externos y no instala.
- Internet nunca alimenta directamente `add`.
- Antes de crear una Skill propia se buscan y evalúan alternativas existentes.
- La incorporación de una Skill externa deberá preservar procedencia, licencia, versión e integridad.
- `actualiza` persiste conocimiento aprobado; no sustituye a `add`.

## Pendientes conocidos

### Núcleo

- Permitir configurar el directorio raíz de proyectos y gestionar su creación durante la instalación.
- Implementar tolerancia controlada a errores humanos de escritura en nombres de componentes y Skills cuando la coincidencia sea inequívoca.
- Añadir scripts determinísticos a `diagnostico-entorno`.
- Ampliar pruebas automatizadas del CLI.
- Evaluar contratos aportados por Skills como parte del contrato efectivo del proyecto.

### Skill Supply Chain

- Incorporar progresivamente proveedores adicionales de búsqueda, comenzando por Anthropic Skills.
- Implementar `skill inspect`.
- Implementar staging controlado de candidatos.
- Definir formalmente `SOURCE.md`.
- Definir `skills.lock.yaml`.
- Incorporar política de licencias y niveles de seguridad.
- Implementar `audit` y `test`.
- Implementar importación/adopción controlada.
- Diseñar comprobación y actualización de upstream sin cambios inesperados.

## Catálogo de capacidades previsto

El catálogo expresa necesidades/capacidades previstas, no implica que deban implementarse como Skills propias. Cada una deberá pasar primero por descubrimiento y evaluación.

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

## Últimas actualizaciones

**2026-09-28**

- Implementado y validado `proyecto skill search <consulta>`.
- GitHub Awesome Copilot incorporado como primer proveedor de descubrimiento.
- Validada búsqueda end-to-end desde el launcher instalado.
- Consolidada la separación `list/add` (catálogo local) frente a `skill search` (descubrimiento externo).
- Consolidado `actualiza` como persistencia de decisiones humanas aprobadas.
- Estado aprendido `projects/` excluido del Git público.
- Skill Supply Chain pasa de investigación pura a implementación incremental.

**2026-09-21**

- Incorporado bootstrap conversacional inicial.

**2026-09-19**

- Cierre y promoción de Proyecto v0.2.2.

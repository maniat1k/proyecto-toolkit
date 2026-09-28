# Investigación e implementación: Skill Supply Chain

**Inicio de investigación:** 2026-09-21
**Última actualización:** 2026-09-28
**Estado:** arquitectura definida; implementación incremental iniciada. `skill search` implementado y validado.

## Objetivo

Evaluar y reutilizar Agent Skills existentes antes de crear capacidades desde cero, priorizando interoperabilidad entre GitHub Copilot, OpenAI Codex y entornos locales, sin perder control sobre procedencia, licencia, seguridad, integridad y modificaciones.

La dirección de Proyecto cambia el enfoque de **crear Skills** por el de **gestionar Skills**:

```text
buscar -> inspeccionar -> evaluar -> stage -> auditar -> probar
      -> adoptar/adaptar -> registrar procedencia -> versionar -> actualizar
```

La regla operativa es:

```text
¿Existe algo adecuado?
  sí -> evaluar -> adoptar/adaptar
  no -> crear una Skill propia sólo cuando sea necesario
```

## Estado de implementación

La Skill Supply Chain dejó de ser únicamente una línea de investigación.

| Fase | Estado | Observación |
|---|---|---|
| `search` | IMPLEMENTADO | Descubrimiento externo sin instalación ni modificación del proyecto |
| `inspect` | ROADMAP | Inspección de candidato, origen y metadatos |
| `stage` | ROADMAP | Incorporación temporal y aislada para evaluación |
| `audit` | ROADMAP | Licencia, seguridad, integridad y riesgo |
| `test` | ROADMAP | Validación funcional antes de adopción |
| `import` | ROADMAP | Incorporación controlada al catálogo/proyecto |
| `source` / `diff` | ROADMAP | Trazabilidad y diferencias locales/upstream |
| `lock` / `update` | ROADMAP | Pinning y actualización controlada |

### Primera implementación: `skill search`

Interfaz validada:

```powershell
proyecto skill search "etl"
```

La implementación actual:

- utiliza el mismo CLI `proyecto`;
- mantiene la lógica de red fuera de `proyecto.ps1`, en `scripts/skill-search.ps1`;
- consulta GitHub Awesome Copilot como primer proveedor;
- busca sobre nombre y descripción;
- puntúa y ordena coincidencias;
- limita la salida a los primeros candidatos;
- presenta `NAME` y `DESCRIPTION`;
- informa fallos de red explícitamente;
- no instala Skills;
- no ejecuta código encontrado;
- no descarga una Skill dentro del proyecto;
- no modifica proyectos.

`search` es deliberadamente una operación de **descubrimiento**, no de confianza ni instalación.

La consulta piloto `etl` encontró un candidato relacionado con reconciliación/validación de tablas SQL Server. El resultado validó el mecanismo, pero no resolvió por sí mismo la necesidad general de `desarrollo-etl`. Esto justifica ampliar la cobertura de proveedores antes de decidir entre adoptar, adaptar, derivar o crear.

## Separación de responsabilidades

La búsqueda externa no reemplaza el catálogo local existente.

```text
proyecto list
    ↓
catálogo local conocido/aprobado

proyecto add
    ↓
instalación determinística desde catálogo local

proyecto skill search
    ↓
descubrimiento de candidatos externos
```

Regla de seguridad:

> Internet nunca alimenta directamente `proyecto add`.

Un resultado de `search` es sólo un candidato. Las futuras fases `inspect`, `stage`, `audit` y `test` deberán convertir ese candidato en una capacidad técnicamente evaluada antes de cualquier incorporación.

## Conclusión arquitectónica

Proyecto evoluciona hacia un **gestor curado de Agent Skills**.

Una Skill podrá ser:

- **PROPIA**: creada específicamente para Proyecto.
- **ADOPTADA**: importada sin cambios funcionales.
- **ADAPTADA**: importada y modificada.
- **DERIVADA**: reconstruida usando una o más fuentes como referencia.

El formato canónico recomendado continúa siendo **Agent Skills / `SKILL.md`**, manteniendo:

```text
.agents/skills/<skill>/SKILL.md
```

Esto coincide con la arquitectura actual de Proyecto y favorece la portabilidad entre agentes compatibles.

## Fuentes prioritarias

| Prioridad | Fuente | Uso | Estado en Proyecto |
|---|---|---|---|
| A | Agent Skills specification | Contrato técnico base | Referencia |
| A | GitHub Awesome Copilot | Catálogo práctico | Proveedor `search` operativo |
| A | Anthropic Skills | Adopción/adaptación y patrones | Próximo proveedor a validar |
| A | Hugging Face Skills | Catálogo/adopción cuando aplique | Pendiente |
| B | OpenAI Codex Skills / Cookbook | Patrones y workflows | Pendiente |
| B | Awesome lists | Descubrimiento, no autoridad de licencia | Referencia |
| C | Ollama | Runtime/model provider | No es catálogo de Skills |

### URLs de referencia

- https://agentskills.io/specification
- https://github.com/agentskills/agentskills
- https://github.com/github/awesome-copilot
- https://github.com/anthropics/skills
- https://github.com/huggingface/skills
- https://developers.openai.com/codex/skills
- https://github.com/VoltAgent/awesome-agent-skills
- https://ollama.com/

## Candidatos iniciales de la investigación

Los siguientes candidatos se mantienen como material de estudio; su identificación **no implica adopción**.

1. **Anthropic `skill-creator`**
   - candidato para estudiar creación y evaluación de Skills;
   - https://github.com/anthropics/skills/tree/main/skills/skill-creator

2. **GitHub Awesome Copilot `agent-supply-chain`**
   - relacionado con procedencia, integridad, pinning y cadena de confianza;
   - https://github.com/github/awesome-copilot/tree/main/skills/agent-supply-chain

3. **GitHub Awesome Copilot `agentic-eval`**
   - posible base para evaluaciones repetibles;
   - https://github.com/github/awesome-copilot/tree/main/skills/agentic-eval

4. **GitHub Awesome Copilot `database-data-management`**
   - materia prima potencial para PostgreSQL, DW y calidad de datos;
   - https://github.com/github/awesome-copilot/tree/main/plugins/database-data-management

## Evaluación preliminar histórica

La investigación inicial utilizó mantenimiento, calidad/tests, licencia, adaptabilidad y seguridad como dimensiones comparativas.

Estos valores son una **estimación preliminar histórica**, no una certificación ni una decisión de adopción:

| Capacidad | Estrategia preliminar | Confianza inicial |
|---|---|---:|
| postgres-diagnostico | ADAPTAR desde database-data-management | 92% |
| diagnostico-entorno | PROPIA + componentes externos | 88% |
| git-workflow | ADAPTAR | 84% |
| gestion-data-warehouse | ADAPTAR/DERIVAR | 82% |
| calidad-datos | DERIVAR | 80% |
| desarrollo-etl | DERIVAR | 77% |
| docker-setup | PROPIA/DERIVADA | 75% |
| orquestacion-procesos | PROPIA + referencias | 72% |

La Skill Supply Chain deberá sustituir progresivamente estas estimaciones manuales por evidencia obtenida mediante inspección, auditoría y pruebas.

El trabajo determinístico —por ejemplo utilidades Python genéricas— debe continuar viviendo en scripts/librerías y ser consumido por las Skills, no convertirse artificialmente en una Skill.

## Procedencia obligatoria

Para Skills externas se mantiene como diseño objetivo:

```text
.agents/
├── skills.lock.yaml
└── skills/
    └── <skill>/
        ├── SKILL.md
        ├── SOURCE.md
        ├── LICENSE / NOTICE
        ├── scripts/
        ├── references/
        └── tests/
```

`SOURCE.md` deberá registrar como mínimo:

- URL y repositorio upstream;
- path original;
- commit/tag inmutable;
- fecha de importación;
- licencia SPDX y archivos LICENSE/NOTICE;
- relación: adopted/adapted/derived;
- modificaciones locales;
- hashes/integridad;
- revisión de seguridad;
- compatibilidad declarada;
- estrategia de actualización.

Esta estructura todavía no está implementada.

## Política de seguridad

Una Skill externa **no debe instalarse directamente desde Internet en el proyecto**.

Primero deberá atravesar las fases de evaluación definidas por la Supply Chain.

Niveles propuestos:

- **S0**: sólo `SKILL.md`.
- **S1**: referencias/assets.
- **S2**: scripts locales sin red.
- **S3**: red/gestores de paquetes.
- **S4**: MCP/API/credenciales; revisión humana.
- **S5**: privilegios, root, Docker socket u operaciones destructivas; nunca autoejecutar.

Los niveles continúan como diseño pendiente de formalización e implementación.

## CLI

### Disponible actualmente

```powershell
proyecto skill search "postgres diagnostic"
```

### Interfaz objetivo

Los siguientes comandos representan el diseño previsto y **no deben interpretarse como implementados**:

```powershell
proyecto skill inspect <source>
proyecto skill stage <source> --ref <commit>
proyecto skill audit <skill>
proyecto skill test <skill>
proyecto skill import <skill> --project <proyecto>
proyecto skill source <skill>
proyecto skill diff <skill>
proyecto skill update <skill> --check
proyecto skill update <skill> --stage
proyecto skill list
proyecto skill lock
```

La interfaz podrá ajustarse a medida que cada fase sea validada.

## Decisiones consolidadas

1. Buscar antes de crear.
2. Un resultado de búsqueda no equivale a una Skill confiable.
3. `search` no instala ni modifica.
4. `list/add` representan capacidades locales conocidas; `skill search` representa descubrimiento externo.
5. Internet no alimenta directamente `add`.
6. La procedencia debe preservarse.
7. Las versiones externas deberán fijarse a referencias inmutables antes de adopción.
8. Código ejecutable y acceso a red elevan el nivel de revisión requerido.
9. La licencia debe verificarse sobre el artefacto concreto.
10. Las capacidades del catálogo de Proyecto son necesidades, no una obligación de crear Skills propias.

## Próximos pasos

Orden de trabajo actual:

1. ampliar `search` de forma incremental con un segundo proveedor, comenzando por Anthropic Skills;
2. comparar la mejora real de cobertura usando consultas conocidas, incluyendo `etl`;
3. implementar `skill inspect`;
4. definir el contrato de staging;
5. formalizar `SOURCE.md`;
6. formalizar `skills.lock.yaml`;
7. incorporar política de licencias y niveles S0-S5;
8. implementar `audit` y `test`;
9. validar adopción/adaptación con casos reales;
10. implementar importación sólo después de validar los controles anteriores.

No se incorporarán proveedores únicamente por cantidad. Cada fuente deberá demostrar utilidad real para el descubrimiento.

## Caso de uso: `desarrollo-etl`

`desarrollo-etl` deja de tratarse como una Skill que deba escribirse de antemano.

Se utiliza como primer caso para validar la Supply Chain:

```text
necesidad: desarrollo-etl
        ↓
search en proveedores
        ↓
comparar candidatos
        ↓
inspect / audit / test
        ↓
¿existe una capacidad adecuada?
   ├── sí → adoptar/adaptar/derivar
   └── no → crear Skill propia
```

La búsqueda inicial sobre GitHub Awesome Copilot no encontró una capacidad genérica equivalente a `desarrollo-etl`; encontró una capacidad específica relacionada con reconciliación/validación ETL. Por lo tanto, todavía no existe evidencia suficiente para decidir cómo resolver `desarrollo-etl`.

## Checkpoint 2026-09-28

Completado:

- arquitectura general de Skill Supply Chain documentada;
- `proyecto skill search <consulta>` implementado;
- lógica externa aislada en `scripts/skill-search.ps1`;
- GitHub Awesome Copilot conectado como primer proveedor;
- ranking y salida `NAME + DESCRIPTION`;
- búsqueda `etl` validada desde el launcher instalado;
- ausencia de efectos laterales verificada conceptualmente por diseño;
- README y ayuda del CLI actualizados para reflejar el nuevo flujo.

Siguiente checkpoint técnico:

- incorporar Anthropic Skills como segundo proveedor de `search`;
- medir si aumenta la cobertura útil;
- mantener sin implementar instalación automática.

## Nota

Este documento registra tanto decisiones consolidadas como diseño futuro. Las secciones indican explícitamente qué está implementado y qué permanece en roadmap.

La presencia de una fuente o candidato en este documento **no implica adopción ni instalación**. Cada futura incorporación deberá verificar el artefacto concreto, su licencia, procedencia, integridad, comportamiento y nivel de riesgo.

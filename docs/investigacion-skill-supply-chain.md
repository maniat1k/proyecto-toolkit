# Investigación: Skill Supply Chain

**Fecha:** 2026-09-21  
**Estado:** investigación completada; implementación pendiente.

## Objetivo

Evaluar el universo de Agent Skills reutilizables para Proyecto antes de crear capacidades desde cero, priorizando interoperabilidad entre GitHub Copilot, OpenAI Codex y entornos locales basados en Ollama.

La dirección propuesta cambia el enfoque de **crear skills** por el de **gestionar skills**:

```text
buscar -> inspeccionar -> evaluar -> stage -> auditar -> probar
      -> adoptar/adaptar -> registrar procedencia -> versionar -> actualizar
```

## Conclusión principal

Proyecto debería evolucionar hacia un **gestor curado de Agent Skills**. Una skill podrá ser:

- **PROPIA**: creada específicamente para Proyecto.
- **ADOPTADA**: importada sin cambios funcionales.
- **ADAPTADA**: importada y modificada.
- **DERIVADA**: reconstruida usando una o más fuentes como referencia.

El formato canónico recomendado es **Agent Skills / `SKILL.md`**, manteniendo `.agents/skills/<skill>/SKILL.md`, que ya coincide con la arquitectura actual de Proyecto y ofrece alta portabilidad entre agentes compatibles.

## Fuentes prioritarias identificadas

| Prioridad | Fuente | Uso |
|---|---|---|
| A | Agent Skills specification | Contrato técnico base |
| A | GitHub Awesome Copilot | Catálogo práctico principal |
| A | Anthropic Skills con licencia permisiva | Adopción/adaptación |
| A | Hugging Face Skills | Adopción cuando aplique |
| B | OpenAI Codex Skills / Cookbook | Patrones y workflows |
| B | Awesome lists | Descubrimiento, no autoridad de licencia |
| C | Ollama | Runtime/model provider, no catálogo de skills |

### URLs de referencia

- https://agentskills.io/specification
- https://github.com/agentskills/agentskills
- https://github.com/github/awesome-copilot
- https://github.com/anthropics/skills
- https://github.com/huggingface/skills
- https://developers.openai.com/codex/skills
- https://github.com/VoltAgent/awesome-agent-skills
- https://ollama.com/

## Candidatos iniciales

1. **Anthropic `skill-creator`** — candidato fuerte para adoptar como referencia/capacidad de creación y evaluación de skills.
   - https://github.com/anthropics/skills/tree/main/skills/skill-creator

2. **GitHub Awesome Copilot `agent-supply-chain`** — especialmente alineado con procedencia, integridad, pinning y cadena de confianza.
   - https://github.com/github/awesome-copilot/tree/main/skills/agent-supply-chain

3. **GitHub Awesome Copilot `agentic-eval`** — base para pruebas/evaluaciones repetibles.
   - https://github.com/github/awesome-copilot/tree/main/skills/agentic-eval

4. **GitHub Awesome Copilot `database-data-management`** — materia prima para PostgreSQL, DW y calidad de datos.
   - https://github.com/github/awesome-copilot/tree/main/plugins/database-data-management

## Validez preliminar para capacidades de Proyecto

Los porcentajes son una evaluación técnica comparativa, no una certificación. La investigación utilizó mantenimiento, calidad/tests, licencia, adaptabilidad y seguridad como dimensiones.

| Capacidad | Estrategia | Validez/confianza preliminar |
|---|---|---:|
| postgres-diagnostico | ADAPTAR desde database-data-management | 92% |
| diagnostico-entorno | PROPIA + componentes externos | 88% |
| git-workflow | ADAPTAR | 84% |
| gestion-data-warehouse | ADAPTAR/DERIVAR | 82% |
| calidad-datos | DERIVAR | 80% |
| desarrollo-etl | DERIVAR | 77% |
| docker-setup | PROPIA/DERIVADA | 75% |
| orquestacion-procesos | PROPIA + referencias | 72% |

El trabajo determinístico (por ejemplo utilidades Python genéricas) debe continuar viviendo en scripts/librerías y ser consumido por las skills, no convertirse artificialmente en una skill.

## Procedencia obligatoria

Para skills externas se propone incorporar:

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

`SOURCE.md` debería registrar como mínimo:

- URL y repositorio upstream.
- path original.
- commit/tag inmutable.
- fecha de importación.
- licencia SPDX y archivos LICENSE/NOTICE.
- relación: adopted/adapted/derived.
- modificaciones locales.
- hashes/integridad.
- revisión de seguridad.
- compatibilidad declarada.
- estrategia de actualización.

## Política de seguridad

Una skill externa **no debe instalarse directamente desde Internet en el proyecto**. Primero debe pasar por staging.

Niveles propuestos:

- **S0**: sólo SKILL.md.
- **S1**: referencias/assets.
- **S2**: scripts locales sin red.
- **S3**: red/gestores de paquetes.
- **S4**: MCP/API/credenciales; revisión humana.
- **S5**: privilegios, root, Docker socket u operaciones destructivas; nunca autoejecutar.

## CLI objetivo

```powershell
proyecto skill search "postgres diagnostic"
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

## Decisión arquitectónica propuesta

El próximo salto de Proyecto **no es escribir todo el catálogo previsto**. Es implementar una **Skill Supply Chain** capaz de:

1. descubrir;
2. inspeccionar;
3. verificar licencia;
4. fijar versión/commit;
5. auditar seguridad;
6. probar;
7. adoptar o adaptar;
8. conservar atribución;
9. bloquear cambios upstream inesperados;
10. actualizar de forma controlada.

Después de disponer de ese mecanismo, cada capacidad del catálogo actual se resolverá con la regla:

```text
¿Existe algo adecuado?
  sí -> evaluar -> adoptar/adaptar
  no -> crear skill propia
```

## Próximos pasos

- Definir formalmente `SOURCE.md`.
- Definir `skills.lock.yaml`.
- Incorporar política de licencias y niveles S0-S5.
- Implementar primero `skill inspect` y `skill stage`.
- Usar `skill-creator`, `agent-supply-chain` y `agentic-eval` como primeros casos de estudio.
- Adaptar posteriormente `database-data-management` para el primer piloto técnico relacionado con PostgreSQL.
- Actualizar README y catálogo sólo después de validar el mecanismo.

## Nota

Este documento registra la investigación y las decisiones candidatas para seguimiento. **No implica todavía la adopción ni instalación de ninguna skill externa.** Cada importación deberá verificar la licencia del artefacto concreto, no sólo la licencia del catálogo que lo referencia.

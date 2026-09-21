# Bootstrap inicial de contexto

## Propósito

Proyecto utiliza un bootstrap conversacional para obtener contexto de alta calidad durante la primera interacción relevante con IA y persistirlo para agentes posteriores.

La estrategia es:

```text
inspección determinística del repo
        ↓
detección de vacíos
        ↓
entrevista adaptativa
(máximo 10 preguntas, una por vez)
        ↓
síntesis
        ↓
confirmación humana
        ↓
CONTEXT.md + reglas estables de AGENTS.md
        ↓
bootstrap COMPLETADO
```

## Principios

El agente debe descubrir antes de preguntar. La entrevista no es un formulario fijo: cada pregunta depende de la evidencia del repositorio y de las respuestas anteriores. Puede finalizar antes de diez preguntas.

El objetivo es capturar objetivo, usuarios, arquitectura y stack, ambientes, restricciones, límites de cambio, flujo operativo, estado actual, riesgos/bloqueos y Definition of Done.

Los hechos técnicos descubiertos se separan de las decisiones declaradas por el usuario. Ningún secreto debe almacenarse.

## Persistencia

`CONTEXT.md` incorpora un estado de Bootstrap: `PENDIENTE` o `COMPLETADO`. Una vez completado no debe repetirse automáticamente. Las sesiones posteriores sólo realizan preguntas puntuales cuando aparezcan vacíos o contradicciones.

Las reglas estables que afecten a cualquier agente pueden proponerse para `AGENTS.md`. El estado cambiante y el punto de continuación permanecen en `CONTEXT.md`.

## CLI

El bootstrap no es un comando público. `proyecto valida <proyecto>` comprueba el estado de `CONTEXT.md`: si el contexto inicial sigue `PENDIENTE`, activa internamente el prompt de bootstrap; si figura `COMPLETADO`, continúa directamente con la validación normal.

De este modo, el usuario expresa una sola intención —validar el proyecto— y Proyecto decide internamente si antes necesita completar el contexto.

La validación end-to-end en un entorno local queda pendiente hasta ejecutar la nueva versión del CLI sobre un proyecto real.

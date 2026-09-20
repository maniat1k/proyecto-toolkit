# AGENTS

## Contrato operativo

Este proyecto sigue el estándar de trabajo Proyecto.

## Inicio de una tarea

Antes de modificar archivos:

1. Lee `AGENTS.md`.
2. Lee `CONTEXT.md`.
3. Ejecuta `git status` si el proyecto utiliza Git.
4. Inspecciona únicamente los archivos necesarios para la tarea.
5. Diagnostica antes de modificar.

## Contexto del proyecto

`CONTEXT.md` es el contexto operativo persistente del proyecto.

Todo agente que trabaje en este proyecto debe:

1. Leer `CONTEXT.md` antes de comenzar una tarea relevante.
2. Utilizarlo como referencia del estado actual del proyecto.
3. Distinguir hechos verificados, decisiones, elementos no verificados, bloqueos y pendientes.
4. Actualizarlo cuando una tarea produzca un cambio significativo en el estado operativo, las decisiones, la arquitectura, los bloqueos o el punto de continuación.
5. Mantener únicamente información respaldada por evidencia o decisiones explícitas.
6. No almacenar contraseñas, tokens, claves API ni otros secretos en `CONTEXT.md`.

`CONTEXT.md` no sustituye la inspección del proyecto ni la evidencia técnica. Si su contenido contradice evidencia actual, debe señalarse y verificarse antes de utilizarlo como hecho.

## Antes de realizar cambios

Para cambios relevantes, indica brevemente:

- qué se encontró;
- cómo se detectó;
- qué se modificará;
- qué archivos o componentes están afectados;
- por qué es necesario el cambio;
- cómo se validará.

No amplíes silenciosamente el alcance solicitado.

## Cambio mínimo

- Modifica únicamente lo necesario.
- Prefiere cambios pequeños, directos y reversibles.
- No refactorices ni reorganices archivos no relacionados.
- Conserva el estado funcional actual salvo que la tarea autorizada requiera modificarlo.

## Validación

Después de un cambio:

1. Ejecuta la validación mínima apropiada disponible.
2. Revisa `git diff`.
3. Informa exactamente qué cambió.
4. Distingue lo que fue realmente validado de lo que permanece sin verificar.

Nunca afirmes que algo funciona solamente porque fue creado, inspeccionado o validado estáticamente.

## Git

Git es la fuente de verdad para los artefactos versionados del proyecto.

- No hagas commit ni push sin autorización explícita.
- No descartes cambios existentes sin autorización explícita.
- No agregues automáticamente al control de versiones logs, dumps, archivos temporales, salidas generadas, evidencias de pruebas ni secretos.

## Seguridad

- Nunca almacenes contraseñas, tokens, claves API u otros secretos en el repositorio.
- No ejecutes operaciones destructivas sin autorización explícita.
- Respeta las restricciones documentadas de solo lectura.
- No modifiques la configuración del entorno salvo que sea necesaria para la tarea autorizada.

## Skills de agente

Los procedimientos reutilizables se proporcionan como Agent Skills bajo `.agents/skills/<nombre-skill>/SKILL.md`.

Utiliza una Skill aplicable cuando la tarea coincida con su propósito declarado, en lugar de recrear el procedimiento manualmente.

## Fin de una tarea

Antes de cerrar un trabajo significativo:

1. Revisa `git diff`.
2. Registra únicamente resultados respaldados por evidencia.
3. Actualiza `CONTEXT.md` si cambió el estado operativo.
4. No hagas commit ni push salvo autorización explícita.

Las reglas específicas del proyecto pueden ampliar este contrato, pero no deben duplicar ni debilitar estas reglas base.


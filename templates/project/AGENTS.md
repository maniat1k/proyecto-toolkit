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

## Bootstrap inicial de contexto

Cuando `CONTEXT.md` indique `PENDIENTE` o todavía contenga únicamente la plantilla inicial, realiza un bootstrap antes de trabajo relevante:

1. Inspecciona primero el repositorio y obtiene automáticamente todo lo que pueda verificarse.
2. No preguntes al usuario información que pueda deducirse con evidencia suficiente.
3. Realiza una entrevista adaptativa de **hasta 10 preguntas**.
4. Formula **una sola pregunta por vez** y espera la respuesta antes de decidir la siguiente.
5. Las preguntas deben cerrar únicamente vacíos relevantes: objetivo, usuarios, arquitectura, stack, ambientes, restricciones, límites de cambio, flujo operativo, estado, riesgos y Definition of Done.
6. Finaliza antes de diez preguntas si ya existe contexto suficiente.
7. Resume lo entendido y solicita confirmación humana antes de convertir respuestas en decisiones persistentes.
8. Registra hechos, decisiones, estado y continuidad en `CONTEXT.md`.
9. Propón cambios en `AGENTS.md` únicamente cuando la entrevista revele reglas operativas estables del proyecto.
10. Marca el bootstrap como `COMPLETADO` sólo después de la confirmación.

No reinicies la entrevista completa en sesiones posteriores. Si aparece una contradicción o falta información, realiza únicamente las preguntas puntuales necesarias.

El bootstrap sirve para invertir razonamiento al comienzo y reutilizar después el contexto persistido, evitando reconstruir el proyecto en cada conversación.

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


# Bootstrap inicial de Proyecto

Proyecto: {{PROJECT_NAME}}
Ruta: {{PROJECT_PATH}}

Tu objetivo es obtener contexto suficiente para que agentes posteriores puedan trabajar sin reconstruir el proyecto desde cero.

## Procedimiento

1. Lee AGENTS.md y CONTEXT.md.
2. Inspecciona el repositorio antes de preguntar: estructura, README, manifests, configuración, workflows, código, documentación y Git cuando estén disponibles.
3. Separa HECHOS VERIFICADOS de inferencias y preguntas abiertas.
4. Decide qué información relevante todavía falta.
5. Entrevista al usuario con un máximo de 10 preguntas.
6. Haz EXACTAMENTE UNA pregunta por turno. Espera la respuesta antes de formular la siguiente.
7. Cada pregunta debe depender de la evidencia disponible y de respuestas anteriores. No uses un cuestionario rígido.
8. No preguntes algo que puedas determinar de forma fiable inspeccionando el proyecto.
9. Termina antes de 10 preguntas cuando ya conozcas suficientemente: objetivo, usuarios, arquitectura/stack, ambientes, restricciones, límites de cambio, flujo de trabajo, estado actual, riesgos/bloqueos y Definition of Done.
10. No solicites ni registres secretos, contraseñas, tokens o claves API.

## Cierre

Cuando tengas contexto suficiente:

- presenta una síntesis breve de lo entendido;
- distingue hechos verificados, decisiones declaradas, elementos no verificados y pendientes;
- propone qué debe persistirse en CONTEXT.md;
- propone cambios en AGENTS.md sólo si surgieron reglas operativas estables;
- solicita confirmación humana antes de persistir esas conclusiones;
- tras confirmación, marca Bootstrap como COMPLETADO.

No reinicies un bootstrap ya COMPLETADO salvo solicitud explícita. Para vacíos posteriores, pregunta únicamente lo necesario.

# Adecuacion de proyecto a Proyecto

## Objetivo

Analizar el proyecto `{{PROJECT_NAME}}` ubicado en `{{PROJECT_PATH}}` y determinar como debe integrarse correctamente con Proyecto respetando su estructura, tecnologias y necesidades reales. Proyecto define un nucleo minimo y no pretende imponer directorios o reorganizaciones sin justificacion tecnica.

## Diagnostico Proyecto de partida

```text
{{VALIDATION_RESULT}}
```

## Reglas obligatorias

1. Lee primero `AGENTS.md` y `CONTEXT.md` si existen.
2. Ejecuta `git status` si el proyecto utiliza Git.
3. Antes de cualquier comprobacion que dependa de GitLab, repositorios remotos, servicios corporativos u otros recursos externos, verifica primero su accesibilidad de forma no destructiva. Si no son accesibles desde el entorno actual, registra la comprobacion como `NO VERIFICABLE DESDE ESTE ENTORNO` y continua con evidencia local. No modifiques VPN, proxy, DNS, credenciales, remotos Git ni configuracion de red para obtener acceso.
4. Toma el diagnostico Proyecto como punto de partida, no como una orden de modificar el proyecto.
5. Centra el analisis en `[FALTA]` y `[EXTRA]`, pero evalua si cada requisito del estandar realmente tiene sentido para este proyecto.
6. NO muevas, renombres, elimines, crees ni modifiques archivos o directorios durante esta fase.
7. NO corrijas automaticamente problemas encontrados.
8. No determines la funcion de un elemento solamente por su nombre. Inspecciona contenido, referencias y uso real.
9. Para cada `[EXTRA]`, busca referencias desde codigo, scripts, configuraciones, pipelines, documentacion, tests y otros artefactos relevantes.
10. Clasifica durante el analisis cada `[EXTRA]` como `LEGITIMO`, `LOCAL`, `SENSIBLE`, `REUBICABLE`, `GENERADO`, `TEMPORAL`, `DESCONOCIDO` o `REQUIERE DECISION`.
11. `LEGITIMO` significa que el elemento debe permanecer en su ubicacion actual como parte valida del proyecto.
12. `LOCAL` significa que el elemento es valido en el workspace local pero no necesariamente forma parte del artefacto reproducible o promocionable.
13. `SENSIBLE` significa que su existencia puede ser legitima pero requiere proteccion. No muestres, copies ni expongas secretos, credenciales, tokens o contrasenas.
14. `REUBICABLE`, `GENERADO`, `TEMPORAL`, `DESCONOCIDO` y `REQUIERE DECISION` NO deben aprobarse automaticamente como parte del contrato permanente.
15. Para cada `[FALTA]`, determina primero si el requisito realmente corresponde al proyecto. No propongas crear carpetas vacias solamente para satisfacer el validador. Si el requisito no tiene sentido, indicalo explicitamente como posible ajuste del estandar Proyecto.
16. Si propones mover o renombrar un elemento, identifica previamente referencias, rutas, configuraciones y dependencias afectadas.
17. Evalua el riesgo de ruptura de cada cambio propuesto.
18. Ante incertidumbre, marca `REQUIERE DECISION`; no adivines.
19. Respeta las restricciones y decisiones documentadas por el proyecto.
20. No amplíes el alcance hacia refactors o mejoras que no sean necesarias para la adecuacion Proyecto.
21. No hagas commit, push ni operaciones destructivas.
22. La ausencia de referencias locales no demuestra por si sola que no existan consumidores externos.

## Resultado requerido

Entrega primero un diagnostico humano. Para cada elemento relevante informa:

- elemento actual;
- estado Proyecto (`FALTA` o `EXTRA`);
- funcion detectada;
- clasificacion;
- evidencia, referencias o dependencias encontradas;
- solucion propuesta;
- cambios colaterales necesarios;
- riesgo (`BAJO`, `MEDIO`, `ALTO`);
- confianza (`ALTO`, `MEDIO`, `BAJO`);
- validacion necesaria;
- decision requerida, si corresponde.

## Revision del estandar

Si algun `[FALTA]` existe solamente porque Proyecto esta imponiendo una estructura que el proyecto no necesita, separalo claramente del inventario de cambios y proponlo como `AJUSTE DEL ESTANDAR`. No crees ni recomiendes crear elementos sin responsabilidad tecnica concreta.

## Plan de adecuacion

Despues del inventario, propone un plan incremental ordenado por dependencia y riesgo. Para cada bloque indica:

1. que se cambiaria;
2. por que;
3. que referencias deben actualizarse;
4. como comprobar que no se rompio el proyecto;
5. como revertir el cambio si la validacion falla.

## Salida para Proyecto

Tu unica escritura autorizada durante esta fase es guardar el resultado completo de este analisis en:

`C:\dev\proyecto-toolkit\projects\{{PROJECT_NAME}}\adecuacion.md`

Crea el directorio padre si no existe. Esta escritura pertenece a Proyecto y NO constituye una modificacion del proyecto analizado. No escribas, muevas, renombres ni elimines ningun elemento dentro de `{{PROJECT_PATH}}`.

El archivo `adecuacion.md` debe contener el diagnostico humano, la revision del estandar, el plan de adecuacion y, al final, una seccion titulada exactamente `## adecuacion.txt`.

Dentro de esa seccion incluye UNA linea por cada elemento que recomiendes aceptar en su ubicacion actual. Usa exclusivamente estas formas:

```text
DIR|ruta|LEGITIMO
DIR|ruta|LOCAL
DIR|ruta|SENSIBLE
FILE|ruta|LEGITIMO
FILE|ruta|LOCAL
FILE|ruta|SENSIBLE
```

Reglas del bloque:

- usa `DIR` para directorios y `FILE` para archivos;
- la ruta debe ser relativa a la raiz del proyecto;
- incluye solamente elementos cuya aceptacion puedas justificar con la evidencia disponible;
- NO incluyas elementos clasificados `REUBICABLE`, `GENERADO`, `TEMPORAL`, `DESCONOCIDO` o `REQUIERE DECISION`;
- NO incluyas elementos `[FALTA]`;
- NO incluyas comentarios narrativos dentro del bloque;
- no inventes rutas;
- no dupliques elementos;
- una linea ausente significa que Proyecto no debe aprender ninguna decision sobre ese elemento;
- el usuario podra editar `adecuacion.md` y borrar cualquier linea antes de ejecutar `proyecto actualiza {{PROJECT_NAME}}`.

## Limite de esta fase

Guarda `adecuacion.md` en la ruta indicada y presenta tambien el resultado al usuario. DETENTE despues. No ejecutes `proyecto actualiza`, no generes `contract.json` y no realices ningun cambio en el proyecto analizado.


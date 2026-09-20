---
name: diagnostico-entorno
description: Diagnostica de forma controlada un entorno tecnico antes de instalar, modificar, desplegar o investigar problemas. Usar cuando sea necesario relevar sistema operativo, recursos, software, servicios, red, proxy, puertos, usuarios, permisos, filesystem o conectividad sin realizar cambios.
---

# Diagnostico de entorno

## Objetivo

Obtener evidencia tecnica reproducible del estado actual de un entorno antes de proponer o ejecutar cambios.

## Principios

- Diagnosticar antes de modificar.
- Priorizar comandos de solo lectura.
- No instalar, actualizar, eliminar, reiniciar ni reconfigurar componentes durante el diagnostico.
- No asumir que una herramienta, servicio, puerto, ruta o permiso existe: comprobarlo.
- No exponer secretos, passwords, tokens ni credenciales.
- Distinguir hechos comprobados de inferencias y elementos no verificados.
- Ejecutar solamente las comprobaciones pertinentes para la tarea actual.

## Areas de diagnostico

Cuando sean relevantes, comprobar:

1. Sistema operativo y version.
2. CPU, memoria y almacenamiento.
3. Software instalado y versiones.
4. Servicios y procesos relevantes.
5. Runtime y dependencias tecnicas.
6. Contenedores o plataforma de ejecucion cuando corresponda.
7. Red, DNS y rutas de conectividad.
8. Proxy y restricciones de salida.
9. Puertos y listeners relevantes.
10. Usuario efectivo, grupos y permisos.
11. Rutas, filesystem y espacio disponible.
12. Conectividad hacia bases de datos o servicios requeridos.

## Metodo

1. Identificar que necesita conocerse para la tarea.
2. Seleccionar las comprobaciones minimas necesarias.
3. Ejecutar primero comprobaciones no invasivas.
4. Registrar resultados observables.
5. Separar resultados en comprobado, no verificado y bloqueo.
6. No corregir automaticamente los problemas encontrados.
7. Proponer el siguiente paso solamente despues del diagnostico.

## Resultado esperado

Entregar un resumen estructurado que indique:

- entorno diagnosticado;
- comprobaciones realizadas;
- hechos comprobados;
- restricciones o bloqueos detectados;
- elementos no verificados;
- siguiente accion tecnica recomendada.

Cuando sea necesario conservar evidencia, utilizar los mecanismos de evidencia definidos por el proyecto.

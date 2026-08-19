# Superficie operativa

Esta carpeta contiene scripts reutilizables para operaciones aprobadas sobre VMs Azure y clústeres UiPath.

- `powershell`: scripts PowerShell con `Param()`, validacion de entradas, `$ErrorActionPreference = 'Stop'` y `try/catch`.
- `kql/resource-graph`: inventario de recursos Azure.
- `kql/log-analytics`: consultas de telemetria del Workspace.

Prueba primero en PRE. Usa `-WhatIf` en operaciones de limpieza, revisa la suscripcion y no incluyas credenciales en parametros o archivos.

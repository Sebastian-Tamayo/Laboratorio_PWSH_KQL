# Superficie operativa

Esta carpeta contiene scripts reutilizables para operaciones aprobadas sobre VMs Azure y clústeres UiPath.

- `powershell`: scripts PowerShell con `Param()`, validacion de entradas, `$ErrorActionPreference = 'Stop'` y `try/catch`.
La ejecución debe comenzar en PRE. Las operaciones de limpieza requieren `-WhatIf`, revisión del equipo objetivo y ausencia de credenciales en parámetros o archivos.

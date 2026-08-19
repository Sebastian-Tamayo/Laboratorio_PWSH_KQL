# Bloque 02: Eventos Windows

## Objetivo

Consultar eventos de `Application` y `System` con `Get-WinEvent`, filtrando en origen por registro, nivel, proveedor, identificador y ventana temporal.

## Prerrequisitos

- Windows PowerShell en una VM Windows.
- Permisos de lectura sobre los registros.
- WinRM y firewall aprobados para consultas remotas.

## Ejecución

`Ejercicios.ps1` contiene consultas de laboratorio. Cambia los nombres de VM por equipos autorizados y limita siempre la salida con `-MaxEvents`.

Para un informe reutilizable usa `src/powershell/Get-WindowsEventReport.ps1`.

## Seguridad operativa

No ejecutes comandos de detención o reinicio desde este bloque durante un incidente sin aprobación. Guarda la salida junto al ticket y valida la zona horaria de los eventos.

# Bloque 01: Parametrizacion

## Objetivo

Construir funciones avanzadas con `CmdletBinding`, validacion de parametros, entrada por pipeline y salida estructurada.

## Ejecución

```powershell
. .\Get-RobotStatus.ps1
Get-RobotStatus -VMName VM-PROD-01 -Environment PRO -Verbose
'VM-PRE-01', 'VM-PRE-02' | Get-RobotStatus -Environment PRE
```

El script devuelve un estado de ejemplo (`Online`) para practicar la forma del resultado. No representa el estado real de Azure; para inventario real usa `src/powershell/Get-AzureVmInventory.ps1`.

# Laboratorio PowerShell y UiPath

Repositorio de aprendizaje y automatizacion para administrar 14 VMs Azure (10 PRO y 4 PRE) que soportan clústeres UiPath.

## Estructura

- `powershell_KQL/PWSH_KQL/src`: scripts operativos reutilizables.
- `powershell_KQL/PWSH_KQL/Scripts/BLOQUE-01-Fundamentos`: variables, filtros, bucles y errores.
- `powershell_KQL/PWSH_KQL/Scripts/BLOQUE-01-Parametrizacion`: funciones avanzadas y validacion de parametros.
- `powershell_KQL/PWSH_KQL/Scripts/BLOQUE-02-Eventos-Windows`: diagnostico local y remoto con `Get-WinEvent`.
- `powershell_KQL/PWSH_KQL/Scripts/BLOQUE-03-PowerShell-Azure`: comandos PowerShell que integraran los ejercicios probados en el portal Azure.
- `powershell_KQL/PWSH_KQL/docs`: apuntes de referencia y roadmap.

Los bloques `Scripts` son ejercicios guiados. No deben ejecutarse directamente en PRO sin revisar sus parametros y el efecto de cada cmdlet. Para tareas reales se usa `src`.

Las consultas se practican directamente en el portal de Azure. No se mantienen carpetas `kql`, `log-analytics` ni `resource-graph`; cuando una consulta este validada, se incorpora una sola vez en el script PowerShell del bloque 03.

## Prerrequisitos

- Windows PowerShell 5.1 o PowerShell 7.
- Para administracion remota: WinRM, firewall y permisos aprobados por el equipo corporativo.
- Managed Identity o CyberArk para secretos de UiPath y Azure Key Vault. No almacenar credenciales en scripts.

## Validacion y despliegue

1. Ejecutar el parser de PowerShell sobre `src/powershell` antes de publicar cambios.
2. Probar `Invoke-TempCleanup.ps1` con `-WhatIf` y en una VM PRE.
3. Validar nombres de VMs y permisos antes de consultar PRO.
4. Publicar mediante el repositorio o agente aprobado por el control corporativo.
5. Ejecutar cambios UiPath desde UiPath Solutions Management y conservar la version anterior para rollback.

Ejemplo de validacion de sintaxis:

```powershell
Get-ChildItem .\powershell_KQL\PWSH_KQL\src\powershell -Filter *.ps1 |
    ForEach-Object {
        $tokens = $null
        $errors = $null
        [System.Management.Automation.Language.Parser]::ParseFile(
            $_.FullName, [ref]$tokens, [ref]$errors
        ) | Out-Null
        if ($errors) { throw "Error de sintaxis en $($_.Name): $errors" }
    }
```

## Runbooks breves

- Temporales: `Invoke-TempCleanup.ps1 -Path C:\Windows\Temp -WhatIf`; revisar antes de retirar `-WhatIf`.
- Servicios UiPath: `Test-RpaWindowsServices.ps1 -ComputerName VM-PROD-RPA01`.
- Eventos Windows: `Get-WindowsEventReport.ps1 -ComputerName VM-PROD-RPA01 -Newest 20`.
- Incidente: conservar salida y eventos, detener el cambio, abrir ticket y escalar a Azure/RPA.

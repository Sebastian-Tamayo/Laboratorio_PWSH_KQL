# Laboratorio PowerShell, Azure Monitor y UiPath

Repositorio de aprendizaje y automatizacion para administrar 14 VMs Azure (10 PRO y 4 PRE) que soportan clústeres UiPath.

## Estructura

- `powershell_KQL/PWSH_KQL/src/powershell`: scripts operativos parametrizados.
- `powershell_KQL/PWSH_KQL/src/kql`: consultas para Azure Resource Graph y Log Analytics.
- `powershell_KQL/PWSH_KQL/Scripts/BLOQUE-01-Fundamentos`: variables, filtros, bucles y errores.
- `powershell_KQL/PWSH_KQL/Scripts/BLOQUE-01-Parametrizacion`: funciones avanzadas y validacion de parametros.
- `powershell_KQL/PWSH_KQL/Scripts/BLOQUE-02-Eventos-Windows`: diagnostico local y remoto con `Get-WinEvent`.
- `powershell_KQL/PWSH_KQL/Scripts/BLOQUE-03-KQL-Azure`: notas sobre observabilidad Azure; las consultas ejecutables estan en `src/kql`.
- `powershell_KQL/PWSH_KQL/docs`: apuntes de referencia y roadmap.

Los bloques `Scripts` son ejercicios guiados. No deben ejecutarse directamente en PRO sin revisar sus parametros y el efecto de cada cmdlet. Para tareas reales se usa `src`.

## Prerrequisitos

- Windows PowerShell 5.1 o PowerShell 7.
- Modulos `Az.Accounts` y `Az.ResourceGraph`: `Install-Module Az.Accounts, Az.ResourceGraph -Scope CurrentUser`.
- Permisos `Reader` sobre la suscripcion o Resource Group para Resource Graph.
- Permisos `Log Analytics Reader` y un Workspace con diagnosticos de Azure Monitor para las consultas de logs.
- Para administracion remota: WinRM, firewall y permisos aprobados por el equipo corporativo.
- Managed Identity o CyberArk para secretos de UiPath y Azure Key Vault. No almacenar credenciales en scripts.

## Validacion y despliegue

1. Ejecutar el parser de PowerShell sobre `src/powershell` antes de publicar cambios.
2. Probar `Invoke-TempCleanup.ps1` con `-WhatIf` y en una VM PRE.
3. Validar nombres de VMs, suscripcion, Resource Group y Workspace antes de consultar PRO.
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
- Inventario Azure: `Get-AzureVmInventory.ps1 -SubscriptionId <subscription-id>`.
- Incidente: conservar salida y eventos, detener el cambio, abrir ticket y escalar a Azure/RPA.

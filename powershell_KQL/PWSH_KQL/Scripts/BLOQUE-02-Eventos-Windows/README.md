# Bloque 02: Windows Event Viewer

## Objetivo

Dominar el diagnostico de VMs UiPath desde PowerShell usando `Get-WinEvent`, filtros en origen, limites de salida y consultas remotas.

## Ejercicios recuperados

1. Errores de `Application` en las ultimas 24 horas.
2. Caidas de procesos con Event ID `1000`.
3. Cambios de estado de servicios con Event ID `7036`.
4. Filtrado por `Service Control Manager` y `-MaxEvents`.
5. Consulta remota de una VM.
6. Consulta simultanea de varias VMs.
7. Detecciones de Microsoft Defender, Event ID `1116`.
8. Caidas de Application Pool mediante WAS, Event ID `5002`.
9. Errores de procesos y excepciones .NET, Event IDs `1000` y `1026`.
10. Problemas de `User Profiles Service` que afectan RDP/VDI.
11. Errores Schannel/TLS, Event IDs `36871` y `36874`.

## Ejecucion

Por defecto se ejecuta solo el ejercicio 1 sobre el equipo local:

```powershell
.\Ejercicios.ps1
```

Seleccionar ejercicios concretos:

```powershell
.\Ejercicios.ps1 -Exercise 1,2,3 -ComputerName localhost -Newest 20
.\Ejercicios.ps1 -Exercise 5 -ComputerName VM-PROD-RPA01
.\Ejercicios.ps1 -Exercise 6 -ComputerName VM-PROD-RPA01,VM-PROD-RPA02
```

Para equipos remotos se puede proporcionar una credencial administrada por el procedimiento corporativo con `-Credential`. No se escriben contrasenas en el script.

## Como estudiar cada consulta

- `LogName` selecciona `Application` o `System`.
- El parámetro `Level` utiliza valores Windows: 1 crítico, 2 error, 3 advertencia y 4 información.
- `Id` aisla un evento conocido.
- `ProviderName` identifica el componente que lo genero.
- `StartTime` limita la ventana temporal.
- `-MaxEvents` evita traer una cantidad innecesaria de registros.
- `-ComputerName` permite consultar una o varias VMs con WinRM.

El script filtra en el origen con `-FilterHashtable`, en lugar de traer todos los eventos para filtrarlos despues con `Where-Object`.

## Prerrequisitos y seguridad

- Windows PowerShell 5.1 o PowerShell 7.
- Permisos de lectura sobre los registros.
- WinRM y firewall aprobados para consultas remotas.
- Defender Operational, WAS, User Profiles Service o Schannel pueden no existir o no tener eventos en todas las VMs; el resultado devuelve el error del ejercicio sin ocultarlo.
- No detener servicios ni modificar IIS desde este bloque. Las acciones correctivas requieren ticket, aprobacion y ventana de mantenimiento.

Los informes operativos reutilizables se generan con `src/powershell/Get-WindowsEventReport.ps1`.

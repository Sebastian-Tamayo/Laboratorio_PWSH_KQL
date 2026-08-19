[CmdletBinding()]
param(
    [Parameter()]
    [ValidateSet(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)]
    [int[]]$Exercise = @(1),

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string[]]$ComputerName = @('localhost'),

    [Parameter()]
    [ValidateRange(1, 100)]
    [int]$Newest = 10,

    [Parameter()]
    [System.Management.Automation.PSCredential]$Credential
)

$ErrorActionPreference = 'Stop'

function Invoke-EventExercise {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$FilterHashtable,

        [Parameter(Mandatory)]
        [string[]]$TargetComputer,

        [Parameter(Mandatory)]
        [int]$MaxEvents,

        [Parameter()]
        [System.Management.Automation.PSCredential]$RemoteCredential
    )

    # Filtrar en el motor de eventos reduce memoria y tiempo frente a Where-Object posterior.
    foreach ($computer in $TargetComputer) {
        # Get-WinEvent recibe un nombre escalar; el bucle mantiene el soporte multi-VM.
        $eventParameters = @{
            FilterHashtable = $FilterHashtable
            ComputerName    = $computer
            MaxEvents       = $MaxEvents
            ErrorAction     = 'Stop'
        }
        if ($RemoteCredential) {
            $eventParameters.Credential = $RemoteCredential
        }

        Get-WinEvent @eventParameters |
            Select-Object @{Name = 'ComputerName'; Expression = { $_.MachineName }},
                LogName, Id, LevelDisplayName, ProviderName, TimeCreated, Message
    }
}

function Invoke-SelectedExercise {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [int]$Number
    )

    $now = Get-Date
    $filter = $null
    $targetComputer = $ComputerName
    $maxEvents = $Newest

    switch ($Number) {
        1 {
            # Errores de Application de las ultimas 24 horas: primer triaje de UiPath/IIS.
            $filter = @{ LogName = 'Application'; Level = 2; StartTime = $now.AddDays(-1) }
        }
        2 {
            # Event ID 1000: caidas de procesos como UiRobot.exe o w3wp.exe.
            $filter = @{ LogName = 'Application'; Level = 2; Id = 1000; StartTime = $now.AddDays(-1) }
        }
        3 {
            # Event ID 7036: cambios de estado registrados por Windows Service Control Manager.
            $filter = @{ LogName = 'System'; Id = 7036; StartTime = $now.AddHours(-12) }
        }
        4 {
            # Service Control Manager durante las ultimas seis horas, limitado a 10 eventos.
            $filter = @{
                LogName      = 'System'
                ProviderName = 'Service Control Manager'
                StartTime    = $now.AddHours(-6)
            }
            $maxEvents = 10
        }
        5 {
            # El mismo filtro del ejercicio 4 contra un unico equipo remoto.
            $targetComputer = @($ComputerName | Select-Object -First 1)
            $filter = @{
                LogName      = 'System'
                ProviderName = 'Service Control Manager'
                StartTime    = $now.AddHours(-6)
            }
            $maxEvents = 10
        }
        6 {
            # Auditoria simultanea de varios equipos: pasa varios nombres a -ComputerName.
            $filter = @{
                LogName      = 'System'
                ProviderName = 'Service Control Manager'
                StartTime    = $now.AddHours(-6)
            }
            $maxEvents = 10
        }
        7 {
            # Defender Operational, Event ID 1116: detecciones que pueden bloquear UiRobot.exe.
            $filter = @{
                LogName   = 'Microsoft-Windows-Windows Defender/Operational'
                Id        = 1116
                StartTime = $now.AddHours(-2)
            }
        }
        8 {
            # WAS, Event ID 5002: indicios de caida del Application Pool de IIS/Orchestrator.
            $filter = @{
                LogName      = 'System'
                Id           = 5002
                ProviderName = 'Microsoft-Windows-WAS'
                StartTime    = $now.AddHours(-1)
            }
        }
        9 {
            # Event IDs 1000 y 1026: fallo de proceso o excepcion .NET asociada a w3wp.exe.
            $filter = @{
                LogName   = 'Application'
                Id        = 1000, 1026
                StartTime = $now.AddHours(-1)
            }
        }
        10 {
            # User Profiles Service: advertencias y errores que afectan sesiones RDP/VDI.
            $filter = @{
                LogName      = 'Application'
                ProviderName = 'Microsoft-Windows-User Profiles Service'
                Level        = 2, 3
                StartTime    = $now.AddDays(-1)
            }
        }
        11 {
            # Schannel: errores TLS/certificados durante la comunicacion con Orchestrator.
            $filter = @{
                LogName      = 'System'
                Id           = 36871, 36874
                ProviderName = 'Schannel'
                StartTime    = $now.AddHours(-4)
            }
        }
    }

    try {
        Invoke-EventExercise -FilterHashtable $filter -TargetComputer $targetComputer `
            -MaxEvents $maxEvents -RemoteCredential $Credential
    }
    catch {
        # Un registro o proveedor puede no existir en todas las VMs; el resto de ejercicios continua.
        [PSCustomObject]@{
            Exercise     = $Number
            ComputerName = $targetComputer -join ', '
            Status       = 'Error'
            Error        = $_.Exception.Message
        }
    }
}

foreach ($exerciseNumber in $Exercise) {
    Write-Verbose "Ejecutando ejercicio $exerciseNumber sobre: $($ComputerName -join ', ')"
    Invoke-SelectedExercise -Number $exerciseNumber
}

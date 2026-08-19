[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string[]]$ComputerName = @('localhost'),

    [Parameter()]
    [ValidateRange(1, 100)]
    [int]$Newest = 10
)

$ErrorActionPreference = 'Stop'

try {
    foreach ($computer in $ComputerName) {
        # Application: errores recientes de aplicaciones y UiPath.
        Get-WinEvent -ComputerName $computer -FilterHashtable @{
            LogName   = 'Application'
            Level     = 2
            StartTime = (Get-Date).AddHours(-24)
        } -MaxEvents $Newest -ErrorAction Stop |
            Select-Object @{Name = 'ComputerName'; Expression = { $computer }},
                Id, ProviderName, TimeCreated, Message

        # System: cambios y errores del sistema operativo y servicios.
        Get-WinEvent -ComputerName $computer -FilterHashtable @{
            LogName       = 'System'
            Level         = 2
            StartTime     = (Get-Date).AddHours(-24)
            ProviderName  = 'Service Control Manager'
        } -MaxEvents $Newest -ErrorAction Stop |
            Select-Object @{Name = 'ComputerName'; Expression = { $computer }},
                Id, ProviderName, TimeCreated, Message
    }
}
catch {
    throw "No se pudieron consultar eventos Windows: $($_.Exception.Message)"
}

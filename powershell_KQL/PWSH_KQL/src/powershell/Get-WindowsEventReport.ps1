[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string[]]$ComputerName = @('localhost'),

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string[]]$LogName = @('Application', 'System'),

    [Parameter()]
    [ValidateSet('Error', 'Warning', 'Information')]
    [string]$EntryType = 'Error',

    [Parameter()]
    [ValidateRange(1, 1000)]
    [int]$Newest = 20,

    [Parameter()]
    [System.Management.Automation.PSCredential]$Credential
)

$ErrorActionPreference = 'Stop'

try {
    foreach ($computer in $ComputerName) {
        foreach ($log in $LogName) {
            $filter = @{ LogName = $log; Level = switch ($EntryType) { 'Error' { 2 } 'Warning' { 3 } default { 4 } } }
            $eventParameters = @{
                FilterHashtable = $filter
                MaxEvents        = $Newest
                ComputerName     = $computer
                ErrorAction      = 'Stop'
            }
            if ($Credential) { $eventParameters.Credential = $Credential }

            $events = Get-WinEvent @eventParameters
            $events | Select-Object @{Name = 'ComputerName'; Expression = { $computer }}, LogName, Id, LevelDisplayName, TimeCreated, ProviderName, Message
        }
    }
}
catch {
    throw "No se pudieron consultar eventos Windows: $($_.Exception.Message)"
}
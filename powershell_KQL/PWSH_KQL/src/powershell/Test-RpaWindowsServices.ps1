[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string[]]$ComputerName = @('localhost'),

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string[]]$ServiceName = @('UiRobotSvc', 'UiPathRobot', 'W32Time'),

    [Parameter()]
    [System.Management.Automation.PSCredential]$Credential
)

$ErrorActionPreference = 'Stop'

try {
    foreach ($computer in $ComputerName) {
        if ($computer -eq 'localhost' -or $computer -eq $env:COMPUTERNAME) {
            $services = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
        }
        else {
            $invokeParameters = @{ ComputerName = $computer; ScriptBlock = {
                param($Names)
                Get-Service -Name $Names -ErrorAction SilentlyContinue
            }; ArgumentList = (,$ServiceName) }
            if ($Credential) { $invokeParameters.Credential = $Credential }
            $services = Invoke-Command @invokeParameters
        }

        foreach ($service in $services) {
            [PSCustomObject]@{
                ComputerName = $computer
                ServiceName  = $service.Name
                Status       = [string]$service.Status
                Healthy      = $service.Status -eq 'Running'
            }
        }

        $foundNames = @($services | ForEach-Object Name)
        foreach ($missingName in ($ServiceName | Where-Object { $_ -notin $foundNames })) {
            [PSCustomObject]@{
                ComputerName = $computer
                ServiceName  = $missingName
                Status       = 'NotFound'
                Healthy      = $false
            }
        }
    }
}
catch {
    throw "No se pudo consultar el estado de los servicios RPA: $($_.Exception.Message)"
}
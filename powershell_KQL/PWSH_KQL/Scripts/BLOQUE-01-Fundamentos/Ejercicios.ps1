[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Path = 'C:\Windows\Temp'
)

$ErrorActionPreference = 'Stop'

try {
    if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
        throw "La ruta no existe o no es una carpeta: $Path"
    }

    # 1. Obtener archivos y practicar filtros por tamaño, antiguedad y extension.
    $files = Get-ChildItem -LiteralPath $Path -File -ErrorAction Stop
    $largeFiles = $files | Where-Object Length -gt 1MB
    $oldFiles = $files | Where-Object LastWriteTime -lt (Get-Date).AddDays(-7)
    $recentLogs = $files | Where-Object {
        $_.Extension -eq '.log' -and $_.LastWriteTime -gt (Get-Date).AddDays(-1)
    }

    # Mostrar resultados evita acciones destructivas durante el aprendizaje.
    [PSCustomObject]@{
        Path        = $Path
        TotalFiles  = @($files).Count
        LargeFiles  = @($largeFiles).Count
        OldFiles    = @($oldFiles).Count
        RecentLogs  = @($recentLogs).Count
    }

    # 2. Recorrer una lista y consultar servicios sin modificar su estado.
    foreach ($serviceName in @('UiRobotSvc', 'UiPathRobot', 'W32Time')) {
        $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
        [PSCustomObject]@{
            ServiceName = $serviceName
            Status      = if ($service) { [string]$service.Status } else { 'NotFound' }
        }
    }

    # 3. Practicar control de flujo con datos simulados.
    $vmStates = @(
        [PSCustomObject]@{ Name = 'VM-PROD-RPA01'; State = 'Online' }
        [PSCustomObject]@{ Name = 'VM-PRE-RPA01'; State = 'Maintenance' }
        [PSCustomObject]@{ Name = 'VM-PROD-RPA02'; State = 'Critical' }
    )

    foreach ($vm in $vmStates) {
        switch ($vm.State) {
            'Maintenance' { "[SKIP] $($vm.Name) en mantenimiento"; continue }
            'Critical'    { "[STOP] $($vm.Name) critica"; break }
            default       { "[OK] $($vm.Name) operativa" }
        }
    }
}
catch {
    throw "No se pudieron ejecutar los ejercicios: $($_.Exception.Message)"
}

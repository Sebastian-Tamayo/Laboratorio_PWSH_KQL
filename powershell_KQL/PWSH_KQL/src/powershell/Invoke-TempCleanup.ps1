[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Path = 'C:\Windows\Temp',

    [Parameter()]
    [ValidateRange(1, 3650)]
    [int]$OlderThanDays = 7
)

$ErrorActionPreference = 'Stop'

try {
    if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
        throw "La ruta no existe o no es una carpeta: $Path"
    }

    $cutoff = (Get-Date).AddDays(-$OlderThanDays)
    $files = Get-ChildItem -LiteralPath $Path -File -Force |
        Where-Object { $_.LastWriteTime -lt $cutoff }

    foreach ($file in $files) {
        if ($PSCmdlet.ShouldProcess($file.FullName, 'Eliminar archivo temporal')) {
            Remove-Item -LiteralPath $file.FullName -Force -ErrorAction Stop
        }

        [PSCustomObject]@{
            Path          = $file.FullName
            LastWriteTime = $file.LastWriteTime
            Action        = if ($WhatIfPreference) { 'WhatIf' } else { 'Removed' }
        }
    }
}
catch {
    throw "No se pudo completar la limpieza de '$Path': $($_.Exception.Message)"
}
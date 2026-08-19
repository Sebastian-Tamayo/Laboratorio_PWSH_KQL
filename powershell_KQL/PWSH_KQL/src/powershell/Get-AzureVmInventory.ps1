[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$SubscriptionId,

    [Parameter()]
    [string]$ResourceGroupName,

    [Parameter()]
    [string]$QueryPath = (Join-Path $PSScriptRoot '..\kql\resource-graph\azure-vm-inventory.kql')
)

$ErrorActionPreference = 'Stop'

try {
    Import-Module Az.Accounts, Az.ResourceGraph -ErrorAction Stop
    $context = Get-AzContext
    if (-not $context) { Connect-AzAccount -ErrorAction Stop | Out-Null }
    Set-AzContext -SubscriptionId $SubscriptionId -ErrorAction Stop | Out-Null

    $query = Get-Content -LiteralPath $QueryPath -Raw -ErrorAction Stop
    if ($ResourceGroupName) {
        $resourceGroupFilter = "| where resourceGroup =~ '$ResourceGroupName'"
        $query = $query -replace '(?m)^Resources\s*$', "Resources`n$resourceGroupFilter"
    }

    Search-AzGraph -Query $query -Subscription $SubscriptionId -First 1000 -ErrorAction Stop
}
catch {
    throw "No se pudo obtener el inventario Azure: $($_.Exception.Message)"
}
#  Prerrequisito: Autenticación contra tu tenant de Azure
# En un entorno automatizado (Runbook/Pipeline), esto se haría mediante Managed Identity.
# En tu consola local, me pide que me autentique con mi cuenta de Azure.
Connect-AzAccount

#  Definición de la Query KQL 
$queryKQL = @"
Resources
#  filtramos por tipo de recurso (Storage Account) y por región (France Central)
| where type =~ 'microsoft.storage/storageaccounts'
| where location == 'francecentral'
| project name, location, sku.name
"@

# 4. Lanzamiento del Cmdlet
# Buenas prácticas: Usa -First para limitar resultados 
$resultados = Search-AzGraph -Query $queryKQL -First 1000

# Mostrar en tabla para lectura visual rápida:
$resultados | Format-Table -AutoSize

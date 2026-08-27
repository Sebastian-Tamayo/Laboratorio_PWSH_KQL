# 1. Definimos la query KQL 
$queryKQL = @"
Resources
| where type =~ 'microsoft.storage/storageaccounts'
| where location == 'francecentral'
| project name, location, sku.name
"@

# 2. Ejecutamos la consulta contra Azure Resource Graph
$resultadoStorage = Search-AzGraph -Query $queryKQL

# 3. Mostramos el resultado por pantalla
$resultadoStorage
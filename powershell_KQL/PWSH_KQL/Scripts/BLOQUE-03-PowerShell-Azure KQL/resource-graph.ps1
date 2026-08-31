#-----------------------------------------------🪵 Ejercicio 1 de 20 (Inventariado de Storage)----------------------------------------
#El Escenario Operativo:
#Seguridad Corporativa necesita auditar las cuentas de almacenamiento de tus Buckets de UiPath.


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



#-----------------------------------------------🪵 Ejercicio 2 de 20 (Bloque 3): Detección de Cuellos de Botella (CPU)--------------------------------
#Ejercicio 2 de 10: Auditoría de Homogeneidad en VMs (Resource Graph)

#Tu responsabilidad exige asegurar la homogeneidad y el dimensionamiento correcto del hardware
#para que los robots de UiPath no se queden sin RAM. Necesitas un reporte instantáneo que te muestre qué tamaño de máquina (SKU) y qué sistema operativo tiene cada nodo.
#La Base Técnica, Tabla objetivo: Resources. Tu Misión, Construir el script de PowerShell que encapsule la consulta KQL para extraer el inventario exacto de estas 14 máquinas.

$queryKQL = @"
Resources
| where type =~ 'microsoft.compute/virtualmachines'
| where name startswith 'VM-'
| project name, resourceGroup, properties.hardwareProfile.vmSize, properties.storageProfile.osDisk.osType
"@
$resultados = Search-AzGraph -Query $queryKQL -First 1000


#-----------------------------------------------🪵 Ejercicio 3 de 10: Auditoría de Discos Huérfanos (Optimización de Costes)--------------------------------
#El Escenario Operativo:
#Asumes el control de los costes de Azure Durante los ciclos de actualización,
#cuando se destruyen VMs obsoletas de UiPath, a menudo los administradores olvidan eliminar los discos duros subyacentes (Managed Disks).
#Azure sigue facturando por estos discos inactivos mes tras mes. Necesitas un reporte de este desperdicio.
#La Base Técnica, Tabla objetivo: Resources. Tu Misión, Arma el bloque de PowerShell con KQL para identificar exclusivamente los discos que están flotando sin uso en el tenant.

$queryKQL = @"
Resources
| where type =~ 'microsoft.compute/disks'
| where properties.diskState == 'Unattached'
| project name, resourceGroup, properties.diskSizeGB

"@
$resultados = Search-AzGraph -Query $queryKQL -First 1000


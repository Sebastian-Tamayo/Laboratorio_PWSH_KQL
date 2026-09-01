# ==============================================================================
# 🪵 Ejercicio 1 de 10: Inventariado de Storage (Auditoría de Buckets)
# ==============================================================================
# El Escenario Operativo:
# Seguridad Corporativa necesita auditar las cuentas de almacenamiento de tus 
# Buckets de UiPath para garantizar la residencia de datos.

# Prerrequisito: Autenticación contra el tenant de Azure
# En producción con UiPath, esto se ejecutará vía Managed Identity sin intervención manual.
Connect-AzAccount

# Encapsulamos la consulta KQL en un Here-String
$queryKQL = @"
Resources
// Aislamos el tipo de recurso correspondiente a Storage Accounts
| where type =~ 'microsoft.storage/storageaccounts'
// Garantizamos que los datos residen en la región aprobada por Randstad (France Central)
| where location == 'francecentral'
// Proyectamos columnas clave para el reporte de Seguridad
| project name, location, sku.name
"@

# Invocamos la API de Resource Graph. 
# Buena práctica: Usar -First 1000 protege la memoria del host o del robot que ejecuta el script.
$resultados = Search-AzGraph -Query $queryKQL -First 1000

# Formateo tabular para lectura rápida en consola
$resultados | Format-Table -AutoSize

# ==============================================================================
# 🪵 Ejercicio 2 de 10: Auditoría de Homogeneidad en VMs
# ==============================================================================
# El Escenario Operativo: 
# Tu responsabilidad exige asegurar la homogeneidad y el dimensionamiento 
# correcto del hardware para que los robots de UiPath no se queden sin RAM. 
# Necesitas un reporte instantáneo con el tamaño de máquina (SKU) y el 
# sistema operativo de cada nodo.

$queryKQL = @"
Resources
// Filtramos estrictamente por el proveedor de cómputo para aislar VMs
| where type =~ 'microsoft.compute/virtualmachines'
// Aislamos nuestras 14 máquinas de la suscripción filtrando por prefijo corporativo
name startswith 'VM-'
// Navegación JSON: Extraemos SKU y SO para validar que soportan la concurrencia de UiPath
| project name, resourceGroup, properties.hardwareProfile.vmSize, properties.storageProfile.osDisk.osType
"@

$resultados = Search-AzGraph -Query $queryKQL -First 1000

# ==============================================================================
# 🪵 Ejercicio 3 de 10: Auditoría de Discos Huérfanos (Optimización de Costes)
# ==============================================================================
# El Escenario Operativo: 
# Asumes el control de los costes de Azure. Tras destruir VMs obsoletas de UiPath, 
# a menudo quedan discos duros subyacentes (Managed Disks). Azure sigue facturando 
# por ellos. Necesitas un reporte de este desperdicio.

$queryKQL = @"
Resources
// Apuntamos al tipo de recurso de discos administrados
| where type =~ 'microsoft.compute/disks'
// 'Unattached' indica que el disco está huérfano y consume presupuesto mensual en vano
| where properties.diskState == 'Unattached'
// Proyectamos el tamaño en GB para cuantificar la fuga económica
| project name, resourceGroup, properties.diskSizeGB
"@

$resultados = Search-AzGraph -Query $queryKQL -First 1000

# ==============================================================================
# 🪵 Ejercicio 4 de 10: Auditoría de IPs Públicas (Seguridad Zero-Trust)
# ==============================================================================
# El Escenario Operativo: 
# Los clústeres de UiPath ejecutan procesos críticos desatendidos. Bajo el estándar 
# Zero-Trust, ninguna VM debe tener una IP pública. Todo tráfico pasa por Azure Bastion 
# o VPN. Necesitas verificar incumplimientos de esta política.

$queryKQL = @"
Resources
// Localizamos recursos de red tipo IP pública (riesgo crítico de exposición)
| where type =~ 'microsoft.network/publicipaddresses'
// Extraemos la IP exacta y su método de asignación para proceder a su bloqueo/eliminación
| project name, resourceGroup, properties.ipAddress, properties.publicIPAllocationMethod
"@

$resultados = Search-AzGraph -Query $queryKQL -First 1000

# ==============================================================================
# 🪵 Ejercicio 5 de 10: Auditoría de Imágenes de SO (Parcheo)
# ==============================================================================
# El Escenario Operativo: 
# Seguridad necesita el informe de las versiones de sistema operativo de tus 14 máquinas 
# para coordinar la ventana de parcheo. Debes confirmar que todas nacieron de la 
# misma imagen base para evitar incompatibilidades con los runtimes de UiPath.

$queryKQL = @"
Resources
// Aislamos las máquinas virtuales de la suscripción
| where type =~ 'microsoft.compute/virtualmachines'
// Filtramos exclusivamente los nodos gestionados para UiPath
| where name startswith 'VM-'
// Descendemos por el árbol JSON para verificar la homogeneidad de la imagen base
| project name, properties.storageProfile.imageReference.offer, properties.storageProfile.imageReference.sku, properties.storageProfile.imageReference.version
"@

$resultados = Search-AzGraph -Query $queryKQL -First 1000

# ==============================================================================
# 🪵 Ejercicio 6 de 10: Auditoría de Storage Accounts (Acceso Público)
# ==============================================================================
# El Escenario Operativo: 
# Los procesos desatendidos de UiPath en Randstad generan logs y datos transaccionales 
# que se almacenan en Buckets sobre Azure Storage Accounts. Bajo el estándar Zero-Trust, 
# ningún Storage Account debe permitir el acceso anónimo o público a sus contenedores.

$queryKQL = @"
Resources
// Aislamos el tipo de recurso correspondiente a cuentas de almacenamiento
| where type =~ 'microsoft.storage/storageaccounts'
// Evaluamos la propiedad booleana que expone la vulnerabilidad de acceso público
| where properties.allowBlobPublicAccess == true
// Proyectamos el nombre, grupo de recursos y la propiedad vulnerada
| project name, resourceGroup, properties.allowBlobPublicAccess
"@

$resultados = Search-AzGraph -Query $queryKQL -First 1000


# ============================================================================
# Ejercicio 8 de 10: Auditoría de Agentes y Extensiones (EDR/Monitorización)
# ==============================================================================

#El Escenario Operativo:
#Tus 14 VMs ejecutan procesos desatendidos de UiPath que necesitan extraer credenciales de Azure Key Vault
#Necesitas auditar rápidamente si a alguna de tus máquinas de producción o preproducción le falta habilitar esta identidad.
#Lista las máquinas virtuales y extrae el estado actual de su identidad administrada.

$queryKQL = @"
Resources
// Aislamos las máquinas virtuales de la suscripción
| where type == "microsoft.compute/virtualmachines"
// Filtramos exclusivamente los nodos gestionados para UiPath
| where name startswith 'VM-'
//Proyectamos la configuración de identidad
| project identity, name, resourceGroup, identity.type
"@

$resultados = Search-AzGraph -Query $queryKQL -First 1000

# ==============================================================================
#  Ejercicio 8 de 10: Auditoría de Agentes y Extensiones (EDR/Monitorización)
# ==============================================================================

#El Escenario Operativo:
#Para que Log Analytics pueda recibir la telemetría (Event Viewer) y el SOC pueda monitorizar bloqueos,
#Necesita listar todas las extensiones instaladas en los nodos de cómputo para detectar si alguna de tus 14 VMs está "ciega" operativamente.
#Escribe el script de PowerShell documentado para inventariar las extensiones de máquina virtual.

$queryKQL = @"
Resources
// Aislamos las extensiones de las máquinas virtuales de la suscripción
| where type == "microsoft.compute/virtualmachines/extensions"
// filtramos evaluando si la columna tiene el prefijo VM
| where id contains 'VM-'
//proyectamos visibilidad al equipo de seguridad
| project name, resourceGroup, properties.publisher, properties.type

"@

$resultados = Search-AzGraph -Query $queryKQL -first 1000
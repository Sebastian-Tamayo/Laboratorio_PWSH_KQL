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
#El Escenario Operativo:
#Son las 11:30 AM. El Servicio AM te reporta que los procesos de los robots en producción están fallando por Timeouts. Sabes que el motor de UiPath consume mucha máquina cuando procesa automatizaciones pesadas. Necesitas saber si alguna de tus 10 máquinas de producción ha superado el 90% de uso de CPU en la última hora.

#La Base Técnica:
#Estás en tu consola de Azure Log Analytics. Los datos de rendimiento de las VMs de Windows se ingieren en una tabla llamada Perf.

Perf
| where ObjectName == "Processor"
| where CounterName == "% Processor Time"
# Filtro de tiempo  
| where TimeGenerated > ago(1h)
# Filtro de Nodos
| where Computer startswith "VM-PROD"
# Filtro de Umbral Crítico
| where CounterValue > 90
# Limpieza Visual
| project TimeGenerated, Computer, CounterValue


#-----------------------------------------------🪵Ejercicio 3 de 20: Análisis de Errores Críticos (Event Viewer Centralizado)--------------------------------
#Varios procesos desatendidos de UiPath en PRO reportan fallos esporádicos al interactuar con un aplicativo interno. Necesitas auditar las excepciones de .NET 
#y errores de aplicación en los 10 nodos de producción simultáneamente para descartar fallos globales de infraestructura.
#Tu Misión:
#Atacar la tabla de eventos unificados y filtrar los registros exactos.

#La Base Técnica:

#Fragmento de código

Event
#Filtrado de tiempo
| where TimeGenerated > ago(4h)
#Filtrado de Nodos
| where Computer startswith "VM-PROD"
#Filtrado de registro
| where EventLog == "Application"
#Los events IDs
| where EventID in(1000, 1026)
#El Mensaje del Error
| project TimeGenerated, Computer, EventID, RenderedDescription
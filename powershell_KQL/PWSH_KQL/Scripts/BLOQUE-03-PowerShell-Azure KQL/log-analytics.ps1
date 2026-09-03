# ==============================================================================
#  Ejercicio 1 de 10: Detección de Cuellos de Botella (Memoria)
# ==============================================================================

#El Escenario Operativo:
#Es tu primera guardia. Un proceso desatendido de UiPath se ha colgado intentando cruzar datos en un Excel masivo
#No puedes acceder por RDP a la VM en Azure Francia porque está totalmente bloqueada
#Escribe el script de PowerShell documentado para buscar alertas de agotamiento de memoria en el visor de eventos de Windows

$queryKQL = @"
//tabla maestra de telemetría de Windows en Azure Monitor
Event
//Filtra el canal del registro de logs en el sistema
| where EventLog == "System"
//Aplica el filtro para el Event ID de Resource Exhaustion Detector
| where EventID == 2004
//Columnas que contienen el mensaje de qué proceso consumió toda la RAM
| project TimeGenerated, Computer, RenderedDescription 

"@

Invoke-AzoperationalInsightsQuery -WorkspaceId "ID-workspace" -Query $queryKQL

# ==============================================================================
#  Ejercicio 2 de 10: Diagnóstico de caídas del IIS en UiPath Orchestrator
# ==============================================================================
#Orchestrator está inaccesible y devuelve un "Error 503 Service Unavailable" en el navegador.
#Los robots no pueden descargar nuevos Jobs y la producción está paralizada.
#Escribe el script documentado de PowerShell para extraer los errores críticos del servicio web en la última hora y confirmar si el IIS apagó el pool de Orchestrator.

$queryKQL = @"
Event
//Umbral de tiempo
| where TimeGenerated > ago(1h)
//Componente WAS
| where Source =="Microsoft-Windows-WAS"
//Gravedad
| where EventLevelName == "Error"
//  Proyectamos las columnas de triaje
| project TimeGenerated, Computer, EventID, RenderedDescription

"@

Invoke-AzoperationalInsightsQuery -WorkspaceId "ID-workspace" -Query $queryKQL
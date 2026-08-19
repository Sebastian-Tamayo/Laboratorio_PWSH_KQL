Bloque 3: Azure Log Analytics y Resource Graph (KQL)
   Contexto y Valor de Negocio: Observabilidad Cloud
El Problema Operativo:
Administrar infraestructura a escala mediante RDP secuencial o bucles de PowerShell tradicionales (Get-AzVM) no es escalable. Genera throttling en la API, tiempos de respuesta inaceptables en crisis y puntos ciegos en la auditoría de seguridad.

La Solución Técnica:
Adopción del motor Azure Resource Graph y Log Analytics. Utilización intensiva de KQL (Kusto Query Language) para interrogar la base de datos subyacente de Azure, permitiendo inventariado global en milisegundos y correlación de telemetría de todos los nodos del clúster RPA en tiempo real.

El Impacto en Negocio:
Cumplimiento estricto de las normativas de residencia de datos (asegurando recursos en Azure Francia), visibilidad centralizada del estado de los 14 nodos de UiPath, e identificación casi instantánea de cuellos de botella en la infraestructura.
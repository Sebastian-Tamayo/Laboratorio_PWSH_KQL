**BLOQUE 2: Windows Event Viewer, Troubleshooting y Servicios

Dominio de:
-------Service Control Manager (SCM):-------
 Diagnóstico de servicios caídos o colgados en los nodos de UiPath.

-------Microsoft Defender (EDR): -------
Detección de bloqueos de falsos positivos en ejecutables clave como UiRobot.exe.

-------Windows Process Activation Service (WAS) e IIS: -------
Identificación de colapsos del Application Pool de Orchestrator.

-------.NET Framework y Application Logs: -------
Búsqueda de excepciones internas y caídas de procesos (Event IDs 1000 y 1026).

-------User Profiles Service: -------
Detección de cuellos de botella en sesiones RDP que bloquean a los robots desatendidos.

Schannel: Troubleshooting de conectividad segura, túneles TLS y fallos de certificados.

Este módulo documenta las herramientas, cmdlets y prácticas de administración empleadas para la monitorización proactiva y el diagnóstico rápido de incidentes en un clúster de producción de 14 VMs en Azure (soportando el ecosistema de UiPath). El objetivo principal es reducir el *Mean Time to Resolve* (MTTR) durante incidencias críticas.

**Competencias Técnicas y Operativas:

**Consultas Optimizadas de Logs (`Get-WinEvent`):** Implementación de filtrado avanzado en origen mediante `-FilterHashtable` y consultas XML. Esta técnica delega la carga de procesamiento al motor de eventos de Windows, evitando la saturación de memoria (RAM) en los nodos de producción al no traer datos innecesarios a la consola.
**Auditoría de Servicios Críticos (SCM):** Aislamiento y extracción de eventos del *Service Control Manager* para detectar de forma instantánea caídas, bloqueos o reinicios en procesos vitales como el motor de robots (`UiRobotSvc`), pools de IIS y posibles interrupciones causadas por el agente de EDR/Antivirus.
**Troubleshooting a Gran Escala:** Configuración de consultas de ejecución remota masiva (mediante el parámetro `-ComputerName` y arrays de servidores). Esto permite auditar los registros de todo el clúster de Azure de forma simultánea, eliminando el cuello de botella y la latencia que supone establecer sesiones RDP individuales por máquina.
**Gestión de Rendimiento en Triaje:** Aplicación de limitadores de salida (como `-MaxEvents`) para garantizar respuestas inmediatas de la terminal durante la resolución de caídas de infraestructura.

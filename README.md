***-------------------------------------------Contexto y Valor de Negocio------------------------------------------- Este repositorio documenta el diseño operativo y la automatización de la infraestructura que da soporte a un clúster crítico de RPA (UiPath). Gestionar 14 máquinas virtuales (10 PRO / 4 PRE) alojadas en Azure de forma manual es inasumible, genera puntos ciegos y retrasa los pases a producción.

El objetivo de este proyecto es estandarizar la administración del entorno mediante la automatización con PowerShell, centralizar la observabilidad con KQL y asegurar el acceso a credenciales utilizando los estándares nativos de seguridad de Azure.

------------------------------------------- Hoja de Ruta Operativa------------------------------------------- El proyecto está dividido en 4 grandes bloques de implementación:

Bloque 1: PowerShell y Mantenimiento de VMs: Filtrado avanzado, tuberías y automatización estricta para la purga de temporales y optimización de recursos en los nodos.

Bloque 2: Windows Event Viewer y Troubleshooting: Diagnóstico profundo sin interfaz gráfica. Resolución proactiva de caídas de IIS, bloqueos de antivirus (EDR) y cuellos de botella en sesiones RDP que afectan a los robots.

Bloque 3: Azure Log Analytics, KQL y Resource Graph: Observabilidad centralizada. Inventariado exprés de infraestructura y análisis de telemetría en tiempo real con Kusto Query Language.

Bloque 4: UiPath Platform y Seguridad Cloud: Hardening del entorno RPA. Integración de Orchestrator con Azure Key Vault vía Managed Identities (cero contraseñas en código), gestión de GPOs para VDIs y control del clúster.

-------------------------------------------Impacto------------------------------------------- Reducción drástica del MTTR (Mean Time To Recovery), aseguramiento del cumplimiento corporativo (Azure Francia) y eliminación de tareas mecánicas en favor de operaciones programáticas fiables.

# Bloque 03: PowerShell Azure

Este bloque queda preparado, pero sin ejercicios implementados hasta que se practiquen las consultas en el portal Azure.

- Los ejercicios practicados en **Resource Graph Explorer** se incorporan en `resource-graph.ps1`
- Los ejercicios practicados de Log Analytics se en `log-analytics.ps1`.
- El resultado final debe ser PowerShell. La consulta KQL solo se guardara dentro del script si el comando PowerShell necesita enviarla al servicio.

## Método de trabajo

1. La consulta se practica directamente en Resource Graph Explorer o Logs del portal Azure.
2. La tabla, las columnas, el alcance y los resultados se comprueban en un entorno de pruebas.
3. El comando PowerShell que ejecuta o consume el ejercicio se incorpora a `resource-graph.ps1`o `log-analytics.ps1`
5. El script se prueba con alcance reducido antes de consultar producción.

No hay consultas ni conexión Azure implementadas todavía en este bloque. No se mantienen archivos `.kql` ni carpetas separadas para estos servicios.

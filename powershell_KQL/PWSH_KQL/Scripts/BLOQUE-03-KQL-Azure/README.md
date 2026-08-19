# Bloque 03: KQL en Azure

## Objetivo

Separar inventario Azure y observabilidad de VMs/RPA mediante KQL.

## Ubicación de consultas

- `src/kql/resource-graph/azure-vm-inventory.kql`: se ejecuta en Azure Resource Graph Explorer; usa la tabla `Resources`.
- `src/kql/log-analytics/vm-errors.kql`: se ejecuta en Logs de un Workspace; usa `WindowsEvent` si el agente y el conector están configurados.
- `src/kql/log-analytics/rpa-service-health.kql`: usa `Perf` y depende de contadores enviados por Azure Monitor Agent.

Las tablas y columnas dependen de la configuración de diagnóstico. Validar primero en PRE y ajustar el esquema del Workspace antes de usarlo en PRO.

## Regla operativa

Usa Resource Graph para inventario y Log Analytics para telemetría. No reemplaces consultas KQL por bucles de PowerShell sobre las 14 VMs salvo que exista una necesidad concreta.

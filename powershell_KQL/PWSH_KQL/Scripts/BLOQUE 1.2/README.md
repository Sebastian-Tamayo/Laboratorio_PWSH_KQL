
## Arquitectura del Cmdlet: Parametrización y Control de Flujo

El código ha sido refactorizado pasando de ser un script secuencial a una **Función Avanzada (Cmdlet)** de PowerShell, diseñada para integrarse en pipelines de automatización y tareas programadas sobre el clúster de VMs en Azure.

###  Características Técnicas Implementadas:

**Parametrización Avanzada (`[CmdletBinding]`)**: Conversión de la función a un cmdlet nativo, habilitando el soporte de tuberías (Pipeline) mediante `ValueFromPipeline`. Esto permite procesar listas masivas de servidores provenientes de consultas a Azure Resource Graph.
**   **Sanitización y Validación Estricta**:
**   `[ValidateNotNullOrEmpty()]`: Previene bloqueos por variables de entrada vacías.
**   `[ValidateScript]`: Fuerza el cumplimiento de la nomenclatura corporativa (ej. servidores que comiencen por `"VM-"`), protegiendo máquinas fuera del alcance.
**   `[ValidateSet]`: Restringe la ejecución de forma nativa a los entornos autorizados (`"PRO"`, `"PRE"`).
**   **Tolerancia a Fallos (`try/catch`)**: Abandono de condicionales simples en favor de manejo de excepciones estructural. Si un nodo UiPath cae, pierde red o falla el servicio WinRM, el error se captura (`$_.Exception.Message`) como estado "Offline", pero **el bucle continúa**, garantizando la auditoría del resto de la granja sin detener el pipeline.
**   **Splatting**: Despliegue de argumentos de ejecución mediante tablas hash para maximizar la legibilidad y mantenibilidad del código en producción.

- Parametrización y Funciones
# Referencia de Get-WinEvent

`Get-WinEvent` filtra eventos en el origen mediante `-FilterHashtable`, reduciendo datos transferidos y memoria usada.

| Parámetro | Uso |
| --- | --- |
| `LogName` | Registro, por ejemplo `Application` o `System`. |
| `Level` | Severidad: 1 crítico, 2 error, 3 advertencia, 4 información. |
| `Id` | Identificador concreto del evento. |
| `StartTime`, `EndTime` | Ventana temporal de la consulta. |
| `ProviderName` | Componente que generó el evento. |
| `-MaxEvents` | Límite de resultados devueltos. |

Ejemplo seguro de consulta local:

```powershell
Get-WinEvent -FilterHashtable @{
    LogName   = 'System'
    Level     = 2
    StartTime = (Get-Date).AddHours(-4)
} -MaxEvents 20
```

En consultas remotas valida WinRM, permisos y nombres de equipo antes de ejecutar sobre PRO.

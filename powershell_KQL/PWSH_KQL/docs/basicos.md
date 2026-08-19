# Referencia rápida de PowerShell

## Objetos y filtros

- `.Name`: nombre del objeto.
- `.FullName`: ruta completa.
- `.Length`: tamaño en bytes.
- `.LastWriteTime`: última modificación.
- `Where-Object`: filtra objetos antes de mostrarlos o modificarlos.
- `Select-Object`: limita las propiedades de salida.

```powershell
Get-ChildItem -Path C:\Windows\Temp -File |
    Where-Object Length -gt 1MB |
    Select-Object Name, Length, LastWriteTime
```

## Cmdlets útiles

```powershell
Get-Process
Get-Service
Get-ScheduledTask
Get-Disk
Get-NetAdapter
Get-CimInstance -ClassName Win32_OperatingSystem
```

Para eventos nuevos usa `Get-WinEvent` y limita la consulta con `-FilterHashtable` y `-MaxEvents`.

## Git

```powershell
git clone '<repository-url>'
git pull origin main
git add .
git commit -m 'Refactorizado.'
git push origin main
```

Estos son ejemplos de referencia; ejecuta cambios sobre el repositorio corporativo siguiendo su flujo de revisión.

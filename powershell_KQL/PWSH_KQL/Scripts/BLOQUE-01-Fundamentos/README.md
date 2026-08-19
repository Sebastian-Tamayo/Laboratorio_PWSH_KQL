# Bloque 01: Fundamentos de PowerShell

## Objetivo

Practicar variables, propiedades de objetos, filtros, bucles y manejo básico de errores sobre ejemplos de administración Windows.

## Ejecución

`Ejercicios.ps1` contiene ejemplos didácticos. Cada sección debe ejecutarse de forma independiente y únicamente en una VM de laboratorio con los permisos adecuados. Los ejercicios que consultan `C:\Windows\Temp`, servicios o eventos no están destinados a ejecución directa en producción.

## Criterios

- Preferir rutas explícitas y cmdlets completos.
- Filtrar antes de mostrar o modificar objetos.
- Usar `-ErrorAction Stop` cuando el ejercicio trate errores.
- Simular operaciones destructivas con `-WhatIf`.

Para mantenimiento real, el repositorio proporciona `src/powershell/Invoke-TempCleanup.ps1`, parametrizado y protegido con `SupportsShouldProcess`.

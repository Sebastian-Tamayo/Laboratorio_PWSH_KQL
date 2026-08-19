# Bloque 01: Fundamentos de PowerShell

## Objetivo

Practicar variables, propiedades de objetos, filtros, bucles y manejo básico de errores sobre ejemplos de administración Windows.

## Ejecución

`Ejercicios.ps1` contiene ejemplos didácticos. Lee cada sección y ejecuta solo el fragmento que estés estudiando. Los ejercicios que consultan `C:\Windows\Temp`, servicios o eventos requieren una VM de laboratorio y permisos adecuados.

## Criterios

- Preferir rutas explícitas y cmdlets completos.
- Filtrar antes de mostrar o modificar objetos.
- Usar `-ErrorAction Stop` cuando el ejercicio trate errores.
- Simular operaciones destructivas con `-WhatIf`.

Para mantenimiento real usa `src/powershell/Invoke-TempCleanup.ps1`, que ya está parametrizado y protegido con `SupportsShouldProcess`.

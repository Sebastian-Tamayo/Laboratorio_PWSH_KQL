#----------------------Navegar por la ruta de los logs del sistema operativo------------------------
#desde esta ubicacion se ejecuta el script
Set-Location C:\Windows\Logs
Set-Location C:\Windows\Temp
#crea un objeto que contiene todos los archivos con extension .log
$logs = Get-ChildItem -Filter *.log 
#Enseña el nombre y la fecha de modificacion de los archivos de la variable $logs y muestra la informacion en un panel de control
$logs | Select-Object Name, LastWriteTime | Out-GridView

#----------------------Foreach and IF ------------------------
# 1. Obtener la lista de archivos .log
$logs = Get-ChildItem -Path "C:\Windows\Logs" -Filter *.log

# 2. Recorrer cada archivo de la lista
foreach ($archivo in $logs) {
    # 3. Evaluar si supera los 5 MB
    if ($archivo.Length -gt 5MB) {
        # 4. Eliminar el archivo
        #para hacer simulacion en produccion se puede comentar la linea de eliminacion y mostrar un mensaje en pantalla
        Remove-Item $archivo.FullName -WhatIf
    }
}


#limpieza de archivos temporales de mi pc 
# 1. Validar que la carpeta existe en el disco
if (Test-Path -Path "C:\Windows\Temp") {

    # 2. Obtener y guardar solo los archivos mayores a 1KB
    $temporales = Get-ChildItem -Path "C:\Windows\Temp" | Where-Object { $_.Length -gt 1KB }

    # 3. Validar si la variable $temporales contiene archivos
    if ($temporales) {
        # 4. Simular el borrado de los archivos encontrados
        $temporales | Remove-Item 
    } else {
        Write-Output "La carpeta existe, pero no hay archivos mayores a 1KB para eliminar."
    }

} else {
    Write-Output "La carpeta C:\Windows\Temp no existe."
}


try {Remove-Item $archivo.FullName -ErrorAction Stop}

catch {
    Write-Host "No se pudo eliminar el archivo: $($_.Exception.Message)"
}

#ensamblado de bucle completo
foreach ($archivo in $temporales) {
    if ($archivo.Length -gt 5MB) {
        try {
            Remove-Item $archivo.FullName -ErrorAction Stop
            Write-Host "Archivo eliminado: $($archivo.Name)"
        } catch {
            Write-Host "No se pudo eliminar el archivo: $($archivo.Name). Error: $($_.Exception.Message)"
        }
    }
}
#----------------------------------------------🧱 BLOQUE 1: Variables y Filtros (Ejercicio 1 de 10)------------------
#📂.
#1.#- eliminar archivos temporales en C:\Windows\Temp
$archivosTemp = Get-ChildItem -Path "C:\Windows\Temp" -File | Where-Object { $_.Extension -eq ".log" }
remove-item -Path $archivosTemp.FullName -Force

#2.#- Queremos revisar la carpeta "C:\Windows\Temp" y guardar en la variable $archivosGrandes únicamente los archivos que ocupen más de 1 Megabyte (1MB).
$archivosGrandes = Get-ChildItem -Path "C:\Windows\Temp" -File | Where-Object {$_.Length -gt 1MB}
Write-Output "Archivos guardados en la variable correctamente "

#3. #-Queremos revisar la carpeta "C:\Windows\Temp" y guardar en la variable $archivosAntiguos únicamente los archivos cuya fecha de última modificación 
#(LastWriteTime) sea anterior a hace 7 días (es decir, archivos con más de 7 días de antigüedad).

#4.#- archivos de temp de antes de 7 dias 
$archivosAntiguos = Get-ChildItem -Path "C:\Windows\Temp" -File | Where-Object{$_.LastWriteTime -lt (Get-Date).AddDays(-7) }

#5#- Revisar la carpeta "C:\Windows\Temp" y guardar en la variable $archivosRelevantes únicamente los archivos cuya extensión NO sea ".tmp".
$archivosRelevantes = Get-ChildItem -Path "C:\Windows\Temp" -File | Where-Object{$_.Name -notlike "tmp*" -and $_.Length -gt 500KB }  

#6#- Un job de UiPath Orchestrator acaba de fallar en una de las 14 VMs y necesitas aislar rápidamente los archivos de registro recientes descartando logs viejos.
$logsRecientes = Get-ChildItem -Path "C:\Windows\Temp" -File | Where-Object{$_.Extension -eq ".log" -and $_.LastWriteTime -gt (Get-Date).AddDays(-1) }

#7#- Recorrer los archivos .log de la carpeta "C:\Windows\Temp" e imprimir en pantalla una frase exacta para cada uno usando este formato: "Archivo: <Nombre> - Tamaño: <TamañoEnKB> KB"
$archivosTemp = Get-ChildItem -Path "C:\Windows\Temp" -File | Where-Object { $_.Extension -eq ".log" } | ForEach-Object { "Archivo: $($_.Name) - Tamaño: $($_.Length / 1KB) KB" }

#---------------------------------------🧱 BLOQUE 2: Control de Flujo e Iteración (Ejercicio 2 de 10)-------------------
#1- Escribe un bloque de código que utilice la estructura foreach para recorrer la lista, consultar el estado de cada servicio con Get-Service e imprimir en pantalla el siguiente 
#texto exacto para cada uno:"Servicio: <Nombre> - Estado: <Status>"
$servicios = @("UiRobotSvc", "W32Time", "Spooler") 
foreach ($servicio in $servicios)
{$infodetalles = Get-Service -Name $servicio
"Servicio: $($infodetalles.Name) - Estado: $($infodetalles.Status)"}

#2- Dada la misma lista de servicios: $servicios = @("UiRobotSvc", "W32Time", "Spooler"),Dada la misma lista de servicios: $servicios = @("UiRobotSvc", "W32Time", "Spooler"),l 
#Escribe un bloque de código usando foreach e if / else que recorra los servicios y valide lo siguiente:
#Si el servicio está ejecutándose (Status -eq "Running"), imprime:
#"[OK] El servicio $($s.Name) está activo."
#Si el servicio NO está ejecutándose, imprime:
#"[ALERTA] El servicio $($s.Name) está detenido."

$servicios = @("UiRobotSvc", "W32Time", "Spooler")
foreach ($servicio in $servicios){
$s = Get-Service -Name $servicio

if ($s.Status -eq "Running")
{Write-Host "[OK] El servicio $($s.Name) está activo."}
else 
{Write-Host "[ALERTA] El servicio $($s.Name) está detenido."}
}

#3- #Escribe un bloque de código utilizando la estructura switch que evalúe $estadoJob e imprima por pantalla un mensaje personalizado según el caso:
#NOWN] Estado de Job no reconocido."

$estadoJob = "Faulted"

switch ($estadoJob) {
    "Successful"    { "[INFO] El Job terminó con éxito." }
    "Faulted"       { "[CRITICAL] El Job falló en producción." }
    "Stopped"       { "[WARNING] El Job fue detenido manualmente." }
     default        {  "[UNKNOWN] Estado de Job no reconocido."}
}

#4.-Escribe un bloque de código usando foreach e if / else que recorra la lista $vmsDisco y evalúe la propiedad .FreeGB:
#1. -Si la máquina tiene menos de 10 GB libres (-lt 10), imprime:
#"[CRITICAL] $($vm.Nombre) requiere purga urgente. Espacio libre: $($vm.FreeGB) GB"

#2- En caso contrario (else), imprime:
#"[OK] $($vm.Nombre) espacio suficiente. Espacio libre: $($vm.FreeGB) GB"

$vmsDisco = @(
    [PSCustomObject]@{ Nombre = "VM-PROD-RPA01"; FreeGB = 25 },
    [PSCustomObject]@{ Nombre = "VM-PROD-RPA02"; FreeGB = 6 },
    [PSCustomObject]@{ Nombre = "VM-PRE-RPA01";  FreeGB = 45 },
    [PSCustomObject]@{ Nombre = "VM-PROD-RPA03"; FreeGB = 8 }
)
    
foreach ($vm in $vmsDisco) {
if ($vm.FreeGB -lt 10)
{ Write-host "[CRITICAL] $($vm.Nombre) requiere purga urgente. Espacio libre: $($vm.FreeGB) GB"}
else
{ Write-host "[OK] $($vm.Nombre) espacio suficiente. Espacio libre: $($vm.FreeGB) GB"}
}

#5.- Escribe un bloque de código utilizando ⁠foreach⁠ que recorra el array ⁠$logs⁠ y ejecute ⁠Get-EventLog⁠ para extraer únicamente los 3 eventos más recientes de tipo ⁠Error⁠ de cada registro.

$logs = @("Application", "System")
foreach ($log in $logs){
    $s = Get-EventLog -LogName $log -EntryType Error -Newest 3
    foreach ($e in $s){
    Write-Host $e.Message}
}
#🛠️ Escenario de Producción:
#Auditaremos el estado de salud del pool de VMs de UiPath en Azure Francia antes de desplegar un paquete con UiPath Solutions Management.
#Tienes la siguiente estructura de datos en memoria:
#📝 Tu Tarea:
#Escribe un bucle foreach ($vm in $vms) que recorra el array e implemente las siguientes reglas:
#Si el estado es "Maintenance", imprime "[SKIP] $($vm.Nombre) en mantenimiento" y ejecuta continue.
#Si el estado es "Critical", imprime "[STOP] $($vm.Nombre) crítica. Abortando revisión" y ejecuta break.
#En cualquier otro caso (else), imprime "[OK] $($vm.Nombre) operativa".


$vms = @(
    [PSCustomObject]@{ Nombre = "VM-PROD-01"; Estado = "Online" },
    [PSCustomObject]@{ Nombre = "VM-PROD-02"; Estado = "Maintenance" },
    [PSCustomObject]@{ Nombre = "VM-PROD-03"; Estado = "Critical" },
    [PSCustomObject]@{ Nombre = "VM-PROD-04"; Estado = "Online" }
)
foreach ($vm in $vms){
if ( $vm.Estado -eq "Maintenance" ) 
{ Write-Host "[SKIP] $($vm.Nombre) en mantenimiento"            
continue }
elseif ($vm.Estado -eq "Critical") 
{Write-Host "[STOP] $($vm.Nombre) crítica. Abortando revisión"
break}
else
{Write-Host "[OK] $($vm.Nombre) operativa"}
}
#🧱 BLOQUE 2: Control de Flujo e Iteración (Ejercicio 8 de 10)
#🛠️ Escenario de Producción:
#En la administración de las 14 VMs en Azure Francia, al ejecutar acciones de mantenimiento sobre servicios o procesos, pueden ocurrir fallos imprevistos (servicios inexistentes, falta de permisos, bloqueos). Para evitar que el script colapse, se utiliza el manejo de excepciones con try / catch.
#📝 Tu Tarea:
#Escribe un bloque que intente detener un servicio inexistente usando Stop-Service:
#En el bloque try, ejecuta: Stop-Service -Name "ServicioInexistente" -ErrorAction Stop.
#En el bloque catch, captura la excepción e imprime: "[ERROR] No se pudo detener el servicio: $_".
#💡 Pistas:
#La estructura base es try { ... } catch { ... }.
#El parámetro -ErrorAction Stop es indispensable porque convierte un error común en un error terminante (terminating error), lo que obliga a PowerShell a saltar al bloque catch.
#La variable automática $_ dentro del catch almacena el mensaje del error capturado.
#¿Cómo escribirías este bloque try / catch en PowerShell? 💻

try {
Stop-Service -Name "ServicioInexistente" -ErrorAction Stop
}
catch{
Write-Output"[ERROR] No se pudo detener el servicio porque no existe : $_"
}

#🧱 BLOQUE 2: Control de Flujo e Iteración (Ejercicio 9 de 10)
#Avanzamos al penúltimo ejercicio de este bloque.
#🛠️ Escenario de Producción:
#Para monitorizar la salud del runtime de UiPath en las VMs de Azure Francia 🇨🇱, necesitas filtrar de forma rápida qué servicios críticos están detenidos antes de enviar una alerta a Azure Monitor.
#Tienes el siguiente array de objetos:
#📝 Tu Tarea:
#Utiliza el cmdlet Where-Object (o la canalización |) para filtrar $serviciosRPA y guardar en una variable llamada $detenidos únicamente aquellos objetos cuyo .Estado sea igual a "Stopped".


$serviciosRPA = @(
    [PSCustomObject]@{ Nombre = "UiRobotSvc"; Estado = "Running" },
    [PSCustomObject]@{ Nombre = "OrchestratorTriggers"; Estado = "Stopped" },
    [PSCustomObject]@{ Nombre = "UiPathAgent"; Estado = "Running" }
)
$detenidos = $serviciosRPA | Where-Object { $_.Estado -eq "Stopped" }
Write-Host $detenidos

#🧱 BLOQUE 2: Control de Flujo e Iteración (Ejercicio 10 de 10)
#Llegamos al último ejercicio de este bloque para cerrar con broche de oro. 🚀
#🛠️ Escenario de Producción:
#En el servidor de UiPath, tras detectar qué servicios críticos están caídos, no necesitas ver todo el objeto completo, sino extraer únicamente los nombres de los servicios afectados para pasárselos a una rutina de reinicio o a un log de auditoría.
#📝 Tu Tarea:
#Escribe una cadena de comandos en tubería que, partiendo de $serviciosRPA:
#Filtre los servicios cuyo Estado sea igual a "Stopped".
#Pase ese resultado por otra tubería (|) para seleccionar únicamente la propiedad Nombre utilizando el cmdlet Select-Object.
$detenidos = $serviciosRPA | Where-Object { $_.Estado -eq "Stopped" } | Select-Object Nombre 


#🛠️ Escenario de producción: funciones y parametrización, 20 ejercicios 
#Para administrar el estado de las ejecuciones de UiPath en las 14 VMs de Azure Francia 🇫🇷, necesitamos empaquetar nuestro código en funciones reutilizables que acepten nombres de servidor como entrada.



#--------------------------------------------------------------------PROPIEDADES---------------------------------------------------------------------------------------

Propiedad 🏷️	                        ¿Qué guarda? 	                                                                     Ejemplo 
.Name	                                📝Solo el nombre con su extensión	                                                robot_error.log
.FullName	                            📝La ruta completa en el disco	                                                    C:\Windows\Temp\robot_error.log
.Extension	                            📝La extensión del archivo (con el punto)	                                        .log
.Length	                                📝El tamaño del archivo en bytes	                                                1024 (se compara con 1KB, 5MB, etc.)
.LastWriteTime	                        📝Fecha y hora de última modificación	                                            07/08/2026 14:30:00
.CreationTime	                        📝Fecha y hora de creación del archivo	                                            01/08/2026 9:00:00


🔍 Operadores de comparación--------------------------------------🧠Operadores lógicos------------------    📤Operadores de redirección(Controlan la salida hacia archivos o flujos.) 
-eq → igual                                                         -and                                        > → sobrescribe archivo
-ne → distinto                                                      -or                                         >> → agrega al archivo    
-gt → mayor que                                                     -xor                                        2> → redirige errores    
-lt → menor que                                                     -not                                    
-like → comparación con comodines
-match → regex


🧩 Operadores de tipo--------------------------------------------- 🧱 Operadores unarios--------------------------------- 🛠 Operadores especiales
-is → comprueba tipo                                                   - para negar un número                              -replace → reemplazo de texto
-as → intenta convertir                                                ++ y -- para incrementar/decrementar                -contains / -in → búsqueda en colecciones
                                                                                                                            .. → rango (ej. 1..5)       



 #-------------------------------------------------------------------------COMANDOS SYSADMIN----------------------------------------------------------------------------
📍Get-Location (alias pwd):                                                                       #procesos y servicios
 #Muestra en qué carpeta estás situado.                                                          Get-Process
🚪Set-Location (alias cd):                                                                      Get-Service
#Cambia la ubicación a otra ruta.(alias ls o dir): Lista los archivos y subcarpetas.             #informacion detallada de un proceso 
📋Get-ChildItem                                                                                 Get-Process -Name "NombreDelProceso" | fl                                                  
#Usuarios                                                                                       #panel de control de procesos y filtros
Get-LocalUser                                                                                   get-process|out-gridview                                                                              
#usuario, informacion detallada                                                                 #panel de control de servicios y filtros     
Get-LocalUser -Name "NombreDeUsuario" |fl                                                       get-service|out-gridview
#grupos                                                                                         #servicios en ejecución
Get-Localgroup                                                                                  Get-Service | Where-Object {$_.Status -eq "Running"}  #con detalles |fl 
#Informacion detallada de un grupo                                                              #tareas programadas                            
Get-LocalGroup -Name "NombreDelGrupo" | fl                                                      Get-ScheduledTask|out-gridview                    
#recursos compartidos                                                                           # tareas programadas con detalles
Get-SmbShare                                                                                    Get-ScheduledTask -TaskName               
#recursos compartidos con informacion detallada                                                 #registros    
Get-SmbShare | fl                                                                               Get-EventLog -LogName "NombreDelRegistro" | fl
#recursos compartidos especiales                                                                #registros limitados a los ultimos 10 eventos    
Get-SmbShare -Special $true | fl                                                                Get-EventLog -LogName "NombreDelRegistro" -Newest 10 | fl    
#discos                                                                                         #registros limitados a los ultimos 10 eventos de un dia especifico
Get-disk                                                                                        Get-EventLog -LogName "NombreDelRegistro" -After (Get-Date).AddDays(-1) | fl
#informacion detallada de un disco                                                              #registros limitados a los ultimos 10 eventos de un dia especifico y con un tipo de evento especifico                    
Get-disk -number 0|fl                                                                           Get-EventLog -LogName "NombreDelRegistro" -After (Get-Date).AddDays(-1) -EntryType Error | fl
#INFORMACION DE LA RED                                                                          #informacion de la version del sistema operativo                   
Get-NetAdapter                                                                                  get-computerinfo | fl
#informacion detallada de un adaptador de red                                                   #informacion de la version del sistema operativo con detalles                       
Get-NetAdapter -Name "NombreDelAdaptador" | fl                                                  get-CimInstance -class Win32_OperatingSystem | Format-Table -AutoSize   
get-CimInstance -class Win32_OperatingSystem | fl  
#informacion de la version del sistema operativo con detalles y en formato tabla


#-------------------------------------------------------------------------GUTHUB-----------------------------------------------------------
#Clonar repositorio
git clone "URL DEL REPOSITORIO"


git pull origin main                         #Descargar/actualizar datos 


git add .                                    #Empaqueta

git commit -m "feat: hasta el Bloque 3"      #Etiqueta

git push origin main                         #Sube a producción
                                                                 
                                                                                










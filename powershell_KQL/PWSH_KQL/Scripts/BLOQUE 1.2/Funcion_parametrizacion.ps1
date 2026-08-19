function Get-RobotStatus {
    # Habilita los parámetros comunes de funciones avanzadas, incluido -Verbose.
    [CmdletBinding()] 
    param(
        # Permite ampliar la información devuelta en futuras consultas del estado.
        [switch]$IncludeDetails, 

        # Acepta nombres de VM obligatorios desde un parámetro o desde la canalización.
        [Parameter(
        ValueFromPipelineByPropertyName=$true, 
        Mandatory=$true, 
        ValueFromPipeline=$true
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateScript ({$_.StartsWith("VM-")})]
        [string[]]$VMName,

        # Restringe la operación a los entornos corporativos permitidos.
        [ValidateSet("PRO", "PRE")]
        [string]$Environment = "PRO"
    )

    begin {
        # Se ejecuta una vez antes de procesar las VMs recibidas.
        Write-Verbose "Iniciando auditoría de infraestructura..."
    }

    process {
        # Permite procesar una o varias VMs en cada invocación.
        foreach ($VM in $VMName) {
            Write-Verbose "Consultando estado de la VM $VM en entorno $Environment"
            try {
                # Devuelve un resultado uniforme para facilitar informes y canalizaciones.
                [PSCustomObject]@{
                    VM           = $VM
                    Entorno      = $Environment
                    Estado       = "Online"
                    ErrorDetalle = $null
                }
            }
            catch {
                # Conserva el error asociado a la VM sin interrumpir el resto del lote.
                [PSCustomObject]@{
                    VM           = $VM
                    Entorno      = $Environment
                    Estado       = "Offline"
                    ErrorDetalle = $_.Exception.Message
                }
            }
        }
    }

    end {
        # Se ejecuta una vez al finalizar el procesamiento de todas las VMs.
        Write-Verbose "Auditoría de infraestructura finalizada."
    }
}

# Splatting: agrupa los argumentos y facilita reutilizar o auditar la ejecución.
$misParametros = @{
    VMName      = "VM-PROD-01"
    Environment = "PRO"
    ErrorAction = "Stop"
}
# Ejecuta la función con los parámetros definidos arriba.
Get-RobotStatus @misParametros


function Get-RobotStatus { 
    [CmdletBinding()] 
    param( 
        [switch]$IncludeDetails, 

        [Parameter(
        ValueFromPipelineByPropertyName=$true, 
        Mandatory=$true, 
        ValueFromPipeline=$true
        )] 
        
        [ValidateNotNullOrEmpty()]
        [ValidateScript ({$_.StartsWith("VM-")})]
        [string[]]$VMName,
   
        [ValidateSet("PRO", "PRE")]
        [string]$Environment = "PRO"
    )

    begin { 
        Write-Verbose "Iniciando auditoría de infraestructura..." 
    }

    process {
        foreach ($VM in $VMName) {
            Write-Verbose "Consultando estado de la VM $VM en entorno $Environment"
            try {
                [PSCustomObject]@{
                    VM           = $VM
                    Entorno      = $Environment
                    Estado       = "Online"
                    ErrorDetalle = $null
                }
            }
            catch {
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
        Write-Verbose "Auditoría de infraestructura finalizada." 
    }
}

$misParametros = @{
    VMName      = "VM-PROD-01"
    Environment = "PRO"
    ErrorAction = "Stop"
}    
Get-RobotStatus @misParametros


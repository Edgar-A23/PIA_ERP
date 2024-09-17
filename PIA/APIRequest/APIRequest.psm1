#Generamos la función para cumplir la tarea dada
function Get-FilesReport {
<#
.SYNOPSIS
    Obtains a report of files from a chossen direcotry with the API of Virus Total ussing hashes 

    -User specified the Folderpath to make the report
    -User can select the hash algorith to use
    -User can give the path for the creation of the report 
    
    The function creates a txt file with the data collected

.DESCRIPTION
    This function generates a txt report from a directory with the file report from Virus Total API

.PARAMETER FolderPath
    Specifies the Directory to make the analisis

.PARAMETER HashAlgorithm
    Specifies hash algorithm that the function will use to get the hashes from files

.PARAMETER Report Path
    Specifies the path where the report will be stored


.EXAMPLE
    Get-FilesReport -FolderPath C:\Users\rdzed\Downloads
    This example the fuction will generate the report of the Downloads directory in the default
    Reportpath "Hash_ReportVT.txt"

.EXAMPLE
    Get-FilesReport -FolderPath C:\Users\rdzed\Downloads -ReportPath C:\Users\rdzed\Documents\Report\Report.txt
    This version of the function generate the report from the downloads directory but also stores the
    result in the given report path 
#>

    #Obtenemos la información de las variables que vamos a usar
    param(

        [Parameter(Mandatory)][string]$FolderPath,
        [Parameter()][string]$HashAlgorithm = "SHA256",
        [Parameter()][string]$ReportPath = "$PSScriptRoot\HASH_ReportVT.txt"

    )
    process{
        #Tratamos de conseguir la información de los archivos que contiene la ruta dada
        try{
            $Files = Get-ChildItem -Path $FolderPath -File -Recurse -WarningAction Stop -ErrorAction Stop   
        } catch{
            Write-Host "Ocurrió un error: $($_.ExceptionMessage)"
        }
        #Analizamos que el directorio dado tenga contenido
        if ($Files.Count -eq 0){
                Write-Host "La carpeta seleccionada no tiene archivos, operación inválida"
                exit
        }
        #Recorremos la lista de arichivos para obtener los hashes
        $FilesHashes = foreach($File in $Files){
            $FileHash = Get-FileHash -Path $File.fullname -Algorithm $HashAlgorithm
        }
        #Obtenemos la información de la API
        $ApiKey = 05cead00057c0925d3773cdbc4d5645dd168b5def1603695c60ef675e69c7ce9
        $headers = @{
            "x-apikey" = $ApiKey
            "User-Agent" = "Powershel Script"
        }
        $Counter = 0
        foreach($HashFromFile in $FilesHashe){
            $Hash = $HashFromFile.Hash
            if($Counter -lt 4){
                try{
                    $URL = "https://www.virustotal.com/api/v3/files/$Hash"
                    $Response = Invoke-RestMethod -Uri $URL -Headers $headers -Method Get -ErrorAction Stop
                } catch{
                    Write-Host "El hashe no pudo ser analizado error: $($_.ExceptionMessage)"
                }
                $Counter = $Counter++
            } else {
                Write-Host "La api con la api key actual solo permite 4 solicitudes por min"
                Start-Sleep -Seconds 5
                $Salida = Read-Host -Prompt "Desea esperar? [1]Sí [0]No"
                if ($Salida == 0){
                    exit
                } else{
                    Start-Sleep -Seconds 55
                }
                $Counter = 0
            }
            $FileName = $HashFromFile.Path
        #Comentario para la profe: profe este segmento es idea de mis compañeras Maria Fernanda y Estrella
        #solamente es para darle formato bonito a la respuesta :,(
        #Se le da formato a la respuesta obtenida por la API y se evía a la ruta del reporte especificada
            $InfoCopiled = $Response | 
            ConvertTo-Json -Compress "File $FileName`nHash$Hash`nVirus total report`n$InfoCopiled`n" |
            Out-File -FilePath $ReportPath -Append 
        }
    } 
}

#Creamos la función para el escaneo de puertos y análisis de vulnerabilidades
function Get-IPInfo{
<#
.SYNOPSIS
    Obtains a report of IP with info like ports usefull data and host status

    -User can specified IP that will be used for the report
    -User can specife the name of the txt file created for the repor
    -User can give a list or range of port to do the scan
    
    The function creates a txt file with the data collected

.DESCRIPTION
    This function generates a txt report from with the IP and ports analysis

.PARAMETER IP
    Specifies the IP to analyze

.PARAMETER ReportPath
    Specifies the path where the report will created

.PARAMETER PortRange
    Specifies the ports that were used to make an analysis


.EXAMPLE
    Get_IPInfo
    This veriosn of the function without parameters will use for each one the default value, like
    IP 127.0.0.1
    Reportpath .\IPReport.txt

.EXAMPLE
    Get-IPInfo -IP 127.0.1.14 -ReportPath "C:\Users\rdzed\Documents\Report.txt" -PortRange (1..80)
    This example specifies the IP to make the report and the ubication where the report will be stored,
    also in this example the port range is from 1 to 80 and those will be used to make an analysis
#>

    #Solicitamos una IP para analizar o en caso contrario por default ser revisará
    #la IP host
    param(
        [Parameter()][String]$IP = "127.0.0.1",
        [Parameter()][String]$ReportPath = "$PSScriptRoot\IPReport.txt",
        [Parameter()][int[]]$PortRange = (21,22,25,80,443,587,465,8080)
    )
    process{
        #Realizamos un escaneo de puertos
        $PortScan = $PortRange | ForEach-Object {
            Test-NetConnection -ComputerName $IP -Port $_ -WarningAction SilentlyContinue |
            Select-Object -Property @{n="IP";e={$_.ComputerName}},`
            @{n="Ping Sent";e={$_.PingSucceeded}},`            @{n="Ping Reply";e={$_.PingReplyDetails}},`            @{n="TcpTest Result";e={$_.TcpTestSucceeded}}
        }
        #Registro de hosts activos
        if (Test-Connection -ComputerName $IP -Count 1 -Quiet) {
            $ActiveHosts = "Active"
        } else{
            $ActiveHosts = "Deactivate"
        }
        $InfoReport = "Reporte de puertos con la Ip dada`n$PortScan`n`n",`
        "El estatus del host de la IP actual es: $ActiveHosts"
        $InfoReport | Out-File -FilePath $ReportPath
    }
}
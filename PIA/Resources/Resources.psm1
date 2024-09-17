#Definimos la funci�n para la obtenci�n de informaci�n acerca del uso de la memoria RAM
function Get-ResourcesSystemMemInfo {
<#
.SYNOPSIS
    Show information about the system's memory

    -User can specify the property to show
    
    The function shows a prompt with the properties that are selected

.DESCRIPTION
    This function shows RAM information

.PARAMETER Option
    Specifies the property that the user can select to show

.EXAMPLE
    Get-ResourcesSystemMemInfo -Option Total
    This example specified the option that the user wants and in this case the option Total
    the function shows a prompt with information about the total capacity of the RAM

.EXAMPLE
    Get-ResourcesSystemMemInfo 
    This version of the command without parameters uses the default option and shows all the info
    that the function compiling in a list 
#>
    #Se definen las opciones para que el usario pueda escoger que vizualizar
    param(
        [Parameter()][Validateset("Total","Free","Used","All")][string]$Option = "All"
    )
    process {
        #Almacenamos la informaci�n de la capacidad total de la memoria RAM
        $TotalRAM = Get-CimInstance -ClassName Win32_PhysicalMemory | 
        Select-Object @{n="Total Memory";e={$_.Capacity/1GB}}
        #Obtenemos la informaci�n de la memoria disponible de la RAM
        $FreeRAM = Get-CimInstance -ClassName Win32_OperatingSystem |
        Select-Object @{n="Free RAM";e={$_.FreePhysicalMemory/1GB}}
        #Caculamos la memoria RAM usada por los procesos en funcionamiento de la computadora
        $UsedRAM = Get-Process | Measure-Object -Property Workingset -Sum |
        Select-Object -Property @{n="Used RAM";e={$_.Sum/1GB}}
        #Mencionar que a todos se les di� formato en GB

        #Filtramos la informaci�n para la presentaci�n de la informaci�n
        switch($Option){
            #Mostramos la informaci�n de la memoria RAM total
            "Total"{
                Write-Host "La memoria RAM total instalada es de: $TotalRAM GB"
            #Mostramos la memoria disponible en la RAM
            } "Free"{
                Write-Host "La memoria RAM disponible es de: $FreeRAM GB"
            #Mostramos la memoria RAM que se esta usando
            } "Used" {
                Write-Host "La memoria RAM en uso es de: $UsedRAM GB"
            #En caso de no especificar alguna opcion o usar la opci�n all muestra toda la info de la RAM
            #en formato de lista para una mejor visualizaci�n
            }default{
                $TotalRAM,$FreeRAM,$UsedRAM | Format-List *
            }
        }
    }
}

#Definimos la funci�n para la obtenci�n de informaci�n acerca del uso del disco
function Get-ResourcesSystemDiskInfo{
<#
.SYNOPSIS
    Show information on the system disk

    -User can specify the property to show
    
    The function shows a prompt with the properties that are selected

.DESCRIPTION
    This function shows Disk use information

.PARAMETER Option
    Specifies the property that the user can select to show

.EXAMPLE
    Get-ResourcesSystemDiskInfo -Option Free
    This example specified the option that the user wants and in this case with the option Free
    the function shows a prompt with information about the space available on the disk

.EXAMPLE
    Get-ResourcesSystemDiskInfo 
    This version of the command without parameters uses the default option and shows all the info
    that the function compiling in a list 
#>
    #Se definen las opciones para que el usario pueda escoger que vizualizar
    param(
        [Parameter()][Validateset("Total","Free","Used","All")][string]$Option = "All"
    )
    process{
        #Se obtiene la informaci�n del disco
        $DISK = Get-CimInstance -ClassName Win32_LogicalDisk
        #Se filtra el espacio total del disco
        $DISK_Total = $DISK | Select-Object -Property @{n="Disk Space";e={$_.Size/1GB}}
        #Se obtiene el espacio disponible del disco
        $DISK_Free = $DISK | Select-Object -Property @{n="Disk aviable";e={$_.FreeSpace/1GB}}
        #Se calcula es espacio usado
        $DISK_Used = $DISK | Select-Object -Property @{n="Disk used";e={($_.Size/1GB)-($_.FreeSpace/1GB)}}
        #Se mide el porcentaje de uso del disco
        $DISK_UsedPercent = $DISK | 
        Select-Object -Property @{n="Percentage of use";e={(($_.Size-$_.FreeSpace)*(100)/1GB)/($_.Size/1GB)}} 
        #Se filtra la informaci�n que se mostrara de acuerdo a la variable Option
        switch($Option){
            "Total"{
                #Se muestra todo el espacio que tiene el disco 
                Write-Host "El espacio total del disco es de: $DISK_Total GB"
            } "Free"{
                #Se muestra el espacio que dispone a�n el disco par usar
                Write-Host "Espacio disponible del disco: $DISK_Free GB"
            } "Used" {
                #Se muestra el espacio de disco usado y su porcentaje
                Write-Host "Espacio del disco usado: $DISK_Used GB`n",`
                "Porcentaje del uso del disco: $DISK_UsedPercent%"
            }default{
                #Se muestra toda la informaci�n obtenida del disco en formato de lista para mejor visualizaci�n
                $DISK_Total,$DISK_Free,$DISK_Used,$DISK_UsedPercent |
                Format-List
            }
        }
    }
}

#Definimos la funci�n para la obtenci�n de informaci�n acerca del uso del CPU
function Get-ResourcesSystemCPUInfo{
<#
.SYNOPSIS
    Show information about the processor

    -User can specify the property to show
    
    The function shows a prompt with the properties that are selected

.DESCRIPTION
    This function shows processor information

.PARAMETER Option
    Specifies the property that the user can select to show

.EXAMPLE
    Get-ResourcesSystemCPUInfo -Option Architecture
    This example specified the option that the user wants and in this case with the option Architecture
    the function shows a prompt with the information about the architecture of the processor

.EXAMPLE
    Get-ResourcesSystemCPUInfo 
    This version of the command without parameters uses the default option and shows all the info
    that the function compiling in a list 
#>
    #Se definen las opciones para que el usario pueda escoger que vizualizar
    param(
        [Parameter()][ValidateSet("Name","NumCores","CoresEnabled","ID","Thread","Architecture","ALL")][string]$Option = "All"
    )
    process{
        #Se obtiene toda la informaci�n del procesador para posteriormente filtrar
        $CPUInfo = Get-CimInstance -ClassName Win32_Process
        #Se filtra en nombre del procesador
        $PName = $CPUInfo | Select-Object -Property @{n="Processor Name";e={$_.Name}}
        #Se filtra el n�mero de nucleos del procesador
        $PCore = $CPUInfo | Select-Object -Property @{n="Cores";e={$_.NumberOfCores}}
        #Se filtra el n�mero de nucleos activos
        $PCoreEnabled = $CPUInfo | Select-Object -Property @{n="Enabled Cores";e={$_.NumberOfEnabledCore}}
        #Se filtra el Id del procesador instalado
        $PId = $CPUInfo | Select-Object -Property @{n="Processor ID";e={$_.ProcessorId}}
        #Se filtran los hilos con los que trabaja el procesador
        $PTrheads = $CPUInfo | Select-Object -Property @{n="Threads";e={$_.ThreadCount}}
        #Se filtra la arquitectura del procesador a partir de la informaci�n de la computadora
        $PArchitecture = Get-ComputerInfo | Select-Object -Property @{n="Architecture";e={$_.OsArchitecture}}
        switch($Option){
            "Name"{
                #Se muestra el nombre del procesador
                Write-Host "El nombre del procesador es $PName"
            } "NumCores"{
                #Se presenta la cantidad de nucleos que posee el procesador
                Write-Host "Los nucleos totales del procesador son $PCore"
            } "CoresEnabled" {
                #Se muestran los nucleos activos o en funcionamiento
                Write-Host "Los nucleos en funcionamiento son $PCoreEnabled"
            } "ID" {
                #Mosramos el ID del procesador instalado
                Write-Host "El id del procesador es $PId"
            } "Thread" {
                #Se�alamos la cantidad de hilos con los que trabaja el procesador
                Write-Host "El n�mero de hilos del procesador es de $PTrheads"
            } "Architecture" {
                #Presentamos la arquitectura con la que trabaja la CPU
                Write-Host "La arquitectura de la CPU es de $PArchitecture"
            }default{
                #Se muestra toda la informaci�n del procesador en formato de list para una mejor visualizaci�n
                $PName,$PName,$PCore,$PCoreEnabled,$PId,$PTrheads,$PArchitecture | 
                Format-List
            }
        }
    }
}

#Definimos la funci�n para la obtenci�n de informaci�n acerca de la red
function Get-ResourcesSystemNetInfo {
<#
.SYNOPSIS
    Show information on the net and net adapters

    -User can specify the property to show
    
    The function shows a prompt with the properties that are selected

.DESCRIPTION
    This function shows net information

.PARAMETER Option
    Specifies the property that the user can select to show

.EXAMPLE
    Get-ResourcesSystemNetInfo -Option NetSpeed
    This example specified the option that the user wants and in this case with the option NetSpeed
    the function shows a prompt with information about the amount of data passed through per second

.EXAMPLE
    Get-ResourcesSystemNetInfo 
    This version of the command without parameters uses the default option and shows all the info, first
    the net information in list format and then the adapter information in table format
#>
    #Se definen las opciones para que el usario pueda escoger que vizualizar
    param(
        [Parameter()][ValidateSet("NetSpeed","AdapterStatus","NetStats","Full")][String]$Option = "Full"
    )
    process{
        #Se obtiene la informaci�n acerca de la velocidad de transferencia de datos por segundo de la red
        #actual a la que esta conectada el equipo
        $NetSpeed = Get-NetAdapter -Name Wi-fi | Select-Object -Property @{n="Net Speed";e={$_.LinkSpeed}}
        #Registramos informaci�n acerca de los adaptadores de red tal como el nombre, estatus y direcci�n mac
        $AdaptersInfo = Get-NetAdapter | Select-Object -Property Name,Status,MacAddress
        #Almacenamos toda la info sobre la trasnferencia de datos de la red de conexi�n actual
        $NetStat = Get-NetAdapterStatistics | Format-Table -AutoSize

        switch($Option){
            "NetSpeed" {
                #Mostramos la velocidad de transferencia de la red que estamos conectados
                Write-Host "La velocidad de la red actual es de $NetSpeed"
            } "AdapterStatus" {
                #Presentamos la imformaci�n de los adaptadores de conexi�n que tiene nuestro equipo
                Write-Host "La informaci�n de los adaptadores de red es la siguiente: `n"
                $AdaptersInfo | Format-Table -AutoSize
            } "NetStats" {
                #Se�alamos la informaci�n de la red acutal relacionada con el envi� o recibo de paquetes
                Write-Host "Informaci�n de la red actual`n"
                $NetStat | Format-Table -AutoSize
            } Default {
                #Se muestra toda la info que se tiene de las redes del equipo
                Write-Host "La informaci�n de la red es la siguiente:`n"
                $NetStat, $NetSpeed | Format-List *
                $AdaptersInfo | Format-Table -AutoSize
            }
        }
    }
}

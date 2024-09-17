do {
$opcion = Read-Host "-- Bienvenido al menu --`n",`
"Escoga la opción que desea realizar`n",
"[1]Instalar módulos`n",
"[2]Consultar funciones de los módulos a instalar`n",
"[3]Desinstalar módulos`n",
"[4]Visualizar los módulos instalados"
"[0]Salir del menú`n"
switch($opcion){
    1{
        do{
            $opcionInstall = Read-Host "-- Bienvenido al menu de instalación --`n",`
            "Escoga la opción que desea realizar`n",
            "[1]Instalar modulo IPInfo`n",
            "[2]Instalar modulo HiddenItems`n",
            "[3]Instalar modulo Resources`n",
            "[4]Instalar modulo ApiRequest`n",
            "[0]Salir del menú`n",
            "[Default] Install all`n"
            switch($opcionInstall){
                1{
                    Import-Module -Name IPInfo
                    return
                } 2{
                    Import-Module -Name HiddenItems
                    return
                } 3{
                    Import-Module -Name Resources
                    return
                } 4{
                    Import-Module -Name APIRequest
                    return
                } defautl{
                    Import-Module -Name IPInfo
                    Import-Module -Name HiddenItems
                    Import-Module -Name Resources
                    Import-Module -Name APIRequest
                    return
                }
            }
        } until ($opcionInstall -eq 0)
    } 2{
        do{
            $opcionInstall = Read-Host "-- Bienvenido al menu de consulta --`n",`
            "Escoga la opción que desea realizar`n",
            "[1]Consultar comandos del modulo IPInfo`n",
            "[2]Consultar comandos del modulo HiddenItems`n",
            "[3]Consultar comandos del modulo Resources`n",
            "[4]Consultar comandos del modulo ApiRequest`n",
            "[0]Salir del menú`n",
            "[Default] Review all comands`n"
            switch($opcionInstall){
                1{
                    Get-Command -Module IPInfo
                    return
                } 2{
                    Get-Command -Module HiddenItems
                    return
                } 3{
                    Get-Command -Module Resources
                    return
                } 4{
                    Get-Command -Module APIRequest
                    return
                } defautl{
                    Get-Command -Module IPInfo,HiddenItems,Resources,APIRequest
                    return
                }
            }
        } until ($opcionInstall -eq 0)
    } 3{
        do{
            $opcionUnnstall = Read-Host "-- Bienvenido al menu de desintalación --`n",`
            "Escoga la opción que desea realizar`n",
            "[1]Desinstalar modulo IPInfo`n",
            "[2]Desinstalar modulo HiddenItems`n",
            "[3]Desinstalar modulo Resources`n",
            "[4]Desinstalar modulo ApiRequest`n",
            "[0]Salir del menú`n",
            "[Default] Uninstall all`n"
            switch($opcionInstall){
                1{
                    Remove-Module -Name IPInfo
                    return
                } 2{
                    Remove-Module -Name HiddenItems
                    return
                } 3{
                    Remove-Module -Name Resources
                    return
                } 4{
                    Remove-Module -Name APIRequest
                    return
                } defautl{
                    Remove-Module -Name IPInfo
                    Remove-Module -Name HiddenItems
                    Remove-Module -Name Resources
                    Remove-Module -Name APIRequest
                    return
                }
            }
        } until ($opcionInstall -eq 0)
    } default{
        $opcion = 0
    }
}
} until ($opcion -eq 0)

do{
    $opcion = Read-Host "-- Bienvenido al menu --`n",`
    "Escoga la opción que desea realizar`n",
    "[1]Instalar módulos`n",
    "[2]Consultar funciones de los módulos a instalar`n",
    "[3]Desinstalar módulos`n",
    "[4]Visualizar los módulos instalados`n",
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
                        Import-Module -Name IPInfo -ErrorAction SilentlyContinue
                    } 2{
                        Import-Module -Name HiddenItems -ErrorAction SilentlyContinue
                    } 3{
                        Import-Module -Name Resources -ErrorAction SilentlyContinue
                    } 4{
                        Import-Module -Name APIRequest -ErrorAction SilentlyContinue
                    } defautl{
                        Import-Module -Name IPInfo,HiddenItems,Resources,APIRequest -ErrorAction SilentlyContinue
                    }
                }
                } until ($opcionInstall -eq 0)
        } 2{
            do{
                $opcionReview = Read-Host "-- Bienvenido al menu de consulta --`n",`
                "Escoga la opción que desea realizar`n",
                "[1]Consultar comandos del modulo IPInfo`n",
                "[2]Consultar comandos del modulo HiddenItems`n",
                "[3]Consultar comandos del modulo Resources`n",
                "[4]Consultar comandos del modulo ApiRequest`n",
                "[0]Salir del menú`n",
                "[Default] Review all comands`n"
                switch($opcionReview){
                    1{
                        Get-Command -Module IPInfo -ErrorAction SilentlyContinue
                        
                    } 2{
                        Get-Command -Module HiddenItems -ErrorAction SilentlyContinue
                        
                    } 3{
                        Get-Command -Module Resources -ErrorAction SilentlyContinue
                        
                    } 4{
                        Get-Command -Module APIRequest -ErrorAction SilentlyContinue
                        
                    } defautl{
                        Get-Command -Module IPInfo,HiddenItems,Resources,APIRequest -ErrorAction SilentlyContinue
                        
                    }
                }
                } until ($opcionReview -eq 0)
        } 3{
            do{
                $opcionUninstall = Read-Host "-- Bienvenido al menu de desintalación --`n",`
                "Escoga la opción que desea realizar`n",
                "[1]Desinstalar modulo IPInfo`n",
                "[2]Desinstalar modulo HiddenItems`n",
                "[3]Desinstalar modulo Resources`n",
                "[4]Desinstalar modulo ApiRequest`n",
                "[0]Salir del menú`n",
                "[Default] Uninstall all`n"
                switch($opcionUninstall){
                    1{
                        Remove-Module -Name IPInfo -ErrorAction SilentlyContinue
                        
                    } 2{
                        Remove-Module -Name HiddenItems -ErrorAction SilentlyContinue
                        
                    } 3{
                        Remove-Module -Name Resources -ErrorAction SilentlyContinue
                        
                    } 4{
                        Remove-Module -Name APIRequest -ErrorAction SilentlyContinue
                        
                    } defautl{
                        Remove-Module -Name IPInfo,HiddenItems,Resources,APIRequest -ErrorAction SilentlyContinue
                        
                    }
                }
                } until ($opcionUninstall -eq 0)
        } 4{
            Get-Module
            
        } default{
            $opcion = 0
        }
    }
} until($opcion -eq 0)

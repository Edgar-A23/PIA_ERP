#Function definition
function Get-HiddenFiles{
<#
.SYNOPSIS
    Show files from a path that are hidden

    -User Specified Path to analize
    -User can specified the format for the report of hidden files

    The funcition show a prompt with de hidden file in the path given and in the fomat
    specified

.DESCRIPTION
    This function show hidden files from specified path

.PARAMETER Path
    Specifies the path to find the hidden files
.PARAMETER Format
    Specifies the format of the function output

.EXAMPLE
    Get-Hidden -Path .\Document
    This version of the command find all the hidden files in Documents directory and
    subdirectorys and use the default parameters settings
    Format List

.EXAMPLE
    Get-Hidden -Path .\Document -Format Table
    This example specifies the format of the output from the command into a format table
    provides the name and full path of the each file
#>
    #Parameter definition
    param(
        [Parameter(Mandatory)][String]$Path,
        [Parameter()][ValidateSet("Table","List")][String]$Format = "List"
    )
    process{
        Set-StrictMode -Version Latest
        #Get the hidden files from the path specified and filter only the name and 
        #the full path of the each file in the directory in path variable
        try{
            $PathFiles = Get-ChildItem -Path "$Path" -Hidden -Recurse `
            -ErrorAction Stop
            #If we don't have an error continue with the format of the output, 
            # and with an error proceeds like terminated error
            if ($Format -eq "Table"){
                #Give table format to the output
                $Files = $PathFiles | 
                Select-Object -Property @{Name="File";Expression={$_.name}},`
                @{Name="Full Path";Expression={$_.fullname}}|
                Format-Table -AutoSize
            } else{
                #Give list format to the output (Default format)
                $Files = $PathFiles | 
                Select-Object -Property @{Name="File"; Expression={$_.name}},`
                @{Name="Full Path";Expression={$_.fullname}}| 
                Format-List
            }
            echo $Files
        #Manage the possible error
        } catch{
            Write-Host "Ocurrió un error"
            $_.Exception.Message
        }
    }
}
#### how to import Libs

````powershell
$modulesFolder = "..\PowerShell.Libs"
foreach ($module in Get-Childitem $modulesFolder -Name -Filter "*.psm1")
{
    Import-Module $modulesFolder\$module -Force
}
````

[string]$global:rootWorkDir = "C:\Temp"

function SetEvent ([string]$eventName){
    [string]$script:rootWorkDir = $global:rootWorkDir + "\"+$eventName
    [string]$global:rootWorkDir = $script:rootWorkDir
    if (!(Test-Path -Path $rootWorkDir))
    {
        New-Item -Path $rootWorkDir -ItemType Directory
        New-Item -Path $rootWorkDir\"!logs" -ItemType Directory
        New-Item -Path $rootWorkDir\"!archives" -ItemType Directory
    }
    $script:eventLogFile = $rootWorkDir+"\!logs\eventLog."+(Get-Date).ToString('yyyyMMdd-hh')+".log"
}


function EventLogger
{
   Param ([string]$logstring)

   write-host $logstring
   Add-content $script:eventLogFile -value "[INFO]: $logstring"
}
function EventLogger-Warning
{
   Param ([string]$logstring)
   write-warning $logstring
   Add-content $script:eventLogFile -value "[WARNING]: $logstring"
}
function EventLogger-Error
{
   Param ([string]$logstring)

   write-Error $logstring
   Add-content $script:eventLogFile -value "[ERROR]: $logstring"
}

Export-ModuleMember -Function SetEvent
Export-ModuleMember -Function EventLogger
Export-ModuleMember -Function EventLogger-Warning
Export-ModuleMember -Function EventLogger-Error



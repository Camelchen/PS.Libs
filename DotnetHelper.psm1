function GetProjectVersionInfo ([string]$projPath) 
{
    function GetProjectVersion {
        Param (
            [string]$projectFile
        )
        if (!(Test-Path -Path $projectFile)) { 
            Write-Error "Project file not exist, " $projectFile
            return
        }
        $projVersion = ""
        Write-Host $projectFile
    
    #get version number in csproj file
        [xml]$csproj =  Get-Content -Path $projectFile
    
        #from <Version> node in csproj
        $projVersion = $csproj.Project.PropertyGroup.Version  | Where-Object {$_ -ne $null}
        if ($projVersion.length -gt 0 ) { 
            return $projVersion
        }
    
        #from <AssemblyVersion> node in csproj
        $projVersion = $csproj.Project.PropertyGroup.AssemblyVersion | Where-Object {$_ -ne $null}
        if ($projVersion.length -gt 0 ) { 
            return $projVersion 
        }
    
        #get version in AssemblyInfo.cs
        $assemblyInfoFile = (Get-Item $projectFile).DirectoryName+"\Properties\AssemblyInfo.cs"
        if (!(Test-Path -Path $assemblyInfoFile)) { 
            Write-Warning "AssemblyInfo file not exist, $projectFile"
            return
        }
        Get-Content -Path $assemblyInfoFile | % {
            $line = $_
            # write-host $line
            if ($line -like "[[]assembly: AssemblyVersion*"){
                $version = $line.Replace("[assembly: AssemblyVersion(","").Replace(")]","").TrimStart("""").TrimEnd("""")
                return $version
            }
        }
    }
}
Export-ModuleMember -Function GetProjectVersionInfo
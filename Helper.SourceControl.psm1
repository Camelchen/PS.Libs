[string]$gitProcess = "C:\Program Files\Git\bin\git.exe"

function GetCodeFromGit([string]$componentName, [string]$gitRepositoryHTTPS, [string]$branch) {

    $runtimeDatetime = (Get-Date -format "yyyyMMdd-HHmmss")
    $gitWorkDir = $global:rootWorkDir +"\"+$componentName+"."+ $runtimeDatetime
    $gitWorkLog = $global:rootWorkDir+"\!logs\getCodeFromGit"+(Get-Date -format "yyyyMMdd").ToString()+".log"

    if (!(Test-Path -Path $gitWorkDir))
    {
        New-Item -Path $gitWorkDir -ItemType Directory
    }

    Write-Information "`r`nInfo: GetProjectHistory [$gitProcess] Output File [$gitWorkLog]"
    Set-Location "$gitWorkDir"

    & $gitProcess init | Out-File -Append $gitWorkLog
    & $gitProcess remote add origin $gitRepositoryHTTPS | Out-File -Append $gitWorkLog
    & $gitProcess fetch 2>&1 | Out-File -Append $gitWorkLog

    if ($branch -eq "")
    {
        $branch = "master"
    }
    & $gitProcess checkout $branch  | Out-File -Append $gitWorkLog
    & $gitProcess pull origin $branch  2>&1 | Out-File -Append $gitWorkLog
    
    Write-Host "Successful get the latest code from "$gitRepositoryHTTPS" on branch: "$branch -ForegroundColor Green
    # Write-Information $gitWorkDir
    return $gitWorkDir
}

Export-ModuleMember -Function GetCodeFromGit



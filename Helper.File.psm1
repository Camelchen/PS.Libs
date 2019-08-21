# Import-Module '.\EventHelper.psm1'
function GetMD5 ([string]$str) 
{   
    EventLogger "Here is GetMD5"
    $someString = $str
    $md5 = new-object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
    $utf8 = new-object -TypeName System.Text.UTF8Encoding
    $hash = [System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($someString)))
    return $hash.replace('-','')
}

Export-ModuleMember -Function GetMD5
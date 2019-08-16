Class SQLServerConnection {
	[String]$Server
	[String]$Database
} 
function DBConnection ([string]$server,[string]$database) 
{
	$connection = New-Object SQLServerConnection 
	$connection.Server = $server
	$connection.Database = $database
    return $connection
}

function DBQuery ([SQLServerConnection]$conn,[string]$sqlcmd) {
	Invoke-Sqlcmd -ServerInstance $conn.Server -Database $conn.Database -Query $sqlcmd # | format-table -AutoSize
}

function DBInsertCsvFile([SQLServerConnection]$conn,[string]$sourceCsvFile,[string]$targetTable,[string]$fileDeterminator) {
    DBQuery $conn @(
        "
            BULK INSERT "+$targetTable+"
            FROM '"+$sourceCsvFile+"'
            WITH
            (
            FIRSTROW = 2,   --ignore header
            FIELDTERMINATOR = '$fileDeterminator',  --CSV field delimiter
            ROWTERMINATOR = '\n',   --Use to shift the control to next row
            TABLOCK
            )
        ")
}

Export-ModuleMember -Function DBConnection
Export-ModuleMember -Function DBQuery
Export-ModuleMember -Function DBInsertCsvFile
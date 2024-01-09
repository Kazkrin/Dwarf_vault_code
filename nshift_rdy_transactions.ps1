$response_ok = '{
    "checkresults": [
        {
            "checkresult": {
                "type": "service"
            },
            "hostname": "",
            "servicename": "SQL Listener DB Check",
            "state": "0",
            "output": "All is OK"
        }
    ]
}' 

$response_crit = '{
    "checkresults": [
        {
            "checkresult": {
                "type": "service"
            },
            "hostname": "",
            "servicename": "SQL Listener DB Check",
            "state": "2",
            "output": "Critical: More than 1 transaction stuck in READY status"
        }
    ]
}' 

#####Core of the script below######

$serverInstance = ""
$query = "SELECT COUNT(*) FROM [WTP].dbo.REQUEST_TRANSACTIONS rt WHERE rt.STATUS = 'READY' AND RECEIVED_TIMESTAMP > DATEADD(minute,-10,GETDATE())"
$queryResult = Invoke-Sqlcmd  -ServerInstance $serverInstance  -Query $query -TrustServerCertificate

if ($queryResult.Column1 -ne "NULL"){
    #return $response_ok
    $query_check | Out-GridView
    $json=$response_ok
    } else {
        Write-Host "No results from query"
        $json=$response_crit
        }


######Send information to nagios######
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
$token = ''
$cmd ='submitcheck'
$Uri = "?token=$token&cmd=$cmd&json=$json"
$Result = Invoke-webrequest -UseBasicParsing -Uri $Uri -method Post 
Write-Output $Result

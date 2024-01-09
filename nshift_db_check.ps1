$response_ok = '{
    "checkresults": [
        {
            "checkresult": {
                "type": "service"
            },
            "hostname": "",
            "servicename": "WTP SQL Listener",
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
            "servicename": "WTP SQL Listener",
            "state": "2",
            "output": "Critical: WTP SQL Listener is not running"
        }
    ]
}' 

#####Core of the script below######
$serverInstance = ""
$query = "SELECT GETDATE()"
$query_check= Invoke-Sqlcmd -Query $query -ServerInstance $serverInstance -TrustServerCertificate

#$query_check = 1

if ($query_check.Column1 -ne "NULL"){
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


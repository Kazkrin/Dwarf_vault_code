# Define the SQL Server instance name
$serverInstance = "i26329.dsv.com"
$username = "G.S.6463.DEVELOP.PRD"
$password = "wCATEvhvR0e@!Rl8uS161Bd!"

# Create a connection string
$connectionString = "Server=$serverInstance;User=$username;Password=$password;Integrated Security=True;"

# Create a SQL Server connection
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString

$response_ok = '{
    "checkresults": [
        {
            "checkresult": {
                "type": "service"
            },
            "hostname": "i26329.dsv.com",
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
            "hostname": "i26329.dsv.com",
            "servicename": "WTP SQL Listener",
            "state": "2",
            "output": "Critical: WTP SQL Listener is not running"
        }
    ]
}' 

#####Core of the script below######

try {
    # Open the SQL Server connection
    $connection.Open()
    $command = $connection.CreateCommand()
    $command.CommandText = "SELECT GETDATE()"
    $result = $command.ExecuteScalar()

    # Check if the SQL Server is running
    if ($connection.State -eq [System.Data.ConnectionState]::Open) {
        #return $response_ok
        Write-Host "SQL Server $serverInstance is running. Current date: $result"
    } else {
        Write-Host "SQL Server $serverInstance is not running."
        #return $response_crit
    }
}
catch {
    Write-Host "Failed to connect to SQL Server"
}

if($connection.State -eq [System.Data.ConnectionState]::Open)
{$json=$response_ok}else{$json=$response_crit}

######Send information to nagios######
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
$token = 'YY8X2QPZ6e0K'
$cmd ='submitcheck'
$Uri = "http://nagios.prd.sit-automation.dsv.com/nrdp/?token=$token&cmd=$cmd&json=$json"
$Result = Invoke-webrequest -UseBasicParsing -Uri $Uri -method Post 
Write-Output $Result

# Define the SQL Server instance name
$serverInstance = "i26329.dsv.com"
$username = "G.S.6463.DEVELOP.PRD"
$password = "wCATEvhvR0e@!Rl8uS161Bd!"

# Create a connection string
$connectionString = "Server=$serverInstance;User=$username;Password=$password;Integrated Security=True;"

# Create a SQL Server connection
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString

try {
    # Open the SQL Server connection
    $connection.Open()
    $command = $connection.CreateCommand()
    $command.CommandText = "SELECT GETDATE()"
    $result = $command.ExecuteScalar()

    # Check if the SQL Server is running
    if ($connection.State -eq [System.Data.ConnectionState]::Open) {
        Write-Host "SQL Server $serverInstance is running. Current date: $result"
    } else {
        Write-Host "SQL Server $serverInstance is not running."
        Restart-Service -Name ""
    }
}
catch {
    Write-Host "Failed to connect to SQL Server: $_.Exception.Message"
}

#Query a WTP database for transactions stuck in Awaiting
try {
    #$usernameDB = "G.S.6463.NSHIFT.prd"
    #$passwordDB = "!TNe0Lx?h3UXVc0pWA8hm?w7"
    $query = "SELECT * FROM [WTP].dbo.REQUEST_TRANSACTIONS rt WHERE rt.STATUS = 'ERROR'"
    $query = "SELECT *,DATEDIFF(MINUTE, RECEIVED_TIMESTAMP, CURRENT_TIMESTAMP) AS TimeDifferenceInMinutes FROM [WTP].dbo.REQUEST_TRANSACTIONS rt WHERE rt.STATUS = 'ERROR'"
    $query = "SELECT *,FLOOR(DATEDIFF(SECOND, RECEIVED_TIMESTAMP, CURRENT_TIMESTAMP) / 60.0) AS TimeDifferenceInMinutes FROM [WTP].dbo.REQUEST_TRANSACTIONS rt WHERE rt.STATUS = 'ERROR' AND FLOOR(DATEDIFF(SECOND, RECEIVED_TIMESTAMP, CURRENT_TIMESTAMP) / 60.0) <= 10;"
    $queryResult = Invoke-Sqlcmd  -ServerInstance $serverInstance  -Query $query -TrustServerCertificate

    if ($queryResult){ 
        $queryResult | Out-GridView
    } else {
        Write-Host "No results from query"
    }   

}

finally {
    # Close the connection
    $connection.Close()
}
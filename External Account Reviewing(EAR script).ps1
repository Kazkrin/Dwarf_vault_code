<#
External account reviewing script in PowerShell aka EAR script

Created by: Kamil Karpiuk
With guide & help of: Marcin Kawka
At 22 DEC 2022 14:30 CET Warsaw, Poland

EAR Script is designated to be expanded by new functionalities and features in near future.


29 DEC 2022 10:25 CET - added Send-MailMessage feature.

#>

$searched_ad_user = Read-Host -Prompt 'Input your AD user namer here: '
$users = Get-AdUser -Identity $searched_ad_user -Properties DirectReports | Select-Object -ExpandProperty DirectReports 
$external_users_data = ForEach ($user in $users) {
    $U = Get-AdUser -identity $user -Property *
        if ($U.UserPrincipalName -like 'EXT.*') {
            $today = Get-Date
            $startdate = $U.PasswordLastSet
            #Write-Host $startdate to check if script is extracting date
                if ($startdate -eq $null){
                    $PasswordAge = 'Account Deprovisioned'}
                else{$Password =  New-TimeSpan -Start $startdate  -End $today 
                    $PasswordAge = $Password.Days}

        [PSCustomObject]@{
            "AccountName"    = $U.UserPrincipalName
            "ExpirationDate" = $U.AccountExpirationDate
            "Name" = $U.Name
            "Surname" = $U.Surname
            "Email Address" = $U.EmailAddress
            "Password Age" = $PasswordAge            
        }
    }
}
#Write-Output $external_users_data to check if script populate file with correct data 
$external_users_data | Export-Csv -Append -Path 'C:\Users\kamil.karpiuk\OneDrive - DSV\Desktop\Code Vault\PowerShell\expiration_externals.csv'
Send-MailMessage -From 'Kamil <kamil.karpiuk@dsv.com>' -To 'Kamil <kamil.karpiuk@dsv.com>' -Subject 'External account reviewing' -Body 'Hello! This is brief view of External users accounts, directly reports to you. Provided by External Account Review(EAR script). '-Attachments @('C:\Users\kamil.karpiuk\OneDrive - DSV\Desktop\Code Vault\PowerShell\expiration_externals.csv') -SmtpServer 'smtprelay.dsv.com'-Port '25'


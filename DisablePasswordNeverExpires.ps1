$userAccounts = Get-ADUser -Filter * -SearchBase "OU=Users,DC=DOMAIN,DC=LOCAL" 

foreach ($userAccount in $userAccounts) {
    Set-ADUser -Identity $userAccount -PasswordNeverExpires $false
    Write-Host "Password never expires option disabled for user $UserAccount"
}
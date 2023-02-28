$users = Get-ADUser -Filter * -Properties PasswordLastSet, PasswordNeverExpires | Where-Object {
	($_.Enabled -eq $true -and $_.PasswordNeverExpires -eq $false) -and ($_.DistinguishedName -notlike "*Informatyka*" -or "*!Tymczasowe*" -or "*Integracje*"  -or "*Urzadzenia*")
} 

foreach ($user in $users) {
	$pwdLastSet = $user.PasswordLastSet
    $timeSincePwdLastSet = (Get-Date) - $pwdLastSet

    # Check if the password has not been changed in the last 90 days
    if ($timeSincePwdLastSet.Days -ge 30) {
        # Check if the password length is less than 12 characters
        if ($user.Password.Length -lt 12) {
            # Force the user to change their password at next logon
            Set-ADUser -Identity $user -ChangePasswordAtLogon $true
            Write-Host "User $($user.Name) has been forced to change their password at next logon."
        }
    }
}
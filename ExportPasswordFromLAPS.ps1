Import-Module AdmPwd.PS

$passwords =  Get-AdmPwdPassword -ComputerName * | Select-Object -Property ComputerName,PasswordLastSetTime,Password

$array = @();

foreach ($p in $passwords) {
	if ($p.Password) {
		$item = @{
      		organizationId = $null
      		folderId = "f1415bf5-d0a4-409b-b498-58dcc61e4fc8"
			type = 1
			reprompt = 0
			notes = $null
			favorite = $false
			collectionIds = @(
				"23605e34-b270-40aa-a9b6-7ddff2bcd261"
			)
			name = $p.ComputerName
			login = @{
				username = "Administrator"
				password = $p.Password
				totp = $null
			}
		}
		$array += $item;
	}
}

$today = Get-Date -Format "dd-MM-yyyy"




$jsonObject = @{
	encrypted = $false;
	folders = @(
		@{
			id = "f1415bf5-d0a4-409b-b498-58dcc61e4fc8"
			name = "LAPS import (" + $today + ")"
		}
	)
	collections = @(
		@{
			id = "23605e34-b270-40aa-a9b6-7ddff2bcd261"
			organizationId = $null
			name = "LAPS import (" + $today + ")"
			externalId = $null
		}
	)
	items = $array;
} | ConvertTo-Json -Depth 3 

$jsonObject | Out-File -Encoding UTF8 "C:\vaultwarden.json"
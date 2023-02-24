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
			collectionIds = $null
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
	items = $array;
} | ConvertTo-Json -Depth 3 | Out-File -Encoding UTF8 "C:\vaultwarden.json"
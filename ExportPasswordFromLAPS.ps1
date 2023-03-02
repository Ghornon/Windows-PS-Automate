Import-Module AdmPwd.PS

$passwords =  Get-AdmPwdPassword -ComputerName * | Select-Object -Property ComputerName,PasswordLastSetTime,Password

$newFolderId = New-Guid
$newCollectionId = New-Guid

$array = @();

foreach ($p in $passwords) {
	if ($p.Password) {
		$item = @{
      		organizationId = $null
      		folderId = $newFolderId
			type = 1
			reprompt = 0
			notes = $null
			favorite = $false
			collectionIds = @(
				$newCollectionId
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
			id = $newFolderId
			name = "LAPS import (" + $today + ")"
		}
	)
	collections = @(
		@{
			id = $newCollectionId
			organizationId = $null
			name = "LAPS import (" + $today + ")"
			externalId = $null
		}
	)
	items = $array;
} | ConvertTo-Json -Depth 3 

$jsonObject | Out-File -Encoding UTF8 "C:\vaultwarden.json"
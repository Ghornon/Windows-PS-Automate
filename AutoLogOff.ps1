quser | Select-String "Disc" | ForEach {
	$id = ($_.tostring() -split ' +')[2]
	$LogOnTime = ($_.tostring() -split ' +')[5]
	$currentDate = get-date -format "dd.MM.yyyy"

	if ($LogOnTime -ne $currentDate) {
		logoff $id
	}
}
param(
	[Parameter(Mandatory=$True)]
	[string]
	$source,
	[Parameter(Mandatory=$True)]
	[string]
	$message
	)
    Write-Host "From:" $source -ForegroundColor Red
	Write-Host "Message:" $message -ForegroundColor Red
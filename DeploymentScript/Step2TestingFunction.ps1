param(
	[string]
	$ResourceGroupName,

	[string]
	$FuncAppName
)
#Write-Host "Getting the user credentials..."
#$Creds = Invoke-AzureRmResourceAction -ResourceGroupName $ResourceGroupName -ResourceType Microsoft.Web/sites/config `
#            -ResourceName $FuncAppName/publishingcredentials -Action list -ApiVersion 2015-08-01 -Force

$url="https://funcsca3asdpbqefi.azurewebsites.net/api/Step2CutomFunction?code='3S67fS777boKoiTqTgztmq7invw1Gcnwpe10Z8h3FsScYp7gLaLk76Rpm2ai'&name=$funcsca3asdpbqefi"

Invoke-RestMethod -Uri $url  -Method POST -ContentType "application/json" -Body '{'
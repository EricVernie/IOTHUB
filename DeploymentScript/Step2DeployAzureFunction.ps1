#name of the kudu server
param(
	[Parameter(Mandatory=$True)]
    [string]	
    $SiteFuncName
)

Write-Host "Deploying the function...."

$KudoSiteName=$SiteFuncName + "scm.azurewebsites.net"

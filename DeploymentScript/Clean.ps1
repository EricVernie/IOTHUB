param(    
	[Parameter(Mandatory=$True)]
    [string]
    $resourceGroupName,
	[Parameter(Mandatory=$True)]
    [boolean]	
    $Login
	)
Disable-AzureDataCollection

if($Login)
	{
		.\Login.ps1
	}	


Write-Host "Removing Resource Group"
Remove-AzureRmResourceGroup -Name $resourceGroupName
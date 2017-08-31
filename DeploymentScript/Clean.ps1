param(    
	[Parameter(Mandatory=$True)]
    [string]
    $resourceGroupName,
	[Parameter(Mandatory=$True)]
    [string]	
    $Login
	)
Disable-AzureDataCollection

if($Login.ToUpper() -eq "O")
			{
				Invole-Expression ".\Login.ps1"
			}	


Write-Host "Removing Resource Group"
Remove-AzureRmResourceGroup -Name $resourceGroupName
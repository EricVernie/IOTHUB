param(    
	[Parameter(Mandatory=$True)]
    [string]
    $ResourceGroupName,
	[Parameter(Mandatory=$True)]
    [string]	
    $Login
	)
Disable-AzureDataCollection

if($Login.ToUpper() -eq "O")
			{
				Invoke-Expression ".\Login.ps1"
			}	


Write-Host "Removing Resource Group"
Remove-AzureRmResourceGroup -Name $ResourceGroupName
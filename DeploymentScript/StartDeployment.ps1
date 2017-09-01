param(
	[Parameter(Mandatory=$True)]
    [string]	
    $Step,
	[Parameter(Mandatory=$True)]
    [string]	
    $DeployedCustomPowershell,
	
	[Parameter(Mandatory=$True)]
    [string]	
    $Login,
	[Parameter(Mandatory=$True)]
    [string]	
    $RegisterResourceProvider,

	[Parameter(Mandatory=$True)]
    [string]	
    $DeploymentName

	)
	Invoke-Expression ".\ChangePrompt.ps1"
	try
	{
		#First Setup the custom Powershell command if not already
		Write-Host $DeployedCustomPowershell
		if ($DeployedCustomPowershell.ToUpper() -eq "O")
		{
		Write-Host "Installing Custom Powershell CmdLet"
			Invoke-Expression ".\SetupCustomPowershellCmdlet.ps1"
		}

			if($Login.ToUpper() -eq "O")
			{
				Invoke-Expression ".\Login.ps1"
			}
			if ($RegisterResourceProvider.ToUpper() -eq "O")
			{
				Invoke-Expression '.\RegisterResources.ps1'   
			}
			

			Invoke-Expression ".\AddNewResourceGroupDeployment.ps1 '$Step' '$DeploymentName'"
			
	}
	catch
	{
		.\ErrorHelper.ps1   "Startdeployment.ps1"	 $($_.Exception.Message)	
	}


param(
	[Parameter(Mandatory=$True)]
    [string]	
    $deployedCustomPowershell,
	
	[Parameter(Mandatory=$True)]
    [string]	
    $Login,

	[Parameter(Mandatory=$True)]
    [string]	
    $deploymentName

	)
	.\ChangePrompt.ps1
	try
	{
		#First Setup the custom Powershell command if not already
		Write-Host $deployedCustomPowershell
		if ($deployedCustomPowershell.ToUpper() -eq "O")
		{
		Write-Host "Installing Custom Powershell CmdLet"
			.\SetupCustomPowershellCmdlet.ps1
		}

			if($Login.ToUpper() -eq "O")
			{
				.\Login.ps1
			}	
			.\Step1InvokeArmTemplate.ps1 $deploymentName
	}
	catch
	{
		.\ErrorHelper.ps1   "Startdeployment.ps1"	 $($_.Exception.Message)	
	}


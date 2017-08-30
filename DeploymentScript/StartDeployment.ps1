param(
	[Parameter(Mandatory=$True)]
    [string]	
    $deployedCustomPowershell,
	
	[Parameter(Mandatory=$True)]
    [string]	
    $Login

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
			.\Step1InvokeArmTemplate.ps1
	}
	catch
	{
		.\ErrorHelper.ps1   $($_.Exception.Source)	 $($_.Exception.Message)	
	}


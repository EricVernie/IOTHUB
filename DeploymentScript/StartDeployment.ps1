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
    $DeploymentName

	)
	.\ChangePrompt.ps1
	try
	{
		#First Setup the custom Powershell command if not already
		Write-Host $DeployedCustomPowershell
		if ($DeployedCustomPowershell.ToUpper() -eq "O")
		{
		Write-Host "Installing Custom Powershell CmdLet"
			.\SetupCustomPowershellCmdlet.ps1
		}

			if($Login.ToUpper() -eq "O")
			{
				.\Login.ps1
			}	
			
			if ($Step.ToUpper() -eq "STEP1")
				{
					.\Step1InvokeArmTemplate.ps1 $DeploymentName
				}
			else
				{
					Write-Host "Unknow script !!"
				}
	}
	catch
	{
		.\ErrorHelper.ps1   "Startdeployment.ps1"	 $($_.Exception.Message)	
	}


param(  
	[Parameter(Mandatory=$True)]
	[string]
	$Step,
	
	[Parameter(Mandatory=$True)]
    [string]
    $ResourceGroupName,
   
	[string]
    $TemplateFilePath=$Step +"template.json",
		
    [string]
    $ResourceGroupLocation="North Europe",
   
	[string]
	$DeviceId="Device42"
   )

   try
   {
		
		$Command = ".\CreateResourceGroup.ps1 '$ResourceGroupName' '$ResourceGroupLocation'"
	   Invoke-Expression $Command
	
	   # Start the deployment using template
	   Write-Host "Starting deployment...";  
	   
	   New-AzureRmResourceGroupDeployment -DeploymentDebugLogLevel None -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFilePath;		   

	   $StepFinish =".\"+$Step+"Finish.ps1 '$ResourceGroupName' '$DeviceId'"
	   
	   Invoke-Expression  $StepFinish 
   }
   catch
   {
	   
		.\ErrorHelper.ps1   "AddNewResourceGroupDeployment.ps1"	 $($_.Exception.Message)	
   }
   

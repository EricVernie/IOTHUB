	# sign in
	
	Write-Host "Logging in...";
	try
	{
		$Subscription=Login-AzureRmAccount;
		if ($Subscription)
		{
			$SubscriptionId = $Subscription.Context.Subscription.SubscriptionId;
			# select subscription
			if ($SubscriptionId -eq $null)
			{				
				throw [System.Exception] "It seems that you don't have any Azure subscription check it on the azure portal: https://portal.azure.com"
			}
			else
			{
				Write-Host "Selecting subscription '$SubscriptionId'";
				Select-AzureRmSubscription -SubscriptionID $SubscriptionId;
				Write-Host "Login succeeded"		
			}
			
		}
		else
		{
			throw [System.Exception] "you are not authentified"
		}
	}
	catch
	{			
			throw
	}
		
		

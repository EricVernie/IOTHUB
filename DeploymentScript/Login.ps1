	# sign in
	
	Write-Host "Logging in...";
	try
	{
		$subscription=Login-AzureRmAccount;
		if ($subscription)
		{
			$subscriptionId = $subscription.Context.Subscription.SubscriptionId;
			# select subscription
			if ($subscriptionId -eq $null)
			{				
				throw [System.Exception] "It seems that you don't have any Azure subscription check it on the azure portal: https://portal.azure.com"
			}
			else
			{
				Write-Host "Selecting subscription '$subscriptionId'";
				Select-AzureRmSubscription -SubscriptionID $subscriptionId;
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
		
		

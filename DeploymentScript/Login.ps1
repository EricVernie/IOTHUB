	# sign in
	
	Write-Host "Logging in...";
	
		$subscription=Login-AzureRmAccount;
		if ($subscription)
		{
			$subscriptionId = $subscription.Context.Subscription.SubscriptionId;
			# select subscription
			Write-Host "Selecting subscription '$subscriptionId'";
			Select-AzureRmSubscription -SubscriptionID $subscriptionId;
			Write-Host "Login succeeded"		
		}
		else
		{
			.\ErrorHelper.ps1 "Login.ps1" "no authentified"
		}
		

# Iot Hub Demo

The purpose of this demo, is to provide all the necessaries elements in order to:

__Step1__

Simulate de vice on your PC

1. Create the IOT Hub with template ARM (__Step1template__.json) and Powershell cmdlet
2. Simulate a device which send telemetry to the cloud (D2C)
3. Read the telemetry from the Device
4. Send message to the device (C2D)
5. Invoke direct method

For More information see [Connect your device to your IoT hub using .NET](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-csharp-csharp-getstarted)

__Step2__
1. All the Step1
2. Create an Azure Storage (__Step2template.json__)

For More Information see [Save IoT hub messages that contain sensor data to your Azure table storage](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-store-data-in-azure-table-storage)

To complete the demo, you need the following:

* Visual Studio 2017.
* An active Azure account. (If you don't have an account, you can create a [free account](http://azure.microsoft.com/pricing/free-trial/) in just a couple of minutes.)


# Solution

Clone the solution https://github.com/EricVernie/IOTHUB.git

Open the IotHubLab solution in VS 2017 and build it.
You will find the following projects:

## SimulatedDevice 
1. Connects to your to your IoT hub with the device identity, and sends a telemetry message every second by using the AMQP protocol.
2. Receives message from cloud
3. Responses to Direct Method (writeLine)




## CloudToDevice
1. Displays the telemetry sent by your device app
2. Sends a message to the Device
3. Invokes a direct method (writeLine)


## PowershellCmdLet
* Allows to create a device in your Iot Hub

## DeploymentScript 
* Contains all necessaries Powershell scripts & ARM Templates to set up the IOT Hub Resources in your Azure Subscription



# Setup
If you have not installed Azure PowerShell, see [How to install and configure Azure PowerShell](https://docs.microsoft.com/en-us/powershell/azure/overview?view=azurermps-4.3.1).

or access directly to the setup files:

[Azure PowerShell 4.3.1 Installer](https://github.com/Azure/azure-powershell/releases/download/v4.3.1-August2017/azure-powershell.4.3.1.msi)

[Gallery Module for ARM Cmdlets](https://www.powershellgallery.com/packages/AzureRM/4.3.1)


If you have installed Azure PowerShell in the past but have not updated it recently, consider installing the latest version. You can update the version through the same method you used to install it. For example, if you used the Web Platform Installer, launch it again and look for an update.

To check your version of the Azure Resources module, use the following cmdlet:

```json
PS:> Get-Module -ListAvailable -Name AzureRm.Resources | Select Version
```

# Create an Azure IOT Hub 

* Open a Powershell console in admin mode

* Go to the __DeploymentScript__ folder, and enter the following command:
```json
PS:> .\StartDeployment.ps1 -Step Step1 -DeployedCustomPowershell O -Login O -RegisterResourceProvider O -ResourceGroupName [RESOURCE GROUP NAME IOT HUB NAME]
```

| Parameters | Value | Description|
| ------------- |:-------------:| -----:|
| Step | StepX | This parameter use the appropriate ARM Template in order to create the resources|
| DeployedCustomPowershell | O or N | This parameter allows to set up the custom powershell command (PowershellCmdlet). __Note:__ If you stay in the current powershell session the next time you execute the script, no need to install again the Powershell command, so, enter 'N' or whatever except 'O'. |
|Login | O or N | Allows to sign in to your Azure Subscription. __Note:__ If you stay in the current powershell session the next time you execute the script, no need to reenter your Azure credential, so, enter 'N' or whatever except 'O'
|RegisterResourceProvider | O or N | Register the Resource Providers
|ResourceGroupName|[YOUR RESOURCE GROUP NAME]||
	



The set up start and do the following tasks:
1. Installs the custom Powershell command
2. Logs in with your azure credential 
3. Creates an Azure Resource Group
   
```json
	New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation 
```

__Note__: By default the name of the resource group is a composition of [YOUR IOT HUB NAME DEPLOYMENT] and .rg extension and the location is __North Europe__ (near my home)


4. Start the deployment to Azure using the __StepXtemplate.json__ template
	```json
	New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath;
	```
5. Create a device in the Iot Hub (Custom Powershell CmdLet)
    ```json
	Add-CreateIOTHubDevice -ConnectionString $connectionString  -Name $deviceId
	```
## Test Step1
To test the solution launch the console Apps:

Sending telemetry
```json
PS:> .\SimulatedDevice.exe [IOT HUB NAME] [DEVICE KEY] [DEVICEID]
```

Receive telemetry
```json
PS:>.\CloudToDevice.Exe [IOT Hub ConnectionString] [DEVICEID]
```

__Note__: You can send a message or Invoke a method to the device entering 's' or 'i' characters in the CloudToDevice console App

You can also use the [Azure Portal](https://portal.azure.com) in order to send a message to the device or invoke a direct method.

* Sign in to the Azure Portal [Azure Portal](https://portal.azure.com)
* Select the Resource Group
* Select the IOT Hub resource
* Select Device Explorer
* Select the Device ID (i.e Device42 for example)

Send a message

* Click on __Message to Device__
* In the __Message Body__ enter your message
* then click on __Send the Message__
* Checked in the SimulatedDevice app console that your message is displayed

Invoke a method

* Click on __Direct Method__
* In the __Method Name__ box enter writeLine
* In the __Payload__ box enter 'Your message to print'
* Then click on __Invoke Method__
* Checked if the SimulatedDevice correclty call the writeLine method displaying the Payload to the console.

To delete the IOT HUB execute the script: 
```json
PS:>.\Clean.ps1 [RESOURCE GROUP NAME]
```

__Remarks__: The template use as a pricing and scale tier 'free' and 'F1' which allows only __1 unit__. So you can create only 1 IOT Hub.
If you want to have more than one IOT Hub resources, edit the template.json and change the following in the resources section:
```json
"sku": {
        "name": "S1",
        "tier": "Standard",
        "capacity": 200
      },








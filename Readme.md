# Iot Hub Demo

The purpose of this demo, is to provide all the necessaries elements in order to:

__Step1__

Simulate device on your PC 

1. Create the IOT Hub with template ARM (__Step1template.json__) and Powershell cmdlet
2. Simulate a device which send telemetry to the cloud (D2C)
3. Read the telemetry from the Device
4. Send message to the device (C2D)
5. Invoke direct method

For More information see [Connect your device to your IoT hub using .NET](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-csharp-csharp-getstarted)

__Step2__

Store IOT Hub message to Azure Storage using an Azure Function App

1. Create the IOT Hub with template ARM (__Step2template.json__) and Powershell cmdlet
2. Create an Azure Storage to store messages from IOT Hub
3. Create an Azure Function App (Site)
4. Create a __function.json__ files allowing to bind the Iot Hub event endpoint and Azure Storage endpoint
5. Deploy the function to the Function App

For More Information see [Save IoT hub messages that contain sensor data to your Azure table storage](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-store-data-in-azure-table-storage)
__Step3__

Visualize real-time sensor data that your IoT hub receives by running a web application that is hosted on a web app

For more information [Visualize real-time sensor data from your Azure IoT hub by using the Web Apps feature of Azure App Service](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-live-data-visualization-in-web-apps)

1. Create the IOT Hub with template ARM (__Step3template.json__) and Powershell cmdlet
2. Create a web app 
3. 

To complete the demos, you need the following:

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

## AzureFunction

* Includes the Azure Function code which store IotHub message to an Azure Storage
    ```json
    // JavaScript source code
    'use strict';
    // This function is triggered each time a message is received in the IoT hub.
    // The message payload is persisted in an Azure storage table
    
    module.exports = function (context, iotHubMessage) {
    context.log('Message received: ' + JSON.stringify(iotHubMessage));
    var date = Date.now();
    var partitionKey = Math.floor(date / (24 * 60 * 60 * 1000)) + '';
    var rowKey = date + '';
    context.bindings.outputTable = {
     "partitionKey": partitionKey,
     "rowKey": rowKey,
     "message": JSON.stringify(iotHubMessage)
    };
    context.done();
    };
    ```


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
#Step1
PS:> .\StartDeployment.ps1 -Step Step1 -DeployedCustomPowershell O -Login O -RegisterResourceProvider O -ResourceGroupName [RESOURCE GROUP NAME IOT HUB NAME]

#Step2
PS:> .\StartDeployment.ps1 -Step Step2 -DeployedCustomPowershell O -Login O -RegisterResourceProvider O -ResourceGroupName [RESOURCE GROUP NAME IOT HUB NAME]

```

| Parameters | Value | Description|
| ------------- |:-------------:| -----:|
| Step | StepX | This parameter use the appropriate ARM Template in order to create the resources|
| DeployedCustomPowershell | O or N | This parameter allows to set up the custom powershell command (PowershellCmdlet). __Note:__ If you stay in the current powershell session the next time you execute the script, no need to install again the Powershell command, so, enter 'N' or whatever except 'O'. |
|Login | O or N | Allows to sign in to your Azure Subscription. __Note:__ If you stay in the current powershell session the next time you execute the script, no need to reenter your Azure credential, so, enter 'N' or whatever except 'O'
|RegisterResourceProvider | O or N | Register the Resource Providers
|ResourceGroupName|[YOUR RESOURCE GROUP NAME]||
	

## Test Step1

Launch the __SimulatedDevice__ console App to send telemetry

```json
PS:> .\SimulatedDevice.exe [IOT HUB NAME] [DEVICE KEY] [DEVICEID]
```
Launch __CloudToDevice__ console app to receive telemetry

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
* Checked if the SimulatedDevice correctly called the __writeLine__ method displaying the Payload to the console.

## Test Step2
__Verify your message in your table storage__

1. Launch the __SimulatedDevice__ console App to send telemetry
```json
PS:> .\SimulatedDevice.exe [IOT HUB NAME] [DEVICE KEY] [DEVICEID]
```
2. [Download and install Azure Storage Explorer](https://azure.microsoft.com/en-us/features/storage-explorer/)
3. Open Storage Explorer, click __Add an Azure Account > Sign in__, and then sign in to your Azure account.
4. Click your Azure subscription > __Storage Accounts__ > your storage account > Tables > __deviceData__.

You should see messages sent from your device to your IoT hub logged in the __deviceData__ table.

You can also use the [Azure Portal](https://portal.azure.com) in order to invoke the azure function.

* Sign in to the Azure Portal [Azure Portal](https://portal.azure.com)
* Select the Resource Group
* Select the Function App 
* Select the __Step2CustomFunction__
* At the right on the screen, select __test__
* In the __Request body__ enter a message '_This is a message from Step2CustomFunction_'
* Check in Azure Storage Explorer 
  




To delete the Azure Resources execute the script: 
```json
PS:>.\Clean.ps1 [RESOURCE GROUP NAME]
```








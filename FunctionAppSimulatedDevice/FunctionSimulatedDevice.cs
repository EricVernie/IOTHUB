using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Newtonsoft.Json;
using Microsoft.Azure.Devices.Client;
using System.Text;
using System.Threading.Tasks;

namespace FunctionAppSimulatedDevice
{
    public static class FunctionSimulatedDevice
    {
        [FunctionName("FunctionSimulatedDevice")]
        public static void Run([QueueTrigger("queue35fvteqbcapb6", Connection = "STORAGE__CONNECTION_STRING")]string myQueueItem, TraceWriter log)
        {
            //TODO Setup AppSettings
            log.Info($"C# Queue trigger function processed: {myQueueItem}");
            //Start device
            
            try
            {
                DeviceInfo di = JsonConvert.DeserializeObject<DeviceInfo>(myQueueItem);
                log.Info($"starting sending telemetry from {di.DeviceId}");    
                
                DeviceClient deviceClient = DeviceClient.Create(di.DeviceUri, new DeviceAuthenticationWithRegistrySymmetricKey(di.DeviceId, di.DevicePrimaryKey), TransportType.Amqp);
                SendDeviceToCloudMessagesAsync(deviceClient, di,log);
            }
            catch (JsonReaderException jsonException)
            {
                log.Info(jsonException.Message);                
            }            
        }
        private static async void SendDeviceToCloudMessagesAsync(DeviceClient deviceClient, DeviceInfo deviceInfo, TraceWriter log)
        {
            double minTemperature = 20;
            double minHumidity = 60;
            int messageId = 1;
            Random rand = new Random();

            while (true)
            {
                              
                double currentTemperature = minTemperature + rand.NextDouble() * 15;
                double currentHumidity = minHumidity + rand.NextDouble() * 20;

                var telemetryDataPoint = new
                {
                    messageId = messageId++,
                    deviceId = deviceInfo.DeviceId,
                    temperature = currentTemperature,
                    humidity = currentHumidity
                };
                var messageString = JsonConvert.SerializeObject(telemetryDataPoint);
                var message = new Message(Encoding.ASCII.GetBytes(messageString));

                message.Properties.Add("temperatureAlert", (currentTemperature > 30) ? "true" : "false");

                await deviceClient.SendEventAsync(message);
                log.Info($"{DateTime.Now} > Sending message: {messageString}");
                await Task.Delay(deviceInfo.Delay);
            }
        }
    }
}

using System;
using Microsoft.Azure.Devices.Client;
using Newtonsoft.Json;
using System.Threading.Tasks;
using System.Text;
//DEMO SECOND COMMIT
namespace SimulatedDevice
{
    class Program
    {
        static DeviceClient _deviceClient;
        //static string iotHubUri = Properties.Settings.Default.IOTHubUri;
        //static string deviceKey = Properties.Settings.Default.DevicePrimaryKey;
        static string _deviceId;
        static void Main(string[] args)
        {
            if (args.Length <= 1 || args[0].ToLower().Equals("help"))
            {
                Console.WriteLine("arguments: IOTHubName DevicePrimaryKey DeviceId");
                return;
            }
                        
            try
            {
                string deviceKey = args[1];
                _deviceId = args[2];
                string iotHubUri = $"{args[0]}.azure-devices.net";
                Console.ForegroundColor = ConsoleColor.Green;
                _deviceClient = DeviceClient.Create(iotHubUri, new DeviceAuthenticationWithRegistrySymmetricKey(_deviceId, deviceKey), TransportType.Amqp);


                ReceiveMessagesFromCloudAsync();
                SendDeviceToCloudMessagesAsync();

                _deviceClient.SetMethodHandlerAsync("writeLine", WriteLineToConsole, null).Wait();
                Console.ReadLine();
            }
            catch (Exception ex)
            {

                Console.WriteLine(ex.Message);
                Console.WriteLine(ex.Source);
            }
            
        }
       
        private static async void ReceiveMessagesFromCloudAsync()
        {
            Console.ForegroundColor = ConsoleColor.Red;
            Console.WriteLine("En attente de recevoir un message du Cloud");
            while (true)
            {
                                
                var message = await _deviceClient.ReceiveAsync();
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine("#############Message recu du Cloud#######################");
                if (message == null) continue;
                if (message.Properties.Count > 0 && message.Properties.ContainsKey("Command"))
                {
                    var s = message.Properties["Command"];
                    if (s.Equals("clear"))
                    {
                        Console.Clear();
                    }
                }
                
                
                Console.WriteLine("Message Recu du cloud");
                byte[] buffer = message.GetBytes();
                var stringBuffer=Encoding.ASCII.GetString(buffer);
                Console.WriteLine(stringBuffer);
                Console.WriteLine("###########################################################");
                Console.ResetColor();
                await _deviceClient.CompleteAsync(message);
                await Task.Delay(1000);
                

            }
        }
        static Task<MethodResponse> WriteLineToConsole(MethodRequest methodRequest, object userContext)
        {
            Console.ForegroundColor = ConsoleColor.Magenta;

            Console.WriteLine("#############Methode invoquee du Cloud#######################");
            Console.WriteLine();
            Console.WriteLine("\t{0}", methodRequest.DataAsJson);
            Console.WriteLine("Reponse pour la methode {0}", methodRequest.Name);

            string result = "'Ligne ecrite correctement (message de l appareil).'";
            Console.WriteLine("###########################################################");
            Console.ResetColor();
            return Task.FromResult(new MethodResponse(Encoding.UTF8.GetBytes(result), 200));
            
        }
        private static async void SendDeviceToCloudMessagesAsync()
        {
            double minTemperature = 20;
            double minHumidity = 60;
            int messageId = 1;
            Random rand = new Random();
            
            while (true)
            {
                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine("#############Envoi Message au Cloud#######################");

                double currentTemperature = minTemperature + rand.NextDouble() * 15;
                double currentHumidity = minHumidity + rand.NextDouble() * 20;

                var telemetryDataPoint = new
                {
                    messageId = messageId++,
                    deviceId = _deviceId,
                    temperature = currentTemperature,
                    humidity = currentHumidity
                };
                var messageString = JsonConvert.SerializeObject(telemetryDataPoint);
                var message = new Message(Encoding.ASCII.GetBytes(messageString));
                
                message.Properties.Add("temperatureAlert", (currentTemperature > 30) ? "true" : "false");

                await _deviceClient.SendEventAsync(message);
                Console.WriteLine("{0} > Sending message: {1}", DateTime.Now, messageString);
                Console.WriteLine("###########################################################");
                Console.ResetColor();
                await Task.Delay(3000);
            }
        }
    }
}

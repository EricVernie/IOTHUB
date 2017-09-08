using Microsoft.Azure.Devices;
using Microsoft.ServiceBus.Messaging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ReadDeviceToCloudMessages
{
    class Program
    {
        static string _connectionString;
        static string _iotHubD2cEndpoint = "messages/events";
        static EventHubClient _eventHubClient;
        static ServiceClient _serviceClient;
        static FeedbackReceiver<FeedbackBatch> _feedBackReceiver;
        static CloudToDeviceMethod _cloudToDeviceMethod;
        static string _deviceId;
        static string _consumerGroup=null;
        static void Main(string[] args)
        {
            if (args.Length <=1 || args[0].ToLower().Equals("help"))
            {
                Console.WriteLine("arguments: IOTHubConnectionString DeviceId ConsumerGroup (Optional)");
                return;
            }
           
            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine("CTRL-C : exit.");
            Console.WriteLine("s : Send a message to device.");
            Console.WriteLine("i : Invoke a method.\n");
            _connectionString = args[0]; 
            _deviceId = args[1];
            if (args.Length == 3)
            {
                _consumerGroup = args[2];
            }
            _eventHubClient = EventHubClient.CreateFromConnectionString(_connectionString, _iotHubD2cEndpoint);
            _serviceClient = ServiceClient.CreateFromConnectionString(_connectionString);
            var d2cPartitions = _eventHubClient.GetRuntimeInformation().PartitionIds;
             _feedBackReceiver = _serviceClient.GetFeedbackReceiver();
            _cloudToDeviceMethod = new CloudToDeviceMethod("writeLine") { ResponseTimeout = TimeSpan.FromSeconds(30) };
            CancellationTokenSource cts = new CancellationTokenSource();
            
            
            
            var tasks = new List<Task>();


            foreach (string partition in d2cPartitions)
            {
                tasks.Add(ReceiveMessagesFromDeviceAsync(partition, cts.Token));
            }

            
            tasks.Add(ReceiveFeedbackAsync());            
            tasks.Add(HubMethodsAsync());
            Task.WaitAll(tasks.ToArray());
        }
        static async Task HubMethodsAsync()
        {
            while(true)
            {
                var keyInfo = Console.ReadKey();
                switch(keyInfo.Key)
                {
                    case ConsoleKey.C:
                        Console.Clear();
                        break;
                    case ConsoleKey.S:
                        await SendMessageToDeviceAsync();
                        break;
                    case ConsoleKey.I:
                        await InvokeMethodAsync();
                        break;
                    default:
                        break;
                }
            }
        }
        static int compteur = 1;
        static int i = 1;
        private async static Task ReceiveFeedbackAsync()
        {
            
          
            while (true)
            {
                
                var feedbackBatch = await _feedBackReceiver.ReceiveAsync();
                if (feedbackBatch == null) continue;
                Console.ForegroundColor = ConsoleColor.Yellow;
                Console.WriteLine("#############FeedBack Recu#######################");
                
                Console.WriteLine("feedback recu: {0}", string.Join(", ", feedbackBatch.Records.Select(f => f.StatusCode)));
                Console.WriteLine("#################################################");
                Console.ResetColor();
                await _feedBackReceiver.CompleteAsync(feedbackBatch);
            }
        }
        private static async Task InvokeMethodAsync()
        {
                                      
                    _cloudToDeviceMethod.SetPayloadJson($"'Message du cloud : une ligne a ecrire {i.ToString()}'");
                    var response = await _serviceClient.InvokeDeviceMethodAsync(_deviceId, _cloudToDeviceMethod);
                    Console.ForegroundColor = ConsoleColor.Magenta;
                    Console.WriteLine("Response status: {0}, payload:", response.Status);
                    Console.WriteLine(response.GetPayloadAsJson());
                    Console.ResetColor();
                    i++;            
        }
        private static async Task SendMessageToDeviceAsync()
        {

                                             
                //https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-csharp-csharp-c2d
                var message = new Message(Encoding.ASCII.GetBytes($"Message provenant du cloud #{compteur.ToString()}"));
                message.Ack = DeliveryAcknowledgement.Full;
                message.Properties.Add("Command", "clear");                              
                await _serviceClient.SendAsync(_deviceId, message);
                compteur += 1;            
        }
        private static async Task ReceiveMessagesFromDeviceAsync(string partition, CancellationToken ct)
        {
            try
            {
                EventHubConsumerGroup currentConsumerGroup = null;
                if (string.IsNullOrEmpty(_consumerGroup))
                {
                    currentConsumerGroup = _eventHubClient.GetDefaultConsumerGroup();
                }
                else
                {
                    currentConsumerGroup = _eventHubClient.GetConsumerGroup(_consumerGroup);
                }
                var eventHubReceiver = await currentConsumerGroup.CreateReceiverAsync(partition, DateTime.UtcNow);


                while (true)
                {
                    if (ct.IsCancellationRequested) break;
                    EventData eventData = await eventHubReceiver.ReceiveAsync();
                    if (eventData == null) continue;
                    Console.ForegroundColor = ConsoleColor.Green;
                    Console.WriteLine("#############Message Recu de l appareil#######################");
                    string data = Encoding.UTF8.GetString(eventData.GetBytes());
                    //var alert = eventData.Properties["temperatureAlert"];
                    //Console.WriteLine($"Alerte Temperature : {alert}");
                    Console.WriteLine("Message recu. Partition: {0} Data: '{1}'", partition, data);
                    Console.WriteLine("##############################################################");
                    Console.ResetColor();
                }
            }
            catch (Exception ex)
            {

                Console.WriteLine(ex.Message);
            }
            
        }
    }
}

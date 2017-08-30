namespace PowershellCmdLet
{
    using Microsoft.Azure.Devices;
    using Microsoft.Azure.Devices.Common.Exceptions;
    using System.Threading.Tasks;

    namespace PowershellCmdLet
    {
        public class RegisterIotHubDevice
        {
            public static async Task<Device> CreateDeviceAsync(string connectionString, string deviceId)
            {
                RegistryManager registryManager = null;
                Device device = null;

                try
                {
                    registryManager = RegistryManager.CreateFromConnectionString(connectionString);
                    device = await registryManager.AddDeviceAsync(new Device(deviceId));
                }
                catch (DeviceAlreadyExistsException)
                {
                    device = await registryManager.GetDeviceAsync(deviceId);
                }
                catch (Microsoft.Azure.Devices.Common.Exceptions.IotHubException)
                {
                    throw;
                }

                return device;
            }
        }
    }

}

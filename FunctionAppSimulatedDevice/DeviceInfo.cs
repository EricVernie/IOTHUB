using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FunctionAppSimulatedDevice
{

    public class DeviceInfo
    {
        public string Action { get; set; }
        public string DeviceUri { get; set; }
        public string IotHubName { get; set; }
        public string DeviceId { get; set; }
        public string DevicePrimaryKey { get; set; }
        public int Delay { get; set; }
    }

}

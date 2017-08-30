using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PowershellCmdLet
{
    using Microsoft.Azure.Devices;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Linq;
    using System.Management.Automation;
    using System.Text;
    using System.Threading.Tasks;

    namespace PowershellCmdLet
    {
        [Cmdlet(VerbsCommon.Add, "CreateIOTHubDevice")]
        public class CreateIOTHubDevice : PSCmdlet
        {

            private string _connectionString;
            [Parameter(Position = 0)]
            public string ConnectionString
            {
                get { return _connectionString; }
                set { _connectionString = value; }
            }

            private string _name;

            [Parameter(Position = 1)]
            public string Name
            {
                get { return _name; }
                set { _name = value; }
            }
            protected override void ProcessRecord()
            {
                Task<Device> t = RegisterIotHubDevice.CreateDeviceAsync(_connectionString, _name);
                var result = t.Result;
                this.WriteObject(result);

            }

        }

        [RunInstaller(true)]
        public class CreateIOTHubDeviceSnapIn : PSSnapIn
        {
            public CreateIOTHubDeviceSnapIn() : base()
            {

            }
            public override string Description
            {
                get { return "This CmdLet allow to create an IOTHub device"; }
            }

            public override string Name
            {
                get { return "CreateIotHubDevice"; }
            }

            public override string Vendor
            {
                get { return "Eric Vernié"; }
            }
            public override string VendorResource
            {
                get
                {
                    return "";
                }
            }
        }
    }

}

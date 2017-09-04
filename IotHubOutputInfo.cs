
public class Rootobject
{
    
    public Operationsmonitoringproperties operationsMonitoringProperties { get; set; }
    public string state { get; set; }
    public string provisioningState { get; set; }
    public object[] ipFilterRules { get; set; }
    public string hostName { get; set; }
    public Eventhubendpoints eventHubEndpoints { get; set; }
    public Routing routing { get; set; }
    public Storageendpoints storageEndpoints { get; set; }
    public Messagingendpoints messagingEndpoints { get; set; }
    public bool enableFileUploadNotifications { get; set; }
    public Cloudtodevice cloudToDevice { get; set; }
    public string features { get; set; }
}

public class Operationsmonitoringproperties
{
    public Events events { get; set; }
}

public class Events
{
    public string None { get; set; }
    public string Connections { get; set; }
    public string DeviceTelemetry { get; set; }
    public string C2DCommands { get; set; }
    public string DeviceIdentityOperations { get; set; }
    public string FileUploadOperations { get; set; }
    public string Routes { get; set; }
}

public class Eventhubendpoints
{
    public Events1 events { get; set; }
    public Operationsmonitoringevents operationsMonitoringEvents { get; set; }
}

public class Events1
{
    public int retentionTimeInDays { get; set; }
    public int partitionCount { get; set; }
    public string[] partitionIds { get; set; }
    public string path { get; set; }
    public string endpoint { get; set; }
}

public class Operationsmonitoringevents
{
    public int retentionTimeInDays { get; set; }
    public int partitionCount { get; set; }
    public string[] partitionIds { get; set; }
    public string path { get; set; }
    public string endpoint { get; set; }
}

public class Routing
{
    public Endpoints endpoints { get; set; }
    public object[] routes { get; set; }
    public Fallbackroute fallbackRoute { get; set; }
}

public class Endpoints
{
    public object[] serviceBusQueues { get; set; }
    public object[] serviceBusTopics { get; set; }
    public object[] eventHubs { get; set; }
}

public class Fallbackroute
{
    public string name { get; set; }
    public string source { get; set; }
    public string condition { get; set; }
    public string[] endpointNames { get; set; }
    public bool isEnabled { get; set; }
}

public class Storageendpoints
{
    public Default _default { get; set; }
}

public class Default
{
    public string sasTtlAsIso8601 { get; set; }
    public string connectionString { get; set; }
    public string containerName { get; set; }
}

public class Messagingendpoints
{
    public Filenotifications fileNotifications { get; set; }
}

public class Filenotifications
{
    public string lockDurationAsIso8601 { get; set; }
    public string ttlAsIso8601 { get; set; }
    public int maxDeliveryCount { get; set; }
}

public class Cloudtodevice
{
    public int maxDeliveryCount { get; set; }
    public string defaultTtlAsIso8601 { get; set; }
    public Feedback feedback { get; set; }
}

public class Feedback
{
    public string lockDurationAsIso8601 { get; set; }
    public string ttlAsIso8601 { get; set; }
    public int maxDeliveryCount { get; set; }
}

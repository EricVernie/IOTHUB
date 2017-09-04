
public class Function
{
    public Binding[] bindings { get; set; }
    public bool disabled { get; set; }
}

public class Binding
{
    public string type { get; set; }
    public string name { get; set; }
    public string direction { get; set; }
    public string path { get; set; }
    public string connection { get; set; }
    public string cardinality { get; set; }
    public string consumerGroup { get; set; }
    public string tableName { get; set; }
}

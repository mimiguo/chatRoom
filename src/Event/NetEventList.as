package Event
{
	public class NetEventList
	{
		static public const NETCONNECTION_CONNECT_CLOSED:String 		= "NetConnection.Connect.Closed";
		static public const NETCONNECTION_CONNECT_REJECTED:String 		= "NetConnection.Connect.Rejected";
		static public const NETCONNECTION_CONNECT_FAILED:String			= "NetConnection.Connect.Failed";
		static public const NETCONNECTION_CONNECT_APPSHUTDOWN:String	= "NetConnection.Connect.AppShutdown";
		static public const NETCONNECTION_CONNECT_INVALIDAPP:String		= "NetConnection.Connect.InvalidApp";
		static public const NETCONNECTION_CONNECT_SUCCESS:String		= "NetConnection.Connect.Success";
		
		static public const NETSTREAM_CONNECT_SUCCESS:String		= "NetStream.Connect.Success";
		static public const NETSTREAM_CONNECT_REJECTED:String		= "NetStream.Connect.Rejected";
		static public const NETSTREAM_CONNECT_FAILED:String			= "NetStream.Connect.Failed";
		static public const NETSTREAM_CONNECT_CLOSED:String			= "NetStream.Connect.Closed";
		static public const NETSTREAM_MULTICASTSTREAM_RESET:String	= "NetStream.MulticastStream.Reset";
		static public const NETSTREAM_BUFFER_FULL:String			= "NetStream.Buffer.Full";
		
		static public const NETGROUP_CONNECT_SUCCESS:String			= "NetGroup.Connect.Success";
		static public const NETGROUP_CONNECT_REJECTED:String		= "NetGroup.Connect.Rejected";
		static public const NETGROUP_CONNECT_FAILED:String			= "NetGroup.Connect.Failed";
		static public const NETGROUP_POSTING_NOTIFY:String			= "NetGroup.Posting.Notify";
		static public const NETGROUP_SENDTO_NOTIFY:String			= "NetGroup.SendTo.Notify";
		static public const NETGROUP_LOCALCOVERAGE_NOTIFY:String	= "NetGroup.LocalCoverage.Notify";
		static public const NETGROUP_NEIGHBOR_CONNECT:String		= "NetGroup.Neighbor.Connect";
		static public const NETGROUP_NIEGHBOR_DISCONNECT:String		= "NetGroup.Neighbor.Disconnect";
		static public const NETGROUP_REPLICATION_REQUEST:String		= "NetGroup.Replication.Request";
		static public const NETGROUP_MULTICASTSTREAM_PUBLISHNOTIFY:String		= "NetGroup.MulticastStream.PublishNotify";
		static public const NETGROUP_MULTICASTSTREAM_UNPUBLISHNOTIFY:String		= "NetGroup.MulticastStream.UnpublishNotify";
		static public const NETGROUP_REPLICATION_FETCH_SENDNOTIFY:String		= "NetGroup.Replication.Fetch.SendNotify";
		static public const NETGROUP_REPLICATION_FETCH_FAILED:String			= "NetGroup.Replication.Fetch.Failed";
		static public const NETGROUP_REPLICATION_FETCH_RESULT:String			= "NetGroup.Replication.Fetch.Result";
	}
}
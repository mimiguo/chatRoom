package Model
{
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.ObjectEncoding;
	import mx.core.UIComponent;

	public class FMSservice
	{
		private var cam:Camera;
		private var mic:Microphone;
		public var container:UIComponent;
		public var streamVideo:Video;
		
		public var nc_Publisher:NetConnection;
		public var ns_Publisher:NetStream;
		public var nc_Receiver:NetConnection;
		public var ns_Receiver:NetStream;
		
		private var showlog:Boolean = true;
		
		public function FMSservice()
		{
//			傳出Stream的程式碼
			cam = Camera.getCamera();
			mic = Microphone.getMicrophone();
			
			nc_Publisher = new NetConnection();
			nc_Publisher.objectEncoding = ObjectEncoding.AMF0;
			nc_Publisher.connect("rtmp://fms.2be.com.tw/live");
			nc_Publisher.client = this;
			nc_Publisher.addEventListener( NetStatusEvent.NET_STATUS, publishStreamHandler);
			
//			播出來的程式碼
			streamVideo = new Video(320,240);
			streamVideo.name = "videoPlayer";
			container = new UIComponent();
			container.addChild( streamVideo );
			
			nc_Receiver = new NetConnection();
			nc_Receiver.objectEncoding = ObjectEncoding.AMF0;
			nc_Receiver.connect("rtmp://fms.2be.com.tw/live");
			nc_Receiver.client = this;
			nc_Receiver.addEventListener( NetStatusEvent.NET_STATUS, receiveStreamHandler);
		}
		private function publishStreamHandler(event:NetStatusEvent):void
		{
			trace("publishStream the event code is", event.info.code);
			ns_Publisher = new NetStream( nc_Publisher );
//			ns.addEventListener( NetStatusEvent.NET_STATUS, onNetStatusHandler);
			ns_Publisher.attachCamera( cam );
			ns_Publisher.attachAudio( mic );
			ns_Publisher.publish("ttttt", "live");
		}
		private function receiveStreamHandler( event:NetStatusEvent ):void
		{
			trace("receiveStreamHandler the event code is", event.info.code);
			ns_Receiver = new NetStream( nc_Receiver );
//			ns.addEventListener( NetStatusEvent.NET_STATUS, onNetStatusHandler );
			streamVideo.attachNetStream( ns_Receiver );
			ns_Receiver.play( "kkktt" );
		}
		public function onBWDone(...rest):void
		{
			trace('onBWDone();'+ rest, rest.length);
			if (showlog == false) {
				return;
			}
			for (var i:int=0; i<rest.length; ++i) {
				trace("\t"+i+":"+rest[i]);
			}
		}
		public function onMetaData(info:Object):void
		{
			trace('onMetaData');
			if (showlog == false) {
				return;
			}
			for( var p:String in info)
			{
				trace(p, info[p]);
			}
		}
		public function onPlayStatus(info:Object):void
		{
			trace('onPlayStatus');
			if (showlog == false) {
				return;
			}
			for( var p:String in info)
			{
				trace('*', p, info[p]);
			}
		}
		public function onXMPData(...rest):void
		{
			if (showlog == false) {
				return;
			}
			trace('onXMPData:'+ rest, rest.length);
			for (var i:int=0; i<rest.length; ++i) {
				trace("\t"+i+":"+rest[i]);
			}
		}
	}
}
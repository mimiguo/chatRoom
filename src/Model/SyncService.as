package Model
{
	import MyEvent.NetEventList;
	import flash.events.*;
	import flash.net.NetConnection;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import mx.utils.ObjectUtil;
	import util.TraceOut;
	
	public class SyncService extends EventDispatcher
	{
//		public static const STOP_CHAT:String = "STOP_CHAT";
		
		private var url:String = "rtmp://fms.2be.com.tw/basicSO";
		private var netConnection:NetConnection;
		private var so:SharedObject;
		
		public function SyncService()
		{
			netConnection = new NetConnection();
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, eventHandler);
		}
		
		public function start():void
		{
			netConnection.connect(this.url);
		}
		
		private function eventHandler(e:NetStatusEvent):void
		{
			switch( e.info.code )
			{
				case NetEventList.NETCONNECTION_CONNECT_SUCCESS:
					so = SharedObject.getRemote("videoChat", netConnection.uri, false);
					so.addEventListener(SyncEvent.SYNC, syncControl);
					so.addEventListener(AsyncErrorEvent.ASYNC_ERROR, syncErrorHandler);
					so.connect(netConnection, "test");
					break;
			}
		}
		
		private function syncControl(e:SyncEvent):void
		{
			dispatchEvent(e);
		}
//		private function syncControl(e:SyncEvent):void
//		{
//			trace("\n========================SyncEvent========================\n", ObjectUtil.toString(e) );
//			TraceOut.traceout(ObjectUtil.toString(e));
//			var len:int = e.changeList.length;
//			if (len == 1 && e.changeList[0].code == "clear") {
//				initSo();
//				return;
//			}
//			
//			for (var i:uint; i < len; i++) {
//				
//				// if self is not null, means have been login
//				if (e.changeList[i].code == "change" && self) {
//					trace("*name", e.changeList[i].name);
//					var changer:Object = so.data[e.changeList[i].name];
//					//finish
//					if (selectBy != null && changer.name == selectBy.name && changer.select == "" && changer.isPublish == false && changer.isPlay == false ) {
//						selectBy = null;
//						TraceOut.traceout("stop publish ");
//						TraceOut.traceout("stop play ");	
//					}
//					
//					// if user have been selected
//					//					trace("select", changer.select);
//					//					if ( so.data[e.changeList[i].name]["select"] == self.name ) {
//					if ( changer.select == self.name ) {
//						
//						trace("selected");
//						selectBy = changer;
//						//						if (self.isTalking) {
//						//							if (self.isPublish) {
//						//								//stop publish
//						//							} else {
//						//								//publish stream
//						//							}
//						// keep publishing	
//						trace("publish self");
//						// change chooser 
//						//							if (self.isPlay) {
//						//stop play
//						//							} else {
//						//play stream
//						//							}
//						//find who is talking to
//						//
//						
//						//						}
//						//cuz can switch stream to another, directly play
//						trace("play strem", e.changeList[i].name);
//					}
//					
//					// someone break my video chat
//					trace(changer.name, "changer.select", changer.select);
//					//if all empty string, no need to go into process
//					if ( changer.select == self.select && changer.select != "") {
//						if (selectBy != null ) {
//							selectBy = null;
//						}
//						finish();
//						trace("my selected person has been selected");
//						trace("stop publish");
//						trace("stop play");
//					}
//				} 
//			}
//		}
		
		private function initSo():void
		{
			trace("initSo");
//			for (var i:int=0; i<userList.length; i++ ) {
//				var user:User = userList[i];
//				so.setProperty(user.name, user);
//			}
		}
		
		private function syncErrorHandler(e:SyntaxError):void
		{
			trace('SyntaxError', ObjectUtil.toString(e));
		}
		
		public function getUserList():Object
		{
			return so.data;	
		}
	}
}
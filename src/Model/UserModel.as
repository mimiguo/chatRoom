package Model
{
	import Event.CustomEvent;
	import Event.EventsList;
	import Event.NetEventList;
	
	import Model.DepartmentList;
	import Model.User;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.SharedObject;
	
	import flashx.textLayout.elements.BreakElement;
	
	import mx.containers.Form;
	import mx.core.FlexGlobals;
	import mx.states.SetProperty;
	import mx.utils.ObjectProxy;
	import mx.utils.ObjectUtil;
	
	public class UserModel extends EventDispatcher
	{
	    private static var _access:Boolean = false;
		private static var _instance:UserModel;
		
		private var userList:Array;
		private var departmentList:Array;
		public var self:User;
		private var netConnection:NetConnection;
		private var so:SharedObject;
		
		public function UserModel()
		{
			if ( !_access) {
				throw new Error("Singleton");
			}
			
			userList = new Array(
				new User("Nerse", "aaaa", DepartmentList.NURSING),
				new User("Dr.A", "aaaa", DepartmentList.MEDICAL),
				new User("Dr.B", "aaaa", DepartmentList.MEDICAL),
				new User("Dr.C", "aaaa", DepartmentList.NEUROLOGY),
				new User("Dr.D", "aaaa", DepartmentList.NEUROLOGY),
				new User("Dr.E", "aaaa", DepartmentList.PEDIATRICS),
				new User("Dr.F", "aaaa", DepartmentList.PEDIATRICS),
				new User("Dr.G", "aaaa", DepartmentList.SURGICAL),
				new User("Dr.H", "aaaa", DepartmentList.SURGICAL),
				new User("Dr.I", "aaaa", DepartmentList.SURGICAL)
			);
			
			var rtmp:String = 'rtmp://fms.2be.com.tw/basicSO';
			netConnection = new NetConnection();
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, eventHandler);
			netConnection.connect(rtmp);
		}
		
		public static function get instance():UserModel
		{
				if ( _instance == null) {
					_access = true;
					_instance = new UserModel();
					_access = false;
				}
				
				return _instance;
		}
		
		/**
		 * 
		 * @param userName:String
		 * @param password:String
		 * @return 
		 * 
		 */

		public function login(userName:String, password:String):Object
		{
			for (var i:int=0; i<userList.length; i++ ) {
				var user:User = userList[i];
				if ( userName == user.name) {
					if (password == user.password) {
						self = user;
						setOnlineStatus(true);
//						return {result:true, msg:"login success"};
					} else {
						return {result:false, msg:"wrong password"};
					}
				}
			}
			return {result:false, msg:"user not found"};
		}
		
		/**
		 * type of each elemetn in userList is Model.User
		 * 
		 * @return userList:Array;
		 * @see Model.User
		 */		
		public function getUserList():Array
		{
			return userList;	
		}
		
		/**
		 * 
		 * @param isOnline:Boolean	
		 * 
		 * @see Model.User
		 */		
		private function setOnlineStatus(isOnline:Boolean):void
		{
//			self.isOnLine = isOnline;
			setProp(self.name, "isOnLine", isOnline);
		}
		
		public function select(who:String, selected:*):void
		{
			trace(who, selected);
			setProp(who, "select", selected);
		}
		
		private function eventHandler(e:NetStatusEvent):void
		{
			trace(ObjectUtil.toString(e));
			switch( e.info.code )
			{
				case NetEventList.NETCONNECTION_CONNECT_SUCCESS:
					so = SharedObject.getRemote("videoChat", netConnection.uri, false);
					so.addEventListener(SyncEvent.SYNC, syncControl);
					so.addEventListener(AsyncErrorEvent.ASYNC_ERROR, syncErrorHandler);
					so.connect(netConnection);
					break;
			}
		}
		
		private function syncControl(e:SyncEvent):void
		{
//			trace("================================================\n", ObjectUtil.toString(e) );
			FlexGlobals.topLevelApplication.status_txt.appendText( ObjectUtil.toString(e) );
			var len:int = e.changeList.length;
			if (len == 1 && e.changeList[0].code == "clear") {
//				so.setProperty("userList", userList);
				initSo();
				return;
			}
			for (var i:uint; i < len; i++) {
				if (e.changeList[i].code == "change") {
					trace("name", e.changeList[i].name);
				} 
			}
		}
		
		private function setProp(name:String, prop:String, value:*):void
		{
			for (var i:int=0; i< userList.length; i++) {
				var user:User = userList[i];
				if ( user.name == name) {
					user[prop] = value;
					trace(ObjectUtil.toString( user ));
					trace("user.name", user.name);
					so.setProperty(user.name, user);
					break;
				}
			}
//			trace(ObjectUtil.toString( list ));
//			so.setProperty("userList", list);
//			so.data.userList = list;
		}
		
		public function test(testvalue:*):void
		{
//			so.setProperty("test", testvalue);
			if (testvalue == "1") {
				so.setProperty("test", [1,2,3]);
			} else {
//				so.setProperty("test", [5,2,3]);
//				so.data.test[2]=100;
//				so.setProperty("test.2",100);
			}
		}
		
		private function initSo():void
		{
			trace("initSo");
			for (var i:int=0; i<userList.length; i++ ) {
				var user:User = userList[i];
				so.setProperty(user.name, user);
			}
		}
		
		private function syncErrorHandler(e:SyntaxError):void
		{
			trace(ObjectUtil.toString(e));
		}
		
	}
}
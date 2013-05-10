package Model
{
	import Model.DepartmentList;
	import Model.SyncService;
	import Model.User;
	import MyEvent.CustomEvent;
	import MyEvent.EventsList;
	import MyEvent.NetEventList;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.SharedObject;
	import mx.containers.Form;
	import mx.utils.ObjectUtil;

	public class UserModel extends EventDispatcher
	{
	    private static var _access:Boolean = false;
		private static var _instance:UserModel;
		
		private var userList:Array;
		private var departmentList:Array;
		public var self:Object;
		private var selectBy:Object;
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
			trace('connect', rtmp);
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
				var user:Object = userList[i];
				if ( userName == user.name) {
					if (password == user.password) {
						self = user;
						setOnlineStatus(true);
						return {result:true, msg:"login success"};
					} else {
						return {result:false, msg:"wrong password"};
					}
				}
			}
			return {result:false, msg:"user not found"};
		}
		
		public function logout(e:*=null):void
		{
			trace("logout", e);
			if (self) {
				setOnlineStatus(false);
			}
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
//			trace("self", self);
			setProp(self.name, ["isOnLine"], [isOnline]);
			updateList(self);
			
			if (isOnline == false) {
				finish();
				self = null;
			}
		}
		
		public function select(who:String, selected:*):void
		{
			setProp(who, ["select","isPublish"], [selected, true]);
		}
		
		public function finish():void
		{
			trace("self", self);
			if (self) {
				if (self.select == "") {
					//find who select me
					var who:Object = findWhoSelectMe();
					trace("who", who);
					if ( who ) {
						setProp(who.name, ["select", "isPublish", "isPlay"], ["", false, false]);
					}
				} else {
					setProp(self.name, ["select", "isPublish", "isPlay"], ["", false, false]);
				}
			}
			dispatchEvent( new Event(EventsList.EVENT_FINISH_CHAT) );
		}
		
		private function eventHandler(e:NetStatusEvent):void
		{
//			trace(ObjectUtil.toString(e));
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
			trace("\n========================SyncEvent========================\n", ObjectUtil.toString(e) );
			var len:int = e.changeList.length;
			if (len == 1 && e.changeList[0].code == "clear") {
				initSo();
				return;
			}
			
			for (var i:uint; i < len; i++) {
				
				if (e.changeList[i].code == "change" ) {
					trace("*name", e.changeList[i].name);
					var changer:Object = so.data[e.changeList[i].name];
					// changer and vldValue means same person
					trace("changer",ObjectUtil.toString(changer));
					var oldValue:Object = e.changeList[i].oldValue;
					trace("oldValue:", ObjectUtil.toString(oldValue));
					
					updateList(e.changeList[i]);
					
					if ( self ) {
						if ( changer.name == self.name) {
							self = changer;
						}
						
						if ( changer.isOnLine == false) {
							//have been changed
							if (oldValue && oldValue.select == self.name && changer.select == "" ) {
								trace("oldValue.select:", oldValue.select, "select:", changer.select);
								finish();
								return;
							}
						}
						
						// if someone off line, check if he is talking to me
						trace("changer.isOnline", changer.isOnLine);
						
						// if my select changes to empty ; check if someone i talk to is offline
						if ( changer.name == self.name && self.select == "" && oldValue.select != "" ) {
								finish();
								return;
						}
						
						// if user have been selected
						if ( changer.select == self.name ) {
							
							trace("selected");
							selectBy = changer;
							// keep publishing	
							//cuz can switch stream to another, directly play
							var playEvent:CustomEvent = new CustomEvent(EventsList.READY_TO_CHAT);
							playEvent.play = e.changeList[i].name;
//							playEvent.playIdx = findIndexWhoSelectMe(e.changeList[i].name);
							dispatchEvent(playEvent);
						}
						
						// someone break my video chat
						trace(changer.name, "changer.select", changer.select);
						//if all empty string, no need to go into process
						if ( changer.select == self.select && changer.select != "") {
							if (selectBy != null ) {
								selectBy = null;
							}
							trace("my selected person has been selected");
							trace("stop publish");
							trace("stop play");
							finish();
						}
					}
					
					//finish
					if (selectBy != null && changer.name == selectBy.name && changer.select == "" && changer.isPublish == false && changer.isPlay == false ) {
						selectBy = null;
						finish();
					}
				} 
				
				if ( e.changeList[i].code == "success") {
					if (self && e.changeList[i].name == self.name && self.select != "") {
						var chatEvent:CustomEvent = new CustomEvent(EventsList.READY_TO_CHAT);
						chatEvent.play = self.select;
						dispatchEvent(chatEvent);
					}
				}
			}
		}
		
		/**
		 * 
		 * @param name
		 * @param propArray:Array
		 * @param valueArray:Array
		 * 
		 */		
		private function setProp(name:String, propArray:Array, valueArray:Array):void
		{
			trace("setProp", name);
			
			for (var i:int=0; i< userList.length; i++) {
				var user:Object = userList[i];
				if ( user.name == name) {
						for (var j:int=0; j<propArray.length;j++) {
						user[ propArray[j] ] = valueArray[j];
					}
//					trace("user.name", user.name, ObjectUtil.toString( user ));
					so.setProperty(user.name, user);
					so.setDirty(user.name);
					break;
				}
			}
		}
		
		private function findWhoSelectMe():*
		{
			trace("findWhoSelectMe", so.data);
			for each (var value:Object in so.data) {
				trace("value.select:", value.select);
				if ( value.select == self.name )
				{
					return value;
				}
			}
		}
		
		private function findIndexWhoSelectMe(name:String):int
		{
			for (var i:int=0; i< userList.length; i++) {
				if (userList[i].name == name) {
					return i;
				}
			}
			return -1;
		}
		
		private function initSo():void
		{
			trace("initSo");
			for (var i:int=0; i<userList.length; i++ ) {
				var user:Object = userList[i];
				so.setProperty(user.name, user);
			}
		}
		
		private function syncErrorHandler(e:SyntaxError):void
		{
			trace('SyntaxError', ObjectUtil.toString(e));
		}
		
		private function updateList(changer:Object):void
		{
			trace("updateList");
			for (var i:int=0; i< userList.length; i++) {
//				trace(userList[i].name, changer.name);
				if (userList[i].name == changer.name) {
					userList[i] = so.data[changer.name];
					break;
				}
			}
//			trace(ObjectUtil.toString(userList));
			this.dispatchEvent(new Event(EventsList.EVENT_LIST_CHANGE));
		}
	}
}
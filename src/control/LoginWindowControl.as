package control
{
	import Model.UserModel;
	import MyEvent.EventsList;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.core.FlexGlobals;

	public class LoginWindowControl extends EventDispatcher
	{
		private var usermodel:UserModel;
		
		public function LoginWindowControl()
		{
			usermodel = UserModel.instance;
		}
		
		public function login(name:String, pwd:String):void
		{
			var status:Object = usermodel.login(name, pwd);
			if ( status.result ) {
				dispatchEvent( new Event( EventsList.LOGIN_SUCCESS ));
				FlexGlobals.topLevelApplication.id_lab.text = "user:"+usermodel.self.name;
			} else {
				dispatchEvent( new Event( EventsList.LOGIN_FAILED ));
				FlexGlobals.topLevelApplication.id_lab.text = status.msg;
			}
		}
	}
}
package Model
{
	public class User
	{
		public var name:String;
		public var password:String; 
		public var isOnLine:Boolean = false; 
		public var select:String = "";
		public var selectBy:String = "";
		public var isTalking:Boolean = false; 
		public var department:String = "";
		public var isPublish:Boolean = false;
		public var isPlay:Boolean = false;
		
		public function User(userName:String=null, passWord:String=null, depart:String=null)
		{
			this.name = userName;
			this.password = passWord;
			this.department = depart;
		}
		
		static public function makeVo(obj:Object):User
		{
			var vo:User = new User();
			for (var prop:String in obj) {
				vo[prop] = obj[prop];
			}
			return vo;
		}
	}
}
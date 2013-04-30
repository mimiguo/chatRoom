package Model
{
	public class User
	{
		public var name:String;
		public var password:String; 
		public var isOnLine:Boolean = false; 
		public var select:String = "";
		public var isTalking:Boolean = false; 
		public var department:String = "";
		public var isPublish:Boolean = false;
		public var isPlay:Boolean = false;
		public function User(userName:String, passWord:String, depart:String)
		{
			this.name = userName;
			this.password = passWord;
			this.department = depart;
		}
	}
}
package control
{
	import Model.FMSservice;
	import flash.media.SoundTransform;
	
	import spark.components.VGroup;
	
	import view.Player;

	public class PlayerControl
	{
		private var fmsService:FMSservice;
		private var st:SoundTransform;
		private var player:Player;
		
		public function PlayerControl( player:Player )
		{
			fmsService = FMSservice.instance; 
			st = new SoundTransform;
			this.player = player;
		}
		
		public function closeCameraStream():void
		{
			trace("fmsService", fmsService);
			fmsService.closeCameraStream();
			this.player.closeVideo();
		}
		
		public function controlSoundVolume( value:int ):void
		{
			st.volume = value;
			fmsService.ns_Receiver.soundTransform = st;
		}
	}
}
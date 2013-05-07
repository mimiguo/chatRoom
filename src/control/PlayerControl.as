package control
{
	import Model.FMSservice;
	
	import flash.media.SoundTransform;
	
	import mx.core.FlexGlobals;
	
	import spark.components.VGroup;

	public class PlayerControl
	{
		private var fmsService:FMSservice;
		public var st:SoundTransform;
		
		public function PlayerControl()
		{
			fmsService = FlexGlobals.topLevelApplication.fmsService;
			st = new SoundTransform;
		}
		
		public function closeCameraStream():void
		{
			trace("fmsService", fmsService);
			fmsService.closeCameraStream();
			var player:* = FlexGlobals.topLevelApplication.videoPlayer;
			player.closeVideo();
		}
		
		public function controlSoundVolume( value:int ):void
		{
			st.volume = value;
			fmsService.ns_Receiver.soundTransform = st;
		}
	}
}
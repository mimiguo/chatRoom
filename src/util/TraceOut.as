package util
{
	import mx.core.FlexGlobals;
	import mx.utils.ObjectUtil; 
	public class TraceOut
	{
		public static function traceout(msg:String):void
		{
			trace(msg);
			FlexGlobals.topLevelApplication.status_txt.appendText( msg );
		}
	}
}
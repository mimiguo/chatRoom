package MyEvent
{
	import flash.events.Event;
	
	public dynamic class CustomEvent extends Event
	{
		public function CustomEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
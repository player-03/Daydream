package daydream.menu 
{
	import org.flixel.FlxState;
	
	public class IntroState extends FlxState 
	{
		private var introClass:IntroClass;
		
		override public function create():void 
		{
			introClass = new IntroClass();
			
			add(introClass);
		}
	}

}
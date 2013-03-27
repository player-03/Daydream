package daydream.game 
{
	import org.flixel.FlxSprite;
	
	public class Umbrella extends FlxSprite
	{
		[Embed(source = "../../../lib/Umbrella.png")] protected var umbImg:Class;
		public function Umbrella(x:Number = 0, y:Number = 0) 
		{
			super(x, y);
			
			loadGraphic(umbImg);
		}
		
	}

}
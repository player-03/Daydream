package daydream.game 
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Alex Devik
	 */
	public class Umbrella extends FlxSprite
	{
		[Embed(source = "../../../lib/umbrella.png")] protected var umbImg:Class;
		public function Umbrella(x:Number = 0, y:Number = 0) 
		{
			super(x, y);
			
			loadGraphic(umbImg, false, false, 40, 40);
		}
		
	}

}
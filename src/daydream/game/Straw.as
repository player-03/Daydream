package daydream.game 
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Alex Devik
	 */
	public class Straw extends FlxSprite
	{
		[Embed(source = "../../../lib/straw.png")] protected var strawImg:Class;
		public function Straw(x:Number, y:Number) 
		{
			super(x, y);
			
			loadGraphic(strawImg, false, false, 40, 40);
		}
		
	}

}
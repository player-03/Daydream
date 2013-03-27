package daydream.game 
{
	import org.flixel.FlxSprite;
	
	public class PogoStick extends FlxSprite
	{
		
		[Embed(source = "../../../lib/Spring.png")] protected var pogoImg:Class;
		
		public function PogoStick(x:Number, y:Number) 
		{
			super(x, y);
			
			loadGraphic(pogoImg);
		}
		
	}

}
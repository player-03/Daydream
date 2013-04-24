package daydream.game 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxPoint;
	import daydream.utils.FlxSpriteUtils;
	
	public class Coin extends FlxSprite
	{
		[Embed(source = "../../../lib/COIN.png")] protected var coinImg:Class;
		
		public function Coin(x:Number, y:Number) 
		{
			super(x - 4, y - 10);
			
			loadGraphic(coinImg);
		}
		
	}

}
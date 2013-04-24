package daydream.game 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import daydream.utils.FlxSpriteUtils;
	
	public class CoinCounterSprite extends FlxSprite
	{
		[Embed(source = "../../../lib/COIN.png")] protected var coinImg:Class;
		
		public function CoinCounterSprite(x:Number, y:Number) 
		{
			super(x - 4, y - 10);
			
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			
			loadGraphic(coinImg);
		}
		
		
	}

}
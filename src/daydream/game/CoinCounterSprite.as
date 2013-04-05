package daydream.game 
{
	import org.flixel.FlxSprite;
	
	public class CoinCounterSprite extends FlxSprite
	{
		[Embed(source = "../../../lib/coin.png")] protected var coinImg:Class;
		
		public function CoinCounterSprite(x:Number, y:Number) 
		{
			super(x, y);
			
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			
			loadGraphic(coinImg);
		}
		
		
	}

}
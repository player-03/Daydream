package daydream.game 
{
	import org.flixel.FlxSprite;
	
	public class Coin extends FlxSprite
	{
		[Embed(source = "../../../lib/coin.png")] protected var coinImg:Class;
		
		public function Coin(x:Number, y:Number) 
		{
			super(x, y);
			
			loadGraphic(coinImg);
		}
		
	}

}
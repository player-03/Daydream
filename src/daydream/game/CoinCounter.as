package daydream.game 
{
	import org.flixel.FlxText;
	
	public class CoinCounter extends FlxText
	{
		/**
		 * Name of the coins collected variable in the save data.
		 */
		public static const COINS:String = "coins";
		
		private var getCoins:Function;
		private static var coinCount:int;
		
		public function CoinCounter(getCoins:Function, x:Number, y:Number) 
		{
			super(x, y, 300);
			
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			
			color = 0x00000000;
			size = 10;
			
			this.getCoins = getCoins;
		}
		
		public override function update():void
		{
			var coins:int = getCoins();
			
			if (coins == coinCount)
				return;
			coinCount = coins;
			
			if (coinCount < 10)
				text = "X0" + coinCount;
			else
				text = "X" + coinCount;
		}
	}
}
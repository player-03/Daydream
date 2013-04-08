package daydream.game 
{
	import org.flixel.FlxText;
	
	public class CoinCounter extends FlxText
	{
		private var child:Child;
		private static var coinCount:int;
		
		public function CoinCounter(child:Child, x:Number, y:Number) 
		{
			super(x, y, 300);
			
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			
			color = 0x00000000;
			
			this.child = child;
			this.size = 10;
		}
		
		public override function update():void
		{
			var coins:int = child.getCoins();
			
			if (coins != coinCount)
				coinCount = coins;
			
			if (coinCount < 10)
				text = "X0" + coinCount;
			else
				text = "X" + coinCount;
		}
		
	}

}
package daydream.game 
{
	import org.flixel.FlxBasic;
	import daydream.utils.NumberInterval;
	import org.flixel.FlxG;
	import Math;

	public class CoinSpawner extends FlxBasic
	{
		private var gameState:GameState;
		private var yInterval:NumberInterval;
		private var frequency:Number;
		
		private static const SPAWNCHECKINTERVAL:Number = 2;
		private var spawnCheckTimer:Number = 0;
		
		public function CoinSpawner(gameState:GameState, yInterval:NumberInterval, frequency:Number) 
		{
			super();
			
			this.gameState = gameState;
			this.yInterval = yInterval;
			this.frequency = frequency;
		}
		
		public override function update():void
		{
			if (spawnCheckTimer >= 0 && spawnCheckTimer < SPAWNCHECKINTERVAL)
			{
				spawnCheckTimer += FlxG.elapsed;
			}
			
			if (spawnCheckTimer >= SPAWNCHECKINTERVAL)
			{
				var check:Number = Math.random();
				
				if (check <= frequency)
				{
					var yVal:Number = Math.floor(Math.random() * (yInterval.max - yInterval.min + 1)) + yInterval.min;
					
					gameState.addItem(new Coin(FlxG.worldBounds.right, yVal));
				}
					
				spawnCheckTimer = 0;
			}
		}
		
	}

}
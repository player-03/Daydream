package daydream.game 
{
	import daydream.Main;
	import org.flixel.FlxBasic;
	import daydream.utils.NumberInterval;
	import org.flixel.FlxG;
	import Math;

	public class CoinSpawner extends FlxBasic
	{
		private var gameState:GameState;
		private var gapInterval:NumberInterval;
		private var yInterval:NumberInterval;
		
		private var nextX:Number;
		
		public function CoinSpawner(gameState:GameState, gapInterval:NumberInterval, yInterval:NumberInterval) 
		{
			super();
			
			this.gameState = gameState;
			this.gapInterval = gapInterval;
			this.yInterval = yInterval;
			
			nextX = FlxG.camera.scroll.x + gapInterval.randomValue();
		}
		
		public override function update():void
		{
			if(FlxG.camera.scroll.x >= nextX)
			{
				nextX += gapInterval.randomValue();
				
				gameState.addItem(new Coin(FlxG.camera.scroll.x + Main.STAGE_WIDTH,
											yInterval.randomValue()));
			}
		}
	}
}
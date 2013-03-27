package daydream.game {
	import daydream.Main;
	import daydream.utils.NumberInterval;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class Rain extends FlxSprite {
		[Embed(source = "../../../lib/Rain.jpg")] private static var RainImage:Class;
		
		private var gameState:GameState;
		private var rainbow:Rainbow;
		
		private var dryTime:Number;
		private var rainTime:Number;
		private var dryTimeIncrease:Number;
		private var rainTimeIncrease:Number;
		private var timeRemaining:Number;
		
		public function Rain(gameState:GameState, rainbow:Rainbow,
								dryTime:Number, rainTime:Number,
								dryTimeIncrease:Number = 0, rainTimeIncrease:Number = 0) {
			super(0, 0, null);
			
			this.gameState = gameState;
			this.rainbow = rainbow;
			
			this.dryTime = dryTime;
			this.rainTime = rainTime;
			this.dryTimeIncrease = dryTimeIncrease;
			this.rainTimeIncrease = rainTimeIncrease;
			
			//using the visible property to track whether it's raining
			visible = false;
			
			timeRemaining = dryTime;
			timeRemaining = 2;
			
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			
			loadGraphic(RainImage, true, false, Main.STAGE_WIDTH, Main.STAGE_HEIGHT);
			addAnimation("rain", [0, 1, 2, 3, 4], 8);
			play("rain");
			
			blend = "screen";
		}
		
		public override function update():void {
			timeRemaining -= FlxG.elapsed;
			if(timeRemaining <= 0) {
				visible = !visible;
				
				if(visible) {
					timeRemaining = rainTime;
					rainTime += rainTimeIncrease;
				} else {
					timeRemaining = dryTime;
					dryTime += dryTimeIncrease;
					rainbow.show();
				}
			}
		}
	}
}
package daydream.game {
	import daydream.Main;
	import daydream.utils.NumberInterval;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import Math;
	
	public class Rain extends FlxSprite {
		//[Embed(source = "../../../lib/Rain_master.jpg")] private static var RainImage:Class;
		[Embed(source = "../../../lib/Rain.jpg")] private static var RainImage:Class;
		
		private var gameState:GameState;
		private var rainbow:Rainbow;
		
		private var dryTime:Number;
		private var rainTime:Number;
		private var dryTimeIncrease:Number;
		private var rainTimeIncrease:Number;
		private var timeRemaining:Number;
		
		private var alphaSet:Boolean;
		
		//number to indicate angle of rotation based on child speed
		private var rainRot:Number;
		
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
			timeRemaining = 2; //for quick testing
			
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			
			//uncomment this
			//loadGraphic(RainImage);
			
			loadGraphic(RainImage, true, false, Main.STAGE_WIDTH, Main.STAGE_HEIGHT);
			addAnimation("rain", [0, 1, 2, 3, 4/*, 5, 6, 7, 8, 9, 10, 11,
								12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24*/], 24);
			play("rain");
			
			//this.angle = 45;
			
			blend = "screen";
		}
		
		public override function update():void {
			/*place equation to change angle based on speed
			 */
			 
			/*place equation to scroll based on angle
			 */
			//amount is arbitrary for now
			//this.y += 5
			//this.x -= 5
			
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
					alphaSet = false;
				}
			}
			
			//this is supposed to fade the rain in/out (keywords: supposed to)
			if (timeRemaining > 3 && visible)
			{
				if (!alphaSet)
				{
					this.alpha = 0.1;
					alphaSet = true;
				}
				
				if (this.alpha < 1)
				{
					this.alpha += 0.01;
				}
			}
			else if (timeRemaining <= 3 && visible)
			{
				if (this.alpha > 0)
				{
					this.alpha -= 0.01;
				}
			}
		}
	}
}
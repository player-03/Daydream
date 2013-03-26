/*Harrison gave us 25 different rain images to use for rain so I turned them into one sheet.
 * 	It's giving a weird error that I have no idea how to fix when I try to use the other image
 * 	that seems to mean the image can't be used. I was hoping you had some idea as to how to resolve it.
 */

package daydream.game {
	import daydream.Main;
	import daydream.utils.NumberInterval;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class Rain extends FlxSprite {
		[Embed(source = "../../../lib/Rain.png")] private static var RainImage:Class;
		//[Embed(source = "../../../lib/Rain_mix.png")] private static var RainImage:Class;
		
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
			
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			
			loadGraphic(RainImage, true, false, Main.STAGE_WIDTH, Main.STAGE_HEIGHT);
			addAnimation("rain", [0, 1, 2], 8);
			
			//THIS IS FOR THE RAIN_MIX IMAGE
			//addAnimation("rain", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24], 8);
			//alpha = 0.5;
			
			play("rain");
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
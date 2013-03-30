package daydream.game {
	import daydream.Main;
	import daydream.utils.NumberInterval;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import mx.core.BitmapAsset;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import Math;
	
	public class Rain extends FlxSprite {
		//[Embed(source = "../../../lib/Rain_master.jpg")] private static var RainImage:Class;
		[Embed(source = "../../../lib/Rain.jpg")] private static var RainImage:Class;
		
		protected var rainBmp:Bitmap = new RainImage as Bitmap;
		
		private var gameState:GameState;
		private var rainbow:Rainbow;
		
		private var dryTime:Number;
		private var rainTime:Number;
		private var dryTimeIncrease:Number;
		private var rainTimeIncrease:Number;
		private var timeRemaining:Number;
		
		private var alphaSet:Boolean;
		
		//Rain image rotation variables
		private static const RAIN_ROTATION:Number = 45;
		private static const TRUE_IMAGE_HEIGHT:Number = 2210;
		private static const TRUE_IMAGE_WIDTH:Number = 1800;
		
		//2835.498 was calculated based on matrix rotation of the image
		private static const ROTATED_IMAGE_DIMENSIONS:Number = 2835.498;
		
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
			
			//loadGraphic(RainImage);
			
			//ROTATING RainImage START
			//FlxG.addBitmap(RainImage, false, false, "rain");
			
			//makeGraphic(ROTATED_IMAGE_DIMENSIONS, ROTATED_IMAGE_DIMENSIONS, 0x00000000);
			
			var matrix:Matrix = new Matrix();
			matrix.translate( -TRUE_IMAGE_WIDTH/2, -TRUE_IMAGE_HEIGHT/2);
			matrix.rotate(RAIN_ROTATION);
			matrix.translate(ROTATED_IMAGE_DIMENSIONS / 2, ROTATED_IMAGE_DIMENSIONS / 2);
			
			var bmp:BitmapData = new BitmapData(ROTATED_IMAGE_DIMENSIONS, ROTATED_IMAGE_DIMENSIONS, false, 0x00000000);
			bmp.draw(FlxG.addBitmap(RainImage, false, false, "rain"), matrix);
			//makeGraphic(ROTATED_IMAGE_DIMENSIONS, ROTATED_IMAGE_DIMENSIONS, 0x00000000);
			//ROTATING RainImage END
			
			//loadGraphic(RainImage, true, false, Main.STAGE_WIDTH, Main.STAGE_HEIGHT);
			//addAnimation("rain", [0, 1, 2, 3, 4/*, 5, 6, 7, 8, 9, 10, 11,
			//					12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24*/], 24);
			//play("rain");
			
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
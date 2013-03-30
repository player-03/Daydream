package daydream.game {
	import daydream.Main;
	import daydream.utils.NumberInterval;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import mx.core.BitmapAsset;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import Math;
	
	public class Rain extends FlxSprite {
		[Embed(source = "../../../lib/Rain.png")] private static var RainImage:Class;
		
		private static var sourceImage:BitmapData = FlxG.addBitmap(RainImage);
		private static var sourceImageDiagonal:Number = Math.sqrt(sourceImage.width * sourceImage.width
																+ sourceImage.height * sourceImage.height);
		
		private var gameState:GameState;
		private var rainbow:Rainbow;
		
		private var dryTime:Number;
		private var rainTime:Number;
		private var dryTimeIncrease:Number;
		private var rainTimeIncrease:Number;
		private var timeRemaining:Number;
		
		private var alphaSet:Boolean;
		
		/**
		 * Refer to this instead of angle.
		 */
		private var rotation:Number;
		//can be changed
		private static const RAIN_SPEED:Number = 5;
		
		public function Rain(gameState:GameState, rainbow:Rainbow,
								dryTime:Number, rainTime:Number,
								dryTimeIncrease:Number = 0, rainTimeIncrease:Number = 0) {
			super();
			
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
			
			//the final bitmap should be large enough to hold any rotation
			makeGraphic(sourceImageDiagonal, sourceImageDiagonal, 0x00000000);
			
			//setRotation(45);
			setRotation(30);
			//setRotation(15);
		}
		
		private function setRotation(rotation:Number):void {
			this.rotation = rotation;
			
			var matrix:Matrix = new Matrix();
			matrix.translate( -sourceImage.width / 2, -sourceImage.height / 2);
			matrix.rotate(rotation * Math.PI / 180);
			matrix.translate(sourceImageDiagonal / 2, sourceImageDiagonal / 2);
			
			pixels.lock();
			pixels.fillRect(new Rectangle(0, 0, pixels.width, pixels.height), 0x00000000);
			pixels.draw(sourceImage, matrix);
			pixels.unlock();
		}
		
		public override function update():void {
			/*place equation to change angle based on speed
			 */
			 
			timeRemaining -= FlxG.elapsed;
			if(timeRemaining <= 0) {
				visible = !visible;
				
				if (visible) {
					//trace("IS RAINING: " + rotation + ", " + Math.abs(Math.cos(-rotation * Math.PI/180)) + ", " + Math.abs(Math.sin(-rotation * Math.PI/180)) +"\n");
					timeRemaining = rainTime;
					rainTime += rainTimeIncrease;
				} else {
					timeRemaining = dryTime;
					dryTime += dryTimeIncrease;
					rainbow.show();
					alphaSet = false;
				}
			}
			
			//rain fading in/out
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
		
		public override function draw():void
		{
			if (visible)
			{
				//this.y += RAIN_SPEED * Math.abs(Math.sin(-rotation * Math.PI/180));
				//this.x -= RAIN_SPEED * Math.abs(Math.cos(-rotation * Math.PI/180));
				this.x -= RAIN_SPEED * Math.abs(Math.sin(-rotation * Math.PI/180));
				this.y += RAIN_SPEED * Math.abs(Math.cos(-rotation * Math.PI/180));
				super.draw();
			}
		}
	}
}
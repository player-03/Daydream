package daydream.game {
	import daydream.Main;
	import daydream.utils.NumberInterval;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import mx.core.BitmapAsset;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import Math;
	
	public class Rain extends FlxSprite {
		[Embed(source = "../../../lib/Rain.png")] private static var RainImage:Class;
		
		/**
		 * The unrotated image, used only to produce the rotated image.
		 * Even when rotation is 0, this will not be shown directly.
		 */
		private static var sourceImage:BitmapData = FlxG.addBitmap(RainImage);
		
		/**
		 * The height of the source image. Because the rotated image will
		 * be scrolling along the rotated vertical axis, this equals the
		 * total distance the image can move before it has to repeat.
		 */
		private static var cycleDistance:Number = sourceImage.height;
		
		/**
		 * The distance between opposite corners of the source image. The
		 * rotated bitmap's dimensions must be at least this large to
		 * ensure that it can hold the full image.
		 */
		private static var sourceImageDiagonal:Number = Math.sqrt(sourceImage.width * sourceImage.width
																+ sourceImage.height * sourceImage.height);
		
		private static var centerX:Number = (Main.STAGE_WIDTH - sourceImageDiagonal) / 2;
		private static var centerY:Number = (Main.STAGE_HEIGHT - sourceImageDiagonal) / 2;
		
		private var gameState:GameState;
		private var rainbow:Rainbow;
		
		private var dryTime:Number;
		private var rainTime:Number;
		private var dryTimeIncrease:Number;
		private var rainTimeIncrease:Number;
		private var timeRemaining:Number;
		
		/**
		 * Refer to this instead of angle.
		 */
		private var rotation:Number;
		
		/**
		 * The fraction of a cycle that this has covered so far.
		 */
		private var travelPosition:Number = 0;
		
		/**
		 * How far, horizontally, this is from being centered. Used to
		 * move the rain on and off the screen.
		 */
		private var xOffset:Number = 0;
		
		private var travelDirection:FlxPoint;
		
		/**
		 * Each frame, the rain will cover this fraction of a full cycle.
		 */
		private static const TRAVEL_SPEED:Number = 0.01;
		
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
			//timeRemaining = 2; //for quick testing
			
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			
			//the final bitmap should be large enough to hold any rotation
			makeGraphic(sourceImageDiagonal, sourceImageDiagonal, 0x00000000);
			travelDirection = new FlxPoint();
			
			setRotation(45);
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
			
			travelDirection.x = Math.cos((rotation + 90) * Math.PI/180);
			travelDirection.y = Math.sin((rotation + 90) * Math.PI / 180);
			
			drawFrame(true);
		}
		
		public override function update():void {
			timeRemaining -= FlxG.elapsed;
			if(timeRemaining <= 0 && !visible) {
				visible = true;
				
				timeRemaining = rainTime;
				rainTime += rainTimeIncrease;
				xOffset = Main.STAGE_WIDTH * 2;
			}
			
			if(!visible) {
				return;
			}
			
			//rain entering/leaving the screen
			if (xOffset > 0)
			{
				xOffset -= (FlxG.state as GameState).getChild().velocity.x * FlxG.elapsed;
				if(xOffset < 0) {
					xOffset = 0;
				}
			}
			else if (timeRemaining <= 0)
			{
				if(xOffset == 0) {
					rainbow.show();
				}
				
				xOffset -= (FlxG.state as GameState).getChild().velocity.x * FlxG.elapsed * 1.5;
				
				//the rain doesn't actually go away until it's fully
				//offscreen
				if(xOffset <= -Main.STAGE_WIDTH * 2) {
					visible = false;
					timeRemaining = dryTime;
					dryTime += dryTimeIncrease;
				}
			}
			
			travelPosition += TRAVEL_SPEED;
			if(travelPosition >= 1) {
				travelPosition -= 1;
			}
		}
		
		public override function draw():void {
			if (visible)
			{
				//draw this at the current position in the cycle
				x = centerX + xOffset + travelPosition * cycleDistance * travelDirection.x;
				y = centerY + travelPosition * cycleDistance * travelDirection.y;
				super.draw();
				
				//draw another image one cycle behind this
				x = centerX + xOffset + (travelPosition - 1) * cycleDistance * travelDirection.x;
				y = centerY + (travelPosition - 1) * cycleDistance * travelDirection.y;
				super.draw();
			}
		}
	}
}
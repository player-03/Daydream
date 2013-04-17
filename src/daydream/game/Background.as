package daydream.game {
	import daydream.Main;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class Background extends FlxSprite {
		[Embed(source = "../../../lib/Background.png")] public static var background:Class;
		[Embed(source = "../../../lib/Clouds1Colored.png")] public static var clouds1:Class;
		[Embed(source = "../../../lib/Clouds2Colored.png")] public static var clouds2:Class;
		[Embed(source = "../../../lib/Ocean.png")] public static var ocean:Class;
		
		/**
		 * @param	y The background's y coordinate, or equivalently, the
		 * distance from the top of the world to the top of the image.
		 * @param	bottomDist The distance from the bottom of the world
		 * to the bottom of the image.
		 */
		public function Background(image:Class, y:Number = 0, bottomDist:Number = 0) {
			super(0, y);
			
			loadGraphic(image);
			
			var maxCameraY:Number = FlxG.camera.bounds.bottom - Main.STAGE_HEIGHT;
			var maxScrollY:Number = height + y + bottomDist - Main.STAGE_HEIGHT;
			
			scrollFactor.x = scrollFactor.y = maxScrollY / maxCameraY;
		}
		
		public override function draw():void {
			x = Math.floor(FlxG.camera.scroll.x * scrollFactor.x / width) * width;
			
			super.draw();
			
			x += width;
			super.draw();
			
			for(var i:Number = Main.STAGE_WIDTH - width; i > 0; i -= width) {
				x += width;
				super.draw();
			}
		}
	}
}
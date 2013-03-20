package daydream.game {
	import daydream.Main;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class LoopingBackground extends FlxSprite {
		[Embed(source = "../../../lib/Background.png")] private static var defaultImage:Class;
		
		public function LoopingBackground(image:Class = null) {
			super(0, 0);
			
			if(image == null) {
				image = defaultImage;
			}
			
			loadGraphic(image);
			
			var maxCameraY:Number = FlxG.camera.bounds.bottom - Main.STAGE_HEIGHT;
			var maxScrollY:Number = height - Main.STAGE_HEIGHT;
			
			scrollFactor.x = scrollFactor.y = maxScrollY / maxCameraY;
		}
		
		public override function draw():void {
			x = Math.floor(FlxG.camera.scroll.x * scrollFactor.x / width) * width;
			
			super.draw();
			
			x += width;
			
			super.draw();
		}
	}
}
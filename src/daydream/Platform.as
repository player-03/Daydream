package daydream {
	import org.flixel.FlxSprite;
	
	public class Platform extends FlxSprite {
		[Embed(source = "../../lib/Platform.png")] private var ImgTemp:Class;
		
		
		public function Platform(x:Number, y:Number, width:Number) {
			super(x, y, ImgTemp);
			//this.width = width;
			
			active = false;
			immovable = true;
			moves = false;
			
			allowCollisions = UP;
		}
	}
}
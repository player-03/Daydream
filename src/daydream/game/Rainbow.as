package daydream.game {
	import org.flixel.FlxCamera;
	import daydream.Main;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	public class Rainbow extends FlxSprite {
		[Embed(source = "../../../lib/Rainbow.png")] private static var rainbowImage:Class;
		
		private var objectPoint:FlxPoint = new FlxPoint();
		
		public function Rainbow() {
			super(0, 0, rainbowImage);
			
			scrollFactor.x = 0.5;
			scrollFactor.y = 0.5;
			
			y = (FlxG.camera.bounds.bottom - height) * scrollFactor.y;
			
			visible = false;
		}
		
		public function show():void {
			x = FlxG.camera.scroll.x * scrollFactor.x + Main.STAGE_WIDTH;
			visible = true;
		}
		
		public override function update():void {
			if(visible) {
				if(x - FlxG.camera.scroll.x * scrollFactor.x + width < 0) {
					visible = false;
				}
			}
		}
		
		/**
		 * An alternative to overlaps() that uses the rainbow's circular
		 * shape rather than its bounding rectangle.
		 * @param	object The object to check. Groups will not be checked
		 * properly.
		 * @return Whether the object is within the circular boundary of
		 * the rainbow. Will still return true if the object is in the
		 * bottom half of the circle, even though the rainbow isn't drawn
		 * there.
		 */
		public function withinRainbow(object:FlxObject):Boolean {
			//find the center of the circle onscreen
			getScreenXY(_point);
			_point.x += width / 2;
			_point.y += height;
			
			//get the center of the target object
			object.getScreenXY(objectPoint);
			objectPoint.x += object.width / 2;
			objectPoint.y += object.height / 2;
			
			var r:Number = width / 2 + 150 + Math.max(object.width / 2, object.health / 2);
			var xDiff:Number = objectPoint.x - _point.x;
			var yDiff:Number = objectPoint.y - _point.y;
			
			return xDiff * xDiff + yDiff * yDiff < r * r;
		}
	}
}
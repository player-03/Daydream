package daydream.utils {
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxSprite;
	public class FlxSpriteUtils {
		private static var sourceRect:Rectangle = new Rectangle();
		private static var destination:Point = new Point();
		
		/**
		 * Fills an area of a sprite with randomly-selected tiles taken
		 * from the given source sprite. Remember to call drawFrame(true)
		 * after calling this!
		 * @param	startX The left edge of the area to draw onto.
		 * @param	startY The top edge of the area to draw onto.
		 * @param	endX The right edge of the area to draw onto.
		 * @param	endY The bottom edge of the area to draw onto.
		 * @param	drawTarget The sprite to draw onto. This sprite's
		 * "pixels" property may not be null.
		 * @param	drawSource The sprite to draw from. Randomly-selected
		 * frames from this sprite will be used as the tiles to draw.
		 */
		public static function fillAreaWithTiles(startX:Number, startY:Number, endX:Number, endY:Number,
												drawTarget:FlxSprite, drawSource:FlxSprite,
												color:ColorTransform = null):void {
			var tileWidth:Number = drawSource.width;
			var tileHeight:Number = drawSource.height;
			var frameCount:uint = drawSource.frames;
			if(frameCount < 1) {
				trace("Can't draw from an empty sprite!");
				return;
			}
			
			var bitmapData:BitmapData = drawSource.framePixels;
			sourceRect.x = 0;
			sourceRect.y = 0;
			for(destination.x = startX; destination.x < endX; destination.x += tileWidth) {
				if(destination.x + tileWidth <= endX) {
					sourceRect.width = tileWidth;
				} else {
					sourceRect.width = endX - destination.x;
				}
				
				for(destination.y = startY; destination.y < endY; destination.y += tileHeight) {
					if(destination.y + tileHeight <= endY) {
						sourceRect.height = tileHeight;
					} else {
						sourceRect.height = endY - destination.y;
					}
					
					if(frameCount > 1) {
						drawSource.randomFrame();
					}
					drawSource.drawFrame();
					
					drawTarget.pixels.copyPixels(bitmapData, sourceRect, destination, null, null, true);
				}
			}
		}
		
		/**
		 * Insets the given sprite's hitbox by the given amounts. For
		 * example, if left is 2, the sprite's left edge will be pushed
		 * in by 2 pixels.
		 */
		public static function applyInset(sprite:FlxSprite, left:Number, top:Number, right:Number, bottom:Number):void {
			sprite.width -= left + right;
			sprite.height -= top + bottom;
			sprite.offset.x += left;
			sprite.offset.y += top;
		}
	}
}
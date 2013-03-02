package daydream {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxSprite;
	
	public class Platform extends FlxSprite {
		private static const TILE_WIDTH:int = 20;
		
		[Embed(source = "../../lib/PlatformLeft.png")] private static var LeftTiles:Class;
		private static var leftTileSprite:FlxSprite;
		[Embed(source = "../../lib/PlatformCenter.png")] private static var CenterTiles:Class;
		private static var centerTileSprite:FlxSprite;
		[Embed(source = "../../lib/PlatformRight.png")] private static var RightTiles:Class;
		private static var rightTileSprite:FlxSprite;
		
		private static function staticInit():void {
			leftTileSprite = new FlxSprite();
			leftTileSprite.loadGraphic(LeftTiles, true, false, TILE_WIDTH, TILE_WIDTH);
			centerTileSprite = new FlxSprite();
			centerTileSprite.loadGraphic(CenterTiles, true, false, TILE_WIDTH * 2, TILE_WIDTH);
			rightTileSprite = new FlxSprite();
			rightTileSprite.loadGraphic(RightTiles, true, false, TILE_WIDTH, TILE_WIDTH);
		}
		
		public function Platform(x:Number, y:Number, width:Number) {
			super(x, y);
			
			this.width = width;
			height = TILE_WIDTH;
			
			makeGraphic(width, height, 0x00000000, true);
			
			if(centerTileSprite == null) {
				staticInit();
			}
			
			fillAreaWithTiles(0, 0, TILE_WIDTH, TILE_WIDTH, this, leftTileSprite);
			fillAreaWithTiles(leftTileSprite.width, 0, width - rightTileSprite.width, TILE_WIDTH, this, centerTileSprite);
			fillAreaWithTiles(width - rightTileSprite.width, 0, width, TILE_WIDTH, this, rightTileSprite);
			
			active = false;
			immovable = true;
			moves = false;
			
			allowCollisions = UP;
		}
		
		private static function fillAreaWithTiles(startX:Number, startY:Number, endX:Number, endY:Number,
												drawTarget:FlxSprite, drawSource:FlxSprite):void {
			var tileWidth:Number = drawSource.width;
			var tileHeight:Number = drawSource.height;
			var frameCount:uint = drawSource.frames;
			if(frameCount < 1) {
				trace("Can't draw from an empty sprite!");
				return;
			}
			
			var bitmapData:BitmapData = drawSource.framePixels;
			var sourceRect:Rectangle = new Rectangle();
			var destination:Point = new Point();
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
			
			drawTarget.drawFrame(true);
		}
	}
}
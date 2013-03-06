package daydream.game {
	import daydream.utils.FlxSpriteUtils;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxSprite;
	
	public class Platform extends FlxSprite {
		public static const TILE_WIDTH:int = 20;
		
		[Embed(source = "../../../lib/PlatformLeft.png")] private static var LeftTiles:Class;
		private static var leftTileSprite:FlxSprite;
		[Embed(source = "../../../lib/PlatformCenter.png")] private static var CenterTiles:Class;
		private static var centerTileSprite:FlxSprite;
		[Embed(source = "../../../lib/PlatformRight.png")] private static var RightTiles:Class;
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
			
			pixels = new BitmapData(int(width), TILE_WIDTH, true, 0x00000000);
			
			if(centerTileSprite == null) {
				staticInit();
			}
			
			FlxSpriteUtils.fillAreaWithTiles(0, 0, TILE_WIDTH, TILE_WIDTH, this, leftTileSprite);
			FlxSpriteUtils.fillAreaWithTiles(leftTileSprite.width, 0, width - rightTileSprite.width, TILE_WIDTH, this, centerTileSprite);
			FlxSpriteUtils.fillAreaWithTiles(width - rightTileSprite.width, 0, width, TILE_WIDTH, this, rightTileSprite);
			
			active = false;
			immovable = true;
			moves = false;
			
			allowCollisions = UP;
		}
		
		public override function destroy():void {
			//this is only necessary because each platform has a unique
			//BitmapData object, whereas most sprites share them
			pixels.dispose();
			
			super.destroy();
		}
	}
}
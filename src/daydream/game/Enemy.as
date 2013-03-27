package daydream.game 
{
	import daydream.Main;
	import daydream.utils.FlxSpriteUtils;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	public class Enemy extends FlxSprite
	{
		public static const STANDING:int = 0;
		public static const FLYING:int = 1;
		
		[Embed(source = "../../../lib/ArmyMan.png")] private static var standingImg:Class;
		[Embed(source = "../../../lib/FlyingEnemy.png")] private static var flyingImg:Class;
		
		private static var typeImages:Vector.<Class> = Vector.<Class>([
					standingImg, flyingImg]);
		
		private var type:int;
		
		/**
		 * @param	type The type of enemy to create. This should be one
		 * of the constants defined in this class.
		 */
		public function Enemy(x:Number, y:Number, type:int) 
		{
			super(x, y);
			
			this.type = type;
			
			loadGraphic(typeImages[type]);
			
			if(type == STANDING) {
				FlxSpriteUtils.applyInset(this, 30, 0, 0, 5);
			}
		}
		
		public override function update():void
		{
			if(type == STANDING) {
				//don't apply gravity until it gets nearly onscreen
				if(acceleration.y == 0 &&
						x < FlxG.camera.scroll.x + Main.STAGE_WIDTH
						+ GameState.PHYSICS_BOUNDS_X_OFFSET / 2) {
					acceleration.y = Child.GRAVITY;
				}
			} else if(type == FLYING) {
				
			} else {
				//for later
			}
		}
	}
}
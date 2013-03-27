package daydream.game 
{
	import daydream.Main;
	import daydream.utils.FlxSpriteUtils;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	public class Enemy extends FlxSprite
	{
		public static const SOLDIER:int = 0;
		public static const DRAGON:int = 1;
		public static const LEGO:int = 2;
		
		[Embed(source = "../../../lib/ArmyMan.png")] private static var standingImg:Class;
		[Embed(source = "../../../lib/Dragon.png")] private static var flyingImg:Class;
		
		private static var typeImages:Vector.<Class> = Vector.<Class>([
					standingImg, flyingImg]);
		
		private var type:int;
		
		private var timeAlive:Number = 0;
		
		/**
		 * @param	type The type of enemy to create. This should be one
		 * of the constants defined in this class.
		 */
		public function Enemy(x:Number, y:Number, type:int) 
		{
			super(x, y);
			
			this.type = type;
			
			var animated:Boolean = false;
			var fWidth:int = 0;
			var fHeight:int = 0;
			
			if(type == DRAGON) {
				animated = true;
				fWidth = 542;
				fHeight = 234;
			}
			
			loadGraphic(typeImages[type], animated, false, fWidth, fHeight);
			
			if(type == SOLDIER) {
				FlxSpriteUtils.applyInset(this, 30, 0, 0, 5);
			} else if(type == DRAGON) {
				addAnimation("fly", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], 24);
				play("fly");
				this.x = FlxG.camera.scroll.x - fWidth;
				FlxSpriteUtils.applyInset(this, 140, 90, 0, 10);
			} else {
				//...
			}
		}
		
		public override function update():void {
			timeAlive += FlxG.elapsed;
			
			if(type == SOLDIER) {
				//don't apply gravity until it gets nearly onscreen
				if(acceleration.y == 0 &&
						x < FlxG.camera.scroll.x + Main.STAGE_WIDTH
						+ GameState.PHYSICS_BOUNDS_X_OFFSET / 2) {
					acceleration.y = Child.GRAVITY;
				}
			} else if(type == DRAGON) {
				velocity.x = (FlxG.state as GameState).getChild().velocity.x
							+ 200 + 150 * timeAlive;
				
				if(x > FlxG.camera.scroll.x + Main.STAGE_WIDTH) {
					//this will make GameState clean this up
					x = 0;
					
					velocity.x = 0;
					timeAlive = 0;
				}
			} else {
				//...
			}
		}
		
		public function isDragon():Boolean {
			return type == DRAGON;
		}
	}
}
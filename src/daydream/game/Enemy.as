package daydream.game 
{
	import daydream.Main;
	import daydream.utils.FlxSpriteUtils;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class Enemy extends FlxSprite
	{
		[Embed(source = "../../../lib/ArmyMan.png")] private static var defaultEnemyImg:Class;
		
		public function Enemy(x:Number, y:Number) 
		{
			super(x, y);
			initImage();
		}
		
		protected function initImage():void {
			loadGraphic(defaultEnemyImg, true, false, 79, 109);
			FlxSpriteUtils.applyInset(this, 30, 15, 5, 1);
			randomFrame();
		}
		
		public override function update():void {
			//don't apply gravity until it gets nearly onscreen
			if(acceleration.y == 0 &&
					x < FlxG.camera.scroll.x + Main.STAGE_WIDTH
					+ GameState.PHYSICS_BOUNDS_X_OFFSET / 2) {
				acceleration.y = Child.GRAVITY;
			}
		}
	}
}
package daydream.game {
	import daydream.Main;
	import daydream.upgrades.UpgradeHandler;
	import daydream.upgrades.UpgradesState;
	import daydream.utils.FlxSpriteUtils;
	import daydream.utils.NumberInterval;
	import daydream.utils.Save;
	import org.flixel.FlxG;
	import org.flixel.FlxRect;
	
	public class Dragon extends Enemy {
		[Embed(source = "../../../lib/Dragon.png")] private static var dragonImg:Class;
		[Embed(source = "../../../lib/SFX_DRAGON.mp3")] private static var dragonSound:Class;
		
		private static const FRAME_WIDTH:int = 542;
		private static const FRAME_HEIGHT:int = 234;
		
		//approximate values:
		private static const BASE_OF_TAIL_X:int = 204;
		private static const BASE_OF_NECK_X:int = 375;
		private static const BACK_OF_HEAD_X:int = 482;
		private static const HEAD_NECK_BACK_Y:int = 145;
		
		private var safeHitbox:FlxRect;
		
		public var timeAlive:Number = 0;
		
		public function Dragon(y:Number) {
			super(FlxG.camera.scroll.x - FRAME_WIDTH, y);
			FlxG.play(dragonSound);
			safeHitbox = new FlxRect();
		}
		
		protected override function initImage():void {
			loadGraphic(dragonImg, true, false, FRAME_WIDTH, FRAME_HEIGHT);
			addAnimation("fly", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], 24);
			play("fly");
			FlxSpriteUtils.applyInset(this, BASE_OF_TAIL_X, HEAD_NECK_BACK_Y - 5, 0, 30);
		}
		
		public override function update():void {
			timeAlive += FlxG.elapsed;
			
			if(velocity == null) {
				trace("The Dragon enemy got destroyed while the child was riding the fake dragon.");
				return;
			}
			
			//speed up over time
			velocity.x = (FlxG.state as GameState).getChild().baseXVelocity
						+ 200 + 150 * timeAlive;
			
			//speed up based on onscreen position
			if(x - FlxG.camera.scroll.x > Main.STAGE_WIDTH * 0.2) {
				velocity.x += (x - FlxG.camera.scroll.x - Main.STAGE_WIDTH * 0.2) * 1.5;
			}
			
			if(x > FlxG.camera.scroll.x + Main.STAGE_WIDTH) {
				//this will make GameState clean this up
				x = 0;
				
				velocity.x = 0;
				timeAlive = 0;
			} else if(x > 0 && x < FlxG.camera.scroll.x - FRAME_WIDTH - 3) {
				//keep this from falling so far behind the screen that it
				//gets destroyed
				x = FlxG.camera.scroll.x - FRAME_WIDTH - 3;
			}
		}
		
		public function getSafeHitbox():FlxRect {
			var percentUpgraded:Number = UpgradeHandler.dragonPercentUpgraded();
			
			//the left edge starts out at BASE_OF_NECK_X and moves towards 0
			safeHitbox.x = NumberInterval.interpolate(BASE_OF_NECK_X, 0, percentUpgraded);
			
			//the right edge starts out at BACK_OF_HEAD_X and moves to
			//the edge of the hitbox minus a few pixels
			safeHitbox.width = NumberInterval.interpolate(BACK_OF_HEAD_X, FRAME_WIDTH - 30, percentUpgraded)
							- safeHitbox.x;
			
			//move the hitbox into position (subtract offset.x because the
			//x constants are based on the frame position; don't subtract
			//offset.y because no y constants were used)
			safeHitbox.x += x - offset.x;
			safeHitbox.y = y;
			
			//enough to allow landing from above and not much else
			safeHitbox.height = 10;
			
			return safeHitbox;
		}
	}
}
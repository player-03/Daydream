package daydream.game {
	import daydream.Main;
	import daydream.utils.FlxSpriteUtils;
	import org.flixel.FlxG;
	
	public class Dragon extends Enemy {
		[Embed(source = "../../../lib/Dragon.png")] private static var dragonImg:Class;
		
		private static const FRAME_WIDTH:int = 542;
		private static const FRAME_HEIGHT:int = 234;
		
		public var timeAlive:Number = 0;
		
		public function Dragon(y:Number) {
			super(FlxG.camera.scroll.x - FRAME_WIDTH, y);
		}
		
		protected override function initImage():void {
			loadGraphic(dragonImg, true, false, FRAME_WIDTH, FRAME_HEIGHT);
			addAnimation("fly", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], 24);
			play("fly");
			FlxSpriteUtils.applyInset(this, 140, 90, 0, 10);
		}
		
		public override function update():void {
			timeAlive += FlxG.elapsed;
			
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
	}
}
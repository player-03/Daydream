package daydream.game {
	import daydream.Main;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class Rain extends FlxSprite {
		[Embed(source = "../../../lib/Rain.png")] private static var RainImage:Class;
		
		private var gameState:GameState;
		
		public function Rain(gameState:GameState) {
			super(0, 0, null);
			
			this.gameState = gameState;
			
			loadGraphic(RainImage, true, false, Main.STAGE_WIDTH, Main.STAGE_HEIGHT);
			addAnimation("rain", [0, 1, 2], 8);
			play("rain");
		}
		
		public override function draw():void {
			if(!gameState.raining) {
				return;
			}
			
			x = FlxG.camera.scroll.x;
			y = FlxG.camera.scroll.y;
			
			super.draw();
		}
	}
}
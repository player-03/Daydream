package daydream.menu {
	import daydream.game.GameState;
	import daydream.Main;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	public class MenuState extends FlxState {
		public override function create():void {
			//the entry point for FlxState objects
			
			FlxG.bgColor = 0xFFFFFFFF;
			
			var playButton:FlxButton = new FlxButton(
									Main.STAGE_WIDTH / 2 - 40,
									Main.STAGE_HEIGHT / 2 - 10,
									"Play", onPlayClicked);
			add(playButton);
		}
		
		private function onPlayClicked():void {
			FlxG.switchState(new GameState());
		}
	}
}
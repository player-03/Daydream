package daydream.menu {
	import daydream.game.GameState;
	import daydream.menu.InstructState;
	import daydream.Main;
	import daydream.utils.Save;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	public class MenuState extends FlxState {
		public override function create():void {
			//the entry point for FlxState objects
			
			FlxG.bgColor = 0xFFFFFFFF;
			
			FlxG.mute = Save.getBoolean(GameState.MUTE);
			
			var playButton:FlxButton = new FlxButton(
									Main.STAGE_WIDTH / 2 - 40,
									Main.STAGE_HEIGHT / 2 - 30,
									"Play", onPlayClicked);
			var instructionButton:FlxButton = new FlxButton(Main.STAGE_WIDTH / 2 - 40, Main.STAGE_HEIGHT / 2 + 30, "Instructions", onInstructClick);
			add(playButton);
			add(instructionButton);
		}
		
		private function onPlayClicked():void {
			FlxG.switchState(new GameState());
		}
		
		private function onInstructClick():void
		{
			FlxG.switchState(new InstructState());
		}
	}
}
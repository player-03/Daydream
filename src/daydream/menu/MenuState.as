package daydream.menu {
	import daydream.game.Child;
	import daydream.game.GameState;
	import daydream.menu.InstructState;
	import daydream.Main;
	import daydream.upgrades.UpgradesState;
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
									Main.STAGE_HEIGHT / 2 - 80,
									"Play", onPlayClicked);
			var instructionButton:FlxButton = new FlxButton(Main.STAGE_WIDTH / 2 - 40, Main.STAGE_HEIGHT / 2 - 40, "Upgrade", onInstructClick);
			add(playButton);
			add(instructionButton);
			add(new InstructionText());
		}
		
		public override function update():void {
			super.update();
			if(Child.jumpJustPressed()) {
				onPlayClicked();
			}
		}
		
		private function onPlayClicked():void {
			FlxG.play(Main.buttonSound);
			FlxG.switchState(new GameState());
		}
		
		private function onInstructClick():void
		{
			FlxG.play(Main.buttonSound);
			FlxG.switchState(new UpgradesState());
		}
	}
}
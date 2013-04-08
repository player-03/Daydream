package daydream.menu 
{
	import daydream.menu.MenuState;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import daydream.Main;
	
	public class InstructState extends FlxState
	{
		
		public function InstructState() 
		{
			var backButton:FlxButton = new FlxButton(Main.STAGE_WIDTH / 2 - 40, Main.STAGE_HEIGHT / 2 - 10, "Back", onBackClick);
			add(backButton);
			add(new InstructionText());
		}
		
		private function onBackClick():void
		{
			FlxG.switchState(new MenuState());
		}
		
	}

}
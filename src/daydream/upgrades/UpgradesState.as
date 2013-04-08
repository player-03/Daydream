//As of right now, switching to this state does not save the coins, but it saves the score
//	So it's commented out for the time being
package daydream.upgrades 
{
	import daydream.menu.MenuState;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import daydream.game.GameState;
	import daydream.Main;
	
	public class UpgradesState extends FlxState
	{
		
		public function UpgradesState() 
		{
			var playButton:FlxButton = new FlxButton(
									Main.STAGE_WIDTH / 2 - 120,
									Main.STAGE_HEIGHT - 50,
									"Save and Play", onPlayClicked);
			var quitButton:FlxButton = new FlxButton(
									Main.STAGE_WIDTH / 2 + 40,
									Main.STAGE_HEIGHT - 50,
									"Quit to Menu", onQuitClicked);
			add(playButton);
			add(quitButton);
		}
		
		private function onPlayClicked():void
		{
			FlxG.switchState(new GameState());
		}
		
		private function onQuitClicked():void
		{
			FlxG.switchState(new MenuState());
		}
		
	}
	
	

}
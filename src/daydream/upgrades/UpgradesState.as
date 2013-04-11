//As of right now, switching to this state does not save the coins, but it saves the score
//	So it's commented out for the time being
package daydream.upgrades 
{
	import daydream.game.Child;
	import daydream.game.CoinCounter;
	import daydream.game.CoinCounterSprite;
	import daydream.game.ScoreKeeper;
	import daydream.menu.MenuState;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import daydream.game.GameState;
	import daydream.Main;
	
	public class UpgradesState extends FlxState
	{
		private var coinSprite:CoinCounterSprite;
		private var coinCounter:CoinCounter;
		private var child:Child;
		private var availableCoins:int;
		
		public function UpgradesState(c:Child) 
		{
			coinSprite = new CoinCounterSprite(20, 20);
			coinCounter = new CoinCounter(c, 40, 20);
			
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
			add(coinSprite);
			add(coinCounter);
			
			this.child = c;
			availableCoins = child.getCoins();
		}
		
		private function onPlayClicked():void
		{
			child.setCoins(availableCoins);
			FlxG.switchState(new GameState());
		}
		
		private function onQuitClicked():void
		{
			FlxG.switchState(new MenuState());
		}
	}
}
package daydream.upgrades 
{
	import daydream.game.Child;
	import daydream.game.CoinCounter;
	import daydream.game.CoinCounterSprite;
	import daydream.game.ScoreKeeper;
	import daydream.menu.MenuState;
	import daydream.utils.Save;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import daydream.game.GameState;
	import daydream.Main;
	
	public class UpgradesState extends FlxState
	{
		//The following constants are identifiers for saved integers.
		//These integers represent the number of upgrades of that type
		//that have been purchased (alternately, the "upgrade level").
		
		/**
		 * Pogo stick bounce height.
		 */
		public static const POGO:String = "pogo_upgrades";
		/**
		 * Horse speed and/or jump height.
		 */
		public static const HORSE:String = "horse_upgrades";
		/**
		 * The frequency at which items spawn, excluding coins.
		 */
		public static const ITEM_FREQUENCY:String = "item_upgrades";
		/**
		 * The frequency at which coins spawn, and the number of coins
		 * dropped per enemy.
		 */
		public static const COIN_FREQUENCY:String = "coin_upgrades";
		/**
		 * The ease of landing on a dragon.
		 */
		public static const DRAGON:String = "dragon_upgrades";
		
		
		private var coinSprite:CoinCounterSprite;
		private var coinCounter:CoinCounter;
		private var availableCoins:int;
		
		public function UpgradesState() 
		{
			FlxG.music.fadeOut(0.8, true);
			
			coinSprite = new CoinCounterSprite(20, 20);
			coinCounter = new CoinCounter(getCoins, 40, 20);
			
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
			
			availableCoins = Save.getInt(CoinCounter.COINS);
		}
		
		public override function update():void
		{
			super.update();
			if(Child.jumpJustPressed()) {
				onPlayClicked();
			}
		}
		
		public function getCoins():int
		{
			return availableCoins;
		}
		
		private function onPlayClicked():void
		{
			Save.flush();
			FlxG.switchState(new GameState());
		}
		
		private function onQuitClicked():void
		{
			Save.flush();
			FlxG.switchState(new MenuState());
		}
	}
}
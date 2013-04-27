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
		
		private var upgradeHandler:UpgradeHandler;
		
		private var coinSprite:CoinCounterSprite;
		private var coinCounter:CoinCounter;
		private var availableCoins:int;
		
		private var pogo_count:int;
		private var horse_count:int;
		private var item_count:int;
		private var coin_count:int;
		private var dragon_count:int;
		
		public override function create():void
		{
			if(FlxG.music != null) {
				FlxG.music.fadeOut(0.8, true);
			}
			
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
			pogo_count = Save.getInt(POGO);
			horse_count = Save.getInt(HORSE);
			item_count = Save.getInt(ITEM_FREQUENCY);
			coin_count = Save.getInt(COIN_FREQUENCY);
			dragon_count = Save.getInt(DRAGON);
			
			upgradeHandler = new UpgradeHandler(this);
			add(upgradeHandler);
		}
		
		public override function update():void
		{
			super.update();
			if(Child.jumpJustPressed()) {
				onPlayClicked();
			}
			
			pogo_count = upgradeHandler.pogo_count;
			horse_count = upgradeHandler.horse_count;
			item_count = upgradeHandler.item_count;
			coin_count = upgradeHandler.coin_count;
			dragon_count = upgradeHandler.dragon_count;
		}
		
		public function getCoins():int
		{
			return availableCoins;
		}
		
		public function getPogoCount():int
		{
			return pogo_count;
		}
		
		public function getHorseCount():int
		{
			return horse_count;
		}
		
		public function getItemCount():int
		{
			return item_count;
		}
		
		public function getCoinCount():int
		{
			return coin_count;
		}
		
		public function getDragonCount():int
		{
			return dragon_count;
		}
		
		public function coinChange(x:int):Boolean
		{
			if(availableCoins + x >= 0) {
				availableCoins += x;
				return true;
			}
			return false;
		}
		
		private function onPlayClicked():void
		{
			FlxG.play(Main.buttonSound);
			saveUpgrades();
			Save.flush();
			FlxG.switchState(new GameState());
		}
		
		private function onQuitClicked():void
		{
			FlxG.play(Main.buttonSound);
			saveUpgrades();
			Save.flush();
			FlxG.switchState(new MenuState());
		}
		
		private function saveUpgrades():void
		{
			Save.storeInt(CoinCounter.COINS, availableCoins);
			Save.storeInt(POGO, pogo_count);
			Save.storeInt(HORSE, horse_count);
			Save.storeInt(ITEM_FREQUENCY, item_count);
			Save.storeInt(COIN_FREQUENCY, coin_count);
			Save.storeInt(DRAGON, dragon_count);
		}
	}
}
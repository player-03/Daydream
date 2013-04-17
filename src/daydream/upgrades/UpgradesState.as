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
		private var upgradeHandler:UpgradeHandler;
		
		private var coinSprite:CoinCounterSprite;
		private var coinCounter:CoinCounter;
		public var availableCoins:int;
		
		public override function create():void
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
			
			upgradeHandler = new UpgradeHandler(this);
			add(upgradeHandler);
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
		
		public function coinChange(x:int):void
		{
			if (x == 1)
				availableCoins += 1;
			if (x == -1)
				availableCoins -= 1;
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
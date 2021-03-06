package daydream.upgrades 
{
	import daydream.utils.Save;
	import mx.core.ButtonAsset;
	import org.flixel.FlxBasic;
	import org.flixel.FlxButton;
	import org.flixel.FlxText;
	
	public class UpgradeHandler extends FlxBasic
	{
		public static const UPGRADE_BASE_COST:int = 3;
		public static const UPGRADE_COST_PER_LEVEL:int = 2;
		
		private var upgradeState:UpgradesState;
		
		public var pogo_text:FlxText;
		public var pogo_count:int;
		
		public var horse_text:FlxText;
		public var horse_count:int;
		
		public var item_text:FlxText;
		public var item_count:int;
		
		public var coin_text:FlxText;
		public var coin_count:int;
		
		public var dragon_text:FlxText;
		public var dragon_count:int;
		
		public static const POGO_MAX_UPGRADES:int = 10;
		public static const HORSE_MAX_UPGRADES:int = 10;
		public static const ITEM_MAX_UPGRADES:int = 10;
		public static const COIN_MAX_UPGRADES:int = 10;
		public static const DRAGON_MAX_UPGRADES:int = 10;
		
		public static function pogoPercentUpgraded():Number {
			return Save.getInt(UpgradesState.POGO) / POGO_MAX_UPGRADES;
		}
		public static function horsePercentUpgraded():Number {
			return Save.getInt(UpgradesState.HORSE) / HORSE_MAX_UPGRADES;
		}
		public static function itemPercentUpgraded():Number {
			return Save.getInt(UpgradesState.ITEM_FREQUENCY) / ITEM_MAX_UPGRADES;
		}
		public static function coinPercentUpgraded():Number {
			return Save.getInt(UpgradesState.COIN_FREQUENCY) / COIN_MAX_UPGRADES;
		}
		public static function dragonPercentUpgraded():Number {
			return Save.getInt(UpgradesState.DRAGON) / DRAGON_MAX_UPGRADES;
		}
		
		public function UpgradeHandler(upgradeState:UpgradesState) 
		{
			super();
			
			this.upgradeState = upgradeState;
			
			//POGO START
			pogo_count = upgradeState.getPogoCount();
			
			var pogo_neg_button:FlxButton = new FlxButton(10, 75, "-", pogo_neg);
			var pogo_pos_button:FlxButton = new FlxButton(110, 75, "+", pogo_pos);
			
			pogo_text = new FlxText(10, 45, 500);
			
			upgradeState.add(pogo_neg_button);
			upgradeState.add(pogo_pos_button);
			upgradeState.add(pogo_text);
			
			pogo_text.color = 0x00000000;
			pogo_text.size = 12;
			//POGO END
			
			//HORSE START
			horse_count = upgradeState.getHorseCount();
			
			var horse_neg_button:FlxButton = new FlxButton(10, 150, "-", horse_neg);
			var horse_pos_button:FlxButton = new FlxButton(110, 150, "+", horse_pos);
			
			horse_text = new FlxText(10, 120, 500);
			
			upgradeState.add(horse_neg_button);
			upgradeState.add(horse_pos_button);
			upgradeState.add(horse_text);
			
			horse_text.color = 0x00000000;
			horse_text.size = 12;
			//HORSE END
			
			//ITEM START
			item_count = upgradeState.getItemCount();
			
			var item_neg_button:FlxButton = new FlxButton(10, 225, "-", item_neg);
			var item_pos_button:FlxButton = new FlxButton(110, 225, "+", item_pos);
			
			item_text = new FlxText(10, 195, 500);
			
			upgradeState.add(item_neg_button);
			upgradeState.add(item_pos_button);
			upgradeState.add(item_text);
			
			item_text.color = 0x00000000;
			item_text.size = 12;
			//ITEM END
			
			//COIN START
			coin_count = upgradeState.getCoinCount();
			
			var coin_neg_button:FlxButton = new FlxButton(10, 300, "-", coin_neg);
			var coin_pos_button:FlxButton = new FlxButton(110, 300, "+", coin_pos);
			
			coin_text = new FlxText(10, 270, 500);
			
			upgradeState.add(coin_neg_button);
			upgradeState.add(coin_pos_button);
			upgradeState.add(coin_text);
			
			coin_text.color = 0x00000000;
			coin_text.size = 12;
			//COIN END
			
			//DRAGON START
			dragon_count = upgradeState.getDragonCount();
			
			var dragon_neg_button:FlxButton = new FlxButton(10, 375, "-", dragon_neg);
			var dragon_pos_button:FlxButton = new FlxButton(110, 375, "+", dragon_pos);
			
			dragon_text = new FlxText(10, 345, 500);
			
			upgradeState.add(dragon_neg_button);
			upgradeState.add(dragon_pos_button);
			upgradeState.add(dragon_text);
			
			dragon_text.color = 0x00000000;
			dragon_text.size = 12;
			//DRAGON END
		}
		
		public function countToString(coinCount:int):String {
			if(coinCount < 10) {
				return "0" + coinCount;
			} else {
				return coinCount.toString();
			}
		}
		
		public override function update():void
		{
			//Pogo
			pogo_text.text = "Pogo stick bounce height\n" + countToString(pogo_count);
			
			//Horse
			horse_text.text = "Horse speed\n" + countToString(horse_count);
			
			//Item
			item_text.text = "Item spawn frequency\n" + countToString(item_count);
			
			//Coin
			coin_text.text = "Coin spawn frequency\n" + countToString(coin_count);
			
			//Dragon
			dragon_text.text = "Dragon taming\n" + countToString(dragon_count);
		}
		
		//POGO BUTTON FUNCTIONS
		public function pogo_neg():void
		{
			if (pogo_count != 0)
			{
				pogo_count -= 1;
				coinUp(pogo_count);
			}
		}
		
		public function pogo_pos():void
		{
			if (pogo_count < POGO_MAX_UPGRADES && coinDown(pogo_count))
			{
				pogo_count += 1;
			}
		}
		
		//HORSE BUTTON FUNCTIONS
		public function horse_neg():void
		{
			if (horse_count != 0)
			{
				horse_count -= 1;
				coinUp(horse_count);
			}
		}
		
		public function horse_pos():void
		{
			if (horse_count < HORSE_MAX_UPGRADES && coinDown(horse_count))
			{
				horse_count += 1;
			}
		}
		
		//ITEM BUTTON FUNCTIONS
		public function item_neg():void
		{
			if (item_count != 0)
			{
				item_count -= 1;
				coinUp(item_count);
			}
		}
		
		public function item_pos():void
		{
			if (item_count < ITEM_MAX_UPGRADES && coinDown(item_count))
			{
				item_count += 1;
			}
		}
		
		//COIN BUTTON FUNCTIONS
		public function coin_neg():void
		{
			if (coin_count != 0)
			{
				coin_count -= 1;
				coinUp(coin_count);
			}
		}
		
		public function coin_pos():void
		{
			if (coin_count < COIN_MAX_UPGRADES && coinDown(coin_count))
			{
				coin_count += 1;
			}
		}
		
		//DRAGON BUTTON FUNCTIONS
		public function dragon_neg():void
		{
			if (dragon_count != 0)
			{
				dragon_count -= 1;
				coinUp(dragon_count);
			}
		}
		
		public function dragon_pos():void
		{
			if (dragon_count < DRAGON_MAX_UPGRADES && coinDown(dragon_count))
			{
				dragon_count += 1;
			}
		}
		
		//Coin changing functions
		public function coinUp(upgradesRemaining:int):void
		{
			upgradeState.coinChange(UPGRADE_BASE_COST + upgradesRemaining * UPGRADE_COST_PER_LEVEL);
		}
		
		public function coinDown(upgradesBoughtAlready:int):Boolean
		{
			return upgradeState.coinChange(-UPGRADE_BASE_COST - upgradesBoughtAlready * UPGRADE_COST_PER_LEVEL);
		}
		
	}

}
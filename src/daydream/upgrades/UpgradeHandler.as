package daydream.upgrades 
{
	import mx.core.ButtonAsset;
	import org.flixel.FlxBasic;
	import org.flixel.FlxButton;
	import org.flixel.FlxText;
	
	public class UpgradeHandler extends FlxBasic
	{
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
		
		//these are just for now
		private static const pogo_max:int = 10;
		private static const horse_max:int = 10;
		private static const item_max:int = 10;
		private static const coin_max:int = 10;
		private static const dragon_max:int = 10;
		
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
		
		public override function update():void
		{
			//Pogo
			if(pogo_count < 10)
				pogo_text.text = "Pogo Bounce Height Modifier\n0" + pogo_count.toString();
			else
				pogo_text.text = "Pogo Bounce Height Modifier\n" + pogo_count.toString();
				
			//Horse
			if(horse_count < 10)
				horse_text.text = "Horse Speed Modifier\n0" + horse_count.toString();
			else
				horse_text.text = "Horse Speed Modifier\n" + horse_count.toString();
				
			//Item
			if(item_count < 10)
				item_text.text = "Item Spawn Frequency Modifier\n0" + item_count.toString();
			else
				item_text.text = "Item Spawn Frequency Modifier\n" + item_count.toString();
				
			//Coin
			if(coin_count < 10)
				coin_text.text = "Coin Spawn Frequency Modifier\n0" + coin_count.toString();
			else
				coin_text.text = "Coin Spawn Frequency Modifier\n" + coin_count.toString();
				
			//Dragon
			if(dragon_count < 10)
				dragon_text.text = "Dragon Riding Activation Ease Modifier\n0" + dragon_count.toString();
			else
				dragon_text.text = "Dragon Riding Activation Ease Modifier\n" + dragon_count.toString();
		}
		
		//POGO BUTTON FUNCTIONS
		public function pogo_neg():void
		{
			if (pogo_count != 0 && upgradeState.getCoins() < 15)
			{
				coinUp();
				pogo_count -= 1;
			}
		}
		
		public function pogo_pos():void
		{
			if (upgradeState.getCoins() != 0 && pogo_count < pogo_max)
			{
				coinDown();
				pogo_count += 1;
			}
		}
		
		//HORSE BUTTON FUNCTIONS
		public function horse_neg():void
		{
			if (horse_count != 0 && upgradeState.getCoins() < 15)
			{
				coinUp();
				horse_count -= 1;
			}
		}
		
		public function horse_pos():void
		{
			if (upgradeState.getCoins() != 0 && horse_count < horse_max)
			{
				coinDown();
				horse_count += 1;
			}
		}
		
		//ITEM BUTTON FUNCTIONS
		public function item_neg():void
		{
			if (item_count != 0 && upgradeState.getCoins() < 15)
			{
				coinUp();
				item_count -= 1;
			}
		}
		
		public function item_pos():void
		{
			if (upgradeState.getCoins() != 0 && item_count < item_max)
			{
				coinDown();
				item_count += 1;
			}
		}
		
		//COIN BUTTON FUNCTIONS
		public function coin_neg():void
		{
			if (coin_count != 0 && upgradeState.getCoins() < 15)
			{
				coinUp();
				coin_count -= 1;
			}
		}
		
		public function coin_pos():void
		{
			if (upgradeState.getCoins() != 0 && coin_count < coin_max)
			{
				coinDown();
				coin_count += 1;
			}
		}
		
		//DRAGON BUTTON FUNCTIONS
		public function dragon_neg():void
		{
			if (dragon_count != 0 && upgradeState.getCoins() < 15)
			{
				coinUp();
				dragon_count -= 1;
			}
		}
		
		public function dragon_pos():void
		{
			if (upgradeState.getCoins() != 0 && dragon_count < dragon_max)
			{
				coinDown();
				dragon_count += 1;
			}
		}
		
		//Coin changing functions
		public function coinUp():void
		{
			upgradeState.coinChange(1);
		}
		
		public function coinDown():void
		{
			upgradeState.coinChange(-1);
		}
		
	}

}
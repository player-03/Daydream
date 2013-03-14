package daydream.game {
	import daydream.Main;
	import daydream.game.Platform;
	import daydream.game.Child;
	import daydream.utils.NumberInterval;
	import daydream.game.ItemQueue;
	import daydream.game.Horse_Head;
	import flash.events.TimerEvent;
	import org.flixel.FlxBasic;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import flash.utils.getTimer;
	
	public class GameState extends FlxState {
		public var raining:Boolean;
		private var rain:Rain;
		
		private var child:Child;
		private var platforms:FlxGroup;
		private var items:FlxGroup;
		private var enemies:FlxGroup;
		
		private var background:FlxGroup;
		private var foreground:FlxGroup;
		
		private var item_queue:ItemQueue;
		
		//For rain
		public var rainDurationTimer:Number = -1;
		public static const RAIN_MAX:Number = 10;
		public static const RAIN_CHANCE:Number = 0.1;
		public var rainCooldown:Number = -1;
		public static const RAIN_COOLDOWN_MAX:Number = 20;
		
		public override function create():void {
			rainCooldown = 0;
			
			FlxG.bgColor = 0xFFCCDDFF;
			
			background = new FlxGroup();
			add(background);
			
			platforms = new FlxGroup();
			add(platforms);
			
			items = new FlxGroup();
			add(items);
			
			enemies = new FlxGroup();
			add(enemies);
			
			child = new Child(this, 50, 0);
			add(child);
			
			item_queue = new ItemQueue(child, 10, 10);
			add(item_queue);
			
			foreground = new FlxGroup();
			add(foreground);
			
			raining = false;
			rain = new Rain(this);
			foreground.add(rain);
			
			var worldHeight:Number = Main.STAGE_HEIGHT * 5;
			
			FlxG.camera.setBounds(0, 0, Number.POSITIVE_INFINITY, worldHeight);
			FlxG.camera.follow(child);
			FlxG.camera.deadzone = new FlxRect(Main.STAGE_WIDTH * 0.16,
										Main.STAGE_HEIGHT * 0.35,
										0, Main.STAGE_HEIGHT * 0.2);
			
			addPlatform(new Platform(30, worldHeight - 500, 300));
			addPlatform(new Platform(550, worldHeight - 650, 111));
			addPlatform(new Platform(630, worldHeight - 250, 170));
			
			//addItem(new Horse_Head(590, worldHeight - 700));
			//addItem(new PogoStick(590, worldHeight - 700));
			//addItem(new Straw(200, 360));
			addItem(new Umbrella(590, worldHeight - 700));
			addEnemy(new Enemy(700, worldHeight - 340, 0));
			
			var jumpDistInterval:NumberInterval = new NumberInterval(Child.JUMP_DISTANCE / 2, Child.JUMP_DISTANCE * 2);
			add(new PlatformSpawner(this, 630,
					new NumberInterval(worldHeight - 320, worldHeight - 10 - Platform.TILE_WIDTH),
					new NumberInterval(340, 600),
					new NumberInterval(Child.JUMP_DISTANCE / 3, Child.JUMP_DISTANCE),
					[Horse_Head], [0.1]));
			add(new PlatformSpawner(this, 550,
					new NumberInterval(worldHeight - 700, worldHeight - 340),
					new NumberInterval(280, 550),
					jumpDistInterval,
					[Horse_Head], [0.04]));
			add(new PlatformSpawner(this, 5000,
					new NumberInterval(worldHeight - 1100, worldHeight - 720),
					new NumberInterval(230, 500),
					jumpDistInterval,
					[Horse_Head, Straw], [0.05, 0.05]));
			add(new PlatformSpawner(this, 15000,
					new NumberInterval(worldHeight - 1900, worldHeight - 1130),
					new NumberInterval(200, 470),
					jumpDistInterval));
			
			child.y = FlxG.camera.bounds.bottom - 600;
		}
		
		public override function update():void {
			if(Math.random() < RAIN_CHANCE && rainDurationTimer == -1 && rainCooldown == -1) {
				rainDurationTimer = 0;
				raining = true;
			}
			
			if (rainDurationTimer >= 0)
			{
				rainDurationTimer += FlxG.elapsed;
				
				if (rainDurationTimer >= RAIN_MAX)
				{
					raining = false;
					rainDurationTimer = -1;
					rainCooldown = 0;
				}
			}
			
			if (rainCooldown >= 0)
			{
				rainCooldown += FlxG.elapsed;
				
				if (rainCooldown >= RAIN_COOLDOWN_MAX)
				{
					rainCooldown = -1;
				}
			}
			
			super.update();
			
			//the world bounds define the area where collisions will be
			//checked (and it uses a quad tree, so it isn't possible to
			//set the width to infinity)
			FlxG.worldBounds.x = FlxG.camera.scroll.x;
			FlxG.worldBounds.y = FlxG.camera.scroll.y;
			
			FlxG.collide(child, platforms);
			FlxG.overlap(child, items, child.onItemCollision);
			FlxG.overlap(child, enemies, child.onEnemyCollision);
			
			removeOOBMembers(platforms, false);
			removeOOBMembers(items, true);
			removeOOBMembers(enemies, true);
		}
		
		private function removeOOBMembers(group:FlxGroup, recycle:Boolean):void {
			var member:FlxObject;
			for(var i:int = group.members.length - 1; i >= 0; i--) {
				member = group.members[i] as FlxObject;
				if(member != null && member.exists && member.x + member.width < FlxG.worldBounds.x) {
					if(recycle) {
						member.kill();
					} else {
						//if the second parameter is false, the target
						//group will become unordered
						group.remove(member, false);
						member.destroy();
					}
				}
			}
		}
		
		public function addPlatform(platform:FlxBasic):void {
			if(platform != null) {
				platforms.add(platform);
			}
		}
		public function addItem(item:FlxBasic):void {
			if(item != null) {
				items.add(item);
			}
		}
		public function addEnemy(enemy:FlxBasic):void {
			if(enemy != null) {
				enemies.add(enemy);
			}
		}
		
		public override function destroy():void {
			super.destroy();
			
			child = null;
			platforms = null;
		}
		
	}
}
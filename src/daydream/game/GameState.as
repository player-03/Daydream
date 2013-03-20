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
		private static const WORLD_HEIGHT:Number = 3400;
		
		private var child:Child;
		private var platforms:FlxGroup;
		private var items:FlxGroup;
		private var enemies:FlxGroup;
		
		private var background:FlxGroup;
		private var foreground:FlxGroup;
		
		private var item_queue:ItemQueue;
		
		private var rain:Rain;
		private var rainbow:Rainbow;
		
		private var scoreKeeper:ScoreKeeper;
		
		public override function create():void {
			FlxG.bgColor = 0xFFCCDDFF;
			
			//because some objects refer to this in their constructor
			FlxG.camera.setBounds(0, 0, Number.POSITIVE_INFINITY, WORLD_HEIGHT);
			
			background = new FlxGroup();
			add(background);
			
			background.add(new LoopingBackground());
			
			rainbow = new Rainbow();
			background.add(rainbow);
			
			platforms = new FlxGroup();
			add(platforms);
			
			items = new FlxGroup();
			add(items);
			
			enemies = new FlxGroup();
			add(enemies);
			
			child = new Child(this, rainbow, 50, 0);
			add(child);
			
			foreground = new FlxGroup();
			add(foreground);
			
			rain = new Rain(this, rainbow, 30, 10, 3, 5);
			foreground.add(rain);
			
			item_queue = new ItemQueue(child, 10, 10);
			foreground.add(item_queue);
			
			scoreKeeper = new ScoreKeeper(child, 100, 10);
			foreground.add(scoreKeeper);
			
			foreground.add(new JumpReplenishIndicator(child, 55, 18));
			
			FlxG.camera.follow(child);
			FlxG.camera.deadzone = new FlxRect(Main.STAGE_WIDTH * 0.16,
										Main.STAGE_HEIGHT * 0.35,
										0, Main.STAGE_HEIGHT * 0.2);
			
			addPlatform(new Platform(30, WORLD_HEIGHT - 500, 300));
			addPlatform(new Platform(550, WORLD_HEIGHT - 650, 111));
			addPlatform(new Platform(630, WORLD_HEIGHT - 250, 170));
			
			addItem(new PogoStick(590, WORLD_HEIGHT - 700));
			addEnemy(new Enemy(700, WORLD_HEIGHT - 340, 0));
			
			var jumpDistInterval:NumberInterval = new NumberInterval(Child.JUMP_DISTANCE / 2, Child.JUMP_DISTANCE * 2);
			add(new PlatformSpawner(this, 630,
					new NumberInterval(WORLD_HEIGHT - 320, WORLD_HEIGHT - 10 - Platform.TILE_WIDTH),
					new NumberInterval(340, 600),
					new NumberInterval(Child.JUMP_DISTANCE / 3, Child.JUMP_DISTANCE),
					child, [Horse_Head], [0.17], 0));
			add(new PlatformSpawner(this, 550,
					new NumberInterval(WORLD_HEIGHT - 700, WORLD_HEIGHT - 340),
					new NumberInterval(280, 550),
					jumpDistInterval, child,
					[Horse_Head, PogoStick], [0.04, 0.03]));
			add(new PlatformSpawner(this, 2500,
					new NumberInterval(WORLD_HEIGHT - 1100, WORLD_HEIGHT - 720),
					new NumberInterval(270, 500),
					jumpDistInterval, child,
					[Horse_Head, PogoStick], [0.05, 0.03]));
			add(new PlatformSpawner(this, 5000,
					new NumberInterval(WORLD_HEIGHT - 1900, WORLD_HEIGHT - 1130),
					new NumberInterval(270, 600),
					jumpDistInterval, child,
					[PogoStick], [0.03]));
			add(new PlatformSpawner(this, 7500,
					new NumberInterval(WORLD_HEIGHT - 2400, WORLD_HEIGHT - 1920),
					new NumberInterval(280, 450),
					jumpDistInterval, child,
					[Straw], [0.08], 0.0005));
			add(new PlatformSpawner(this, 10000,
					new NumberInterval(0, WORLD_HEIGHT - 2420),
					new NumberInterval(300, 350),
					jumpDistInterval, child,
					[Horse_Head], [0.2], 0.0005));
			
			child.y = FlxG.camera.bounds.bottom - 600;
		}
		
		public override function update():void {
			if(FlxG.keys.justPressed("P") || FlxG.keys.justPressed("ESCAPE")) {
				FlxG.paused = !FlxG.paused;
				Main.getInstance().updatePauseScreen();
			}
			if(FlxG.paused) {
				return;
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
			FlxG.collide(enemies, platforms);
			
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
		
		public function isRaining():Boolean {
			return rain.visible;
		}
	}
}
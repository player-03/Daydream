package daydream.game {
	import daydream.Main;
	import daydream.game.Platform;
	import daydream.game.Child;
	import flash.events.TimerEvent;
	import org.flixel.FlxBasic;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxRect;
	import org.flixel.FlxState;
	import flash.utils.getTimer;
	
	public class GameState extends FlxState {
		private var child:Child;
		private var platforms:FlxGroup;
		private var items:FlxGroup;
		private var enemies:FlxGroup;
		private var lastSpawnX:Number;
		private var distanceBetweenSpawns:Number;
		
		public override function create():void {
			FlxG.bgColor = 0xFFCCDDFF;
			
			platforms = new FlxGroup();
			add(platforms);			
			
			items = new FlxGroup();
			add(items);
			
			enemies = new FlxGroup();
			add(enemies);
			
			child = new Child(50, 0);
			add(child);
			
			FlxG.camera.setBounds(0, 0, Number.POSITIVE_INFINITY,
										Main.STAGE_HEIGHT * 5);
			FlxG.camera.follow(child);
			FlxG.camera.deadzone = new FlxRect(Main.STAGE_WIDTH * 0.16,
										Main.STAGE_HEIGHT * 0.35,
										0, Main.STAGE_HEIGHT * 0.2);
			
			distanceBetweenSpawns = 200 * Main.STAGE_HEIGHT / FlxG.camera.bounds.height;
			lastSpawnX = 0;
			
			addPlatform(new Platform(30, FlxG.camera.bounds.bottom - 500, 300));
			addPlatform(new Platform(550, FlxG.camera.bounds.bottom - 650, 111));
			addPlatform(new Platform(800, FlxG.camera.bounds.bottom - 600, 222));
			addPlatform(new Platform(630, FlxG.camera.bounds.bottom - 250, 170));
			addPlatform(new Platform(1000, FlxG.camera.bounds.bottom - 250, 170));
			
			child.y = FlxG.camera.bounds.bottom - 600;
		}
		
		public override function update():void {
			super.update();
			
			//the world bounds define the area where collisions will be
			//checked (and it uses a quad tree, so it isn't possible to
			//set the width to infinity)
			FlxG.worldBounds.x = FlxG.camera.scroll.x;
			FlxG.worldBounds.y = FlxG.camera.scroll.y;
			
			FlxG.collide(child, platforms);
			FlxG.overlap(child, items, child.onItemCollision);
			FlxG.overlap(child, enemies, child.onEnemyCollision);
			
			if(FlxG.camera.scroll.x >= lastSpawnX + distanceBetweenSpawns) {
				platformGenerator();
				lastSpawnX = FlxG.camera.scroll.x;
			}
			
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
						group.remove(member, true);
						member.destroy();
					}
				}
			}
		}
		
		public function addPlatform(platform:FlxBasic):void {
			platforms.add(platform);
		}
		public function addItem(item:FlxBasic):void {
			items.add(item);
		}
		public function addEnemy(enemy:FlxBasic):void {
			enemies.add(enemy);
		}
		
		public function platformGenerator():void
		{
			var bounds_max:Number;
			var bounds_min:Number;
			
			bounds_min = FlxG.camera.bounds.top + 100;
			bounds_max = FlxG.camera.bounds.bottom - (Platform.TILE_WIDTH + Child.CHILD_HEIGHT + Child.JUMP_HEIGHT);
			
			addPlatform(new Platform(FlxG.camera.scroll.x + Main.STAGE_WIDTH,
									(Math.random() * bounds_max - bounds_min) + bounds_min,
									(Math.random() * 300) + 50));
		}
		
		public override function destroy():void {
			super.destroy();
			
			child = null;
			platforms = null;
		}
		
	}
}
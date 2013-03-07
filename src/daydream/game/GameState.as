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
		
		//these are the platform generation variables
		private var gen_bounds:Number;
		private var bounds_max:Number;
		private var bounds_min:Number;
		private var bounds_mid:Number;
		private var up_bounds:Number;
		private var down_bounds:Number;
		
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
			
			//set the platform generation variables
			bounds_min = FlxG.camera.bounds.top;
			bounds_max = FlxG.camera.bounds.bottom + (Platform.TILE_WIDTH + Child.CHILD_HEIGHT + Child.JUMP_HEIGHT);
			gen_bounds = bounds_max - bounds_min;
			
			bounds_mid = gen_bounds / 2;
			up_bounds = bounds_max + bounds_mid;
			down_bounds = bounds_mid + bounds_min;
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
			
			second_time = getTimer() * 0.01;
			
			//every 0.7 seconds, generate a platform
			if (second_time - first_time == 7)
			{
				platformGenerator();
				//platformGenerator();
				first_time = second_time;
				//trace("DUNK: " + child.y + "\n");
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
		
		//this generates 1 platform on the top half, 1 on bottom half
		public function platformGenerator():void
		{
			//addPlatform(new Platform(FlxG.worldBounds.right, (Math.random() * gen_bounds), (Math.random() * 300) + 50));
			addPlatform(new Platform(FlxG.worldBounds.right, (Math.random() * up_bounds), (Math.random() * 300) + 50));
			addPlatform(new Platform(FlxG.worldBounds.right, (Math.random() * down_bounds), (Math.random() * 300) + 50));
		}
		
		public override function destroy():void {
			super.destroy();
			
			child = null;
			platforms = null;
		}
		
	}
}
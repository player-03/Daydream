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
		private var first_time:int;
		private var second_time:int;
		
		public override function create():void {
			first_time = getTimer() * 0.001;
			FlxG.bgColor = 0xFFCCDDFF;
			
			platforms = new FlxGroup();
			addPlatform(new Platform(30, 400, 300));
			addPlatform(new Platform(450, 300, 111));
			addPlatform(new Platform(730, 200, 170));
			addPlatform(new Platform(2000, 413, 200));
			addPlatform(new Platform(1050, 220, 135));
			addPlatform(new Platform(950, 520, 50));
			addPlatform(new Platform(1600, 600, 108));
			addPlatform(new Platform(530, 580, 128));
			add(platforms);			
			
			items = new FlxGroup();
			add(items);
			
			enemies = new FlxGroup();
			add(enemies);
			
			child = new Child(50, 300);
			add(child);
			
			FlxG.camera.setBounds(0, 0, Number.POSITIVE_INFINITY, Main.STAGE_HEIGHT * 1.3);
			FlxG.camera.follow(child);
			FlxG.camera.deadzone = new FlxRect(Main.STAGE_WIDTH * 0.16,
										Main.STAGE_HEIGHT * 0.35,
										0, Main.STAGE_HEIGHT * 0.2);
										
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
			
			second_time = getTimer() * 0.001;
			
			if (second_time - first_time == 1)
			{
				platformGenerator();
				platformGenerator();
				first_time = second_time;
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
			var gen_bounds:Number;
			var bounds_max:Number;
			var bounds_min:Number;
			
			//it seems like the camera bounds y is inverted
			bounds_min = FlxG.camera.bounds.top - 100;
			bounds_max = FlxG.camera.bounds.bottom - (Platform.TILE_WIDTH + Child.CHILD_HEIGHT + Child.JUMP_HEIGHT);
			
			gen_bounds = bounds_max - bounds_min;
				
			addPlatform(new Platform(FlxG.worldBounds.right, (Math.random() * gen_bounds), (Math.random() * 300) + 50));
		}
		
		public override function destroy():void {
			super.destroy();
			
			child = null;
			platforms = null;
		}
		
	}
}
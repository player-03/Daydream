package daydream.game {
	import daydream.Main;
	import org.flixel.FlxBasic;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxRect;
	import org.flixel.FlxState;
	
	public class GameState extends FlxState {
		private var child:Child;
		private var platforms:FlxGroup;
		private var items:FlxGroup;
		private var enemies:FlxGroup;
		
		//tiles group and number of tile types
		private var tiles:FlxGroup;
		private var num_tile_types:int;
		
		public override function create():void {
			num_tile_types = 2;
			
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
		
		//this will be reworked to incorporate the generateRandTile function
		//	will be called once the last tile loaded is completely on the screen
		public function addTile(tile:FlxBasic):void
		{
			tiles.add(tile);
		}
		
		public override function destroy():void {
			super.destroy();
			
			child = null;
			platforms = null;
		}
		
		
		//This will give us a random number based on the number of available tile types
		public function generateRandTile():int
		{
			return (Math.round(Math.random() * (num_tile_types - 1)));
		}
	}
}
package daydream {
	import org.flixel.FlxBasic;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxState;
	
	public class GameState extends FlxState {
		private var child:Child;
		private var platforms:FlxGroup;
		
		public override function create():void {
			FlxG.bgColor = 0xFFCCDDFF;
			
			platforms = new FlxGroup();
			addPlatform(new Platform(30, 400, 300));
			addPlatform(new Platform(450, 300, 111));
			addPlatform(new Platform(730, 200, 170));
			addPlatform(new Platform(2000, 400, 200));
			addPlatform(new Platform(1050, 220, 135));
			addPlatform(new Platform(1600, 600, 108));
			addPlatform(new Platform(530, 580, 128));
			add(platforms);
			
			child = new Child(50, 300);
			add(child);
			
			FlxG.camera.setBounds(0, 0, Number.POSITIVE_INFINITY, Main.STAGE_HEIGHT * 1.3);
			FlxG.camera.follow(child, FlxCamera.STYLE_PLATFORMER);
		}
		
		public override function update():void {
			super.update();
			
			FlxG.worldBounds.x = FlxG.camera.scroll.x;
			FlxG.worldBounds.y = FlxG.camera.scroll.y;
			
			FlxG.collide(child, platforms);
		}
		
		public function addPlatform(platform:FlxBasic):void {
			platforms.add(platform);
		}
		
		public override function destroy():void {
			super.destroy();
			
			child = null;
			platforms = null;
		}
	}
}
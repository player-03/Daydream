package daydream.game {
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	
	public class DragonSpawner extends FlxBasic {
		private var timeUntilNext:Number;
		private var timeBetweenDragons:Number;
		
		public function DragonSpawner(timeBetweenDragons:Number) {
			super();
			
			this.timeBetweenDragons = timeBetweenDragons;
			timeUntilNext = timeBetweenDragons / 3;
		}
		
		public override function update():void {
			timeUntilNext -= FlxG.elapsed;
			
			if(timeUntilNext <= 0) {
				timeUntilNext = timeBetweenDragons;
				
				(FlxG.state as GameState).addEnemy(
						new Dragon((FlxG.state as GameState).getChild().y + 100/*100 + Math.random() * 600*/));
			}
		}
	}
}
package daydream.game {
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class DragonRideSprite extends FlxSprite {
		[Embed(source = "../../../lib/DragonRider.png")] private static var image:Class;
		
		private static const RIDE_LENGTH:Number = 6;
		private static const X_OFFSET:Number = -401;
		private static const Y_OFFSET:Number = -98;
		
		private var child:Child;
		
		private var timeLeft:Number;
		
		private var currentDragon:Dragon;
		
		public function DragonRideSprite(child:Child) {
			super(0, 0, image);
			
			this.child = child;
			
			timeLeft = 0;
			
			visible = false;
		}
		
		public override function update():void {
			if(visible) {
				timeLeft -= FlxG.elapsed;
				
				//do this continuously, to keep the dragon from being destroyed
				currentDragon.x = child.x + X_OFFSET + currentDragon.offset.x
								+ child.velocity.x * FlxG.elapsed;
				
				if(timeLeft <= 0) {
					visible = false;
					
					currentDragon.revive();
					currentDragon.y = child.y + Y_OFFSET + currentDragon.offset.y;
					currentDragon.timeAlive += RIDE_LENGTH;
					currentDragon.update();
					
					child.setInvincibleFor(1);
				}
			}
		}
		
		public override function draw():void {
			if(visible) {
				x = child.x + X_OFFSET;
				y = child.y + Y_OFFSET;
				super.draw();
			}
		}
		
		public function activate(dragon:Dragon):void {
			visible = true;
			timeLeft = RIDE_LENGTH;
			currentDragon = dragon;
		}
	}
}
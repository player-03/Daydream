package daydream.game {
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	public class Child extends FlxSprite {
		private static const RUN_SPEED_CUTOFF:Number = 200;
		private static const SPRINT_SPEED_CUTOFF:Number = 400;
		private static const HORSE_SPEED:Number = 600;
		private static const WALK_ACCEL:Number = 100;
		private static const RUN_ACCEL:Number = 10;
		private static const SPRINT_ACCEL:Number = 2;
		private static const JUMP_STRENGTH:Number = 250;
		private static const JUMP_LENGTH:Number = 1;
		private static const JUMP_GRAVITY:Number = 300;
		private static const FALL_SPEED:Number = 300;
		private static const GRAVITY:Number = 470;
		public static const CHILD_HEIGHT:Number = 60;
		
		/**
		 * Estimated distance the child can cover by the apex of his jump.
		 */
		public static const JUMP_DISTANCE:Number = 400;
		/**
		 * Estimated distance the child can reasonably jump.
		 */
		public static const JUMP_HEIGHT:Number = 200;
		
		[Embed(source = "../../../lib/Child.png")] protected var ImgChild:Class;
		[Embed(source = "../../../lib/horse_head.png")] protected var imgHorse:Class;
		
		private var gameState:GameState;
		
		private var deadTime:Number = 0;
		private var jumpTime:Number = 0;
		private var usedMidairJump:Boolean = true;
		
		//Item variables
		public var currentItem:FlxObject = null;
		public var itemInUse:FlxObject = null;
		private var itemTimeLeft:Number;
		//just for horse
		private var prev_vel:Number;
		
		public function Child(gameState:GameState, x:Number, y:Number) {
			super(x, y);
			
			this.gameState = gameState;
			
			loadGraphic(ImgChild, true, false, 50, CHILD_HEIGHT);
			addAnimation("idle", [0, 1], 2);
			addAnimation("run", [4, 5, 6, 7, 8, 9, 10, 11], 20);
			addAnimation("jump", [12, 13, 14], 12, false);
			addAnimation("midair jump", [20, 21, 22], 12, false);
			addAnimation("fall", [15]);
			addAnimation("attack", [16, 17, 18, 19], 20, false);
			
			velocity.x = RUN_SPEED_CUTOFF / 4;
			acceleration.x = WALK_ACCEL;
			acceleration.y = GRAVITY;
			maxVelocity.x = Number.POSITIVE_INFINITY;
			maxVelocity.y = FALL_SPEED;
		}
		
		public function onItemCollision(child:FlxObject, item:FlxObject):void {
			if(child != this) {
				//this probably won't happen
				return;
			}
			
			//check the item picked up
			if (item is Horse_Head
				|| item is Straw
				|| item is Umbrella)
			{
				currentItem = item;
			}
			
			item.kill();
		}
		
		public function onEnemyCollision(child:FlxObject, enemy:FlxObject):void {
			if(child != this) {
				//this probably won't happen
				return;
			}
			
			if(itemInUse is Horse_Head) {
				trace("Attacking " + enemy);
			} else {
				trace("Attacked by " + enemy);
			}
		}
		
		public override function update():void {
			if(y > FlxG.camera.bounds.bottom) {
				deadTime += FlxG.elapsed;
				if(deadTime > 0.25) {
					FlxG.resetState();
				}
				return;
			}
			
			if(!(itemInUse is Horse_Head)) {
				if(velocity.x < RUN_SPEED_CUTOFF) {
					acceleration.x = WALK_ACCEL;
				} else if(velocity.x < SPRINT_SPEED_CUTOFF) {
					acceleration.x = RUN_ACCEL;
				} else {
					acceleration.x = SPRINT_ACCEL;
				}
			}
			
			if (!(itemInUse is Straw))
			{
				var onGround:Boolean = isTouching(FLOOR);
				if(onGround) {
					usedMidairJump = false;
				}
				
				if(!usedMidairJump) {
					if(FlxG.keys.justPressed("UP") || FlxG.keys.justPressed("SPACE")) {
						//rain condition
						if(gameState.raining && !(itemInUse is Umbrella)) {
							velocity.y = -JUMP_STRENGTH * 0.82;
						} else {
							velocity.y = -JUMP_STRENGTH;
						}
						
						jumpTime = 0;
						
						if(onGround) {
							onGround = false;
							play("jump");
						} else {
							usedMidairJump = true;
							play("midair jump");
						}
					}
				}
				
				if(jumpTime < JUMP_LENGTH) {
					if(FlxG.keys.UP || FlxG.keys.SPACE) {
						jumpTime += FlxG.elapsed;
						acceleration.y = JUMP_GRAVITY;
					} else {
						jumpTime = JUMP_LENGTH;
						acceleration.y = GRAVITY;
					}
				} else {
					acceleration.y = GRAVITY;
				}
				
				if(onGround) {
					if(velocity.x < 30) {
						play("idle");
					} else {
						play("run");
					}
				} else {
					if(velocity.y >= 0) {
						play("fall");
					}
				}
			}
			else
			{
				//the movement can be refined as needed (with accel and velocity)
				//	I just wanted to make sure this worked
				//trace("USING: " + itemInUse + " for " + second_time);
				if (FlxG.keys.UP || FlxG.keys.SPACE)
				{
					this.y -= 5;
				}
				
				if (FlxG.keys.DOWN)
				{
					this.y += 5;
				}
			}
			
			//ITEM HANDLING START
			if (currentItem != null && (FlxG.keys.F || FlxG.keys.SHIFT))
			{
				itemInUse = currentItem;
				currentItem = null;
				
				itemTimeLeft = 10;
				
				if (itemInUse is Horse_Head)
				{
					prev_vel = velocity.x;
				}
				
				if (itemInUse is Straw)
				{
					acceleration.y = 0;
					velocity.y = 0;
				}
			}
			
			if (itemInUse is Horse_Head)
			{
				if(itemTimeLeft > 0.5) {
					velocity.x = HORSE_SPEED;
				} else {
					velocity.x = prev_vel + (itemTimeLeft / 0.5) * (HORSE_SPEED - prev_vel);
				}
			}
			
			if (itemInUse != null)
			{
				itemTimeLeft -= FlxG.elapsed;
				if(itemTimeLeft <= 0) {
					if (itemInUse is Horse_Head)
					{
						velocity.x = prev_vel;
					}
					
					if (itemInUse is Straw)
					{
						acceleration.y = GRAVITY;
					}
					
					itemInUse = null;
				}
			}
			
			//ITEM HANDLING END
		}
	}
}
package daydream.game {
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	public class Child extends FlxSprite {
		private static const RUN_SPEED_CUTOFF:Number = 200;
		private static const SPRINT_SPEED_CUTOFF:Number = 400;
		private static const WALK_ACCEL:Number = 100;
		private static const RUN_ACCEL:Number = 10;
		private static const SPRINT_ACCEL:Number = 2;
		private static const JUMP_STRENGTH:Number = 250;
		private static const JUMP_LENGTH:Number = 1;
		private static const JUMP_GRAVITY:Number = 300;
		private static const FALL_SPEED:Number = 300;
		private static const GRAVITY:Number = 470;
		
		[Embed(source = "../../../lib/Child.png")] protected var ImgChild:Class;
		
		private var deadTime:Number = 0;
		private var jumpTime:Number = 0;
		private var usedMidairJump:Boolean = true;
		
		public function Child(x:Number, y:Number) {
			super(x, y);
			
			loadGraphic(ImgChild, true, false /*true*/, 50, 60);
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
			
			trace(item);
			
			//TODO
		}
		
		public function onEnemyCollision(child:FlxObject, enemy:FlxObject):void {
			if(child != this) {
				//this probably won't happen
				return;
			}
			
			trace(enemy);
			
			//TODO
		}
		
		public override function update():void {
			if(y > FlxG.worldBounds.bottom) {
				deadTime += FlxG.elapsed;
				if(deadTime > 0.25) {
					FlxG.resetState();
				}
				return;
			}
			
			if(velocity.x < RUN_SPEED_CUTOFF) {
				acceleration.x = WALK_ACCEL;
			} else if(velocity.x < SPRINT_SPEED_CUTOFF) {
				acceleration.x = RUN_ACCEL;
			} else {
				acceleration.x = SPRINT_ACCEL;
			}
			
			var onGround:Boolean = isTouching(FLOOR);
			if(onGround) {
				usedMidairJump = false;
			}
			
			if(!usedMidairJump) {
				if(FlxG.keys.justPressed("UP") || FlxG.keys.justPressed("SPACE")) {
					velocity.y = -JUMP_STRENGTH;
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
	}
}
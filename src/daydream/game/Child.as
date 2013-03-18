package daydream.game {
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	public class Child extends FlxSprite {
		public static const RUN_SPEED_CUTOFF:Number = 300;
		public static const SPRINT_SPEED_CUTOFF:Number = 500;
		private static const HORSE_MULTIPLIER:Number = 2;
		private static const WALK_ACCEL:Number = 100;
		private static const RUN_ACCEL:Number = 10;
		private static const SPRINT_ACCEL:Number = 2;
		private static const JUMP_STRENGTH:Number = 300;
		private static const JUMP_LENGTH:Number = 1;
		private static const JUMP_GRAVITY:Number = 350;
		private static const FALL_SPEED:Number = 400;
		private static const GRAVITY:Number = 650;
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
		
		private var gameState:GameState;
		private var rainbow:Rainbow;
		
		private var deadTime:Number = 0;
		private var jumpTime:Number = 0;
		private var jumpReplenish:Number = 0;
		private var usedMidairJump:Boolean = true;
		
		//Item variables
		public var currentItem:FlxObject = null;
		public var itemInUse:FlxObject = null;
		private var itemTimeLeft:Number;
		
		private var previousVelocity:FlxPoint = new FlxPoint();
		
		private var pogoStickBounces:int;
		
		/**
		 * The run speed, unless the child is on a horse, in which case
		 * this is a fraction of the run speed.
		 */
		public var baseXVelocity:Number;
		
		//for attacking
		private var attackTimer:Number = -1;
		private static const ATTACK_DAMAGE_START:Number = 0;
		private static const ATTACK_DAMAGE_END:Number = 0.25;
		private static const ATTACK_END:Number = 0.6;
		
		//Getting hit variables
		//**we can use the timer activation to also cancel any items that need to be cancelled on hit
		private var hitTimer:Number = -1;
		private static const HIT_TIMER_END:Number = 1;
		
		public function Child(gameState:GameState, rainbow:Rainbow, x:Number, y:Number) {
			super(x, y);
			
			this.gameState = gameState;
			this.rainbow = rainbow;
			
			loadGraphic(ImgChild, true, false, 50, CHILD_HEIGHT);
			addAnimation("idle", [0, 1], 2);
			addAnimation("run", [4, 5, 6, 7, 8, 9, 10, 11], 20);
			addAnimation("jump", [12, 13, 14], 12, false);
			addAnimation("midair jump", [20, 21, 22, 23], 12, false);
			addAnimation("fall", [15]);
			addAnimation("attack", [16, 17, 18, 19], 20, false);
			addAnimation("damaged", [24, 25], 12);
			addAnimation("pogo jump", [26]);
			addAnimation("pogo fall", [27]);
			addAnimation("fly up", [28]);
			addAnimation("fly down", [29]);
			addAnimation("horse run", [30, 31, 32, 33, 34, 35], 20);
			addAnimation("horse jump", [36, 37, 38], 12, false);
			addAnimation("horse fall", [39]);
			
			baseXVelocity = RUN_SPEED_CUTOFF / 4;
			acceleration.y = GRAVITY;
			//Handling this manually so that it doesn't get in the way of jumps
			//maxVelocity.y = FALL_SPEED;
		}
		
		public function onItemCollision(child:FlxObject, item:FlxObject):void {
			if(child != this) {
				//this probably won't happen
				return;
			}
			
			//check the item picked up
			if (item is Horse_Head
				|| item is Straw
				|| item is Umbrella
				|| item is PogoStick)
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
			
			if(itemInUse is Horse_Head)
			{
				enemy.kill();
			}
			else if(attackTimer >= ATTACK_DAMAGE_START && attackTimer <= ATTACK_DAMAGE_END)
			{
				enemy.kill();
			}
			else
			{
				if (hitTimer == -1)
				{
					hitTimer = 0;
					play("damaged");
				}
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
			
			if(baseXVelocity < RUN_SPEED_CUTOFF) {
				baseXVelocity += WALK_ACCEL * FlxG.elapsed;
			} else if(velocity.x < SPRINT_SPEED_CUTOFF) {
				baseXVelocity += RUN_ACCEL * FlxG.elapsed;
			} else {
				baseXVelocity += SPRINT_ACCEL * FlxG.elapsed;
			}
			
			if (!(itemInUse is Straw) && hitTimer == -1)
			{
				var onGround:Boolean = isTouching(FLOOR);
				if(onGround) {
					usedMidairJump = false;
					jumpReplenish = 1;
				}
				
				//always jump immediately when using the pogo stick
				if(onGround && (itemInUse is PogoStick)) {
					onGround = false;
					usedMidairJump = false;
					jumpTime = JUMP_LENGTH;
					jumpReplenish = 0;
					play("pogo jump");
					
					velocity.y = -JUMP_STRENGTH * (0.5 + 0.25 * pogoStickBounces)
							- previousVelocity.y * 0.7;
					
					if(affectedByRain()) {
						velocity.y *= 0.8;
					}
					
					pogoStickBounces++;
				}
				
				if(jumpReplenish == 1) {
					if(jumpJustPressed()) {
						//start with JUMP_STRENGTH, and then reduce that
						//based on certain conditions
						velocity.y = -JUMP_STRENGTH;
						
						if(affectedByRain()) {
							velocity.y *= 0.8;
						}
						if(attackTimer >= 0) {
							velocity.y *= 0.9;
						}
						
						//the child gets an extra boost from jumping off the
						//pogo stick, and it doesn't count as a midair jump
						if(itemInUse is PogoStick) {
							velocity.y *= 1 + pogoStickBounces * 0.1;
							itemInUse = null;
							itemTimeLeft = 0;
							onGround = true;
						}
						
						jumpTime = 0;
						jumpReplenish = 0;
						
						if(itemInUse is Horse_Head) {
							play("horse jump");
						} else if(onGround) {
							play("jump");
						} else {
							play("midair jump");
						}
						if(onGround) {
							onGround = false;
						} else {
							usedMidairJump = true;
						}
					}
				}
				
				//jumping
				if(jumpTime < JUMP_LENGTH) {
					jumpTime += FlxG.elapsed;
					
					if(jumpHeld()) {
						acceleration.y = JUMP_GRAVITY;
					} else {
						acceleration.y = GRAVITY;
					}
				} else {
					acceleration.y = GRAVITY;
				}
				
				//animations
				if(hitTimer >= 0) {
					play("damaged");
				} else if(attackTimer >= 0) {
					play("attack");
				} else if(onGround) {
					if(itemInUse is Horse_Head) {
						play("horse run");
					} else if(velocity.x < 30) {
						play("idle");
					} else {
						play("run");
					}
				} else {
					if(velocity.y >= 0) {
						if(itemInUse is Horse_Head) {
							play("horse fall");
						} else if(itemInUse is PogoStick) {
							play("pogo fall");
						} else {
							play("fall");
						}
					}
				}
			}
			
			if(jumpReplenish < 1) {
				//the jump replenish rate should be a lot faster
				//when in contact with the rainbow or before the
				//first midair jump, and it should be a little
				//slower when in the rain, and a lot slower if
				//the player is extending the jump
				if(!usedMidairJump || rainbow.visible && rainbow.withinRainbow(this)) {
					jumpReplenish += FlxG.elapsed * 7;
				} else if(acceleration.y == JUMP_GRAVITY) {
					jumpReplenish += FlxG.elapsed * 0.3;
				} else if(affectedByRain()) {
					jumpReplenish += FlxG.elapsed * 0.42;
				} else {
					jumpReplenish += FlxG.elapsed * 0.5;
				}
				
				if(jumpReplenish > 1) {
					jumpReplenish = 1;
				}
			}
			
			//flying
			if(itemInUse is Straw)
			{
				if (jumpHeld() && hitTimer == -1)
				{
					if(jumpJustPressed()) {
						acceleration.y = -GRAVITY * 0.8;
						//while raining, the player gets less of a boost from tapping space
						if(affectedByRain()) {
							acceleration.y *= 0.5 + 0.5 * Math.random();
						}
					} else {
						//while raining, the player loses lift quickly,
						//making them tap space frequently to keep going up
						if(affectedByRain()) {
							acceleration.y += GRAVITY * FlxG.elapsed;
						}
					}
				}
				else
				{
					acceleration.y = GRAVITY * 0.8;
				}
				
				if(acceleration.y < 0) {
					play("fly up");
				} else {
					play("fly down");
				}
				
				//limit velocity in both directions
				if(velocity.y <= -FALL_SPEED * 0.7) {
					velocity.y = -FALL_SPEED * 0.7;
				} else if(velocity.y >= FALL_SPEED) {
					velocity.y = FALL_SPEED;
				}
			}
			
			//attacking
			if (attackTimer >= 0)
			{
				attackTimer += FlxG.elapsed;
				
				if (attackTimer >= ATTACK_END)
				{
					attackTimer = -1;
				}
			}
			else if (attackTimer < 0 && FlxG.keys.justPressed("F") && currentItem == null)
			{
				attackTimer = 0;
			}
			
			//recovering from damage
			if (hitTimer >= 0)
			{
				hitTimer += FlxG.elapsed;
				
				if (hitTimer >= HIT_TIMER_END)
				{
					hitTimer = -1;
				}
			}
			
			//using held items
			if (currentItem != null && (FlxG.keys.D || FlxG.keys.SHIFT))
			{
				itemInUse = currentItem;
				currentItem = null;
				
				itemTimeLeft = 10;
				
				if (itemInUse is Straw)
				{
					acceleration.y = 0;
					velocity.y = 0;
				}
				
				if(itemInUse is PogoStick) {
					pogoStickBounces = 0;
				}
			}
			
			//x velocity
			if (itemInUse is Horse_Head)
			{
				if(itemTimeLeft > 1.2) {
					velocity.x = baseXVelocity * HORSE_MULTIPLIER;
				} else {
					velocity.x = baseXVelocity * (1 + (itemTimeLeft / 1.2) * (HORSE_MULTIPLIER - 1));
				}
			} else {
				velocity.x = baseXVelocity;
			}
			
			//item timing
			if (itemInUse != null)
			{
				//the pogo stick does not time out until after a set number of bounces
				if(itemInUse is PogoStick) {
					if(pogoStickBounces >= 6) {
						itemTimeLeft = 0;
					}
				} else {
					itemTimeLeft -= FlxG.elapsed;
				}
				if(itemTimeLeft <= 0) {
					if (itemInUse is Straw)
					{
						acceleration.y = GRAVITY;
					}
					
					itemInUse = null;
					
					if(velocity.y < 0) {
						play("fall");
					}
				}
			}
			
			if(velocity.y > FALL_SPEED && !(itemInUse is PogoStick)) {
				velocity.y = FALL_SPEED;
			}
			previousVelocity.copyFrom(velocity);
		}
		
		public function affectedByRain():Boolean {
			return gameState.isRaining() && !(itemInUse is Umbrella);
		}
		
		public function jumpReplenishPercent():Number {
			/*if(itemInUse is PogoStick && pogoStickBounces == 0) {
				return 0;
			}
			if(!usedMidairJump) {
				return 1;
			}
			return Math.max(0, Math.min(1, (jumpTime - JUMP_LENGTH) / JUMP_LENGTH * 1.5));*/
			return jumpReplenish;
		}
		
		private function jumpJustPressed():Boolean {
			return FlxG.keys.justPressed("UP") || FlxG.keys.justPressed("SPACE");
		}
		private function jumpHeld():Boolean {
			return FlxG.keys.UP || FlxG.keys.SPACE;
		}
	}
}
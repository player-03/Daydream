package daydream.game {
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	public class Child extends FlxSprite {
		private static const RUN_SPEED_CUTOFF:Number = 200;
		private static const SPRINT_SPEED_CUTOFF:Number = 400;
		private static const HORSE_MULTIPLIER:Number = 2;
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
		
		private var gameState:GameState;
		
		private var deadTime:Number = 0;
		private var jumpTime:Number = 0;
		private var usedMidairJump:Boolean = true;
		
		//Item variables
		public var currentItem:FlxObject = null;
		public var itemInUse:FlxObject = null;
		private var itemTimeLeft:Number;
		
		/**
		 * The run speed, unless the child is on a horse, in which case
		 * this is a fraction of the run speed.
		 */
		private var baseXVelocity:Number;
		
		//for attacking
		/*currently, the attack starts immediately and the player
		 * 	can damage for 0.3 seconds. it then is vulnerable until
		 * 	attackTimer reaches the cooldown then attackTimer is
		 * 	set back to -1 so attacking is available again.
		 */
		private var attackTimer:Number = -1;
		private static const ATTACK_DAMAGE_START:Number = 0;
		private static const ATTACK_DAMAGE_END:Number = 0.25;
		private static const ATTACK_END:Number = 0.6;
		
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
			
			baseXVelocity = RUN_SPEED_CUTOFF / 4;
			acceleration.y = GRAVITY;
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
			
			if(itemInUse is Horse_Head)
			{
				trace("Attacking " + enemy + " on horse");
			}
			else if(attackTimer >= ATTACK_DAMAGE_START && attackTimer <= ATTACK_DAMAGE_END)
			{
				trace("Attacking " + enemy);
				enemy.kill();
			}
			else
			{
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
			
			if(baseXVelocity < RUN_SPEED_CUTOFF) {
				baseXVelocity += WALK_ACCEL * FlxG.elapsed;
			} else if(velocity.x < SPRINT_SPEED_CUTOFF) {
				baseXVelocity += RUN_ACCEL * FlxG.elapsed;
			} else {
				baseXVelocity += SPRINT_ACCEL * FlxG.elapsed;
			}
			
			if (!(itemInUse is Straw))
			{
				var onGround:Boolean = isTouching(FLOOR);
				if(onGround) {
					usedMidairJump = false;
				}
				
				//uncomment this once PogoStick is added (or whatever the
				//class name is)
				/*if(onGround && (itemInUse is PogoStick)) {
					onGround = false;
					usedMidairJump = true;
					play("jump");
					velocity.y = -JUMP_STRENGTH * 1.6;
					if(gameState.raining) {
						velocity.y *= 0.9;
					}
				}*/
				
				if(!usedMidairJump) {
					if(FlxG.keys.justPressed("UP") || FlxG.keys.justPressed("SPACE")) {
						//start with JUMP_STRENGTH, and then reduce that
						//based on certain conditions
						velocity.y = -JUMP_STRENGTH;
						
						if(gameState.raining && !(itemInUse is Umbrella)) {
							velocity.y *= 0.82;
						}
						if(attackTimer >= 0) {
							velocity.y *= 0.9;
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
				
				if(attackTimer >= 0) {
					play("attack");
				} else if(onGround) {
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
				if (FlxG.keys.UP || FlxG.keys.SPACE)
				{
					this.y -= 5;
				}
				
				if (FlxG.keys.DOWN)
				{
					this.y += 5;
				}
			}
			
			if (attackTimer >= 0)
			{
				attackTimer += FlxG.elapsed;
				
				if (attackTimer >= ATTACK_END)
				{
					attackTimer = -1;
				}
			}
			else if (attackTimer < 0 && FlxG.keys.justPressed("F"))
			{
				attackTimer = 0;
			}
			
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
			}
			
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
			
			if (itemInUse != null)
			{
				itemTimeLeft -= FlxG.elapsed;
				if(itemTimeLeft <= 0) {
					if (itemInUse is Straw)
					{
						acceleration.y = GRAVITY;
					}
					
					itemInUse = null;
				}
			}
		}
	}
}
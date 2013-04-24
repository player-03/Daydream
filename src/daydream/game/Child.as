package daydream.game {
	import daydream.upgrades.UpgradesState;
	import daydream.utils.FlxSpriteUtils;
	import daydream.utils.Save;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxSound;
	
	public class Child extends FlxSprite {
		public static const RUN_SPEED_CUTOFF:Number = 500; //800 when upgraded
		public static const SPRINT_SPEED_CUTOFF:Number = 1500; //2000 when upgraded
		public static const HORSE_MULTIPLIER:Number = 2;
		public static const WALK_ACCEL:Number = 100;
		public static const RUN_ACCEL:Number = 10;
		public static const SPRINT_ACCEL:Number = 2; //3 when upgraded
		public static const JUMP_STRENGTH:Number = 300;
		public static const JUMP_LENGTH:Number = 1;
		public static const JUMP_GRAVITY:Number = 350;
		public static const FALL_SPEED:Number = 400;
		public static const GRAVITY:Number = 650;
		public static const CHILD_HEIGHT:Number = 60;
		
		//SFX
		[Embed(source = "../../../lib/SFX_GALLOP.mp3")] private static var gallopSound:Class;
		[Embed(source = "../../../lib/SFX_JUMP.mp3")] private static var jumpSound:Class;
		[Embed(source = "../../../lib/SFX_JUMP_POGO.mp3")] private static var pogoSound:Class;
		[Embed(source = "../../../lib/SFX_NEIGH.mp3")] private static var neighSound:Class;
		[Embed(source = "../../../lib/SFX_COIN.mp3")] private static var coinPickupSound:Class;
		[Embed(source = "../../../lib/SFX_ENEMY_DIE.mp3")] private static var enemyDeathSound:Class;
		[Embed(source = "../../../lib/SFX_STICK_SWING.mp3")] private static var attackSound:Class;
		[Embed(source = "../../../lib/SFX_RAIN_NOUMBRELLA.mp3")] private static var rainNoUmbrellaSound:Class;
		[Embed(source = "../../../lib/SFX_RAIN_UMBRELLA.mp3")] private static var rainWithUmbrellaSound:Class;
		[Embed(source = "../../../lib/SFX_DRAGON.mp3")] private static var dragonSound:Class;
		
		/**
		 * Estimated distance the child can cover by the apex of his jump.
		 */
		public static const JUMP_DISTANCE:Number = 400;
		/**
		 * Estimated distance the child can reasonably jump.
		 */
		public static const JUMP_HEIGHT:Number = 150;
		
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
		private static const ITEM_TIME:Number = 10;
		private var itemTimeLeft:Number;
		
		private var previousVelocity:FlxPoint = new FlxPoint();
		
		private var pogoStickBounces:int;
		
		private var dragonSprite:DragonRideSprite;
		
		private var umbrellaSprite:Umbrella;
		private var umbrellaOffset:FlxPoint;
		
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
		private static const ENEMY_KILL_POINTS:int = 1000;
		
		private static const DRAGON_RIDE_POINTS:int = 5000;
		private static const DRAGON_SPEED_MULTIPLIER:Number = 4;
		
		//Getting hit variables
		//**we can use the timer activation to also cancel any items that need to be cancelled on hit
		private var hitTimer:Number = -1;
		private static const HIT_TIMER_END:Number = 1;
		private var invincibleTimeLeft:Number = 0;
		
		/**
		 * The number of points earned per pixel travelled.
		 */
		private static const DISTANCE_MULTIPLIER:Number = 0.4;
		private var score:int = 0;
		
		//coins
		private var coins:int;
		private static const coinMax:int = 20;
		
		private var rainStart:Boolean;
		
		public function Child(gameState:GameState, rainbow:Rainbow, x:Number, y:Number) {
			super(x, y);
			
			this.gameState = gameState;
			this.rainbow = rainbow;
			
			dragonSprite = new DragonRideSprite(this);
			FlxG.state.add(dragonSprite);
			
			loadGraphic(ImgChild, true, false, 100, 100);
			addAnimation("idle", [0, 1], 2);
			addAnimation("run", [2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 20);
			addAnimation("jump", [12, 13, 14], 12, false);
			addAnimation("midair jump", [12, 13, 14], 12, false);//[20, 21, 22, 23], 12, false);
			addAnimation("fall", [15]);
			addAnimation("attack", [16, 17, 18, 19], 20, false);
			addAnimation("damaged", [24, 25], 12);
			addAnimation("pogo jump", [26]);
			addAnimation("pogo fall", [27]);
			addAnimation("fly up", [28]);
			addAnimation("fly down", [29]);
			addAnimation("horse run", [30, 31, 32, 33, 34, 35, 36, 37, 38, 39], 20);
			addAnimation("horse jump", [40, 41, 42], 12, false);
			addAnimation("horse fall", [43]);
			
			FlxSpriteUtils.applyInset(this, 15, 10, 15, 2);
			
			umbrellaSprite = new Umbrella();
			umbrellaOffset = new FlxPoint(-umbrellaSprite.width / 2 + width / 2,
										15 - umbrellaSprite.height);
			FlxG.state.add(umbrellaSprite);
			
			coins = Save.getInt(CoinCounter.COINS);
			
			baseXVelocity = RUN_SPEED_CUTOFF / 4;
			acceleration.y = GRAVITY;
			//Handling this manually so that it doesn't get in the way of jumps
			//maxVelocity.y = FALL_SPEED;
			
			rainStart = false;
		}
		
		public function onItemCollision(child:FlxObject, item:FlxObject):void {
			if(child != this) {
				//this probably won't happen
				return;
			}
			
			if (item is Coin)
			{
				FlxG.play(coinPickupSound);
				
				if(coins < coinMax)
					coins += 1;
			}
			
			//check the item picked up
			if (item is HorseHead
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
			
			//kill everything while riding a dragon
			if (dragonSprite.visible) {
				gameState.addItem(new Coin(enemy.x + 75, enemy.y + 35));
				enemy.kill();
				
				FlxG.play(enemyDeathSound);
				
				score += ENEMY_KILL_POINTS;
				
				return;
			}
			
			//ignore collisions while invincible
			if(invincibleTimeLeft > 0) {
				//TODO: Allow attacking while invincible.
				return;
			}
			
			//the hit timer doesn't finish until the child leaves contact
			//with the enemy
			if(hitTimer >= 0)
			{
				if(hitTimer > HIT_TIMER_END * 0.6) {
					hitTimer = HIT_TIMER_END * 0.6;
					flicker(HIT_TIMER_END - hitTimer);
				}
			}
			else if(enemy is Dragon)
			{
				var enemyOffset:FlxPoint = (enemy as Dragon).offset;
				//check if the child landed on the dragon's neck (not too
				//far forward, not too far back, and not from below)
				if(x + offset.x + width < enemy.x + enemyOffset.x + enemy.width - (80) + (Save.getInt(UpgradesState.DRAGON) * 2)
					&& x + offset.x > enemy.x + enemyOffset.x + enemy.width - (400) - (Save.getInt(UpgradesState.DRAGON) * 2)
					&& y + offset.y + height < enemy.y + enemyOffset.y + (10))
				{
					gameState.addItem(new Coin(enemy.x + 75, enemy.y + 35));
					enemy.kill();
					
					FlxG.play(dragonSound);
					
					score += DRAGON_RIDE_POINTS;
					
					dragonSprite.activate(enemy as Dragon);
					visible = false;
					
					acceleration.y = -10;
					velocity.y = 20;
					maxVelocity.y = 60;
					
					itemInUse = null;
				} else {
					hitTimer = 0;
					flicker(HIT_TIMER_END);
					baseXVelocity *= 0.99;
					velocity.y *= 0.6;
					itemTimeLeft = 0;
					pogoStickBounces = 10;
				}
			}
			else if(itemInUse is HorseHead || rainbow.visible && rainbow.withinRainbow(this)
				|| attackTimer >= ATTACK_DAMAGE_START && attackTimer <= ATTACK_DAMAGE_END)
			{
				gameState.addItem(new Coin(enemy.x + 75, enemy.y + 35));
				enemy.kill();
				
				FlxG.play(enemyDeathSound);
				
				score += ENEMY_KILL_POINTS;
			}
			else if(hitTimer < 0)
			{
				hitTimer = 0;
				flicker(HIT_TIMER_END);
				velocity.y *= 0.6;
				
				if(!(itemInUse is PogoStick)) {
					itemTimeLeft = 0;
				}
			}
		}
		
		public override function update():void {
			//This should loop the right SFX during these conditions
			if (gameState.isRaining() && rainStart == false)
			{
				rainStart = true;
				
				if (itemInUse is Umbrella)
					FlxG.play(rainWithUmbrellaSound, 1, true);
				else
					FlxG.play(rainNoUmbrellaSound, 1, true);
			}
			
			if (!gameState.isRaining() && rainStart == true)
			{
				rainStart = false;
			}
			
			if(visible == dragonSprite.visible) {
				visible = !dragonSprite.visible;
				if(visible) {
					acceleration.y = GRAVITY;
					velocity.y = -JUMP_STRENGTH * 1.4;
					jumpReplenish = 0;
					usedMidairJump = false;
					maxVelocity.y = 10000; //magic number meaning "infinity"
				}
			}
			
			if(y > FlxG.camera.bounds.bottom) {
				deadTime += FlxG.elapsed;
				if(deadTime > 0.25) {
					//FlxG.resetState();
					FlxG.switchState(new UpgradesState());
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
			
			var onGround:Boolean = isTouching(FLOOR);
			if(onGround) {
				usedMidairJump = false;
				jumpReplenish = 1;
			}
			
			//always jump immediately when using the pogo stick
			if(onGround && (itemInUse is PogoStick)) {
				onGround = false;
				jumpTime = JUMP_LENGTH;
				jumpReplenish = 0;
				play("pogo jump");
				FlxG.play(pogoSound);
				
				velocity.y = -JUMP_STRENGTH * 0.5
						- previousVelocity.y * 0.7;
				if(hitTimer < 0) {
					velocity.y -= JUMP_STRENGTH * (0.2 + 0.05 * Save.getInt(UpgradesState.POGO)) * pogoStickBounces;
				}
				
				if(affectedByRain()) {
					velocity.y *= 0.8;
				}
				
				pogoStickBounces++;
			}
			
			if (!(itemInUse is Straw) && hitTimer == -1 && !dragonSprite.visible)
			{
				//jumping (takeoff)
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
						if(itemInUse is HorseHead) {
							velocity.y *= 1.3;
						}
						
						//jumping from the pogo stick loses the item
						if(itemInUse is PogoStick) {
							itemInUse = null;
							itemTimeLeft = 0;
						}
						
						jumpTime = 0;
						jumpReplenish = 0;
						
						if(onGround) {
							onGround = false;
						} else {
							usedMidairJump = true;
						}
					}
				}
				
				//jumping (in midair -> decreased gravity)
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
			}
			
			if(jumpReplenish < 1) {
				//the jump replenish rate should be a lot faster
				//when in contact with the rainbow or before the
				//first midair jump, and it should be a little
				//slower when in the rain, and a lot slower if
				//the player is extending the jump
				if(!usedMidairJump || rainbow.visible && rainbow.withinRainbow(this)) {
					jumpReplenish += FlxG.elapsed * 7;
				} else if(affectedByRain()) {
					jumpReplenish += FlxG.elapsed * 0.2;
				} else if(acceleration.y == JUMP_GRAVITY) {
					jumpReplenish += FlxG.elapsed * 0.3;
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
				if(onGround)
				{
					itemTimeLeft = 0;
				}
				else if (jumpHeld() && hitTimer == -1)
				{
					if(jumpJustPressed()) {
						//the player gets a burst of speed upon pressing
						//space, but the strength of this burst depends on
						//how long they've been riding
						acceleration.y = -GRAVITY * (0.4 + 0.3 * (itemTimeLeft / ITEM_TIME));
					} else {
						//the player loses lift after a time, making them
						//tap space to go up as fast as possible
						if(!affectedByRain()) {
							acceleration.y += GRAVITY * 0.2 * FlxG.elapsed;
						} else {
							//they lose lift faster while it's raining
							acceleration.y += GRAVITY * 0.4 * FlxG.elapsed;
						}
						
						//they end up accelerating downwards
						if(acceleration.y >= GRAVITY * 0.2) {
							acceleration.y = GRAVITY * 0.2;
						}
					}
				}
				else
				{
					acceleration.y = GRAVITY * 0.8;
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
			else if (attackTimer < 0 && attackJustPressed() && (itemInUse == null || itemInUse is Umbrella))
			{
				FlxG.play(attackSound);
				attackTimer = 0;
			}
			
			//invincibility
			if(invincibleTimeLeft > 0) {
				invincibleTimeLeft -= FlxG.elapsed;
			}
			
			//recovering from damage
			if (hitTimer >= 0)
			{
				if(rainbow.visible && rainbow.withinRainbow(this))
				{
					//recovery is a lot faster within the rainbow
					hitTimer += 4 * FlxG.elapsed;
				}
				else
				{
					hitTimer += FlxG.elapsed;
				}
				
				if (hitTimer >= HIT_TIMER_END)
				{
					hitTimer = -1;
				}
			}
			
			//using held items
			if (currentItem != null && useItemJustPressed())
			{
				if (currentItem is HorseHead)
					FlxG.play(neighSound);
					
				itemInUse = currentItem;
				currentItem = null;
				
				itemTimeLeft = ITEM_TIME;
				
				if (itemInUse is Straw)
				{
					acceleration.y = 0;
					if(onGround) {
						velocity.y = -100;
					}
				}
				
				if(itemInUse is PogoStick) {
					pogoStickBounces = 0;
					usedMidairJump = false;
				}
			}
			
			//x velocity
			var targetXVelocity:Number = baseXVelocity;
			if (itemInUse is HorseHead) {
				targetXVelocity = baseXVelocity * (HORSE_MULTIPLIER + 0.05 * Save.getInt(UpgradesState.HORSE));
			} else if(dragonSprite.visible) {
				targetXVelocity = baseXVelocity * DRAGON_SPEED_MULTIPLIER;
			}
			
			if(velocity.x < targetXVelocity) {
				//this formula makes velocity.x approach the target more
				//quickly the farther apart the values are
				velocity.x += (targetXVelocity - velocity.x) * FlxG.elapsed * 5
							+ 4 * FlxG.elapsed;
				if(velocity.x > targetXVelocity) {
					velocity.x = targetXVelocity;
				}
			} else if(velocity.x > targetXVelocity) {
				velocity.x += (targetXVelocity - velocity.x) * FlxG.elapsed * 6
							+ 5 * FlxG.elapsed;
				if(velocity.x < targetXVelocity) {
					velocity.x = targetXVelocity;
				}
			}
			
			//item timing
			if (itemInUse != null)
			{
				//the pogo stick does not time out until after a set number of bounces
				if(itemInUse is PogoStick) {
					if(pogoStickBounces >= 6) {
						itemTimeLeft = 0;
						itemInUse = null;
					}
				} else {
					itemTimeLeft -= FlxG.elapsed;
					if(itemTimeLeft <= 0) {
						if (itemInUse is Straw) {
							acceleration.y = GRAVITY;
						}
						
						itemInUse = null;
					}
				}
			}
			
			//limit y velocity except when on a pogo stick and above the world
			if(velocity.y > FALL_SPEED && !(itemInUse is PogoStick) && y > -frameHeight) {
				velocity.y = FALL_SPEED;
			}
			previousVelocity.copyFrom(velocity);
			
			//animations
			if(itemInUse is Straw) {
				if(acceleration.y < 0) {
					play("fly up");
				} else {
					play("fly down");
				}
			} /*else if(hitTimer >= 0) {
				play("damaged");
			} */else if(attackTimer >= 0) {
				play("attack");
			} else if(onGround) {
				if (itemInUse is HorseHead) {
					FlxG.play(gallopSound);
					play("horse run");
				} else if(velocity.x < 30) {
					play("idle");
				} else {
					play("run");
				}
			} else {
				//the pogo stick fall animation starts almost immediately
				if(itemInUse is PogoStick) {
					if(jumpReplenish == 1) {
						play("pogo fall");
					}
				}
				
				//in most cases, the fall animation starts after the apex
				else if(velocity.y >= 0) {
					if(itemInUse is HorseHead) {
						play("horse fall");
					} else {
						play("fall");
					}
				} else {
					if(itemInUse is HorseHead) {
						play("horse jump");
					} else if(usedMidairJump) {
						play("midair jump");
					} else {
						play("jump");
					}
				}
			}
		}
		
		public override function postUpdate():void {
			super.postUpdate();
			
			umbrellaSprite.visible = itemInUse is Umbrella;
			umbrellaSprite.x = x + umbrellaOffset.x;
			umbrellaSprite.y = y + umbrellaOffset.y;
		}
		
		public function setInvincibleFor(time:Number):void {
			if(time > invincibleTimeLeft) {
				invincibleTimeLeft = time;
			}
		}
		
		public override function destroy():void {
			Save.storeInt(CoinCounter.COINS, coins);
			super.destroy();
		}
		
		public function getScore():Number {
			return score + x * DISTANCE_MULTIPLIER;
		}
		
		public function getCoins():int {
			return coins;
		}
		
		public function setCoins(c:int):void {
			coins = c;
		}
		
		public function affectedByRain():Boolean {
			return gameState.isRainingOnChild() && !(itemInUse is Umbrella);
		}
		
		public function jumpReplenishPercent():Number {
			return jumpReplenish;
		}
		
		public static function jumpJustPressed():Boolean {
			return FlxG.keys.justPressed("Z") || FlxG.keys.justPressed("A") || FlxG.keys.justPressed("UP") || FlxG.keys.justPressed("SPACE");
		}
		public static function jumpHeld():Boolean {
			return FlxG.keys.Z || FlxG.keys.A || FlxG.keys.UP || FlxG.keys.SPACE;
		}
		
		public static function useItemJustPressed():Boolean {
			return FlxG.keys.justPressed("S") || FlxG.keys.justPressed("X") || FlxG.keys.justPressed("SHIFT");
		}
		
		public static function attackJustPressed():Boolean {
			return FlxG.keys.justPressed("D") || FlxG.keys.justPressed("C");
		}
	}
}
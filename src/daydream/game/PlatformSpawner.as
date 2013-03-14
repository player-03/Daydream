package daydream.game {
	import daydream.Main;
	import daydream.utils.NumberInterval;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	
	public class PlatformSpawner extends FlxBasic {
		/**
		 * The player can fall farther than they can jump, so while a new
		 * platform isn't allowed to be much higher than the one before,
		 * it can be significantly lower.
		 */
		private static const EXTRA_FALL_DIST:Number = 2;
		
		/**
		 * The percentage of jumpHeightInterval at which it starts
		 * producing positive values.
		 */
		private static const GOING_UP_CUTOFF:Number = 1 / (1 + EXTRA_FALL_DIST);
		
		/**
		 * The percentage of all jumps that should involve going upwards.
		 * Greater than 0.5 to counterbalance the length of jumps going
		 * downwards.
		 */
		private static const PERCENT_CHANCE_TO_GO_UP:Number = 0.6;
		
		private static var jumpHeightInterval:NumberInterval = new NumberInterval(-Child.JUMP_HEIGHT, Child.JUMP_HEIGHT * EXTRA_FALL_DIST);
		
		private static function getRandJumpPercentage():Number {
			if(Math.random() < PERCENT_CHANCE_TO_GO_UP) {
				return Math.random() * GOING_UP_CUTOFF;
			} else {
				return GOING_UP_CUTOFF + Math.random() * (1 - GOING_UP_CUTOFF);
			}
		}
		
		private var gameState:GameState;
		
		private var yInterval:NumberInterval;
		private var platformWidthInterval:NumberInterval;
		private var distanceBetweenPlatformsInterval:NumberInterval;
		
		private var lastPlatformX:Number;
		private var lastPlatformY:Number;
		private var lastPlatformWidth:Number;
		
		private var itemTypes:Vector.<Class>;
		private var itemFrequencies:Vector.<Number>;
		private var spawnUmbrellaNext:Boolean;
		
		//This handles spawning umbrella;
		private static const CHANCE_FOR_UMB:Number = 0.3;
		private var umbrellaSpawned:Boolean;
		
		public function PlatformSpawner(gameState:GameState,
									firstPlatformX:Number,
									yInterval:NumberInterval,
									platformWidthInterval:NumberInterval,
									distanceBetweenPlatformsInterval:NumberInterval,
									itemTypes:Array = null, itemFrequencies:Array = null) {
			super();
			
			this.gameState = gameState;
			
			this.yInterval = yInterval;
			this.platformWidthInterval = platformWidthInterval;
			this.distanceBetweenPlatformsInterval = distanceBetweenPlatformsInterval;
			
			lastPlatformX = firstPlatformX;
			lastPlatformY = (yInterval.min + yInterval.max) / 2;
			lastPlatformWidth = platformWidthInterval.min;
			
			if(itemTypes != null) {
				this.itemTypes = Vector.<Class>(itemTypes);
			} else {
				this.itemTypes = new Vector.<Class>();
			}
			if(itemFrequencies != null) {
				this.itemFrequencies = Vector.<Number>(itemFrequencies);
			} else
			this.itemFrequencies = new Vector.<Number>();
			spawnUmbrellaNext = false;
		}
		
		public override function update():void {
			/*The logic seems ok to me on this, but take a second look at it if you get a chance.
			 *	It should work by checking that the rain cooldown is in effect
			 * 	and then checking to see if an umbrella has been spawned recently.
			 * 	If it hasn't, it should spawn one. The check is reset when rain occurs.
			 */
			if (gameState.rainCooldown >= 0)
			{
				if (Math.random() <= CHANCE_FOR_UMB && umbrellaSpawned = false)
				{
					spawnUmbrellaNext = true;
					umbrellaSpawned = true;
				}
				else
					spawnUmbrellaNext = false;
			}
			else if (gameState.rainDurationTimer >= 0)
			{
				umbrellaSpawned = false;
			}
				
			
			if(FlxG.camera.scroll.x + Main.STAGE_WIDTH >=
					lastPlatformX + lastPlatformWidth + distanceBetweenPlatformsInterval.min) {
				spawnPlatform();
			}
		}
		
		private function spawnPlatform():void {
			var percentOfJump:Number;
			do {
				percentOfJump = getRandJumpPercentage();
			} while(!yInterval.contains(lastPlatformY
					+ jumpHeightInterval.getPercentageOfRange(percentOfJump)));
			lastPlatformY += jumpHeightInterval.getPercentageOfRange(percentOfJump);
			
			lastPlatformX = lastPlatformX + lastPlatformWidth
					+ distanceBetweenPlatformsInterval.getPercentageOfRange(percentOfJump);
			
			lastPlatformWidth = platformWidthInterval.randomValue();
			
			gameState.addPlatform(new Platform(lastPlatformX, lastPlatformY, lastPlatformWidth));
			
			//now see if an item should be spawned as well
			if(spawnUmbrellaNext) {
				spawnUmbrellaNext = false;
				gameState.addItem(new Umbrella(lastPlatformX + lastPlatformWidth - 60, lastPlatformY - 60));
			} else {
				var itemRandValue:Number = Math.random();
				for(var i:int = 0; i < itemFrequencies.length; i++) {
					//for a frequency array containing [0.2, 0.3],
					//the first item should be spawned if itemRandValue < 0.2,
					//and the second should be if 0.2 <= itemRandValue < 0.5
					if(itemRandValue < itemFrequencies[i]) {
						var itemType:Class = itemTypes[i];
						gameState.addItem(new itemType(lastPlatformX + lastPlatformWidth - 60, lastPlatformY - 60) as FlxBasic);
					} else {
						itemRandValue -= itemFrequencies[i];
					}
				}
			}
		}
		
		/**
		 * @param	chance The absolute chance of spawning the item. This
		 * is not independant from the other values; in fact, two 50%
		 * chance items result in one item being on every platform.
		 */
		public function addItemToSpawn(itemType:Class, chance:Number):void {
			itemTypes.push(itemType);
			itemFrequencies.push(chance);
		}
	}
}
package daydream.game {
	import daydream.Main;
	import daydream.utils.NumberInterval;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import daydream.utils.Save;
	import daydream.upgrades.UpgradesState;
	
	public class PlatformSpawner extends FlxBasic {
		/**
		 * The player can fall farther than they can jump, so while a new
		 * platform isn't allowed to be much higher than the one before,
		 * it can be significantly lower.
		 */
		private static const EXTRA_FALL_DIST:Number = 2.5;
		
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
		
		/**
		 * 
		 */
		private var recentlySpawnedPlatforms:Vector.<PlatformDefinition>;
		
		private var nextPlatformX:Number;
		
		private var itemTypes:Vector.<Class>;
		private var itemFrequencies:Vector.<Number>;
		
		private var enemyFrequency:Number;
		
		private var spawnUmbrellaNext:Boolean;
		private static const CHANCE_FOR_UMBRELLA:Number = 0.8;
		private var wasRaining:Boolean;
		
		private var child:Child;
		private var childSpeedMultiplier:Number;
		
		public function PlatformSpawner(gameState:GameState,
									seriesCount:int,
									firstPlatformX:Number,
									yInterval:NumberInterval,
									platformWidthInterval:NumberInterval,
									distanceBetweenPlatformsInterval:NumberInterval,
									child:Child, enemyFrequency:Number,
									itemTypes:Array = null, itemFrequencies:Array = null,
									childSpeedMultiplier:Number = 0.001) {
			super();
			
			this.gameState = gameState;
			
			this.yInterval = yInterval;
			this.platformWidthInterval = platformWidthInterval;
			this.distanceBetweenPlatformsInterval = distanceBetweenPlatformsInterval;
			
			this.child = child;
			this.childSpeedMultiplier = childSpeedMultiplier;
			this.enemyFrequency = enemyFrequency;
			
			recentlySpawnedPlatforms = new Vector.<PlatformDefinition>(seriesCount);
			
			for(var i:int = 0; i < seriesCount; i++) {
				//the first platform series starts in the middle; the
				//others start at random points
				recentlySpawnedPlatforms[i] = new PlatformDefinition(
							firstPlatformX,
							i == 0 ? (yInterval.min + yInterval.max) / 2
									: yInterval.randomValue(),
							platformWidthInterval.min);
			}
			
			if(itemTypes != null) {
				this.itemTypes = Vector.<Class>(itemTypes);
			} else {
				this.itemTypes = new Vector.<Class>();
			}
			if(itemFrequencies != null) {
				this.itemFrequencies = Vector.<Number>(itemFrequencies);
			} else {
				this.itemFrequencies = new Vector.<Number>();
			}
			spawnUmbrellaNext = false;
		}
		
		public override function update():void {
			if (gameState.isRaining())
			{
				if (!wasRaining && Math.random() < CHANCE_FOR_UMBRELLA)
				{
					spawnUmbrellaNext = true;
				}
				wasRaining = true;
			}
			else
			{
				wasRaining = false;
			}
			
			for each(var def:PlatformDefinition in recentlySpawnedPlatforms) {
				if(FlxG.camera.scroll.x + Main.STAGE_WIDTH >=
						def.x + def.width
						+ distanceBetweenPlatformsInterval.min
						* xMultiplier()) {
					spawnPlatform(def);
				}
			}
		}
		
		private function spawnPlatform(def:PlatformDefinition):void {
			var percentOfJump:Number;
			do {
				percentOfJump = getRandJumpPercentage();
			} while(!yInterval.contains(def.y
					+ jumpHeightInterval.getPercentageOfRange(percentOfJump)));
			
			def.x += def.width
						+ distanceBetweenPlatformsInterval.getPercentageOfRange(percentOfJump)
						* xMultiplier();
			def.y += jumpHeightInterval.getPercentageOfRange(percentOfJump);
			
			def.width = platformWidthInterval.randomValue() * xMultiplier();
			
			//don't spawn anything if the platform would be too close to another
			for each(var other:Platform in gameState.getPlatforms()) {
				if(other != null && other.exists) {
					//they're too close if they're within 100 pixels
					//horizontally and 200 vertically
					if(def.x < other.x + other.width + 100
						&& other.x < def.x + def.width + 100
						&& Math.abs(other.y - def.y) < 200) {
						return;
					}
				}
			}
			
			var platform:Platform = new Platform(def.x, def.y, def.width);
			gameState.addPlatform(platform);
			
			//now see if an item should be spawned as well
			var itemX:Number = def.x + 5 + Math.random() * def.width * 1.8;
			var itemY:Number = def.y + 5 - Math.random() * 120;
			var item:FlxObject;
			if(spawnUmbrellaNext) {
				spawnUmbrellaNext = false;
				item = new Umbrella(itemX, itemY);
			} else {
				var itemRandValue:Number = Math.random();
				for(var i:int = 0; i < itemFrequencies.length; i++) {
					//for a frequency array containing [0.2, 0.3],
					//the first item should be spawned if itemRandValue < 0.2,
					//and the second should be if 0.2 <= itemRandValue < 0.5
					if(itemRandValue < (itemFrequencies[i] + 0.005 * Save.getInt(UpgradesState.ITEM_FREQUENCY))) {
						var itemType:Class = itemTypes[i];
						item = new itemType(itemX, itemY) as FlxObject;
						break;
					} else {
						itemRandValue -= itemFrequencies[i];
					}
				}
			}
			
			if(item != null) {
				if(item.y + item.height >= platform.y) {
					item.y += platform.height + item.height;
				}
				gameState.addItem(item);
			}
			
			//also spawn a standing enemy if appropriate
			if(Math.random() < enemyFrequency) {
				gameState.addEnemy(new Enemy(
							def.x + 3 + Math.random() * (def.width - 63),
							def.y - 97));
			}
		}
		
		private function xMultiplier():Number {
			if(child.baseXVelocity < Child.SPRINT_SPEED_CUTOFF) {
				return 1;
			}
			return 1 + (child.baseXVelocity - Child.SPRINT_SPEED_CUTOFF) * childSpeedMultiplier;
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

class PlatformDefinition {
	public var x:Number;
	public var y:Number;
	public var width:Number;
	
	public function PlatformDefinition(x:Number, y:Number, width:Number) {
		this.x = x;
		this.y = y;
		this.width = width;
	}
}
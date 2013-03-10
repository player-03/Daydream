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
		
		private var minDistBetweenPlatforms:Number;
		private var maxDistBetweenPlatforms:Number;
		
		public function PlatformSpawner(gameState:GameState,
									firstPlatformX:Number,
									yInterval:NumberInterval,
									platformWidthInterval:NumberInterval,
									distanceBetweenPlatformsInterval:NumberInterval) {
			super();
			
			this.gameState = gameState;
			
			this.yInterval = yInterval;
			this.platformWidthInterval = platformWidthInterval;
			this.distanceBetweenPlatformsInterval = distanceBetweenPlatformsInterval;
			
			lastPlatformX = firstPlatformX;
			lastPlatformY = (yInterval.min + yInterval.max) / 2;
			lastPlatformWidth = platformWidthInterval.min;
		}
		
		public override function update():void {
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
		}
	}
}
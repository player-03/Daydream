package daydream.utils {
	import org.flixel.FlxSound;
	
	public class BetterSound extends FlxSound {
		public function BetterSound() {
			super();
		}
		
		public override function play(forceRestart:Boolean = false):void {
			if(_channel == null || forceRestart) {
				super.play(forceRestart);
			}
		}
		
		/**
		 * Seriously, Flixel, would it have been that hard to include this function?
		 */
		public function isPlaying():Boolean {
			return _channel != null;
		}
		
		public function isFadingIn():Boolean {
			return _fadeInTimer > 0;
		}
		
		public function isFadingOut():Boolean {
			return _fadeOutTimer > 0;
		}
	}
}
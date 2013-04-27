package daydream{
	import daydream.menu.IntroState;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.flixel.FlxG;
	import org.flixel.FlxGame;

	[Frame(factoryClass="daydream.Preloader")]
	public class Main extends FlxGame {
		[Embed(source = "../../lib/SFX_BUTTON.mp3")] public static var buttonSound:Class;
		
		public static const STAGE_WIDTH:int = 1600;
		public static const STAGE_HEIGHT:int = 600;
		
		private static var instance:Main;
		public static function getInstance():Main {
			return instance;
		}
		
		public function Main():void {
			super(STAGE_WIDTH, STAGE_HEIGHT, IntroState, 1, 30, 30, true);
			instance = this;
			_focus.addEventListener(MouseEvent.CLICK, onPauseScreenClicked);
		}
		
		private function onPauseScreenClicked(e:Event = null):void {
			FlxG.paused = false;
			_focus.visible = false;
		}
		
		public function updatePauseScreen():void {
			_focus.visible = FlxG.paused;
		}
		
		protected override function onFocus(e:Event = null):void {
			super.onFocus(e);
			_focus.visible = FlxG.paused;
		}
	}
}
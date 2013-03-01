package daydream{
	import flash.display.Sprite;
	import flash.events.Event;
	import org.flixel.FlxGame;

	[Frame(factoryClass="daydream.Preloader")]
	public class Main extends FlxGame {
		public static const STAGE_WIDTH:int = 800;
		public static const STAGE_HEIGHT:int = 600;
		
		public function Main():void {
			super(STAGE_WIDTH, STAGE_HEIGHT, MenuState, 1, 30, 30, true);
		}
	}
}
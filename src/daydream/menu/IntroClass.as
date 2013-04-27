package daydream.menu 
{
	import daydream.Main;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import daydream.game.Child;
	
	public class IntroClass extends FlxSprite
	{
		[Embed(source = "../../../lib/frame1.png")] private static var frame1:Class;
		[Embed(source = "../../../lib/frame2.png")] private static var frame2:Class;
		[Embed(source = "../../../lib/frame3.png")] private static var frame3:Class;
		[Embed(source = "../../../lib/frame4.png")] private static var frame4:Class;
		[Embed(source = "../../../lib/frame5.png")] private static var frame5:Class;
		[Embed(source = "../../../lib/frame6.png")] private static var frame6:Class;
		
		public var frameCount:int;
		
		public function IntroClass() 
		{
			super();
			
			loadGraphic(frame1);
			
			x = Main.STAGE_WIDTH / 2 - width / 2;
			
			frameCount = 1;
			
			FlxG.stage.addEventListener(MouseEvent.CLICK, advanceFrame, false, 0, true);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, advanceFrame, false, 0, true);
		}
		
		public function advanceFrame(e:Event = null):void {
			if(e is KeyboardEvent && (e as KeyboardEvent).keyCode == Keyboard.ESCAPE) {
				FlxG.switchState(new MenuState());
			} else {
				frameCount += 1;
				showFrame();
			}
		}
		
		public function showFrame():void
		{
			if (frameCount == 2)
				loadGraphic(frame2);
			
			if (frameCount == 3)
				loadGraphic(frame3);
			
			if (frameCount == 4)
				loadGraphic(frame4);
				
			if (frameCount == 5)
				loadGraphic(frame5);
				
			if (frameCount == 6)
				loadGraphic(frame6);
				
			if (frameCount >6 )
				FlxG.switchState(new MenuState());
		}
		
	}

}
package daydream.menu 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import daydream.game.Child;
	
	public class IntroClass extends FlxSprite
	{
		[Embed(source = "../../../lib/frame1-01.png")] private static var frame1:Class;
		[Embed(source = "../../../lib/frame2-01.png")] private static var frame2:Class;
		[Embed(source = "../../../lib/frame3-01.png")] private static var frame3:Class;
		[Embed(source = "../../../lib/frame4-01.png")] private static var frame4:Class;
		[Embed(source = "../../../lib/frame5-01.png")] private static var frame5:Class;
		[Embed(source = "../../../lib/frame6_new-01.png")] private static var frame6:Class;
		
		public var frameCount:int;
		
		public function IntroClass() 
		{
			super();
			
			loadGraphic(frame1);
			
			frameCount = 1;
		}
		
		public override function update():void
		{
			if (Child.jumpJustPressed())
			{
				frameCount += 1;
				showFrame();
			}
			
			if (FlxG.keys.justPressed("ESCAPE"))
			{
				FlxG.switchState(new MenuState());
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
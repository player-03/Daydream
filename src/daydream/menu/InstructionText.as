//Only if we need it. We could probably just make a picture for the instruction screen then all we need to code in is a button
package daydream.menu 
{
	import daydream.Main;
	import org.flixel.FlxText;
	
	public class InstructionText extends FlxText
	{
		
		public function InstructionText() 
		{
			super(Main.STAGE_WIDTH / 2, Main.STAGE_HEIGHT / 2 + 50, 500);
			text = "Get as far as you can before falling!\n" +
							"Up/Space/A : Jump\n" +
							"Shift/S : Use Item\n";
							//+ "D : Attack\n";
			alignment = "center";
			color = 0x00000000;
			size = 15;
			
			x -= width / 2;
		}
		
	}

}
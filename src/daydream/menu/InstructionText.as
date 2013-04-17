//Only if we need it. We could probably just make a picture for the instruction screen then all we need to code in is a button
package daydream.menu 
{
	import org.flixel.FlxText;
	
	public class InstructionText extends FlxText
	{
		
		public function InstructionText() 
		{
			super(0, 0, 500);
			this.text = "Instructions page.\n" +
							"Get as far as you can before falling!\n\n" +
							"Keys\n" +
							"Up/Space : Jump\n" +
							"S : Use Item\n" +
							"D : Attack\n" +
							"M : Mute\n";
			this.color = 0x00000000;
			this.size = 15;
		}
		
	}

}
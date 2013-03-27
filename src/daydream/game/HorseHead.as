package daydream.game 
{
	import org.flixel.FlxSprite;
	
	public class HorseHead extends FlxSprite
	{
		[Embed(source = "../../../lib/HorseHead.png")] protected var horse_head_img:Class;

		public function HorseHead(x:Number, y:Number) 
		{
			super(x, y);
			
			loadGraphic(horse_head_img);
		}
	}
}
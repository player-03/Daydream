/*This and the straw class are just here in case we 
 * 	need the separate classes. They just load the sprites
 * 	for now.
 */

package daydream.game 
{
	import org.flixel.FlxSprite;
	
	public class Horse_Head extends FlxSprite
	{
		[Embed(source = "../../../lib/horse_head.png")] protected var horse_head_img:Class;

		public function Horse_Head(x:Number, y:Number) 
		{
			super(x, y);
			
			loadGraphic(horse_head_img, false, false, 40, 40);
			
			
		}
		
	}

}
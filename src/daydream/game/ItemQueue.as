/*This class puts the current item at the top left of the screen.
 */

package daydream.game 
{
	import org.flixel.*;
	import daydream.Main;

	public class ItemQueue extends FlxSprite
	{
		private var item:FlxObject;
		private var the_child:Child;
		private var img:FlxSprite;
		
		/*I'm not sure if we need to load the images like this again.
		 *	It would probably be best if we didn't have to, but this is the way I know how.
		 *	If you want, I can look into the "Loader" class. It seems as though that's used to
		 * 	load everything all at once and keep it in a place we can reference (I could be
		 * 	and in all likelihood am wrong).
		*/
		[Embed(source = "../../../lib/straw.png")] protected var strawImg:Class;
		[Embed(source="../../../lib/horse_head.png")] protected var horseImg:Class;
		[Embed(source = "../../../lib/umbrella.png")] protected var umbImg:Class;
		[Embed(source = "../../../lib/Child.png")] protected var emptyImg:Class;
		
		public function ItemQueue(child:Child, x:Number, y:Number) 
		{
			super(x, y);
			
			//set scrollFactor to 0 so it stays at the top left of the screen
			this.scrollFactor.x = 0;
			this.scrollFactor.y = 0;
			
			//receives the child instantiated in gamestate
			the_child = child;
		}
		
		public override function update():void
		{
			//this updates the image accordingly
			if (the_child.currentItem is Horse_Head)
			{
				img = loadGraphic(horseImg, false, false, 40, 40);
			}
			else if (the_child.currentItem is Straw)
			{
				img = loadGraphic(strawImg, false, false, 40, 40);
			}
			else if (the_child.currentItem is Umbrella)
			{
				img = loadGraphic(umbImg, false, false, 40, 40);
			}
			else
				img = loadGraphic(emptyImg, false, false, 40, 40);
			
		}
		
	}

}
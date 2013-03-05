/*This class will handle our tile makeups.
 * 
 * 	We can create tiles of whatever width we want.
 * 		(which seems to be necessary to check OOB and if the tile
 * 			is completely onscreen)
 * 
 * 	We just need to keep track of sizes when
 * 		adding things to each tile.
 * 
 * This will create tiles just offscreen.
 */

package daydream.game 
{
	import org.flixel.*;
	
	public class Tile extends FlxSprite
	{
		private var platforms:FlxGroup;
		
		public function Tile(type:String, width:Number) 
		{
			
			platforms = new FlxGroup();
			this.width = width;
			
			//Just to have a constant start platform so we don't have to
			//	worry about how the player is generated each time
			if (type == "Start")
			{
				platforms.add(new Platform(30, 400, 300));
			}
			
			/*For now these are more or less arbitrary.
			 *	This is where the information for each
			 *	tile type will be stored.
			 */
			if (type == "TypeA")
			{
				platforms.add(new Platform(FlxG.width, 400, 300));
				
			}
			
			if (type == "TypeB")
			{
				platforms.add(new Platform(FlxG.width, 600, 110));
			}
			
		}
		
		
		
	}

}
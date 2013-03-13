package daydream.game 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	public class Enemy extends FlxSprite
	{
		private var enemy_type:int;
		private var img:FlxSprite;
		
		[Embed(source = "../../../lib/enemy.png")] protected var enemyImg:Class;
		
		/*type denotes an integer value that determines the type of enemy
		 *		: 0 is a stationary enemy
		 * 		: 1 is a flying enemy
		 */
		
		public function Enemy(x:Number, y:Number, type:int) 
		{
			if (type == 1)
				x = FlxG.worldBounds.right;
			
			super(x, y);
			
			enemy_type = type;
		}
		
		public override function update():void
		{
			if (enemy_type == 0)
			{
				img = loadGraphic(enemyImg, false, false, 40, 80);
			}
			if (enemy_type == 1)
			{
				img = loadGraphic(enemyImg, false, false, 40, 40);
				
				this.x -= 5;
			}
		}
		
	}

}
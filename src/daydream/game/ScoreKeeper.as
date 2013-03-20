package daydream.game 
{
	import org.flixel.FlxText;
	
	public class ScoreKeeper extends FlxText
	{
		private var the_child:Child;
		private var points:int;
		
		public function ScoreKeeper(child:Child, x:Number, y:Number) 
		{
			super(x, y, 300, points.toString());
			
			this.scrollFactor.x = 0;
			this.scrollFactor.y = 0;
			
			this.color = 0x00000000;
			
			the_child = child;
		}
		
		public override function update():void
		{
			points = the_child.x - 50;
			
			this.text = "Score: " + points.toString();
			
			//trace("POINTS: " + points + "\n");
		}
		
	}

}
package daydream.game 
{
	import org.flixel.FlxText;
	
	public class ScoreKeeper extends FlxText
	{
		private var child:Child;
		private static var highscore:int;
		
		public function ScoreKeeper(child:Child, x:Number, y:Number) 
		{
			super(x, y, 300);
			
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			
			color = 0x00000000;
			
			this.child = child;
		}
		
		public override function update():void
		{
			if(child.score > highscore) {
				highscore = child.score;
			}
			text = "Score: " + child.score + "\nBest: " + highscore;
		}
		
	}

}
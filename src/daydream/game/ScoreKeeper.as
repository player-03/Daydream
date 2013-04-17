package daydream.game 
{
	import daydream.utils.Save;
	import org.flixel.FlxText;
	
	public class ScoreKeeper extends FlxText
	{
		/**
		 * Name of the high score variable in the save data.
		 */
		public static const HIGHSCORE:String = "highscore";
		
		private var child:Child;
		private var highscore:int;
		
		public function ScoreKeeper(child:Child, x:Number, y:Number) 
		{
			super(x, y, 300);
			
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			
			color = 0x00000000;
			
			this.child = child;
			this.size = 11;
			
			highscore = Save.getInt(HIGHSCORE);
		}
		
		public override function destroy():void {
			Save.storeInt(HIGHSCORE, highscore);
			
			super.destroy();
		}
		
		public override function update():void
		{
			var score:int = int(child.getScore());
			
			if(score > highscore) {
				highscore = score;
			}
			
			text = "Score: " + score + "\nBest: " + highscore;
		}
		
	}

}
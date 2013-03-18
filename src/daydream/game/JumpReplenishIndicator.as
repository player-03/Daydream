package daydream.game {
	import org.flixel.FlxSprite;
	
	public class JumpReplenishIndicator extends FlxSprite {
		[Embed(source = "../../../lib/Jump.png")] private static var jumpImage:Class;
		
		private var child:Child;
		
		public function JumpReplenishIndicator(child:Child, x:Number = 10, y:Number = 10, width:int = 100, height:int = 10) {
			super(x, y, jumpImage);
			
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			
			this.child = child;
		}
		
		public override function update():void {
			alpha = child.jumpReplenishPercent();
			if(alpha > 0 && alpha < 1) {
				alpha = alpha * alpha * 0.8;
			}
		}
	}
}
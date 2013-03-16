package daydream.game 
{
	import org.flixel.*;
	import daydream.Main;

	public class ItemQueue extends FlxSprite
	{
		private var item:FlxObject;
		private var the_child:Child;
		
		[Embed(source = "../../../lib/straw.png")] protected var strawImg:Class;
		[Embed(source="../../../lib/horse_head.png")] protected var horseImg:Class;
		[Embed(source = "../../../lib/umbrella.png")] protected var umbImg:Class;
		[Embed(source = "../../../lib/pogo_stick.png")] protected var pogoImg:Class;
		
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
			//this is not as inefficient as it seems, because Flixel
			//caches the BitmapData objects
			if (the_child.currentItem is Horse_Head)
			{
				loadGraphic(horseImg, false, false, 40, 40);
			}
			else if (the_child.currentItem is Straw)
			{
				loadGraphic(strawImg, false, false, 40, 40);
			}
			else if (the_child.currentItem is Umbrella)
			{
				loadGraphic(umbImg, false, false, 40, 40);
			}
			else if (the_child.currentItem is PogoStick)
			{
				loadGraphic(pogoImg, false, false, 40, 40);
			}
			
			visible = the_child.currentItem != null;
		}
	}
}
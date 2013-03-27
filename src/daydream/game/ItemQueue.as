package daydream.game 
{
	import org.flixel.*;
	import daydream.Main;

	public class ItemQueue extends FlxSprite
	{
		private var item:FlxObject;
		private var the_child:Child;
		
		[Embed(source = "../../../lib/Straw.png")] protected var strawImg:Class;
		[Embed(source="../../../lib/HorseHead.png")] protected var horseImg:Class;
		[Embed(source = "../../../lib/UprightUmbrella.png")] protected var umbrellaImg:Class;
		[Embed(source = "../../../lib/Spring.png")] protected var pogoImg:Class;
		
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
			if (the_child.currentItem is HorseHead)
			{
				loadGraphic(horseImg);
			}
			else if (the_child.currentItem is Straw)
			{
				loadGraphic(strawImg);
			}
			else if (the_child.currentItem is Umbrella)
			{
				loadGraphic(umbrellaImg);
			}
			else if (the_child.currentItem is PogoStick)
			{
				loadGraphic(pogoImg);
			}
			
			visible = the_child.currentItem != null;
		}
	}
}
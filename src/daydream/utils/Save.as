package daydream.utils {
	import flash.net.SharedObject;
	
	/**
	 * Handles saving and loading. Call one of the "store" methods to save
	 * a value, and call one of the "get" methods to load it. Call the
	 * "flush" method to actually write the data to the disc (Flash will
	 * attempt to flush automatically, but don't count on it).
	 */
	public class Save {
		private static var saveFile:SharedObject = SharedObject.getLocal("Daydream");
		
		public static function storeInt(name:String, value:int):void {
			saveFile.data[name] = value;
		}
		public static function storeNumber(name:String, value:Number):void {
			saveFile.data[name] = value;
		}
		public static function storeString(name:String, value:String):void {
			saveFile.data[name] = value;
		}
		
		public static function getInt(name:String, defaultValue:int = 0):int {
			if(saveFile.data[name] is int) {
				return saveFile.data[name];
			}
			
			return defaultValue;
		}
		public static function getNumber(name:String, defaultValue:Number = 0):Number {
			if(saveFile.data[name] is Number) {
				return saveFile.data[name];
			}
			
			return defaultValue;
		}
		public static function getString(name:String, defaultValue:String = null):String {
			if(saveFile.data[name] is String) {
				return saveFile.data[name];
			}
			
			return defaultValue;
		}
		
		public static function flush():void {
			saveFile.flush();
		}
	}
}
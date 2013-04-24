package daydream.utils {
	public class NumberInterval {
		private var mMin:Number;
		private var mMax:Number;
		
		public function NumberInterval(min:Number, max:Number) {
			mMin = min;
			mMax = max;
			if(mMax < mMin) {
				var temp:Number = mMin;
				mMin = mMax;
				mMax = temp;
			}
		}
		
		public function get min():Number {
			return mMin;
		}
		public function get max():Number {
			return mMax;
		}
		
		public function randomValue():Number {
			return mMin + Math.random() * (mMax - mMin);
		}
		
		public function getPercentageOfRange(p:Number):Number {
			return interpolate(mMin, mMax, p);
		}
		
		public function contains(value:Number):Boolean {
			return value >= mMin && value <= mMax;
		}
		
		public function clamp(value:Number):Number {
			if(value < mMin) {
				return mMin;
			} else if(value > mMax) {
				return mMax;
			} else {
				return value;
			}
		}
		
		public static function interpolate(start:Number, end:Number, percent:Number):Number {
			return start + percent * (end - start);
		}
	}
}
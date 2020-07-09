/* @last_update: 06/29/2015 (mm/dd/yyyy) */
 
class agung.utils.UObj {
	private function UObj() { trace("Kelas statik. Tidak dapat diInstantiasikan.") }
	
	/* Returns a copy of the given object. */
	public static function copy(obj:Object):Object {
		var newObj:Object = new Object();
		for (var prop in obj) {
			newObj[prop] = obj[prop];
		}
		return newObj;
	}
	/* Return value or, if undefined, alternate value. */
	public static function valueOrAlt(val, altVal) {
		if (val != undefined) return val;
		return altVal;
	}
}
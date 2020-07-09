/* @last_update: 06/29/2015 (mm/dd/yyyy) */

class agung.utils.UBool {
	private function UBool() { trace("Kelas statik. Tidak dapat diInstantiasikan.") }
	
	/* Returns the Boolean corespondent of the given string. */
	public static function parse(str:String):Boolean {
		return str.toLowerCase() == "true";
	}
}
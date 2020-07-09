/* @last_update: 06/29/2015 (mm/dd/yyyy) */

 class agung.utils.UCookie {
	private function UCookie() { trace("Kelas statik. Tidak dapat diInstantiasikan.") }
	
	/* Set cookie (expiresAfter in ms). */
	public static function setCookie(cookieName:String, cookieValue, expiresAfter:Number) {
		var d:Date 				= new Date();
		var so:SharedObject 	= SharedObject.getLocal(escape(cookieName));		
		so.data["cookieValue"] 	= cookieValue;
		so.data["expiresAfter"] = isNaN(expiresAfter) ? "never" : String(d.getTime() + expiresAfter);		
		return so.flush();
	}
	/* Get cookie. */
	public static function getCookie(cookieName:String):Object {		
		var so:SharedObject 	= SharedObject.getLocal(escape(cookieName));		
		var ct:Number 			= Number(so.data["expiresAfter"]);
		var cookieValue:Object	= so.data["cookieValue"];
		
		var d:Date 				= new Date();
		var t:Number 			= d.getTime();
		
		if ((ct >= t || isNaN(ct)) && cookieValue != null) {
			return cookieValue;
		}else {
			deleteCookie(cookieName);
			return null;
		}		
	}
	/* Delete cookie. */
	public static function deleteCookie(cookieName:String):Void {
		var so:SharedObject = SharedObject.getLocal(escape(cookieName));
		so.clear();
	}
}
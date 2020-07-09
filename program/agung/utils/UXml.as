/* @last_update: 06/29/2015 (mm/dd/yyyy) */

import agung.utils.UFunc;
import agung.utils.UStr;
import agung.utils.UObj;

class agung.utils.UXml {
	private function UXml() { trace("Kelas statik. Tidak dapat diInstantiasikan.") }
	
	private static var XML_CACHE:Object;
	
	/* Create new XML object. */
	public static function loadXml(xmlFile:String, loadHandler:Function, handlerScope:Object, cacheBuster:Boolean, forceReload:Boolean):XML {
		if (XML_CACHE == undefined) XML_CACHE = new Object();
		
		if (XML_CACHE[xmlFile].loaded && !UObj.valueOrAlt(forceReload, false)) {			
			UFunc.timedCall(handlerScope, loadHandler, 0, true);
			return XML_CACHE[xmlFile];
		}
		
		var xml:XML			= new XML();
		XML_CACHE[xmlFile] 	= xml;
		xml.ignoreWhite 	= true;
		xml.onLoad 			= UFunc.delegate(handlerScope, loadHandler);
		
		if (cacheBuster && String(_level0._url).indexOf("http") == 0) xmlFile += "?xml_cache_buster=" + UStr.uniqueStr();		
		xml.load(xmlFile);	
		
		return xml;
	}
	
	/* Get xml status string. */
	public static function statusMsg(status:Number):String {
		var errorMessage:String = "Terjadi kesalahan yang tidak di ketahui.";
		switch (status) {
			case  0 	: errorMessage = "Tidak ada kesalahan. Parse selesai dengan sukses."; 				break;
			case -2 	: errorMessage = "Bagian CDATA tidak diakhiri dengan benar."; 				break;
			case -3 	: errorMessage = "Deklarasi XML tidak diakhiri dengan benar."; 			break;
			case -4 	: errorMessage = "Deklarasi DOCTYPE tidak diakhiri dengan benar."; 		break;
			case -5 	: errorMessage = "Bagian 'comment' tidak diakhiri dengan benar."; 						break;
			case -6 	: errorMessage = "Elemen XML cacat."; 								break;
			case -7 	: errorMessage = "Melebihi batas memori."; 												break;
			case -8 	: errorMessage = "Atribut value tidak diakhiri dengan benar."; 			break;
			case -9 	: errorMessage = "Tag-pembuka tidak sama dengan tag-penutup."; 				break;
			case -10 	: errorMessage = "Tag-penutup tidak sesuai dengan tag-pembuka."; 	break;
		}
		return errorMessage;
	}
}
/**
* Ini adalah kelas utama untuk komponen about
* Di sini, Anda dapat mengubah xml file di dalam fungsi loadMyXml, hanya mengganti string about.xml dengan
* Nama xml yang diinginkan jika Anda ingin menggunakan komponen ini secara eksternal ke projek lain
	 * 
 */

import ascb.util.Proxy;
import caurina.transitions.*;
import mx.data.types.Obj;
import mx.data.types.Str;


import mx.events.EventDispatcher;
import asual.sa.SWFAddress;
import agung.utils.UXml;
import agung.utils.UNode;



class agung.tech01.about.aboutComponent extends MovieClip 
{
	private var xml:XML;	
	private var node:XMLNode;
	private var settingsObj:Object;
	
	private var holder:MovieClip;
		private var scrollerBox:MovieClip;
		private var mainDescription:MovieClip;
		private var productsDisplay:MovieClip;
		private var line:MovieClip;
		/**
	 * Ini adalah konstruktor dimana semua variabel direferensikan dan dijalankan
	 */
	public function aboutComponent() {
		this._visible = false;
	
		mainDescription = holder["mainDescription"];
		
		loadMyXml()
		
		trace(">>> Modul about dikompilasi . . .");
		trace(">>> Modul ini dapat digunakan tanpa file utama");
	}
	
	private function loadMyXml() { 
		if (_global.theXmlFile) {
			xml = _global.theXmlFile;
			xmlLoaded(true)
		}
		else {
			var xmlString:String = "about.xml";
			xml = UXml.loadXml(xmlString, xmlLoaded, this, true, true);
		}
	}

	private function xmlLoaded(s:Boolean) {
		if (!s) { trace("File XML tidak ditemukan !"); return; }	
		
		settingsObj = UNode.nodeToObj(xml.firstChild.firstChild);
		
		node = xml.firstChild;
		
		this.onEnterFrame = Proxy.create(this, enteredFrame);
	}

	private function enteredFrame() {
		delete this.onEnterFrame;
		
		
		mainDescription.setNode(node.firstChild.nextSibling, settingsObj)
		
		this._visible = true;
	}
}

	
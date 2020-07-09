import ascb.util.Proxy;
import caurina.transitions.*;
import mx.data.types.Obj;
import mx.data.types.Str;


import mx.events.EventDispatcher;
import asual.sa.SWFAddress;
import agung.utils.UXml;
import agung.utils.UNode;

/**
 * ini adalah kelas utama untuk modul baru
 */
class agung.tech01.berita.komponenBerita extends MovieClip
{
	private var xml:XML;	
	private var node:XMLNode;
	private var settingsObj:Object;
	
	private var holder:MovieClip;
		private var scrollerBox:MovieClip;
		private var popupHandler:MovieClip;
		
		
	public function komponenBerita() {
		this._visible = false;
		
		scrollerBox = holder["scrollerBox"];
		popupHandler = holder["popupHandler"];
		
		
		
		loadMyXml();
		
		trace(">>> Modul berita dikompilasi . . .");
		trace(">>> Modul ini tidak dapat digunakan tanpa file utama");
	}
	
	/**
	 * Di sini, xml standar dimuat, jika Anda ingin mengubah, hanya mengedit string berita.xml
	 */
	private function loadMyXml() { 
		if (_global.theXmlFile) {
			xml = _global.theXmlFile;
			xmlLoaded(true)
		}
		else {
			var xmlString:String = "berita.xml";
			xml = UXml.loadXml(xmlString, xmlLoaded, this, true, true);
		}
	}

	private function xmlLoaded(s:Boolean) {
		if (!s) { trace("XML gagal dimuat !"); return; }	
		
		settingsObj = UNode.nodeToObj(xml.firstChild.firstChild);
		
		node = xml.firstChild.firstChild.nextSibling;
		
		this.onEnterFrame = Proxy.create(this, enteredFrame);
		
	}
	
	private function enteredFrame() {
		delete this.onEnterFrame;
		
		
		popupHandler.setSettings(settingsObj);
		
		scrollerBox.addEventListener("closePopupFull", Proxy.create(this, closePopupFull));
		scrollerBox.addEventListener("itemClicked", Proxy.create(this, itemClicked));
		scrollerBox.setNode(node, settingsObj);
		
		
		
		this._visible = true;
	}
	
	private function itemClicked(obj:Object) {
		popupHandler.launchPopup(obj.mc);
	}
	
	private function closePopupFull(obj:Object) {
		popupHandler.closePopupFullNow();
	}
	
	public function treatAddress() {
		scrollerBox.treatAddress();
	}
}
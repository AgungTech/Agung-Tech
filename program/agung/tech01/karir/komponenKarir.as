
import ascb.util.Proxy;
import caurina.transitions.*;
import mx.data.types.Obj;
import mx.data.types.Str;


import mx.events.EventDispatcher;
import asual.sa.SWFAddress;
import agung.utils.UXml;
import agung.utils.UNode;

class agung.tech01.karir.komponenKarir extends MovieClip 
{
	private var xml:XML;	
	private var node:XMLNode;
	private var settingsObj:Object;
	
	private var holder:MovieClip;
		private var scrollerBox:MovieClip;
		private var popupHandler:MovieClip;
		
		
	public function komponenKarir() {
		this._visible = false;
		
		scrollerBox = holder["scrollerBox"];
		popupHandler = holder["popupHandler"];
		
		loadMyXml();
		
		
		trace(">>> Careers module compiled . . .");
		trace(">>> This module can't be used as stand-alone without the template, for more info please check the help files");
	}
	
	/**
	 * .xml
	 */
	private function loadMyXml() { 
		if (_global.theXmlFile) {
			xml = _global.theXmlFile;
			xmlLoaded(true)
		}
		else {
			var xmlString:String = "karir.xml";
			xml = UXml.loadXml(xmlString, xmlLoaded, this, true, true);
		}
		
	}
	
	private function xmlLoaded(s:Boolean) {
		if (!s) { trace("XML error !"); return; }	
		
		settingsObj = UNode.nodeToObj(xml.firstChild.firstChild);
		
		node = xml.firstChild.firstChild.nextSibling;
	
		
		this.onEnterFrame = Proxy.create(this, enteredFrame);
	}
	
	private function enteredFrame() {
		delete this.onEnterFrame;
		
		_global.popupCat = "description";
			
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
import ascb.util.Proxy;
import caurina.transitions.*;
import mx.data.types.Obj;
import mx.data.types.Str;


import mx.events.EventDispatcher;
import asual.sa.SWFAddress;
import agung.utils.UXml;
import agung.utils.UNode;

class agung.tech01.tentang_tempat.komponenLokasi extends MovieClip 
{
	private var xml:XML;	
	private var node:XMLNode;
	private var settingsObj:Object;
	
	private var holder:MovieClip;
		private var theTopMenu:MovieClip;
		private var scrollerBox:MovieClip;
		
	public function komponenLokasi() {
		this._visible = false;
		
		
		theTopMenu = holder["theTopMenu"];
		scrollerBox = holder["scrollerBox"];
		
		loadMyXml();
		
		trace(">>> Services module compiled . . .");
		trace(">>> This module can't be used as stand-alone without the template, for more info please check the help files");
	}
	
	private function loadMyXml() { 
		if (_global.theXmlFile) {
			xml = _global.theXmlFile;
			xmlLoaded(true)
		}
		else {
			var xmlString:String = "tentang_tempat.xml";
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
		
		scrollerBox.setSettings(settingsObj);
		
		theTopMenu.addEventListener("buttonClicked", Proxy.create(this, buttonClicked));
		theTopMenu.setNode(node, settingsObj);
		
		this._visible = true;
	}
	
	public function treatAddress() {
		theTopMenu.treatAddress();
	}
	
	private function buttonClicked(obj:Object) {
		scrollerBox.setDetails(obj.mc.node);
	}
}
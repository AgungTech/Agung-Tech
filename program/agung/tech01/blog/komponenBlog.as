import ascb.util.Proxy;
import caurina.transitions.*;
import mx.data.types.Obj;
import mx.data.types.Str;


import mx.events.EventDispatcher;
import asual.sa.SWFAddress;
import agung.utils.UXml;
import agung.utils.UNode;

class agung.tech01.blog.komponenBlog extends MovieClip 
{
	private var xml:XML;	
	private var node:XMLNode;
	private var settingsObj:Object;
	
	private var holder:MovieClip;
		private var scrollerBox:MovieClip;
		private var popupHandler:MovieClip;
		
		private var theTopMenu:MovieClip;
		
	public function komponenBlog() {
		this._visible = false;
		
	
		
		loadMyXml();
		
		trace(">>> Blog module compiled . . .");
		trace(">>> This module can't be used as stand-alone without the template, for more info please check the help files");
	}
	
	private function loadMyXml() { 
		if (_global.theXmlFile) {
			xml = _global.theXmlFile;
			xmlLoaded(true)
		}
		else {
			var xmlString:String = "blog.xml";
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
		
		//scrollerBox = holder["scrollerBox"];
		popupHandler = holder["popupHandler"];
		_global.nowPop = popupHandler;
			
		theTopMenu = holder["theTopMenu"];
		scrollerBox = holder["scrollerBox"];
		
		popupHandler.setSettings(settingsObj);
		
	/*	scrollerBox.addEventListener("closePopupFull", Proxy.create(this, closePopupFull));
		scrollerBox.addEventListener("itemClicked", Proxy.create(this, itemClicked));
		scrollerBox.setNode(node, settingsObj);
	*/	
		
	
		scrollerBox.addEventListener("itemClicked", Proxy.create(this, itemClicked));
		scrollerBox.addEventListener("closePopupFull", Proxy.create(this, closePopupFull));
		scrollerBox.setSettings(settingsObj);
		
		theTopMenu.addEventListener("buttonClicked", Proxy.create(this, buttonClicked));
		theTopMenu.addEventListener("buttonClickedIsTheSame", Proxy.create(this, buttonClickedIsTheSame));
		theTopMenu.setNode(node, settingsObj);
		
		this._visible = true;
		
	}
	
	private function itemClicked(obj:Object) {
		popupHandler.launchPopup(obj.mc);
	}
	
	private function closePopupFull(obj:Object) {
		popupHandler.closePopupFullNow();
	}
	

	
	public function treatAddress() {
		theTopMenu.treatAddress();
	}
	
	private function buttonClicked(obj:Object) {
		scrollerBox.setDetails(obj.mc.node);
	}
	
	private function buttonClickedIsTheSame(obj:Object) {
		scrollerBox.setDetails(obj.mc.node);
	}
}
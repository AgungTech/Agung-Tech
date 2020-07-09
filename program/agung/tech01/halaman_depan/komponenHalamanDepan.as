import ascb.util.Proxy;
import caurina.transitions.*;
import mx.data.types.Obj;
import mx.data.types.Str;


import mx.events.EventDispatcher;
import asual.sa.SWFAddress;
import agung.utils.UXml;
import agung.utils.UNode;

class agung.tech01.halaman_depan.komponenHalamanDepan extends MovieClip 
{
	private var xml:XML;	
	private var node:XMLNode;
	private var settingsObj:Object;
	
	private var holder:MovieClip;
		private var scrollerBox:MovieClip;
		private var mainDescription:MovieClip;
		private var productsDisplay:MovieClip;
		private var line:MovieClip;
		
	public function komponenHalamanDepan() {
		this._visible = false;
		
		scrollerBox = holder["scrollerBox"];
		mainDescription = holder["mainDescription"];
		productsDisplay = holder["productsDisplay"];
		line = holder["line"];
		
		loadMyXml();
		
		
		trace(">>> Homepage module compiled . . .");
		trace(">>> This module can be used as stand-alone without the template, for more info please check the help files, the default .xml file named halaman_depan.xml will be loaded");
	}
	
	private function loadMyXml() { 
		if (_global.theXmlFile) {
			xml = _global.theXmlFile;
			xmlLoaded(true)
		}
		else {
			var xmlString:String = "halaman_depan.xml";
			xml = UXml.loadXml(xmlString, xmlLoaded, this, true, true);
		}
	}

	private function xmlLoaded(s:Boolean) {
		if (!s) { trace("XML error !"); return; }	
		
		settingsObj = UNode.nodeToObj(xml.firstChild.firstChild);
		
		node = xml.firstChild;
		
		this.onEnterFrame = Proxy.create(this, enteredFrame);
	}

	private function enteredFrame() {
		delete this.onEnterFrame;
		
		
		var sbNode:XMLNode = node.firstChild.nextSibling.firstChild;
		var scrollerBoxSettings:Object = UNode.nodeToObj(sbNode.firstChild);
		
		var scrollerBoxTotalWidth:Number = 0;
										
		if (scrollerBoxSettings.enableScrollerBox == 1) {
			scrollerBox.setNode(sbNode, settingsObj);
			scrollerBoxTotalWidth = Math.round((scrollerBoxSettings.thumbWidth + 22) * scrollerBoxSettings.horizontalNumberOfItems
										+ scrollerBoxSettings.horizontalSpace * (scrollerBoxSettings.horizontalNumberOfItems - 1) + 50);
		}
		else {
			scrollerBox._visible = false;
		}
		
		
		var descNode:XMLNode = node.firstChild.nextSibling.firstChild.nextSibling;
		var mainDescriptionSettings:Object = UNode.nodeToObj(descNode.firstChild);
		
		if (mainDescriptionSettings.enableMainDescription == 1) {
			mainDescription.setNode(descNode, settingsObj, scrollerBoxSettings, mainDescriptionSettings)
			
		}
		else {
			mainDescription._visible = false;
		}
		
		
		
		mainDescription._x = Math.round(scrollerBoxTotalWidth);
		
		
		
		productsDisplay._x = Math.round(scrollerBoxTotalWidth);
		productsDisplay._y = 0;
		
		if (mainDescriptionSettings.enableMainDescription == 1) {
			productsDisplay._y = Math.round(mainDescriptionSettings.descriptionHeight + 40);
		}
		
		var prodNode:XMLNode = node.firstChild.nextSibling.firstChild.nextSibling.nextSibling;
		var prodDisplaySettings:Object = UNode.nodeToObj(prodNode.firstChild);
		
		productsDisplay.setNode(prodNode, settingsObj, scrollerBoxSettings, mainDescriptionSettings, prodDisplaySettings);
		
		line._alpha = 0;
		
		if ((mainDescriptionSettings.enableMainDescription == 1) && (prodDisplaySettings.enableProductsDisplay == 1)) {
			line._width = Math.round(mainDescription._width)
			line._x = mainDescription._x;
			line._y = Math.round(productsDisplay._y - 20 - 10 );
			
			Tweener.addTween(line, { _alpha:100, _y:Math.round(productsDisplay._y - 20), time:.5, delay:1, transition:"easeOut" } );
		}
		
		this._visible = true;
	}
	
}
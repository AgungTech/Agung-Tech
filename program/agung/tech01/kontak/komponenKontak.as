import ascb.util.Proxy;
import caurina.transitions.*;
import mx.data.types.Obj;
import mx.data.types.Str;
import agung.utils.UTf;

import mx.events.EventDispatcher;
import asual.sa.SWFAddress;
import agung.utils.UXml;
import agung.utils.UNode;

class agung.tech01.kontak.komponenKontak extends MovieClip 
{
	private var xml:XML;	
	private var node:XMLNode;
	private var settingsObj:Object;
	
	private var holder:MovieClip;
		private var htmlField:MovieClip;
		private var cont:MovieClip;
		private var extraLinks:MovieClip;
		
	public function komponenKontak() {
		this._visible = false;
		htmlField = holder["html"];
		UTf.initTextArea(htmlField["txt"], true);
		
		extraLinks = holder["extraLinks"];
		
		loadMyXml();
		
		trace(">>> Contact module compiled . . .");
		trace(">>> This module can be used as stand-alone without the template, for more info please check the help files, the default .xml file named kontak.xml will be loaded");

	}

	private function loadMyXml() { 
		if (_global.theXmlFile) {
			xml = _global.theXmlFile;
			xmlLoaded(true)
		}
		else {
			var xmlString:String = "kontak.xml";
			xml = UXml.loadXml(xmlString, xmlLoaded, this, true, true);
		}
		
	}

	private function xmlLoaded(s:Boolean) {
		if (!s) { trace("XML error !"); return; }	
		
		settingsObj = UNode.nodeToObj(xml.firstChild.firstChild);
		
		node = xml.firstChild.firstChild.nextSibling;
		
		this.onEnterFrame = Proxy.create(this, enteredFrame);
		
		this._visible = true;
	}
	
	private function enteredFrame() {
		delete this.onEnterFrame;
		cont = holder["cont"];
		htmlField["txt"]._width = settingsObj.htmlFieldWidth;
		htmlField["txt"].condenseWhite 	= true;
		
		htmlField["txt"].htmlText = node.firstChild.nodeValue;
		
		var defContX:Number = settingsObj.htmlFieldWidth + 20;
		cont._x = defContX + 40;
		cont.setNode(settingsObj)
		cont._alpha = 0;
		Tweener.addTween(cont, { _x:defContX, _alpha:100, time:.3, delay:.2, transition:"linear" } );
			
		node = node.parentNode.firstChild.nextSibling.nextSibling.firstChild;
		
		
		
		if (node) {
			var idx:Number = 0;
			var currentPos:Number = 0;
			var maxW:Number = 0;
			
			for (; node != null; node = node.nextSibling) {
				var currentItem:MovieClip = extraLinks.attachMovie("IDsmallLink", "IDsmallLink" + idx, extraLinks.getNextHighestDepth());
				
				currentItem.setNode(node);
				currentItem._y = currentPos;
				currentPos += currentItem._height;
				maxW = Math.max(maxW, currentItem.maxW);
				idx++;
			}
			
			var idx:Number = 0;
			while (extraLinks["IDsmallLink" + idx]) {
				extraLinks["IDsmallLink" + idx].arrange(maxW);
				idx++;
			}
			
			extraLinks._y = Math.ceil(htmlField._height + 14);
		
		}
		else {
			extraLinks._visible = false;
		}
		
		
		
		
		
		
		
		
		
	}
}
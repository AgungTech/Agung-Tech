import ascb.util.Proxy;
import caurina.transitions.*;
import mx.data.types.Obj;
import mx.data.types.Str;


import mx.events.EventDispatcher;

import agung.utils.UXml;
import agung.utils.UNode;
import asual.sa.SWFAddress;
import agung.utils.UAddr;

/**
 * This is the pemesanan component main module
 * This class receives the proper data from the cookies and properly displays everything
 */
class agung.tech01.pemesanan.komponenPemesanan extends MovieClip 
{
	private var node:XMLNode;
	private var settingsObj:Object;
	
	private var holder:MovieClip;
		private var scrollerBox:MovieClip;
		private var mainDescription:MovieClip;
		private var productsDisplay:MovieClip;
		private var line:MovieClip;
		
		private var myInterval:Number;
		
	public function komponenPemesanan() {
		this._visible = false;
		this._alpha = 0;
		
		mainDescription = holder["mainDescription"];
		
		xmlLoaded(true);
		
		trace(">>> Cart module compiled . . .");
		trace(">>> This module can't be used as stand-alone without the template, for more info please check the help files");
	}

	private function xmlLoaded(s:Boolean) {
		if (!s) { trace("XML error !"); return; }	
		
		node = _global.cartXmlNode.firstChild;
		settingsObj = _global.cartSettings;
		
		_global.theModuleTitle.setNewText(_global.globalSettingsObj, settingsObj);
		
		this.onEnterFrame = Proxy.create(this, enteredFrame);
	}

	private function enteredFrame() {
		delete this.onEnterFrame;
		
		var str:String = UAddr.contract(SWFAddress.getValue());
		var strArray:Array = str.split("/");
		var idx:Number = 0;

		if (strArray[2] == "success") {
			
			_global.shopHandler.deleteAllData();
			_global.theTopShopPreview.updateItems();
			_global.theBottomShopPreview.updateItems();
			
			myInterval = setInterval(this, "suc", 1500);
			
		}
		else {
			clearInterval(myInterval);
			myInterval = setInterval(this, "gg", 500);
			this._visible = true;
		}
	}
	
	private function suc() {
		clearInterval(myInterval);
		SWFAddress.setValue(_global.successCart);
	}
	
	private function gg() {
		clearInterval(myInterval);
		mainDescription.setSettings(settingsObj);
		this._x = 30;
		if (!_global.whitePresent) {	
			Tweener.addTween(this, { _alpha:100, _x:13, time:0.7, transition:"linear" } );
		}
		else {
			Tweener.addTween(this, { _alpha:100, _x:12, time:0.7, transition:"linear" } );
		}
		
	}
	
	
}
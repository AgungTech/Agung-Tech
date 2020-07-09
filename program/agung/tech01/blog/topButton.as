import ascb.util.Proxy;
import caurina.transitions.*;
import mx.data.types.Obj;
import mx.data.types.Str;
import agung.utils.UNode;

import mx.events.EventDispatcher;
import asual.sa.SWFAddress;
import agung.utils.UAddr;

class agung.tech01.blog.topButton extends MovieClip 
{
	private var node:XMLNode;
	private var settingsObj:Object
	
	private var refBg:MovieClip;
	private var normal:MovieClip;
	private var over:MovieClip;
	private var over2:MovieClip;
	
	private var activated:Number = 0;
	public var idx:Number;
	public var totalWidth:Number;
	public var totalHeight:Number;
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	public var urlAddress:String;
	public var urlTitle:String;
	
	public function topButton() {
		EventDispatcher.initialize(this);
		this._visible = false;
		
		normal["txt"].autoSize = over["txt"].autoSize = true;
		normal["txt"].wordWrap = over["txt"].wordWrap = false;
		
			over2["txt"].autoSize = true;
		over2["txt"].wordWrap =  false;
		over2._alpha = 0;
		
		over._alpha = refBg._alpha = 0;
	}
	

	public function setNode(pNode:XMLNode, pSettingsObj:Object)
	{
		node = pNode;
		settingsObj = pSettingsObj;
	
		urlTitle = _global.parentTitleLevelOne + " " + _global.globalSettingsObj.urlTitleSeparator + " " + node.attributes.browserTitle;
		
		var strArray:Array = node.attributes.browserUrl.split("/");
		
		urlAddress = UAddr.contract(_global.parentAddressLevelOne + strArray[1]) + "/";
		
		normal["txt"]._x = over["txt"]._x = -3;
		normal["txt"].text = over["txt"].text = node.attributes.title;
		
		over2["txt"]._x  = -3;
		over2["txt"].text = node.attributes.title;
		over2._x = settingsObj.horizontalSpaceOnTopMenuButtons;
		over2["line"]._width = Math.ceil(over2["txt"].textWidth);
		over2["line"]._y = Math.ceil(over2["txt"].textHeight + 2);
		
		normal._x = over._x = settingsObj.horizontalSpaceOnTopMenuButtons;
		totalWidth = refBg._width = Math.round(2*settingsObj.horizontalSpaceOnTopMenuButtons + normal["txt"].textWidth);
		totalHeight = refBg._height = Math.round(4 + normal["txt"].textHeight);
		
		this._visible = true;
	}
	
	private function onRollOver() {
		if (activated == 0) {
			if (over2) {
				Tweener.addTween(over2, { _alpha:100, time:.2, transition:"linear" } );
			}
			else {
				Tweener.addTween(over, { _alpha:100, time:.2, transition:"linear" } );
			}
			
		}
	}
	
	private function onRollOut() {
		if (activated == 0) {
			
				Tweener.addTween(over2, { _alpha:0, time:.2, transition:"linear" } );
		
				Tweener.addTween(over, { _alpha:0, time:.2, transition:"linear" } );
			
		}
	}
	
	
	public function dispatchMc() {
		SWFAddress.setTitle(urlTitle);
		dispatchEvent( { target:this, type:"buttonClicked", mc:this } );
	}
	
	public function onPress() {
		SWFAddress.setValue(urlAddress);
	}
	
	private function onRelease() {
		onRollOut();
	}
	
	private function onReleaseOutside() {
		onRelease() 
	}
	
		public function activate() {
		onRollOver();
		if (over2) {
			Tweener.addTween(over2, { _alpha:0, time:.2, transition:"linear" } );
			Tweener.addTween(over, { _alpha:100, time:.2, transition:"linear" } );
		}
		activated = 1;
	}
	
	public function deactivate() {
		activated = 0;
		if (over2) {
			Tweener.addTween(over, { _alpha:0, time:.2, transition:"linear" } );
		}
		onRollOut();
	}
}
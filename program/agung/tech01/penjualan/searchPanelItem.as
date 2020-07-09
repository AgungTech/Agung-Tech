import ascb.util.Proxy;
import caurina.transitions.*;
import mx.data.types.Obj;
import mx.data.types.Str;
import agung.utils.UNode;

import mx.events.EventDispatcher;
import asual.sa.SWFAddress;
import agung.utils.UAddr;

class agung.tech01.penjualan.searchPanelItem extends MovieClip 
{
	private var settingsObj:Object
	private var theStr:String;
	public var theType:String;
	
	private var activatedBut:MovieClip;
	private var normal:MovieClip;
	private var over:MovieClip;
	
	public var bg:MovieClip;
	
	private var activated:Number = 0;
	public var idx:Number;
	public var totalWidth:Number;
	public var totalHeight:Number;
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	public function searchPanelItem() {
		EventDispatcher.initialize(this);
		this._visible = false;
		
		normal["txt"].autoSize = over["txt"].autoSize = activatedBut["txt"].autoSize = true;
		normal["txt"].wordWrap = over["txt"].wordWrap = activatedBut["txt"].wordWrap = false;
		
		over._alpha = activatedBut._alpha =  bg._alpha = 0;
	}
	

	public function setNode(pStr:String, pSettingsObj:Object, pType:String)
	{
		theStr = pStr;
		settingsObj = pSettingsObj;
		theType = pType;
		
		normal["txt"].text = over["txt"].text = activatedBut["txt"].text = theStr;
		
		bg._width = Math.ceil(activatedBut["txt"].textWidth + 16);
		normal._x = over._x = activatedBut._x = 8 - 2;
		
		bg._height = Math.ceil(activatedBut["txt"].textHeight + 8);
		bg._y = -3;
		
		normal._y = over._y = activatedBut._y = -1
		this._visible = true;
	}
	
	private function onRollOver() {
		if (activated == 0) {
			Tweener.addTween(over, { _alpha:100, time:.2, transition:"linear" } );
		}
	}
	
	private function onRollOut() {
		if (activated == 0) {
			Tweener.addTween(over, { _alpha:0, time:.2, transition:"linear" } );
			Tweener.addTween(activatedBut, { _alpha:0, time:.2, transition:"linear" } );
			Tweener.addTween(bg, { _alpha:0, time:.2, transition:"linear" } );
		}
	}
	
	public function onPress() {
		dispatchEvent( { target:this, type:"buttonClickedGeneral", mc:this } );
	}
	
	private function onRelease() {
		onRollOut();
	}
	
	private function onReleaseOutside() {
		onRelease() 
	}
	
	public function activate() {
		onRollOver();
		activated = 1;
			Tweener.addTween(activatedBut, { _alpha:100, time:.2, transition:"linear" } );
			Tweener.addTween(bg, { _alpha:100, time:.2, transition:"linear" } );
	}
	
	public function deactivate() {
		activated = 0;
		onRollOut();
	}
}
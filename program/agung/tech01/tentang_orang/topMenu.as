import ascb.util.Proxy;
import caurina.transitions.*;
import mx.data.types.Obj;
import mx.data.types.Str;
import agung.utils.UNode;

import mx.events.EventDispatcher;
import asual.sa.SWFAddress;
import agung.utils.UAddr;

class agung.tech01.tentang_orang.topMenu extends MovieClip 
{
	private var theXml:XML;	
	private var node:XMLNode;
	private var settingsObj:Object
	
	private var currentItem:MovieClip;

	private var holder:MovieClip;
		private var lst:MovieClip;
		private var mask:MovieClip;
		
	private var next:MovieClip;
	private var prev:MovieClip;
			
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	public var totalItems:Number;
	private var theItems:Array;
	private var newWidth:Number;
	
	private var currentJump:Number = 0;
	private var init:Number = 1;
	
	public function topMenu() {
		EventDispatcher.initialize(this);
		this._visible = false;
		
		lst = holder["lst"];
		mask = holder["mask"];
		
		next["over"]._alpha = prev["over"]._alpha = 0;
		
		next.onRollOver = Proxy.create(this, nextOnRollOver);
		next.onRollOut = Proxy.create(this, nextOnRollOut);
		next.onPress = Proxy.create(this, nextOnPress);
		next.onReleaseOutside = Proxy.create(this, nextOnReleaseOutside);
		
		prev.onRollOver = Proxy.create(this, prevOnRollOver);
		prev.onRollOut = Proxy.create(this, prevOnRollOut);
		prev.onPress = Proxy.create(this, prevOnPress);
		prev.onReleaseOutside = Proxy.create(this, prevOnReleaseOutside);
		
		lst.setMask(mask);
	}
	

	public function setNode(pNode:XMLNode, pSettingsObj:Object)
	{
		node = pNode;
		settingsObj = pSettingsObj;
	
		node = node.firstChild;
	
	
		theItems = new Array();
		var currentPos:Number = 0;
		var idx:Number  = 0;
		
		for (; node != null; node = node.nextSibling) {
			var currentItem:MovieClip = lst.attachMovie("IDtopButton", "topButton" + idx, lst.getNextHighestDepth());
			currentItem.addEventListener("buttonClicked", Proxy.create(this, buttonClicked));
			currentItem.idx = idx;
			currentItem.setNode(node, settingsObj);
			currentItem._x = Math.round(currentPos);
			currentPos += Math.ceil(currentItem.totalWidth);
			theItems.push(currentItem);
			idx++
		}
		
		mask._width = 0;
		mask._height = Math.round(currentItem.totalHeight);
		
		totalItems = (idx - 1);
		
		/*var goTo:Number = 0;
		var newPos:Number = Math.min(goTo, totalItems - settingsObj.maxNumberOfButtonsOnTopMenu + 1);
		adjustMaskWidth(newPos);
		*/
		if (totalItems < settingsObj.maxNumberOfButtonsOnTopMenu) {
			next.enabled = prev.enabled = false;
			next._visible = prev._visible = false;
		}
		
		if (totalItems == 0) {
			lst._visible = false;
		}
	
		prev.enabled = false;
		prev._x = Math.ceil(-prev._width - 2);
		prev._y = next._y = Math.ceil(mask._height / 2 - next._height / 2 - 2);
		next._y += 1;
		
		currentItem = undefined;
		
		treatAddress();
		
		this._y = -54;
		this._x = settingsObj.moduleWidth - 60
		
		this._visible = true;
	}
	
	private function adjustMaskWidth(pIdx:Number) {
		if (init == 1) {
			init = 0;
			var animationTime:Number = settingsObj.topMaskInitializationAnimationTime;
			var animationType:String = settingsObj.topMaskInitializationAnimationType;
		}
		else {
			var animationTime:Number = settingsObj.topMaskAnimationTime;
			var animationType:String = settingsObj.topMaskAnimationType;
		}
		
		Tweener.addTween(lst, { _x:-theItems[pIdx]._x, time:animationTime, transition:animationType } );
		
		newWidth = 0;
		var i:Number = 0;
		for (i = pIdx; i < (pIdx + settingsObj.maxNumberOfButtonsOnTopMenu); i++) {
			if (theItems[i]) {
				newWidth += theItems[i].totalWidth;
			}
			
		
		}
		
		Tweener.addTween(mask, { _width:newWidth, time:animationTime, transition:animationType } );
		Tweener.addTween(next, { _x:Math.ceil(newWidth), time:animationTime, transition:animationType } );
		
		Tweener.addTween(this, { _x:Math.ceil(settingsObj.moduleWidth - newWidth - next._width - 10), time:animationTime, transition:animationType } );
	}
	
	
	public function treatAddress() {
		var str:String = UAddr.contract(SWFAddress.getValue());
		var strArray:Array = str.split("/");
		var idx:Number = 0;
		
		if (strArray[2]) {
			while (theItems[idx]) {
				var actualUrlAddress:Array = theItems[idx].urlAddress.split("/");
				
				if (theItems[idx].urlAddress == (str + "/")) {
					theItems[idx].dispatchMc();
					break;
				}
				
				idx++;
			}
		}
		else {
			theItems[0].onPress();
		}
		
	}
	
	private function buttonClicked(obj:Object) {
		if (obj.mc != currentItem) {
			currentItem.deactivate();
			currentItem = obj.mc;
			currentItem.activate();
			
			var goTo:Number = Math.ceil(obj.mc.idx - settingsObj.maxNumberOfButtonsOnTopMenu + Math.ceil(settingsObj.maxNumberOfButtonsOnTopMenu/2));
			if (goTo < 0) {
				goTo = 0;
			}
			var newPos:Number = Math.min(goTo, totalItems - settingsObj.maxNumberOfButtonsOnTopMenu + 1);
			adjustMaskWidth(newPos);
		
			currentJump = goTo;
			
			if (currentJump + 1 > totalItems - settingsObj.maxNumberOfButtonsOnTopMenu + 1) {
				nextOnRollOut() 
				next.enabled = false;
			}
			else {
				next.enabled = true;
			}
		
			if (currentJump - 1 < 0) {
				prevOnRollOut();
				prev.enabled = false;
			}
			else {
				prev.enabled = true;
			}
		
			dispatchEvent( { target:this, type:"buttonClicked", mc:obj.mc } );
		}
	}
	
	private function nextOnPress() {
		currentJump++;
		if (currentJump <= totalItems - settingsObj.maxNumberOfButtonsOnTopMenu + 1) {
			var goTo:Number = currentJump;
			var newPos:Number = Math.min(goTo, totalItems - settingsObj.maxNumberOfButtonsOnTopMenu + 1);
			adjustMaskWidth(newPos);
		}
		else {
			currentJump--;
		}
		
		prev.enabled = true;
		
		if (currentJump + 1 > totalItems - settingsObj.maxNumberOfButtonsOnTopMenu + 1) {
			nextOnRollOut() 
			next.enabled = false;
		}
	}
	
	private function prevOnPress() {
		currentJump--;
		if (currentJump >=0) {
			var goTo:Number = currentJump;
			var newPos:Number = Math.min(goTo, totalItems - settingsObj.maxNumberOfButtonsOnTopMenu + 1);
			adjustMaskWidth(newPos);
		}
		else {
			currentJump = 0;
		}
		
		next.enabled = true;
		
		if (currentJump - 1 < 0) {
			prevOnRollOut();
			prev.enabled = false;
		}
	}
		
		
		
	
		private function nextOnRollOver() {
			Tweener.addTween(next["over"], { _alpha:100, time:.2, transition:"linear"} );
		}
		
		private function nextOnRollOut() {
			Tweener.addTween(next["over"], { _alpha:0, time:.2, transition:"linear"} );
		}
		
		
		
	
		private function nextOnReleaseOutside() {
			nextOnRollOut();
		}
		
		
		
		
		
		private function prevOnRollOver() {
			Tweener.addTween(prev["over"], { _alpha:100, time:.2, transition:"linear"} );
		}
		
		private function prevOnRollOut() {
			Tweener.addTween(prev["over"], { _alpha:0, time:.2, transition:"linear"} );
		}
		
		
		
	
		private function prevOnReleaseOutside() {
			prevOnRollOut() 
		}
}
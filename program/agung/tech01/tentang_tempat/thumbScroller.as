import ascb.util.Proxy;
import caurina.transitions.*;
import mx.data.types.Obj;
import mx.data.types.Str;
import agung.utils.UNode;

import mx.events.EventDispatcher;
import asual.sa.SWFAddress;
import agung.utils.UAddr;

class agung.tech01.tentang_tempat.thumbScroller extends MovieClip 
{
	private var theXml:XML;	
	private var node:XMLNode;
	private var mainSettingsObj:Object;
	private var settingsObj:Object
	
	private var holder:MovieClip;
		private var lst:MovieClip;
		private var mask:MovieClip;
		
			
	private var next:MovieClip;
	private var prev:MovieClip;
	
	private var addedToThumbWidth:Number = 11 + 11;
	private var addedToThumbHeight:Number = 11 + 11;
	
	private var thumbArray:Array;
	private var thumbLoadingIdx:Number = -1;
	private var currentJump:Number = 0;
	private var totalItems:Number;
	
	public var totalHeight:Number;
	
	public var scrollerDescription:MovieClip;
	
	public function thumbScroller() {
		this._visible = false;
		
		lst = holder["lst"];
		mask = holder["mask"];
	
		lst.setMask(mask);
		
		
		next["over"]._alpha =0;
		next.onRollOver = Proxy.create(this, nextOnRollOver);
		next.onRollOut = Proxy.create(this, nextOnRollOut);
		next.onPress = Proxy.create(this, nextOnPress);
		next.onRelease = Proxy.create(this, nextOnRelease);
		next.onReleaseOutside = Proxy.create(this, nextOnReleaseOutside);
		
		prev["over"]._alpha =0;
		prev.onRollOver = Proxy.create(this, prevOnRollOver);
		prev.onRollOut = Proxy.create(this, prevOnRollOut);
		prev.onPress = Proxy.create(this, prevOnPress);
		prev.onRelease = Proxy.create(this, prevOnRelease);
		prev.onReleaseOutside = Proxy.create(this, prevOnReleaseOutside);
	}
	

	public function setNode(pNode:XMLNode, pMainSettingsObj:Object)
	{
		
		node = pNode;
		mainSettingsObj = pMainSettingsObj;
	
		node = node.firstChild.firstChild;
		
		settingsObj = UNode.nodeToObj(node);
		
		settingsObj.verticalNumberOfItems = 1;
		
		mask._width = Math.round((settingsObj.thumbWidth + addedToThumbWidth) * settingsObj.horizontalNumberOfItems + settingsObj.horizontalSpace * (settingsObj.horizontalNumberOfItems - 1));
		
		mask._height = totalHeight = Math.round((settingsObj.thumbHeight + addedToThumbHeight) * settingsObj.verticalNumberOfItems + settingsObj.verticalSpace * (settingsObj.verticalNumberOfItems - 1));
		
		
		thumbArray = new Array();
		var currentXPos:Number = 0;
		var currentYPos:Number = 0;
		var idx:Number = 0;
		
		node = node.nextSibling.firstChild;
		
	
		
		for (; node != null; node = node.nextSibling) {
			var currentItem:MovieClip = lst.attachMovie("IDscrollerItem", "scrollerItem" + idx, lst.getNextHighestDepth());
			
			currentItem.addEventListener("thumbLoaded", Proxy.create(this, thumbLoaded));
			currentItem.addEventListener("thumbRollOver", Proxy.create(this, thumbRollOver));
			currentItem.addEventListener("thumbRollOut", Proxy.create(this, thumbRollOut));
			
			
			currentItem._x = currentXPos;
			currentItem._y = 0;
			
			currentItem.setNode(node, settingsObj);

			currentXPos += Math.round(settingsObj.thumbWidth + addedToThumbWidth + settingsObj.horizontalSpace);

			thumbArray.push(currentItem);
			
			
			idx++;
		}
		
		totalItems = idx - 1;
		
		holder._x = Math.ceil(mainSettingsObj.moduleWidth / 2 - mask._width / 2);
		prev._x = Math.ceil(holder._x - next._width - 1);
		next._x = Math.ceil(mask._width + holder._x+ 1 );
		next._y = prev._y = Math.ceil(15);
		
		prev.enabled = false;
		
		if (idx < (settingsObj.horizontalNumberOfItems+1)) {
			next.enabled = prev.enabled = false;
			next._visible = prev._visible = false;
		}
		thumbLoaded();
		
		this._visible = true;
	}
	
	private function thumbRollOver(obj:Object) {
		scrollerDescription.setNewText(obj.mc.node);
	}
	
	private function thumbRollOut(obj:Object) {
		scrollerDescription.hide();
	}
	
	private function thumbLoaded(obj:Object) {
		thumbLoadingIdx++;
		if (thumbArray[thumbLoadingIdx]) {
			thumbArray[thumbLoadingIdx].startLoad();
		}
	}
	
	
	private function goToIdx(pIdx:Number) {
		var newPos:Number = -Math.ceil((settingsObj.thumbWidth + addedToThumbWidth)*pIdx + settingsObj.horizontalSpace*pIdx)
		Tweener.addTween(lst, { _x:newPos, time:settingsObj.scrollAnimationTime, transition:settingsObj.scrollAnimationType } );
	}
	
	private function nextOnRollOver() {
		Tweener.addTween(next["over"], { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function nextOnRollOut() {
		Tweener.addTween(next["over"], { _alpha:0, time:.2, transition:"linear" } );
	}
	
	private function nextOnPress() {
		currentJump++;
		if (currentJump <= totalItems - settingsObj.horizontalNumberOfItems + 1) {
			goToIdx(currentJump);
		}
		
		if (currentJump + 1 > totalItems - settingsObj.horizontalNumberOfItems + 1) {
			nextOnRollOut()
			next.enabled = false;
		}
		
		prev.enabled = true;
	}
	
	private function nextOnRelease() {
		//nextOnRollOut()
	}
	
	private function nextOnReleaseOutside() {
		nextOnRelease();
	}
	
	
	
	
	
	
	private function prevOnRollOver() {
		Tweener.addTween(prev["over"], { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function prevOnRollOut() {
		Tweener.addTween(prev["over"], { _alpha:0, time:.2, transition:"linear" } );
	}
	
	private function prevOnPress() {
		currentJump--;
		if (currentJump >= 0) {
			goToIdx(currentJump);
		}
		
		if (currentJump - 1 < 0) {
			prevOnRollOut()
			prev.enabled = false;
		}
		
		next.enabled = true;
	}
	
	private function prevOnRelease() {
		//prevOnRollOut()
	}
	
	private function prevOnReleaseOutside() {
		prevOnRelease()
	}
}
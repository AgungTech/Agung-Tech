import caurina.transitions.*;
import ascb.util.Proxy;
import agung.utils.UMc;
import agung.utils.UTf;

class agung.tech01.halaman_depan.imagesDisplay extends MovieClip
{
	private var settingsObj:Object;
	private var mainSettingsObj:Object;
	private var scrollerBoxSettingsObj:Object;
	private var mainDescriptionSettingsObj:Object;
	
	public var node:XMLNode;
	
	private var totalJumps:Number = 0;
	private var currentJump:Number = 0;
	
	
	private var holder:MovieClip;
		private var title:MovieClip;	
		private var scroller:MovieClip;
			private var lst:MovieClip;
			private var mask:MovieClip;
			private var nav:MovieClip;
				private var next:MovieClip;
				private var prev:MovieClip;
			
	public function imagesDisplay() {
		this._visible = false;

		scroller = holder["scroller"];
		mask = scroller["mask"];
		lst = scroller["lst"];
		nav = scroller["nav"];
		lst.setMask(mask);
		next = nav["next"];
		prev = nav["prev"];
			next["over"]._alpha = 0;
			prev["over"]._alpha = 0;
		
		title = holder["title"];
		title["txt"].autoSize = true;
		title["txt"].wordWrap = false;
		
		
		next.onRollOver = Proxy.create(this, nextOnRollOver);
		next.onRollOut = Proxy.create(this, nextOnRollOut);
		next.onPress = Proxy.create(this, nextOnPress);
		next.onRelease = Proxy.create(this, nextOnRelease);
		next.onReleaseOutside = Proxy.create(this, nextOnReleaseOutside);
		
		prev.onRollOver = Proxy.create(this, prevOnRollOver);
		prev.onRollOut = Proxy.create(this, prevOnRollOut);
		prev.onPress = Proxy.create(this, prevOnPress);
		prev.onRelease = Proxy.create(this, prevOnRelease);
		prev.onReleaseOutside = Proxy.create(this, prevOnReleaseOutside);
		
	}
			
	/**
	 * @param	pNode
	 * @param	pMainSettings
	 * @param	pSettingsScrollerBox
	 * @param	pMainDescriptionSettings
	 * @param	pSettings
	 */
	public function setNode(pNode:XMLNode, pMainSettings:Object, pSettingsScrollerBox:Object, pMainDescriptionSettings:Object, pSettings:Object) {
		node = pNode;
		settingsObj = pSettings;
		scrollerBoxSettingsObj = pSettingsScrollerBox;
		mainSettingsObj = pMainSettings;
		mainDescriptionSettingsObj = pMainDescriptionSettings;
		
		title["txt"].text = settingsObj.title;
		title._y = -8;
		scroller._y = Math.round(title._y + title["txt"].textHeight + 6);
		
		var maskHeight:Number = Math.round(mainSettingsObj.moduleHeight - this._y - scroller._y - 2);
		
		if (mainDescriptionSettingsObj.enableMainDescription == 0) {
			maskHeight = Math.round(mainSettingsObj.moduleHeight - scroller._y - 2);
		}
	
		var maskWidth:Number = mainSettingsObj.moduleWidth;
		
		if (pSettingsScrollerBox.enableScrollerBox == 1) {
			var scrollerBoxTotalWidth = Math.round((scrollerBoxSettingsObj.thumbWidth + 22) * scrollerBoxSettingsObj.horizontalNumberOfItems
										+ scrollerBoxSettingsObj.horizontalSpace * (scrollerBoxSettingsObj.horizontalNumberOfItems - 1) + 50);
		
			maskWidth = Math.round(mainSettingsObj.moduleWidth - scrollerBoxTotalWidth);
		}
		
		mask._width = maskWidth;
		mask._height = Math.round(maskHeight - nav._height - 10);
		
		nav._x = Math.round(mask._width - nav._width);
		nav._y = Math.round(mask._height + 10);
		
		var oneButtonWidth:Number = Math.round(mask._width / settingsObj.horizontalNumberOfItems);
		
		node = node.firstChild.nextSibling.firstChild;
		
		var currentXPos:Number = 0;
		var currentYPos:Number = 0;
		var nextPlane:Number = 1;
		
		var idx:Number = 0;
		for (; node != null; node = node.nextSibling) {
			var currentItem:MovieClip = lst.attachMovie("IDproductsDisplayItem", "productsDisplayItem" + idx, lst.getNextHighestDepth());
			currentItem.setNode(node, settingsObj, oneButtonWidth);
			
			currentItem._x = Math.round(currentXPos);
			currentItem._y = Math.round(currentYPos);
			
			if ((currentYPos + currentItem.totalHeight) > mask._height) {
				currentYPos = 0;
				currentXPos += oneButtonWidth;
				nextPlane++;
				currentItem._x = Math.round(currentXPos);
				currentItem._y = Math.round(currentYPos);
			}
		
			currentYPos += currentItem.totalHeight + 8;
			
			idx++;
		}
		
	
		totalJumps = Math.ceil(nextPlane / settingsObj.horizontalNumberOfItems);
		
		if (totalJumps == 1) {
			nav._visible = false;
		}
		else {
			prev._alpha = 50;
			prev.enabled = false;
			
		}
		 
		if (settingsObj.enableProductsDisplay == 1) {
			this._visible = true;
		}
		else {
			this._visible = false;
		}
		
		
	}
	
	
	private function goIdx(pIdx:Number) {
		Tweener.addTween(lst, { _x:Math.round( -mask._width * pIdx), time:settingsObj.slideProductsAnimationTime, transition:settingsObj.slideProductsAnimationType } );
	}
	
	private function nextOnRollOver() {
		Tweener.addTween(next["over"], { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function nextOnRollOut() {
		Tweener.addTween(next["over"], { _alpha:0, time:.2, transition:"linear" } );
	}
	
	private function nextOnPress() {
		
		Tweener.addTween(next, { _x:24, time:.2, transition:"easeIn" } );
		
		currentJump++;
		
		if (currentJump < totalJumps) {
			goIdx(currentJump);
		}
		else {
			currentJump--;
		}
		
		if ((currentJump + 1) >= totalJumps) {
			nextOnReleaseOutside();
			next._alpha = 50;
			next.enabled = false;
		}
		
		if (prev.enabled == false) {
			prev._alpha = 100;
			prev.enabled = true;
		}

	}
	
	private function nextOnRelease() {
		Tweener.addTween(next, { _x:21, time:.2, transition:"easeIn" } );
	}
	
	private function nextOnReleaseOutside() {
		nextOnRelease()
		nextOnRollOut();
	}
	
	
	
	
	
	
	private function prevOnRollOver() {
		Tweener.addTween(prev["over"], { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function prevOnRollOut() {
		Tweener.addTween(prev["over"], { _alpha:0, time:.2, transition:"linear" } );
	}
	
	private function prevOnPress() {
		Tweener.addTween(prev, { _x: -3, time:.2, transition:"easeIn" } );
		
		currentJump--;
		
		if (currentJump >=0) {
			goIdx(currentJump);
		}
		else {
			currentJump++;
		}
		
		if ((currentJump - 1) <0) {
			prevOnReleaseOutside()
			prev._alpha = 50;
			prev.enabled = false;
		}
		
		if (next.enabled == false) {
			next._alpha = 100;
			next.enabled = true;
		}
	}
	
	private function prevOnRelease() {
		Tweener.addTween(prev, { _x:0, time:.2, transition:"easeIn" } );
	}
	
	private function prevOnReleaseOutside() {
		prevOnRelease()
		prevOnRollOut();
	}
}
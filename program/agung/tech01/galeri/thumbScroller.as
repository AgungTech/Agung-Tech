import ascb.util.Proxy;
import caurina.transitions.*;
import mx.data.types.Obj;
import mx.data.types.Str;
import agung.utils.UNode;

import mx.events.EventDispatcher;
import asual.sa.SWFAddress;
import agung.utils.UAddr;

class agung.tech01.galeri.thumbScroller extends MovieClip 
{
	private var theXml:XML;	
	private var node:XMLNode;
	private var mainSettingsObj:Object;
	private var settingsObj:Object
	
	private var holder:MovieClip;
		private var lst:MovieClip;
		private var mask:MovieClip;
		private var scroller:MovieClip;
			private var bar:MovieClip;
			private var stick:MovieClip;

	private var addedToThumbWidth:Number = 11 + 11;
	private var addedToThumbHeight:Number = 11 + 11;
	
	private var thumbArray:Array;
	private var thumbLoadingIdx:Number = -1;
	private var currentJump:Number = 0;
	private var totalItems:Number;
	
	
	public var scrollerDescription:MovieClip;
	private var myWaitInterval:Number;
	private var HitZone:MovieClip;
	private var ScrollArea:MovieClip;
	private var ScrollButton:MovieClip;
	private var ContentMask:MovieClip;
	private var Content:MovieClip;
	private var viewHeight:Number;
	private var totalHeight:Number;
	private var ScrollHeight:Number;
	private var scrollable:Boolean;
	
	public function thumbScroller() {
		this._visible = false;
		
		lst = holder["lst"];
		mask = holder["mask"];
		scroller = holder["scroller"];
		scroller._alpha = 0;
			bar = scroller["bar"];
			stick = scroller["stick"];
			
		lst.setMask(mask);
	}
	
	/**
	 * @param	pNode
	 * @param	pMainSettingsObj
	 */

	public function setNode(pNode:XMLNode, pMainSettingsObj:Object)
	{
		
		node = pNode;
		mainSettingsObj = pMainSettingsObj;
	
		node = node.firstChild.firstChild;
		
		settingsObj = UNode.nodeToObj(node);
		
		
		mask._width = Math.round((settingsObj.thumbWidth + addedToThumbWidth) * settingsObj.horizontalNumberOfItems + settingsObj.horizontalSpace * (settingsObj.horizontalNumberOfItems - 1));
		
		mask._height = Math.round((settingsObj.thumbHeight + addedToThumbHeight) * settingsObj.verticalNumberOfItems + settingsObj.verticalSpace * (settingsObj.verticalNumberOfItems - 1));
		
		
		thumbArray = new Array();
		var currentXPos:Number = 0;
		var currentYPos:Number = 0;
		var nextPlane:Number = 1;
		var idx:Number = 0;
		
		node = node.nextSibling.firstChild;
		
	
		
		for (; node != null; node = node.nextSibling) {
			var currentItem:MovieClip = lst.attachMovie("IDscrollerItem", "scrollerItem" + idx, lst.getNextHighestDepth());
			
			currentItem.addEventListener("thumbClicked", Proxy.create(this, thumbClicked));
			currentItem.addEventListener("thumbLoaded", Proxy.create(this, thumbLoaded));
			currentItem.addEventListener("thumbRollOver", Proxy.create(this, thumbRollOver));
			currentItem.addEventListener("thumbRollOut", Proxy.create(this, thumbRollOut));
			currentItem.idx = idx;
			
			currentItem._x = currentXPos;
			currentItem._y = currentYPos;
			
			currentItem.setNode(node, settingsObj);

			currentXPos += Math.round(settingsObj.thumbWidth + addedToThumbWidth + settingsObj.horizontalSpace);
			
			if (currentXPos > mask._width) {
				currentYPos += Math.round(settingsObj.thumbHeight + addedToThumbHeight + settingsObj.verticalSpace);
				currentXPos = 0;
			}
			
			thumbArray.push(currentItem);
			
			
			idx++;
		}
		
		totalItems = idx - 1;
		
		if (settingsObj.enableAutoCentering == 1) {
			holder._x = Math.ceil(mainSettingsObj.moduleWidth / 2 - Math.min(mask._width, lst._width) / 2);
			holder._y = Math.ceil(mainSettingsObj.moduleHeight / 2 - Math.min(mask._height, lst._height) / 2);
			stick._height = Math.min(mask._height, lst._height);
			scroller._x = Math.ceil(lst._width + 10);
		}
		else {
			holder._x = 0;
			holder._y = 0;
			stick._height = mask._height;
			scroller._x = Math.ceil(mainSettingsObj.moduleWidth - scroller._width);
		}
		
		
		treatAddress();
		
		myWaitInterval = setInterval(this, "ScrollBox", 500);
		
		this._visible = true;
	}
	
	public function treatAddress() {
		var str:String = UAddr.contract(SWFAddress.getValue());
		var strArray:Array = str.split("/");
		var idx:Number = 0;
		
		if (strArray[3]) {
			var idx:Number = 0;
			while (lst["scrollerItem" + idx]) {
				
				var actualUrlAddress:String = "/" + strArray[1] + "/" + strArray[2] + "/" + strArray[3] + "/";

				if (lst["scrollerItem" + idx].urlAddress == (actualUrlAddress)) {
					lst["scrollerItem" + idx].dispatchMc();
					break;
				}
				idx++;
			}
		}
		else {
			_global.portfolioPopupHandler.cancelPopup()
		}
		
		
		
	}
	
		
	private function thumbClicked(obj:Object) {
		_global.portfolioPopupHandler.launchPopup(obj.mc, thumbArray, this);
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
	
	public function stopScrolling() {
		Mouse.removeListener(this);
	}
	public function startScrolling() {
		Mouse.addListener(this);
	}
	private function ScrollBox() {
		clearInterval(myWaitInterval);
		thumbLoaded();
		
		ScrollArea = stick;
		ScrollButton = bar;
		Content = lst;
		ContentMask = mask;
		
		HitZone = ContentMask.duplicateMovieClip("_hitzone_", this.getNextHighestDepth());
		HitZone._alpha = 0;
		HitZone._width = ContentMask._width;
		HitZone._height = ContentMask._height;
		
		Content.setMask(ContentMask);
		ScrollArea.onPress = Proxy.create(this, startScroll);
		ScrollArea.onRelease = ScrollArea.onReleaseOutside = Proxy.create(this, stopScroll);
		
		totalHeight = Content._height + 4;
		scrollable = false;
		
		updateScrollbar();
		
		Mouse.addListener(this);
		
		ScrollButton.onRollOver = Proxy.create(this, barOnRollOver);
		ScrollButton.onRollOut = Proxy.create(this, barOnRollOut);
		ScrollButton.onPress = Proxy.create(this, startScroll);
		ScrollButton.onRelease = ScrollButton.onReleaseOutside = Proxy.create(this, stopScroll);
		
		barOnRollOut();
	}
	
	private function updateScrollbar() {
		viewHeight = ContentMask._height;
		
		var prop:Number = viewHeight/(totalHeight-4);
		
		if (prop >= 1) {
			scrollable = false;
			scroller._alpha = 0
			ScrollArea.enabled = false;
			ScrollButton._y = 0;
			Content._y = 0;
			scroller._visible = false;
		} else {
			ScrollButton["normal"]._height = ScrollButton["over"]._height = ScrollArea._height * prop;
			scrollable = true;
			ScrollButton._visible = true;
			ScrollArea.enabled = true;
			ScrollButton._y = 0;
			Tweener.addTween(scroller, { _alpha:100, time:2, transition:"linear" } );
			
			ScrollHeight = ScrollArea._height - ScrollButton._height;
			
			if(ScrollButton._height>(ScrollArea._height)){
				scrollable = false;
				scroller._alpha = 0
				ScrollArea.enabled = false;
				ScrollButton._y = 0;
				Content._y = 0;
			}
			
			scroller._visible = true;
		}
	}
	
	private function startScroll() {
		var center:Boolean = !ScrollButton.hitTest(_level0._xmouse, _level0._ymouse, true);
		var sbx:Number = ScrollButton._x;
		if (center) {
			var sby:Number = ScrollButton._parent._ymouse-ScrollButton._height/2;
			sby<0 ? sby=0 : (sby>ScrollHeight ? sby=ScrollHeight : null);
			ScrollButton._y = sby;
		}

			
		ScrollButton.startDrag(false, sbx, 0, sbx, ScrollHeight);
		ScrollButton.onMouseMove = Proxy.create(this, updateContentPosition);
		updateContentPosition();
	}
	
	private function stopScroll() {
		ScrollButton.stopDrag();
		delete ScrollButton.onMouseMove;
		barOnRollOut();

	}
	
	private function updateContentPosition() {
		if (scrollable == true) {
			var contentPos:Number = (viewHeight-totalHeight)*(ScrollButton._y/ScrollHeight);
		this.onEnterFrame = function() {
			if (Math.abs(Content._y-contentPos)<1) {
				Content._y = contentPos;
				delete this.onEnterFRame;
				return;
			}
			Content._y += (contentPos - Content._y) / 10;
		};
		}
		else{
			Content._y = 0;
			delete Content.onEnterFRame;
		}
		
	}
	
	private function scrollDown() {
		var sby:Number = ScrollButton._y+ScrollButton._height/4;
		if (sby>ScrollHeight) {
			sby = ScrollHeight;
		}
		ScrollButton._y = sby;
		updateContentPosition();
	}
	
	private function scrollUp() {
		var sby:Number = ScrollButton._y-ScrollButton._height/4;
		if (sby<0) {
			sby = 0;
		}
		ScrollButton._y = sby;
		updateContentPosition();
	}
	
	private function onMouseWheel(delt:Number) {
		if (!HitZone.hitTest(_level0._xmouse, _level0._ymouse, true)) {
			return;
		}
		var dir:Number = delt/Math.abs(delt);
		if (dir<0) {
			scrollDown();
		} else {
			scrollUp();
		}
	}
	
	private function barOnRollOver() {
		Tweener.addTween(bar["over"], { _alpha:100, time:0.15, transition:"linear" } );
	}
	
	private function barOnRollOut() {
		Tweener.addTween(bar["over"], { _alpha:0, time:0.15, transition:"linear" } );
	}
}
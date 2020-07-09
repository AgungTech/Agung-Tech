import ascb.util.Proxy;
import caurina.transitions.*;
import mx.data.types.Obj;
import mx.data.types.Str;
import agung.utils.UNode;

import mx.events.EventDispatcher;
import asual.sa.SWFAddress;
import agung.utils.UAddr;

class agung.tech01.karir.scrollerBox extends MovieClip 
{
	private var theXml:XML;	
	private var node:XMLNode;
	private var settingsObj:Object
	
	private var currentItem:MovieClip;
	
	private var HitZone:MovieClip;
	private var ScrollArea:MovieClip;
	private var ScrollButton:MovieClip;
	private var ContentMask:MovieClip;
	private var Content:MovieClip;
	private var viewHeight:Number;
	private var totalHeight:Number;
	private var ScrollHeight:Number;
	private var scrollable:Boolean;
	
	private var holder:MovieClip;
		private var lst:MovieClip;
		private var mask:MovieClip;
		private var scroller:MovieClip;
			private var stick:MovieClip;
			private var bar:MovieClip;
			
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	public var totalItems:Number;
	private var theItems:Array;
	
	public function scrollerBox() {
		EventDispatcher.initialize(this);
		this._visible = false;
		
		lst = holder["lst"];
		mask = holder["mask"];
		scroller = holder["scroller"];
			stick = scroller["stick"];
			bar = scroller["bar"];
		
		lst.setMask(mask);
	}
	

	
	public function setNode(pNode:XMLNode, pSettingsObj:Object)
	{
		node = pNode;
		settingsObj = pSettingsObj;
	
		node = node.firstChild;
	
		mask._width = Math.round(pSettingsObj.moduleWidth - 16);
		mask._height = Math.round(pSettingsObj.moduleHeight);
		
		scroller["stick"]._height = mask._height;
		scroller._x = Math.round(mask._width + 8);


		var itemWidth:Number = mask._width;
		theItems = new Array();
		var currentPos:Number = 0;
		var idx:Number  = 0;
		for (; node != null; node = node.nextSibling) {
			var currentItem:MovieClip = lst.attachMovie("IDCareersItem", "careersItem" + idx, lst.getNextHighestDepth());
			currentItem.addEventListener("itemClicked", Proxy.create(this, itemClicked));
			currentItem.idx = idx;
			currentItem.theParent = this;
			currentItem.setNode(node, settingsObj, itemWidth);
			currentItem._y = Math.round(currentPos);
			currentPos += currentItem.totalHeight + settingsObj.verticalSpace;
			theItems.push(currentItem);
			
			idx++
		}
		
		totalItems = (idx-1);
		
		currentItem = undefined;
		
		ScrollBox();
		
		treatAddress();
		
		this._visible = true;
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
			dispatchEvent( { target:this, type:"closePopupFull", mc:this} );
		}
		
	}
	
	public function resetItemAllState() {
		currentItem.deactivateItem();
		currentItem = undefined;
	}
	
	public function launchOneItem(pIdx:Number) {
		if (settingsObj.enableClickOnCareerItem == 1) {
			lst["careersItem" + pIdx].bgPress();
		}
		else {
			lst["careersItem" + pIdx].readButtonPress();
		}
		
	}
	
	private function itemClicked(obj:Object) {
		if (obj.mc != currentItem) {
			currentItem.deactivateItem();
			currentItem = obj.mc;
			currentItem.activateItem();
			
			disableMouseListener();
			
			dispatchEvent( { target:this, type:"itemClicked", mc:obj.mc } );
		}
	}
	
	public function disableMouseListener() {
		Mouse.removeListener(this);
	}
	
	public function enableMouseListener() {
		Mouse.addListener(this);
	}
	
	private function ScrollBox() {
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
			scroller._alpha = 100
			ScrollHeight = ScrollArea._height - ScrollButton._height;
			
			if(ScrollButton._height>(ScrollArea._height)){
				scrollable = false;
				scroller._alpha = 0
				ScrollArea.enabled = false;
				ScrollButton._y = 0;
				Content._y = 0;
			}
			
			scroller._alpha = 100;
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
			Content._y += (contentPos - Content._y) / 6;
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
		Tweener.addTween(bar["over"] , { _alpha:0, time:0.15, transition:"linear" } );
	}
}
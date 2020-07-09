import caurina.transitions.*;
import ascb.util.Proxy;
import agung.utils.UMc;
import agung.utils.UTf;
import agung.utils.UNode;

/**
 * This class handles the details
 */
class agung.tech01.tentang_orang.details extends MovieClip
{
	private var settingsObjScroller:Object;
	private var node:XMLNode
	private var globalSettings:Object;

	
	private var holder:MovieClip;

	private var lst:MovieClip;
	private var scroller:MovieClip;
		private var stick:MovieClip;
		private var bar:MovieClip;
	
	private var mask:MovieClip;
	
	private var myArray:Array;
	private var currentIdx:Number = -1;
	private var currentPos:Number = 0;
	private var myWaitInterval:Number;
	private var loadingSetIdx:Number = -1;
	
	private var HitZone:MovieClip;
	private var ScrollArea:MovieClip;
	private var ScrollButton:MovieClip;
	private var ContentMask:MovieClip;
	private var Content:MovieClip;
	private var viewHeight:Number;
	private var totalHeight:Number;
	private var ScrollHeight:Number;
	private var scrollable:Boolean;
	
	public function details() {
		this._visible = false;
		
		lst = holder["lst"];
		mask = holder["mask"];
		scroller = holder["scroller"];
			stick = scroller["stick"];
			bar = scroller["bar"];
			
		lst.setMask(mask);
		
		scroller._alpha = 0;
	}
	
	/**
	 * Here, the node, settings and global settings are being sent and prepared for later use of another classes
	 * @param	pNode
	 * @param	pGlobalSettings
	 * @param	pSettingsObjScroller
	 */
	public function setNode(pNode, pGlobalSettings, pSettingsObjScroller){
		globalSettings = pGlobalSettings;
		node = pNode;
			
		scroller._x = Math.ceil(globalSettings.moduleWidth - scroller._width);
		
		mask._width = globalSettings.moduleWidth - 16;
		mask._height = stick._height = globalSettings.moduleHeight;
		
		onEnterFrame = Proxy.create(this, cont)
		
		this._visible = true;
	}
	
	private function cont() {
		delete this.onEnterFrame;

		node = node.firstChild;
		
		myArray = new Array();
	
		for (; node != null; node = node.nextSibling) {
			myArray.push(node);
		}
		
		createNext(0);
	}
	
	public function createNext(pTotalHeight:Number) {
		currentIdx++;
		currentPos += pTotalHeight;
		
		if (myArray[currentIdx]) {
			var currentList:MovieClip = lst.attachMovie("IDtheList", "list" + currentIdx, lst.getNextHighestDepth());
			
			currentList._y = Math.ceil(currentPos);
			currentList.myParent = this;
			currentList.setNode(myArray[currentIdx], globalSettings, currentIdx, myArray);
		}
		else {
			ScrollBox()
			loadNextSet();
			
		}
	}
	
	public function loadNextSet() {
		loadingSetIdx++;
		if (lst["list" + loadingSetIdx]) {
			lst["list" + loadingSetIdx].startLoad();
		}
	}
	
	private function ScrollBox() {
		clearInterval(myWaitInterval);
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
			Content._y += (contentPos - Content._y) / 5;
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
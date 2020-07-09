import caurina.transitions.*;
import ascb.util.Proxy;
import agung.utils.UMc;
import agung.utils.UTf;

class agung.tech01.penjualan.popupDescr extends MovieClip
{
	private var settingsObj:Object;
	private var popupSettings:Object;
	public var node:XMLNode;
	
	
	private var HitZone:MovieClip;
	private var ScrollArea:MovieClip;
	private var ScrollButton:MovieClip;
	private var ContentMask:MovieClip;
	private var Content:MovieClip;
	private var viewHeight:Number;
	private var totalHeight:Number;
	private var ScrollHeight:Number;
	private var scrollable:Boolean;
	
	public var holder:MovieClip;
		private var lst:MovieClip;
		private var mask:MovieClip;
		public var scroller:MovieClip;
			private var stick:MovieClip;
			private var bar:MovieClip;
			
	private var scanImageIdx:Number = 0
	private var totalWidth:Number = 0;
	private var lstHeight:Number = 0;
	
	private var correction:Number;
	
	private var myInterval:Number;
	
	public function popupDescr() {
		this._visible = false;
		this._alpha = 0;
		
		lst = holder["lst"];
		mask = holder["mask"];
		scroller = holder["scroller"];
		stick = scroller["stick"];
		bar = scroller["bar"];
		
		UTf.initTextArea(lst["txt"], true);
		
		lst.setMask(mask);
	}
	
	
	private function startCheck() {
		clearInterval(myInterval);
		
		delete this.onEnterFrame;
		ScrollBox();
		
		if (scrollable == false) {
			lst["txt"]._width += scroller._width + 2;
		}
	}
	
	public function defaultResize() {
		totalWidth = Math.round(settingsObj.w);
		
		lst["txt"]._width = totalWidth - 6;
		mask._width = totalWidth;
		mask._height = settingsObj.h;
		stick._height = mask._height;
		
		scroller._x = Math.round(mask._width + 10);
		
		lstHeight = lst._height;
		
		ScrollBox();
		this.onEnterFrame = Proxy.create(this, cc);
	}
	
	public function setNode(pNode:XMLNode, pSettings:Object, pPopupSettings:Object){
		node = pNode;
		settingsObj = pSettings;
		popupSettings = pPopupSettings;
	
		
		lst["txt"].htmlText = node.firstChild.nodeValue;
	
		Tweener.addTween(this, { _alpha:100, delay:.3, time:.5, transition:"linear" } );
		
		defaultResize();
		this._visible = true;
	}
	
	private function cc() {
		if (scanImageIdx == 100) {
			delete this.onEnterFrame;
			
			if (scrollable == false) {
				lst["txt"]._width += scroller._width + 2;
			}
		}
		else {
			if (lstHeight != lst._height) {
				lstHeight = lst._height;
				ScrollBox();
			}
		}
		
		scanImageIdx++;
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
			Content._y = 0;
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
				delete this.onEnterFrame;
				return;
			}
			Content._y += (contentPos - Content._y) / 10;
		};
		}
		else{
			Content._y = 0;
			delete Content.onEnterFrame;
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
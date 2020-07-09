import caurina.transitions.*;
import ascb.util.Proxy;
import mx.events.EventDispatcher;

/**
 * kelas ini mengatur popup berita
 */
class agung.tech01.berita.beritaPopup extends MovieClip 
{
	private var oldpW:Number = 0;
	private var oldpH:Number = 0;
	
	private var node:XMLNode;
	private var settingsObj:Object

	private var holder:MovieClip;
	
	public var popupDes:MovieClip;
	
	private var leftHit:MovieClip;
	private var rightHit:MovieClip;
	private var arrowsDefs:Object;
	private var myInterval2:Number;
	private var myInterval3:Number;
	
	private var bgBody:MovieClip;
		private var outerBg:MovieClip;
		private var innerFill:MovieClip;
		private var innerStroke:MovieClip;
	
	private var upControl:MovieClip;
		private var bgUC:MovieClip;
			private var bgUCStroke:MovieClip;
			private var bgUCFill:MovieClip;
		private var UCTitle:MovieClip;
		private var closeButton:MovieClip;
			private var closeButtonOver:MovieClip;
			private var closeButtonNormal:MovieClip;
		
	private var next:MovieClip;
	private var prev:MovieClip;
		
	private var popupMode:String;
	private var pressedItem:MovieClip;
	
	private var myInterval:Number;
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	
	public function beritaPopup() {
		EventDispatcher.initialize(this);
		
		this._visible = false;
		
		
		bgBody = holder["bgBody"];
		
		outerBg = bgBody["outerBg"];
		innerFill = bgBody["innerFill"];
		innerStroke = bgBody["innerStroke"];
		
		upControl = holder["upControl"];
		bgUC = upControl["bg"];
		bgUCStroke = bgUC["stroke"];
		bgUCFill = bgUC["fill"];
		UCTitle = upControl["title"];
		UCTitle["txt"].autoSize = true;
		closeButton = upControl["closeButton"];
		closeButtonNormal = closeButton["normal"];
		closeButtonOver = closeButton["over"];
		closeButtonOver._alpha = 0;
		
		next = holder["next"];
		prev = holder["prev"];
		
		next["over"]._alpha = 0;
		next.onRollOver = Proxy.create(this, nextOnRollOver);
		next.onRollOut = Proxy.create(this, nextOnRollOut);
		next.onPress = Proxy.create(this, nextOnPress);
		next.onRelease = Proxy.create(this, nextOnRelease);
		next.onReleaseOutside = Proxy.create(this, nextOnReleaseOutside);
		
		prev["over"]._alpha = 0;
		prev.onRollOver = Proxy.create(this, prevOnRollOver);
		prev.onRollOut = Proxy.create(this, prevOnRollOut);
		prev.onPress = Proxy.create(this, prevOnPress);
		prev.onRelease = Proxy.create(this, prevOnRelease);
		prev.onReleaseOutside = Proxy.create(this, prevOnReleaseOutside);
		
		
		
		closeButton.onRollOver = Proxy.create(this, closeButtonOnRollOver);
		closeButton.onRollOut = Proxy.create(this, closeButtonOnRollOut);
		closeButton.onPress = Proxy.create(this, closeButtonOnPress);
		closeButton.onRelease = Proxy.create(this,closeButtonOnRelease);
		closeButton.onReleaseOutside = Proxy.create(this, closeButtonOnReleaseOutside);
		
		rightHit = holder["rightHit"];
		
		leftHit = holder["leftHit"];
	}
	

	/**
	 * Disini, penyetingan xml node, popup behavior dan item yang sedang ditekan dikirim,
	 * Sisa datanya masuk dalam movieclips
	 * @param	pNode
	 * @param	pSettingsObj
	 * @param	pPopupMode
	 * @param	pPressedItem
	 */
	public function setNode(pNode:XMLNode, pSettingsObj:Object, pPopupMode:String, pPressedItem:MovieClip )
	{
		node = pNode;
		settingsObj = pSettingsObj;
		popupMode = pPopupMode;
		pressedItem = pPressedItem;
		
		outerBg._x = outerBg._y  = -6;
		outerBg._width = Math.round(6 + settingsObj.popupWidth + 6);
		outerBg._height = Math.round(6 + settingsObj.popupHeight + 6);
		
		innerStroke._width = settingsObj.popupWidth;
		innerStroke._height = settingsObj.popupHeight;
		
		innerFill._x = innerFill._y = 1;
		innerFill._width = Math.round(settingsObj.popupWidth - 2);
		innerFill._height = Math.round(settingsObj.popupHeight - 2);
	
		var popupSettings:Object = new Object();
		popupSettings.w = Math.round(settingsObj.popupWidth - 40 - 40 - 8);
		popupSettings.h = Math.round(settingsObj.popupHeight - 80 - 30 );
		
	
		popupDes = holder.attachMovie("IDpopupDescription", "des", holder.getNextHighestDepth());
		popupDes._x = 40;  
		popupDes._y = 80;
		
		popupDes.setNode(node, popupSettings);
		
		upControl._y = upControl._x = 31;
		bgUCStroke._width = Math.round(settingsObj.popupWidth - 31 - 31);
		bgUCFill._width = Math.round(bgUCStroke._width - 2);
		UCTitle["txt"].text = node.attributes.date;
		closeButton._x = Math.round(bgUCStroke._width - closeButton._width - 7 + 7);
		
		
		
		holder._alpha = settingsObj.animationAlpha;
		holder._xscale = settingsObj.animationScale;
		
		if (popupMode == "right") {
			holder._x = Stage.width;
		}
		else {
			holder._x = -Stage.width;
		}
		
		if (pressedItem.idx == pressedItem.theParent.totalItems) {
			next.enabled = false;
		}
		
		if (pressedItem.idx == 0) {
			prev.enabled = false;
		}
		
		leftHit._alpha = rightHit._alpha = 0;
		leftHit._x = -leftHit._width;
		rightHit._x = settingsObj.popupWidth + 6
		
		leftHit._height = rightHit._height = settingsObj.popupHeight;
		
		arrowsDefs = new Object();
		if (!_global.whitePresent) {
			next._x = arrowsDefs.nx = Math.round(settingsObj.popupWidth);
		}
		else {
			next._x = arrowsDefs.nx = Math.round(settingsObj.popupWidth - 1);
		}
		
		next._y = arrowsDefs.ny = 15;
		if (!_global.whitePresent) {
			prev._x = arrowsDefs.px = -Math.round(prev._width);
		}
		else {
			prev._x = arrowsDefs.px = -Math.round(prev._width);
		}
		
		prev._y = arrowsDefs.py = 15;
		
		loadStageResize();
		
		showPopup();
		
			
		myInterval3 = setInterval(this, "launchListener", 300);
		
		this._visible = true;
	}
	
	private function launchListener() {
		clearInterval(myInterval3);
		myInterval2 = setInterval(this, "moveArrows", 30);
		
	}
	private function moveArrows() {
		if (prev.enabled == true) {
			if ((this._xmouse < 0) && (this._xmouse > -leftHit._width) && (this._ymouse > 0) && (this._ymouse < leftHit._height)) {
				Tweener.addTween(prev, { _x:this._xmouse-prev._width / 2 - 4, _y:this._ymouse-prev._height / 2, time:.08, transition:"linear", rounded:true } );
			
			}
			else {
				if ((prev._x != arrowsDefs.px) || (prev._y != arrowsDefs.py)) {
					Tweener.addTween(prev, { _x:arrowsDefs.px, _y:arrowsDefs.py, time:.3, transition:"linear" } );
				}
			}
		}
		
		if (next.enabled == true) {
			if ((this._xmouse > innerFill._width) && (this._xmouse < innerFill._width +rightHit._width) && (this._ymouse > 0) && (this._ymouse < rightHit._height)) {
				Tweener.addTween(next, { _x:this._xmouse-next._width / 2 + 6, _y:this._ymouse-next._height / 2, time:.08, transition:"linear", rounded:true } );
			
			}
			else {
				if ((next._x != arrowsDefs.nx) || (next._y != arrowsDefs.ny)) {
					Tweener.addTween(next, { _x:arrowsDefs.nx, _y:arrowsDefs.ny, time:.3, transition:"linear" } );
				}
			}
		}
		
	}
	
	private function showPopup() {
		Tweener.addTween(holder, { _x:0, _xscale:100, _alpha:100, time:settingsObj.popupShowAnimationTime, transition:settingsObj.popupShowAnimationType } );
	}
	
	public function hidePopup(pPopupMode:String) {
		popupMode = pPopupMode;
		clearInterval(myInterval);
		
		if (popupMode == "right") {
			Tweener.addTween(holder, { _x: -Stage.width-40, _xscale:settingsObj.animationScale, _alpha:settingsObj.animationAlpha, 
										time:settingsObj.popupHideAnimationTime, transition:settingsObj.popupHideAnimationType } );
		}
		else {
			Tweener.addTween(holder, { _x: Stage.width, _xscale:settingsObj.animationScale, _alpha:settingsObj.animationAlpha, 
										time:settingsObj.popupHideAnimationTime, transition:settingsObj.popupHideAnimationType } );
		}
		
		myInterval = setInterval(this, "removeThis", settingsObj.popupHideAnimationTime * 1000);
		
	}
	
	private function removeThis() {
		clearInterval(myInterval);
		this.removeMovieClip();
	}
	
	private function resize(pW:Number, pH:Number) {
		if ((pW != oldpW) || (pH != oldpH)) {
			pW = Math.max(pW, _global.globalSettingsObj.templateMaxWidth);
			pH = Math.max(pH, _global.globalSettingsObj.templateMaxHeight);
			
			oldpW = pW;
			oldpH = pH;
			
			this._x = Math.round(pW / 2 - settingsObj.popupWidth / 2);
			this._y = Math.round(pH / 2 - settingsObj.popupHeight / 2);
			
		}
	}
	
	private function onResize() {
		resize(Stage.width, Stage.height);
	}
	
	private function loadStageResize() {
		Stage.addListener(this);
		onResize();
	}
	
	
	
	
	
	
	
	
	private function nextOnRollOver() {
		Tweener.addTween(next["over"], { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function nextOnRollOut() {
		Tweener.addTween(next["over"], { _alpha:0, time:.2, transition:"linear" } );
	}
	
	private function nextOnPress() {
		nextOnRollOut();
		dispatchEvent( { target:this, type:"nextPressed", mc:this } );
	}
	
	private function nextOnRelease() {
		nextOnRollOut()
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
		prevOnRollOut();
		dispatchEvent( { target:this, type:"prevPressed", mc:this } );
	}
	
	private function prevOnRelease() {
		prevOnRollOut()
	}
	
	private function prevOnReleaseOutside() {
		prevOnRelease()
	}
	
	
	private function closeButtonOnRollOver() {
		Tweener.addTween(closeButtonOver, { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function closeButtonOnRollOut() {
		Tweener.addTween(closeButtonOver, { _alpha:0, time:.2, transition:"linear" } );
	}
	
	private function closeButtonOnPress() {
		dispatchEvent( { target:this, type:"closePressed", mc:this } );
	}
	
	private function closeButtonOnRelease() {
		closeButtonOnRollOut();
	}
	
	private function closeButtonOnReleaseOutside() {
		closeButtonOnRelease();
	}
}
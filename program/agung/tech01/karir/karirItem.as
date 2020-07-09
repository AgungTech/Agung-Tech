import mx.events.EventDispatcher;
import flash.display.BitmapData;
import asual.sa.SWFAddress;
import caurina.transitions.*;
import agung.utils.UAddr;
import agung.utils.UTf;
import ascb.util.Proxy;

class agung.tech01.karir.karirItem extends MovieClip 
{
	public var node:XMLNode;
	private var settingsObj:Object
	
	public var totalHeight:Number;
	private var itemWidth:Number;
	private var activated:Number = 0;
	public var idx:Number;
	public var theParent:MovieClip;
	
	private var holder:MovieClip;
		private var normal:MovieClip;
			private var normalBg:MovieClip;
			private var normalTitle:MovieClip;
			private var normalPlace:MovieClip;
			private var normalLine:MovieClip;
			
		private var over:MovieClip;
			private var overBg:MovieClip;
			private var overTitle:MovieClip;
			private var overPlace:MovieClip;
			private var overLine:MovieClip;
			
	private var des:MovieClip;
	private var des2:MovieClip;
	
	private var readButton:MovieClip;
		private var readButtonNormal:MovieClip;
		private var readButtonOver:MovieClip;
		private var readButtonNormal2:MovieClip;
		
	private var uploadButton:MovieClip;
		private var uploadButtonNormal:MovieClip;
		private var uploadButtonOver:MovieClip;
		private var uploadButtonNormal2:MovieClip;
	
		
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	public var urlAddress:String;
	public var urlTitle:String;
	
	private var myInterval:Number;
	
	public function karirItem() {
		EventDispatcher.initialize(this);
		
		normal = holder["normal"];
		normalBg = normal["bg"];
		normalTitle = normal["title"];
		normalPlace = normal["place"];
		normalLine = normal["line"];
		
		normalTitle["txt"].autoSize = true;
		normalTitle["txt"].wordWrap = true;
		
		normalPlace["txt"].autoSize = true;
		normalPlace["txt"].wordWrap = true;
			
		over = holder["over"];
		overBg = over["bg"];
		overTitle = over["title"];
		overPlace = over["place"];
		overLine = over["line"];
		
		overTitle["txt"].autoSize = true;
		overTitle["txt"].wordWrap = true;
		
		overPlace["txt"].autoSize = true;
		overPlace["txt"].wordWrap = true;
		
		des = holder["des"];
		UTf.initTextArea(des["txt"], true);
		over._alpha = 0;
		if (!_global.whitePresent) {
			des._alpha = 60;
		}
		
	
		
		
		des2 = holder["des2"];
		des2._alpha = 0;
		UTf.initTextArea(des2["txt"], true);
		
		readButton = holder["readButton"];
		readButtonNormal = readButton["normal"];
		readButtonNormal["txt"].autoSize = true;
		readButtonNormal["txt"].wordWrap = false;
		
		readButtonOver = readButton["over"];
		readButtonOver["txt"].autoSize = true;
		readButtonOver["txt"].wordWrap = false;
		readButtonOver._alpha = 0;
		
		readButtonNormal2 = readButton["normal2"];
		if (readButtonNormal2) {
			readButtonNormal2["txt"].autoSize = true;
			readButtonNormal2["txt"].wordWrap = false;
			readButtonNormal2._alpha = 0;
		}
		
		
		uploadButton = holder["upload"];
		uploadButtonOver = uploadButton["over"];
		uploadButtonNormal = uploadButton["normal"];
		
		uploadButtonNormal["txt"].autoSize = true;
		uploadButtonNormal["txt"].wordWrap = false;
		
		uploadButtonOver["txt"].autoSize = true;
		uploadButtonOver["txt"].wordWrap = false;
		uploadButtonOver._alpha = 0;
		
		uploadButtonNormal2 = uploadButton["over2"];
		if (uploadButtonNormal2) {
			uploadButtonNormal2["txt"].autoSize = true;
			uploadButtonNormal2["txt"].wordWrap = false;
			uploadButtonNormal2._alpha = 0;
		}
		
		normalBg.onRollOver = Proxy.create(this, bgOver);
		normalBg.onRollOut = Proxy.create(this, bgOut);
		normalBg.onPress = Proxy.create(this, bgPress);
		normalBg.onRelease = normalBg.onReleaseOutside = Proxy.create(this, bgRelease);
		
		
		readButton.onRollOver = Proxy.create(this, readButtonOverF);
		readButton.onRollOut = Proxy.create(this, readButtonOut);
		readButton.onPress = Proxy.create(this, readButtonPress);
		readButton.onRelease = readButton.onReleaseOutside = Proxy.create(this, readButtonRelease);
		
		
		uploadButton.onRollOver = Proxy.create(this, uploadButtonOverF);
		uploadButton.onRollOut = Proxy.create(this, uploadButtonOut);
		uploadButton.onPress = Proxy.create(this, uploadButtonPress);
		uploadButton.onRelease = uploadButton.onReleaseOutside = Proxy.create(this, uploadButtonRelease);
	}
	
	
	public function setNode(pNode:XMLNode, pSettingsObj:Object, pItemWidth:Number)
	{
		node = pNode;
		settingsObj = pSettingsObj;
		itemWidth = pItemWidth;

		urlTitle = _global.parentTitleLevelOne + " " + _global.globalSettingsObj.urlTitleSeparator + " " + node.attributes.browserTitle;
		
		var strArray:Array = node.attributes.browserUrl.split("/");
		
		urlAddress = UAddr.contract(_global.parentAddressLevelOne + strArray[1]) + "/";
		
		var defaultTitleBoxWidth:Number = 230;
		
			
		var defaultButtonsBoxWidth:Number = settingsObj.defaultLaunchPopupButtonsWidth;
		readButton._x = Math.round(itemWidth - defaultButtonsBoxWidth + 15);
		readButton._y = 20;
		
		readButtonNormal["txt"].text = readButtonOver["txt"].text = settingsObj.readMoreCaption;
		readButtonNormal["txt"]._x = readButtonOver["txt"]._x = 10;
		readButtonNormal["txt"]._y = readButtonOver["txt"]._y = 3;
		
		readButtonNormal["bg"]._width = readButtonOver["bg"]._width = Math.round(defaultButtonsBoxWidth - 30);
		readButtonNormal["bg"]._height = readButtonOver["bg"]._height = Math.round(readButtonNormal["txt"].textHeight + 10);
		readButtonNormal["arrow"]._x = readButtonOver["arrow"]._x = Math.round(readButtonNormal["bg"]._width - 7 -  readButtonNormal["arrow"]._width);
		readButtonNormal["arrow"]._y = readButtonOver["arrow"]._y = Math.round(readButtonNormal["bg"]._height / 2 - readButtonNormal["arrow"]._height / 2);
	
	
		if (readButtonNormal2) {
			readButtonNormal2["txt"].text = settingsObj.readMoreCaption;
			readButtonNormal2["txt"]._x =  10;
			readButtonNormal2["txt"]._y = 3;
			
			readButtonNormal2["bg"]._width = Math.round(defaultButtonsBoxWidth - 30);
			readButtonNormal2["bg"]._height = Math.round(readButtonNormal["txt"].textHeight + 10);
			readButtonNormal2["arrow"]._x = Math.round(readButtonNormal["bg"]._width - 7 -  readButtonNormal["arrow"]._width);
			readButtonNormal2["arrow"]._y = Math.round(readButtonNormal["bg"]._height / 2 - readButtonNormal["arrow"]._height / 2);
		}
		
		uploadButton._x = Math.round(itemWidth - defaultButtonsBoxWidth + 15);
		uploadButton._y = Math.round(20 + readButton._height + 17);
		
		uploadButtonNormal["txt"].text = uploadButtonOver["txt"].text = settingsObj.uploadButtonCaption;
		uploadButtonNormal["txt"]._x = uploadButtonOver["txt"]._x = 10;
		uploadButtonNormal["txt"]._y = uploadButtonOver["txt"]._y = 3;
		
		uploadButtonNormal["bg"]._width = uploadButtonOver["bg"]._width = Math.round(defaultButtonsBoxWidth - 30);
		uploadButtonNormal["bg"]._height = uploadButtonOver["bg"]._height = Math.round(uploadButtonNormal["txt"].textHeight + 10);
		uploadButtonNormal["arrow"]._x = uploadButtonOver["arrow"]._x = Math.round(uploadButtonNormal["bg"]._width - 7 -  uploadButtonNormal["arrow"]._width);
		uploadButtonNormal["arrow"]._y = uploadButtonOver["arrow"]._y = Math.round(uploadButtonNormal["bg"]._height / 2 - uploadButtonNormal["arrow"]._height / 2);
	
		if (uploadButtonNormal2) {
			uploadButtonNormal2["txt"].text =  settingsObj.uploadButtonCaption;
			uploadButtonNormal2["txt"]._x =  10;
			uploadButtonNormal2["txt"]._y =  3;
			
			uploadButtonNormal2["bg"]._width = Math.round(defaultButtonsBoxWidth - 30);
			uploadButtonNormal2["bg"]._height = Math.round(uploadButtonNormal["txt"].textHeight + 10);
			uploadButtonNormal2["arrow"]._x =  Math.round(uploadButtonNormal["bg"]._width - 7 -  uploadButtonNormal["arrow"]._width);
			uploadButtonNormal2["arrow"]._y = Math.round(uploadButtonNormal["bg"]._height / 2 - uploadButtonNormal["arrow"]._height / 2);
		}
		
		normalBg._width = overBg._width = itemWidth;
		
		normalTitle["txt"]._width = overTitle["txt"]._width = normalPlace["txt"]._width = overPlace["txt"]._width = Math.round(defaultTitleBoxWidth - 15 - 15);
	
		normalPlace["txt"].text = overPlace["txt"].text = node.attributes.location;
		
		normalTitle["txt"].text = overTitle["txt"].text = node.attributes.title;
		
		normalTitle._x = overTitle._x = normalPlace._x = overPlace._x = 15;
		
		
		normalTitle._y = overTitle._y = 20
		normalPlace._y = overPlace._y = Math.round(normalTitle._y + normalTitle._height);
		
		des._x = Math.round(defaultTitleBoxWidth + 20);
		des._y = 20;
		des["txt"]._width = Math.round(itemWidth - defaultTitleBoxWidth - defaultButtonsBoxWidth - 20);
		des["txt"].htmlText = node.firstChild.firstChild.nodeValue;
		
		des2._x = Math.round(defaultTitleBoxWidth + 20);
		des2._y = 20;
		des2["txt"]._width = Math.round(itemWidth - defaultTitleBoxWidth - defaultButtonsBoxWidth - 20);
		des2["txt"].htmlText = node.firstChild.firstChild.nodeValue;
		
		var defaultButtonsBoxHeight:Number = Math.round(20 + uploadButton._height + 10 + readButton._height + 27);
		var testHeight1:Number = Math.round(Math.max((normalPlace._y + normalPlace._height + 20), (des._y + des._height + 20)));
		var testHeightFinal:Number = Math.round(Math.max(testHeight1, defaultButtonsBoxHeight));
		
		normalBg._height = overBg._height = testHeightFinal;
		
		totalHeight = normalBg._height;
	
		normalLine._x = overLine._x = defaultTitleBoxWidth;
		normalLine._height = overLine._height = Math.round(normalPlace._y + normalPlace._height - 4);
		
		
		if (settingsObj.enableClickOnCareerItem == 0) {
			normalBg.useHandCursor = false;
		}
		
		this._visible = true;
	}
	
	private function bgOver() {
		if (activated == 0) {
			if (readButtonNormal2) {
				Tweener.addTween(readButtonNormal2, { _alpha:100, time:.2, transition:"linear" } );
			}
			if (uploadButtonNormal2) {
				Tweener.addTween(uploadButtonNormal2, { _alpha:100, time:.2, transition:"linear" } );
			}
			
			clearInterval(myInterval);
			Tweener.addTween(over, { _alpha:100, time:.2, transition:"linear" } );
			if (!_global.whitePresent) {
				Tweener.addTween(des, { _alpha:100, time:.3, transition:"linear" } );
			}
			else {
				Tweener.addTween(des2, { _alpha:100, time:.3, transition:"linear" } );
			}
			
			
		}
	}
	
	private function bgOut() {
		if (activated == 0) {
			
			clearInterval(myInterval);
			checkHit();
			myInterval = setInterval(this, "checkHit", 30);
		}
	}
	
	private function checkHit() {
		if ((this._xmouse > 0) && (this._xmouse < itemWidth) && (this._ymouse > 0) && (this._ymouse < totalHeight)) {
			
		}
		else {
			clearInterval(myInterval);
			if (readButtonNormal2) {
				Tweener.addTween(readButtonNormal2, { _alpha:0, time:.2, transition:"linear" } );
			}
			if (uploadButtonNormal2) {
				Tweener.addTween(uploadButtonNormal2, { _alpha:0, time:.2, transition:"linear" } );
			}
			Tweener.addTween(over, { _alpha:0, time:.3, transition:"linear" } );
			if (!_global.whitePresent) {
				Tweener.addTween(des, { _alpha:60, time:.3, transition:"linear" } );
			}
			else {
				Tweener.addTween(des2, { _alpha:0, time:.3, transition:"linear" } );
			}
			
			
		}
		
	}
	
	public function bgPress() {
		
		clearInterval(myInterval);
		if (settingsObj.enableClickOnCareerItem == 1) {
			_global.popupCat = "description";
			SWFAddress.setValue(urlAddress);
		}
	}
	
	private function bgRelease() {
		bgOut();
	}

	
	public function dispatchMc() {
		clearInterval(myInterval);
		SWFAddress.setTitle(urlTitle);
		dispatchEvent( { target:this, type:"itemClicked", mc:this } );
	}
	

	public function activateItem() {
		bgOver()
		activated = 1;
		
	}
	
	public function deactivateItem() {
		activated = 0;
		Tweener.addTween(over, { _alpha:0, time:.3, transition:"linear" } );
		Tweener.addTween(des2, { _alpha:0, time:.3, transition:"linear" } );
		if (readButtonNormal2) {
				Tweener.addTween(readButtonNormal2, { _alpha:0, time:.2, transition:"linear" } );
		}
		if (uploadButtonNormal2) {
				Tweener.addTween(uploadButtonNormal2, { _alpha:0, time:.2, transition:"linear" } );
			}
	}
	
	
	
	
	
	
	
	
	
	
	
	private function readButtonOverF() {
		Tweener.addTween(readButtonOver, { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function readButtonOut() {
		Tweener.addTween(readButtonOver, { _alpha:0, time:.2, transition:"linear" } );
	}
	
	public function readButtonPress() {
		_global.popupCat = "description";
		SWFAddress.setValue(urlAddress);
		readButtonOut();
	}
	
	private function readButtonRelease() {
		
	}
	
	
	
	private function uploadButtonOverF() {
		Tweener.addTween(uploadButtonOver, { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function uploadButtonOut() {
		Tweener.addTween(uploadButtonOver, { _alpha:0, time:.2, transition:"linear" } );
	}
	
	private function uploadButtonPress() {
		_global.popupCat = "contact";
		SWFAddress.setValue(urlAddress);
		uploadButtonOut()
	}
	
	private function uploadButtonRelease() {
		
	}
}
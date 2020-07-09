import mx.events.EventDispatcher;
import flash.display.BitmapData;
import caurina.transitions.*;
import ascb.util.Proxy;
import asual.sa.SWFAddress;
import agung.utils.UAddr;
import agung.utils.UTf;

class agung.tech01.penjualan.scrollerItem extends MovieClip 
{
	public var node:XMLNode;
	public var settingsObj:Object
	private var mainSettingsObj:Object;
	
	public var theDate:String;
	
	private var allHolder:MovieClip;
		
	private var hit:MovieClip; 
	public var idx:Number;
	
	private var title:MovieClip;
	
	private var normal:MovieClip;
		private var normalBg1:MovieClip;
		private var normalBg2:MovieClip;
		private var normalBg3:MovieClip;
		
	private var over:MovieClip;
		private var overBg1:MovieClip;
		private var overBg2:MovieClip;
		private var overBg3:MovieClip;
		private var overBg4:MovieClip;
	
	private var holder:MovieClip;
		private var holderMc:MovieClip;
		
	private var mask:MovieClip;
		
	private var mcl:MovieClipLoader;
	private var mcl2:MovieClipLoader;
	
	private var dims:Object;
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	private var imageOrig:Object;
	
	public var urlAddress:String;
	public var urlTitle:String;
	
	public var urlAddressPopupClose:String;
	public var urlTitlePopupClose:String;
	
	
		private var addedAtSidesWidth:Number = 11 + 11;
	private var addedAtSidesHeight:Number = 11 + 11;

	
	private var des:MovieClip;
		private var normalStroke:MovieClip;
		private var normalFill:MovieClip;
		private var desStroke:MovieClip;
		private var desFill:MovieClip;
		
		private var theText:MovieClip;
			private var theTextNormal:MovieClip;
			private var theTextOver:MovieClip;
		
			private var priceTag:MovieClip;
	
		private var detailsCaption:MovieClip;
		
		private var newLogo:MovieClip;
	
	public var tagArray:Array;
	public var foundInSearch:Number;
	
		
	public var mySearchTags:String;
	
	private var loader:MovieClip;
	
	public function scrollerItem() {
		EventDispatcher.initialize(this);
		this._visible = false;
		this.enabled = false;
		
		normal = allHolder["normal"];
		over = allHolder["over"];
		mask = allHolder["mask"];
		holder = allHolder["holder"];
		
	
		
		normalBg1 = normal["normalBg1"];
		normalBg2 = normal["normalBg2"];
		normalBg3 = normal["normalBg3"];
		
		overBg1 = over["overBg1"];
		overBg2 = over["overBg2"];
		overBg3 = over["overBg3"];
		overBg4 = over["overBg4"];
		
		over._alpha = 0;
			
		holderMc = holder["mc"];
		holder.setMask(mask);
		
		mcl = new MovieClipLoader();
		mcl.addListener(this);
		
		
		normalStroke = des["normalStroke"];
		
		normalFill = des["normalFill"];
		
		desFill = des["fill"];
		desStroke = des["stroke"];
		
		theText = des["theText"];
		theTextNormal = theText["normal"];
		theTextOver = theText["over"];
		
		UTf.initTextArea(theTextNormal["txt"], true);
		UTf.initTextArea(theTextOver["txt"], true);
	
		priceTag = des["priceTag"];
		priceTag["txt"].autoSize = true;
		priceTag["txt"].wordWrap = false;
		
		detailsCaption = des["detailsCaption"];
		detailsCaption["txt"].autoSize = true;
		detailsCaption["txt"].wordWrap = false;
		
		title = des["title"];
		
		title["normal"]["txt"].autoSize = title["over"]["txt"].autoSize = true;
		title["normal"]["txt"].wordWrap = title["over"]["txt"].wordWrap = true;
		
	}
	
	
	public function setNode(pNode:XMLNode, pSettingsObj:Object, pMainSettingsObj:Object)
	{
		node = pNode;
		settingsObj = pSettingsObj;
		mainSettingsObj = pMainSettingsObj;
	
		var nowStr:String = node.attributes.searchTags + " " + node.attributes.title;
			
		mySearchTags = nowStr;
		
	
		
		tagArray = new Array();
		tagArray = nowStr.toLowerCase().split(" ");
		tagArray.sort();
	
		var dateSpl:Array = node.attributes.date.split("/");
		theDate = dateSpl[0] + dateSpl[1] + dateSpl[2];
		trace(theDate);
		var firstLevel:String = _global.parentAddressLevelOne;
		var secondLevel:String = node.parentNode.parentNode.attributes.browserUrl;
		var thirdLevel:String = node.attributes.browserUrl;
		
		
		var strArray2:Array = secondLevel.split("/");
		var strArray3:Array = thirdLevel.split("/");
		
		urlAddress = UAddr.contract(firstLevel + "/" + strArray2[1] + "/" + strArray3[1]) + "/";
		
		
		urlAddressPopupClose = UAddr.contract(firstLevel + "/" + strArray2[1]) + "/";
		
		
		var firstLevelTitle:String = _global.parentTitleLevelOne;
		var secondLevelTitle:String = node.parentNode.parentNode.attributes.browserTitle;
		var thirdLevelTitle:String = node.attributes.browserTitle;
		
		urlTitle = firstLevelTitle + " " + _global.globalSettingsObj.urlTitleSeparator + " " + secondLevelTitle + " " + _global.globalSettingsObj.urlTitleSeparator + " " + thirdLevelTitle;
		urlTitlePopupClose = firstLevelTitle + " " + _global.globalSettingsObj.urlTitleSeparator + " " + secondLevelTitle;
		

		
		normalBg1._width = overBg1._width = Math.round(11 + settingsObj.thumbWidth + 11);
		normalBg1._height = overBg1._height = Math.round(11 + settingsObj.thumbHeight + 11);
		
		normalBg2._width = overBg2._width =  Math.round(3 + settingsObj.thumbWidth + 3);
		normalBg2._height = overBg2._height = Math.round(3 + settingsObj.thumbHeight + 3);
		
		normalBg2._x = overBg2._x = 8;
		normalBg2._y = overBg2._y = 8;
		
		
		 
		overBg3._width = Math.round(1 + settingsObj.thumbWidth + 1);
		overBg3._height = Math.round(1 + settingsObj.thumbHeight + 1);
		
		overBg3._x = overBg2._x + 2;
		overBg3._y = overBg2._y + 2;
		
		if (_global.whitePresent) {
			overBg1._x = overBg1._y = 1;
			overBg4._width = overBg1._width;
			overBg4._height = overBg1._height;
			
			overBg1._width -= 2;
			overBg1._height -= 2;
			
			
			normalBg1._x = normalBg1._y = 1;
			normalBg3._width = normalBg1._width;
			normalBg3._height = normalBg1._height;
			
			normalBg1._width -= 2;
			normalBg1._height -= 2;
			
		}
		
		holder._alpha = 0;
		holder._x = holder._y = mask._x = mask._y = 11;
		mask._width = settingsObj.thumbWidth;
		mask._height = settingsObj.thumbHeight;
		
		dims = new Object();
		dims.x = 0;
		dims.y = 0;
		dims.w = this._width;
		dims.h = this._height;
		
		hit._width = dims.w;
		hit._height = dims.h;
		
		desStroke._width = normalStroke._width = Math.ceil(addedAtSidesWidth + normalBg1._width);
		desStroke._height = normalStroke._height = Math.ceil(addedAtSidesHeight + normalBg1._height + settingsObj.thumbDescriptionHeight);
		desStroke._alpha = 0;
		
		desFill._width = normalFill._width = desStroke._width - 2;
		desFill._height = normalFill._height = desStroke._height - 2;
		desFill._alpha = 0;
		
		title["normal"]["txt"].text = title["over"]["txt"].text = node.attributes.title;
		title["normal"]["txt"]._width = title["over"]["txt"]._width = Math.ceil(desStroke._width - addedAtSidesWidth);
		
		theTextNormal["txt"]._width = theTextOver["txt"]._width = Math.ceil(desStroke._width - addedAtSidesWidth);
		theTextNormal["txt"].htmlText = theTextOver["txt"].htmlText = node.firstChild.firstChild.nodeValue;
		
		
		theText._x = title._x = Math.ceil(addedAtSidesWidth / 2);
		title._y =  Math.ceil(normalBg1._height + addedAtSidesHeight);
		theText._y = Math.ceil(title._y + title["normal"]["txt"].textHeight);
		title["over"]._alpha = 0;
		theTextOver._alpha = 0;
		
		var thePriceActualText:String = "";
		
		if (_global.cartSettings.currencyPosition == "after") {
			thePriceActualText = node.attributes.price + _global.cartSettings.currency;
		}
		else {
			thePriceActualText = _global.cartSettings.currency + node.attributes.price;
		}
		
		priceTag["txt"].text = thePriceActualText;
		
		
		var my_fmt:TextFormat = new TextFormat();
		my_fmt.bold = true;

		priceTag["txt"].setTextFormat(my_fmt);


		priceTag._y = Math.ceil(desStroke._height - priceTag["txt"].textHeight - 10);
		priceTag._x = Math.ceil(addedAtSidesWidth / 2);
		priceTag._alpha = 50;
		
		
		
		detailsCaption["txt"].text = mainSettingsObj.detailsCaptionOnSimpleProductDisplay;
		detailsCaption._x = Math.ceil(desStroke._width - detailsCaption["txt"].textWidth - 10);
		detailsCaption._y = Math.ceil(desStroke._height - detailsCaption["txt"].textHeight - 8);
		detailsCaption._alpha = 0;
		
		allHolder._alpha = 0;
		
		loader._x = Math.ceil(normalBg1._width / 2 - loader._width / 2);
		loader._y = Math.ceil(normalBg1._height / 2 - loader._height / 2);
		loader._x += addedAtSidesWidth / 2;
		loader._y += addedAtSidesHeight / 2;
		
		this._visible = true;
	}
	
	public function startLoad() {
		
		mcl.loadClip(node.attributes.src, holderMc);
	}
	
	private function onLoadInit(mc:MovieClip) {
		getImage(mc, true);
		
		imageOrig = new Object();
		
		imageOrig.w = mc._width;
		imageOrig.h = mc._height;
		
		if (settingsObj.toggleProportionalResizeOnThumb == 0) {
			mc._width = settingsObj.thumbWidth;
			mc._height = settingsObj.thumbHeight;
			
		
		}
		else {
			var o:Object = getDims(settingsObj.proportionalResizeType, mc._width, mc._height, settingsObj.thumbWidth, settingsObj.thumbHeight, true);
			
				mc._width = o.w;
				mc._height = o.h;
				
			if (settingsObj.proportionalResizeType == "fit") {
				var newWidth:Number = Math.round(11 + o.w + 11);
				var newHeight:Number = Math.round(11 + o.h + 11);
				
				Tweener.addTween(normalBg2, { _width:Math.round(3 + o.w + 3), _height:Math.round(3 + o.h + 3), time:0.2, transition:"linear" } );
				
				Tweener.addTween(overBg2, { _width:Math.round(3 + o.w + 3), _height:Math.round(3 + o.h + 3), time:0.2, transition:"linear" } );
				
				Tweener.addTween(overBg3, { _width:Math.round(1 + o.w + 1), _height:Math.round(1 + o.h + 1), time:0.2, transition:"linear" } );
				
				Tweener.addTween(allHolder, { _x:Math.round(dims.x + dims.w / 2 - newWidth / 2 + addedAtSidesWidth / 2), _y:Math.round(dims.y + dims.h / 2 - newHeight / 2 + addedAtSidesHeight / 2), time:0.2, transition:"linear" } );
				
				 if (_global.whitePresent) {
					 Tweener.addTween(normalBg1, { _width:Math.round(11 + o.w + 11 - 2), _height:Math.round(11 + o.h + 11 - 2), time:0.2, transition:"linear" } );
					 Tweener.addTween(overBg1, { _width:Math.round(11 + o.w + 11 - 2), _height:Math.round(11 + o.h + 11 - 2), time:0.2, transition:"linear" } );
					 
					 Tweener.addTween(overBg4, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
					 Tweener.addTween(normalBg3, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
				 }
				 else {
					 Tweener.addTween(normalBg1, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
					 Tweener.addTween(overBg1, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
				 }
				 
			}
			else {
				mc._x = o.x;
				mc._y = o.y;
				
			}
		}
		
		Tweener.addTween(holder, { _alpha:100, time:0.2, transition:"linear" } );
		Tweener.addTween(allHolder, { _alpha:100, time:0.2, transition:"linear" } );
		
		dispatchEvent( { target:this, type:"thumbLoaded", mc:this } );
		
		var loadAddress:Array = String(node.firstChild.nextSibling.firstChild.attributes.imageAddress).split(".");
		
		var lastL:Number = loadAddress.length - 1;
		
		allHolder._x += addedAtSidesWidth / 2;
		allHolder._y += addedAtSidesHeight / 2;
		
		this.enabled = true;
		
		if (node.attributes.enableNewLabel == 1) {
			var mcl2:MovieClipLoader = new MovieClipLoader();
			mcl2.loadClip(mainSettingsObj.newLogoSrc, newLogo);
		}
		
		loader.cancelSpin();
	}
	
	private function onLoadError(mc:MovieClip) {
		dispatchEvent( { target:this, type:"thumbLoaded", mc:this } );
		loader.cancelSpin();
		this.enabled = true;
	}
	

	private function onRollOver() {
		if ((settingsObj.toggleProportionalResizeOnThumb == 1) && (settingsObj.proportionalResizeType == "crop")) {
			var o:Object = getDims("fit", imageOrig.w, imageOrig.h, settingsObj.thumbWidth, settingsObj.thumbHeight, true);
			Tweener.addTween(holder["mc"], { _width:o.w, _height:o.h, _x:0, _y:0, time:0.2, transition:"linear" } );
		
			var newWidth:Number = Math.round(11 + o.w + 11);
			var newHeight:Number = Math.round(11 + o.h + 11);
				
			Tweener.addTween(normalBg2, { _width:Math.round(3 + o.w + 3), _height:Math.round(3 + o.h + 3), time:0.2, transition:"linear" } );
				
			Tweener.addTween(overBg2, { _width:Math.round(3 + o.w + 3), _height:Math.round(3 + o.h + 3), time:0.2, transition:"linear" } );
				
			Tweener.addTween(overBg3, { _width:Math.round(1 + o.w + 1), _height:Math.round(1 + o.h + 1), time:0.2, transition:"linear" } );
				
			Tweener.addTween(allHolder, { _x:Math.round(dims.x + dims.w / 2 - newWidth / 2 + addedAtSidesWidth/2), _y:Math.round(dims.y + dims.h / 2 - newHeight / 2+addedAtSidesHeight/2), time:0.2, transition:"linear" } );
				
			
			 if (_global.whitePresent) {
					 Tweener.addTween(normalBg1, { _width:Math.round(11 + o.w + 11 - 2), _height:Math.round(11 + o.h + 11 - 2), time:0.2, transition:"linear" } );
					 Tweener.addTween(overBg1, { _width:Math.round(11 + o.w + 11 - 2), _height:Math.round(11 + o.h + 11 - 2), time:0.2, transition:"linear" } );
					 
					 Tweener.addTween(overBg4, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
					 Tweener.addTween(normalBg3, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
				 }
				 else {
					 Tweener.addTween(normalBg1, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
					 Tweener.addTween(overBg1, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
				 }
		}
			
		
		Tweener.addTween(over, { _alpha:100, time:0.2, transition:"linear" } );
		Tweener.addTween(theTextOver, { _alpha:100, time:0.2, transition:"linear" } );
		Tweener.addTween(detailsCaption, { _alpha:100, time:0.2, transition:"linear" } );
		
			Tweener.addTween(desStroke, { _alpha:100, time:0.5, transition:"linear" } );
	
		
		Tweener.addTween(priceTag, { _alpha:100, time:0.2, transition:"linear" } );
		Tweener.addTween(title["over"], { _alpha:100, time:0.2, transition:"linear" } );
		Tweener.addTween(desFill, { _alpha:100, time:0.2, transition:"linear" } );
		
		dispatchEvent( { target:this, type:"thumbRollOver", mc:this } );
	}
	
	private function onRollOut() {
		if ((settingsObj.toggleProportionalResizeOnThumb == 1) && (settingsObj.proportionalResizeType == "crop")) {
			var o:Object = getDims("crop", imageOrig.w, imageOrig.h, settingsObj.thumbWidth, settingsObj.thumbHeight, true);
			Tweener.addTween(holder["mc"], { _width:o.w, _height:o.h, _x:o.x, _y:o.y, time:0.2, transition:"linear" } );
		
			
			
			
				var newWidth:Number = dims.w;
				var newHeight:Number = dims.h;
				o.w = settingsObj.thumbWidth;
				o.h = settingsObj.thumbHeight;
				
				Tweener.addTween(normalBg2, { _width:Math.round(3 + o.w + 3), _height:Math.round(3 + o.h + 3), time:0.2, transition:"linear" } );
				
				Tweener.addTween(overBg2, { _width:Math.round(3 + o.w + 3), _height:Math.round(3 + o.h + 3), time:0.2, transition:"linear" } );
				
				Tweener.addTween(overBg3, { _width:Math.round(1 + o.w + 1), _height:Math.round(1 + o.h + 1), time:0.2, transition:"linear" } );
				
				Tweener.addTween(allHolder, { _x:Math.round(dims.x + dims.w / 2 - newWidth / 2 +  addedAtSidesWidth / 2), _y:Math.round(dims.y + dims.h / 2 - newHeight / 2 + addedAtSidesHeight / 2), time:0.2, transition:"linear" } );
				
				
				 if (_global.whitePresent) {
					 Tweener.addTween(normalBg1, { _width:Math.round(11 + o.w + 11 - 2), _height:Math.round(11 + o.h + 11 - 2), time:0.2, transition:"linear" } );
					 Tweener.addTween(overBg1, { _width:Math.round(11 + o.w + 11 - 2), _height:Math.round(11 + o.h + 11 - 2), time:0.2, transition:"linear" } );
					 
					 Tweener.addTween(overBg4, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
					 Tweener.addTween(normalBg3, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
				 }
				 else {
					 Tweener.addTween(normalBg1, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
					 Tweener.addTween(overBg1, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
				 }
				
				
		}
		
		Tweener.addTween(over, { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(theTextOver, { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(detailsCaption, { _alpha:0, time:0.2, transition:"linear" } );
	
			Tweener.addTween(desStroke, { _alpha:0, time:0.1, transition:"linear" } );
	
		
		Tweener.addTween(priceTag, { _alpha:50, time:0.2, transition:"linear" } );
		Tweener.addTween(title["over"], { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(desFill, { _alpha:0, time:0.2, transition:"linear" } );
		
		dispatchEvent( { target:this, type:"thumbRollOut", mc:this } );
	}
	

	private function onRelease() {
		onRollOut();
	}
	
	private function onReleaseOutside() {
		onRelease();
	}
	
	
	
	public function dispatchMc() {
		SWFAddress.setTitle(urlTitle);
		dispatchEvent( { target:this, type:"thumbClicked", mc:this } );
	}
	
	public function onPress() {
	
		SWFAddress.setValue(urlAddress);
	}
	
	
	private function getImage(mc:MovieClip, smooth:Boolean) {
		smooth == undefined ? smooth = true : null;
		
		var mcDepth:Number 		= mc.getDepth();
		var mcName:String 		= mc._name;
		var mcParent:MovieClip 	= mc._parent;
		var mcAlpha:Number 		= mc._alpha;
		var mcVisible:Boolean 	= mc._visible;
		
		mc._xscale = 100;
		mc._yscale = 100;
		
		var bmp:BitmapData = new BitmapData(mc._width, mc._height, true, 0);
		bmp.draw(mc);
		
		mc.removeMovieClip();
		
		var newMc:MovieClip = mcParent.createEmptyMovieClip(mcName, mcDepth);
		newMc.attachBitmap(bmp, newMc.getNextHighestDepth(), "auto", smooth);
		
		newMc._alpha 	= mcAlpha;
		newMc._visible 	= mcVisible;
		
		return newMc;
	}
	
	// Utils.getDims("fit", 100, 200, 50, 50, true)
	// returns: new width and height in pixels
	// type:String - "fit" or "crop"
	// ow:Number, oh:Number - object original width and height
	// mw:Number, mh:Number - maximum width and height
	// scaleUp:Boolean - if true, the image will be scal;ed up even if it is smaller than mwxmh
	private function getDims(type:String, ow:Number, oh:Number, mw:Number, mh:Number, scaleUp:Boolean) {
		scaleUp == undefined ? scaleUp = false : null;
		
		var cw:Number = ow;
		var ch:Number = oh;
		
		if (scaleUp || ow > mw || oh > mh) {
		
			cw = mw;
			ch = mw * oh / ow;
			
			if ((ch > mh && type == "fit") || (ch < mh && type != "fit")) {
				ch = mh;
				cw = mh * ow / oh;
			}
			
		}
		
		var cx:Number = Math.round((mw - cw) / 2 );
		var cy:Number = Math.round((mh - ch) / 2 );
		
		return {w: cw, h: ch, x: cx, y: cy};
	}
	
}
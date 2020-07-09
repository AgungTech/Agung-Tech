import caurina.transitions.*;
import ascb.util.Proxy;
import agung.utils.UMc;
import agung.utils.UTf;
import asual.sa.SWFAddress;
import agung.utils.UAddr;

/**
 * This class handles the main panel, the one you see upon accessing the module
 */
class agung.tech01.pemesanan.mainDescription extends MovieClip
{
	private var settingsObj:Object;
	private var mainSettingsObj:Object;
	private var scrollerBoxSettingsObj:Object;
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
	
	private var holder:MovieClip;
		private var block:MovieClip;
		private var lst:MovieClip;
		private var mask:MovieClip;
		private var bg:MovieClip;
		private var scroller:MovieClip;
			private var stick:MovieClip;
			private var bar:MovieClip;
		
		private var captions:MovieClip;
			
	private var scanImageIdx:Number = 0
	private var totalWidth:Number = 0;
	private var lstHeight:Number = 0;
	
	
	private var theList:Array;
	
	private var contShop:MovieClip;
	private var totalSum:MovieClip;
	
	private var checkout:MovieClip;
		
	private var xml:XML;
	private var lv:LoadVars;
	public function mainDescription() {
		this._visible = false;

		lst = holder["lst"];
		mask = holder["mask"];
		scroller = holder["scroller"];
		stick = scroller["stick"];
		bar = scroller["bar"];
			
		block = holder["block"];
		block.onPress = null;
		block._visible = false;
		block.useHandCursor = false;
		
		
		captions["product"].autoSize = true;
		captions["product"].wordWrap = false;
		
		captions["price"].autoSize = true;
		captions["price"].wordWrap = false;
		
		captions["quantity"].autoSize = true;
		captions["quantity"].wordWrap = false;
		
		contShop["txt"].autoSize = true;
		contShop["txt"].wordWrap = false;
		
		captions["total"].autoSize = true;
		captions["total"].wordWrap = false;
		
		
		totalSum["t"].autoSize = true;
		totalSum["t"].wordWrap = false;
		
		
		totalSum["txt"].autoSize = true;
		totalSum["txt"].wordWrap = false;
		
		checkout["txt"].autoSize = true;
		checkout["txt"].wordWrap = false;
		
		lv = new LoadVars();
		lv.onLoad = Proxy.create(this, varsLoaded);
		lst.setMask(mask);
	}
	
	
	/**
	 * Here, the settings are being set, the rest of the data is taken from the cookies
	 * @param	pSettings
	 */
	public function setSettings(pSettings:Object) {
		settingsObj = pSettings;
		captions["product"].text = settingsObj.titleCaption;
		captions["price"].text = settingsObj.priceCaption;
		captions["quantity"].text = settingsObj.quantityCaption;
		captions["total"].text = settingsObj.totalCaptionOnTop;
		
		totalWidth = settingsObj.moduleWidth - 12;
		captions["total"]._x = Math.ceil(totalWidth - settingsObj.totalColumnWidth);
		captions["quantity"]._x = Math.ceil(captions["total"]._x - settingsObj.quantityColumnWidth);
		captions["price"]._x = Math.ceil(captions["quantity"]._x - settingsObj.priceColumnWidth);
		
		
		bg._width = settingsObj.moduleWidth;
		bg._height = Math.ceil(settingsObj.moduleHeight - 40);
		
		
			
		holder._y = Math.ceil(captions._height + captions._y + 8);
		
		mask._width = block._width = settingsObj.moduleWidth - 16;
		mask._height = block._height = Math.ceil(settingsObj.moduleHeight - 40 - holder._y - 16 - 26);
		stick._height = mask._height;

		scroller._x = Math.round(mask._width + 4);
		
		contShop["txt"].text = settingsObj.continueShoppingCaption;
		contShop["over"]._width = contShop["normal"]._width = Math.ceil(contShop["txt"].textWidth + 6 + 6 + 17);
		
		contShop["txt2"].autoSize = true;
		contShop["txt2"].wordWrap = false;
		contShop["txt2"].text = settingsObj.continueShoppingCaption;
		contShop["txt2"]._alpha = 0;
		contShop["ar2"]._alpha = 0;
		
		contShop["over"]._alpha = 0;
		contShop.onPress = Proxy.create(this, contShopOnPress);
		contShop.onRollOver = Proxy.create(this, contShopOnRollOver);
		contShop.onRollOut = Proxy.create(this, contShopOnRollOut);

		contShop._y = Math.ceil(bg._height + 7);
		contShop._x = 0;
		
		totalSum["t"].text = settingsObj.totalCaptionOnBottom;
		totalSum._y = Math.round(mask._height + 7 + holder._y);
		totalSum._x = Math.round(captions["total"]._x  + holder._x + 30 - captions["total"]._width - 65);
		totalSum["txt"]._x = Math.ceil(totalSum["t"]._width);
	
		checkout["txt"].text = _global.cartSettings.checkoutCaption;
		checkout["normal"]._width = checkout["over"]._width = Math.ceil(checkout["txt"].textWidth +6 + 6 + 19);
		
		checkout._y = Math.ceil(contShop._y)
		checkout._x = Math.ceil(settingsObj.moduleWidth - checkout._width - 2);
		
		checkout["txt2"].autoSize = true;
		checkout["txt2"].wordWrap = false;
		checkout["txt2"].text = settingsObj.checkoutCaption;
		checkout["txt2"]._alpha = 0;
		checkout["ar2"]._alpha = 0;
		
		checkout["over"]._alpha = 0;
		checkout.onPress = Proxy.create(this, checkoutOnPress);
		checkout.onRollOver = Proxy.create(this, checkoutOnRollOver);
		checkout.onRollOut = Proxy.create(this, checkoutOnRollOut);
		
		_global.totalSumCartDisplay = this;
			if (_global.whitePresent) {
				contShop._x = 21
				checkout._x = Math.ceil(contShop._x + contShop._width + 13)
				
				contShop._y = checkout._y = Math.ceil(totalSum._y -1);
				
				totalSum._y += 1;
				totalSum._x += 2;
				
				scroller._x += 2;
			}
		
		updateTheList();
	
		this._visible = true;
	}
	
	private function checkoutOnPress() {
		checkoutOnRollOut();
		checkout.enabled = false;
		block._visible = true;
		
		var myUrl:String = settingsObj.sendScript + "?";
		var idx:Number = 0;
		var myArr:Array = _global.shopHandler.itemsToPurchase;
		var payPalString:String = "";
		
		while (myArr[idx]) {
			myUrl += "p_" + String(myArr[idx].id) + "=" + myArr[idx].quantity + "&";
			var idx2 = idx + 1;
			
			payPalString += "&item_name_" + idx2 + "=" + String(myArr[idx].name) + "&amount_" + idx2 + "=" + Number(myArr[idx].price) + "&quantity_" + idx2 + "=" + Number(myArr[idx].quantity) + "&on0_" + idx2 + "=" + settingsObj.skuName + "&os0_" + idx2 + "=" + String(myArr[idx].id);
			
			idx++;
		}
		
		trace(payPalString);
		
		if (settingsObj.checkoutHandledByAdmin == 1) {
			getURL(myUrl, "_self");
		}
		else {
			var thePUrl:String = settingsObj.paypalUrl 
								+ "?currency_code=" + settingsObj.currencyCode
								+ "&business=" + settingsObj.businessEmail
								+ "&cmd=_cart&upload=1" + payPalString;
								
								trace(thePUrl)
			getURL(thePUrl, "_self");
			trace("paypal direct!")
		}
	}
	
	private function varsLoaded(s:Boolean) {
		checkout.enabled = true;
		block._visible = false;
		
		if (!s) {
			trace("err on send to server");	
		}
	}
	
	private function checkoutOnRollOver() {
		Tweener.addTween(checkout["over"], { _alpha:100, time:0.2, transition:"linear" } );
		Tweener.addTween(checkout["ar2"], { _alpha:100, time:0.2, transition:"linear" } );
		Tweener.addTween(checkout["txt2"], { _alpha:100, time:0.2, transition:"linear" } );
	}
	
	private function checkoutOnRollOut() {
		Tweener.addTween(checkout["over"], { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(checkout["ar2"], { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(checkout["txt2"], { _alpha:0, time:0.2, transition:"linear" } );
	}
	
	public function updateTotal() {
		var thePriceActualText:String = "";
		if (_global.cartSettings.currencyPosition == "after") {
			thePriceActualText = _global.totalCost + _global.cartSettings.currency;
		}
		else {
			thePriceActualText = _global.cartSettings.currency + _global.totalCost;
		}
		
		if (_global.totalCost == 0) {
			totalSum._visible = checkout._visible = false;
		}
		else {
			totalSum._visible = checkout._visible = true;
		}
		
		totalSum["txt"].text = thePriceActualText;
		
		
		
		var my_fmt:TextFormat = new TextFormat();
		my_fmt.bold = true;
		totalSum["txt"].setTextFormat(my_fmt);
		
	}
	
	public function updateTheList() {
		theList = _global.shopHandler.getCurrentList();
		
		var idx:Number = 0;
		while (lst["cartI" + idx]) {
			lst["cartI" + idx].removeMovieClip();
			idx++;
		}
		
		var idx:Number = 0;
		var currentPos:Number = 0;
		
		while (theList[idx]) {
			var currentItem:MovieClip = lst.attachMovie("IDcartItem", "cartI" + idx, lst.getNextHighestDepth());
			currentItem._y = currentPos;
			currentItem.setData(theList[idx], settingsObj, idx);
			currentPos += 34 + 8;
			idx++;
		}
		
		if (lst["cartI" + 0]) {
			lst["cartI" + 0].updateTotal();
		}
		
		updateTotal();
	
		
		ScrollBox();
	}
	
	private function contShopOnPress() {
		_global.shopsArray[0].ponRelease();
	}
	
	private function contShopOnRollOver() {
		Tweener.addTween(contShop["over"], { _alpha:100, time:0.2, transition:"linear" } );
		Tweener.addTween(contShop["txt2"], { _alpha:100, time:0.2, transition:"linear" } );
		Tweener.addTween(contShop["ar2"], { _alpha:100, time:0.2, transition:"linear" } );
	}
	
	private function contShopOnRollOut() {
		Tweener.addTween(contShop["over"], { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(contShop["txt2"], { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(contShop["ar2"], { _alpha:0, time:0.2, transition:"linear" } );
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
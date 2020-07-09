import ascb.util.Proxy;
import caurina.transitions.*;
import asual.sa.SWFAddress;
import agung.utils.UAddr;
import agung.utils.UTf;

/**
 * This class handles the top shop small preview
 */
class agung.tech01.main.shopPreview extends MovieClip
{
	private var hit:MovieClip;
	
	private var handler:MovieClip;
		private var bg:MovieClip;
		private var lst:MovieClip;
	
		private var view:MovieClip;
	
	private var icon:MovieClip;
		private var actualIcon:MovieClip;
	
	private var openedState:Number = 0 ;
	private var permitRollOut:Number = 1;
	private var myInterval:Number;
	private var defXHandler:Number;
	private var defYHandler:Number;
	
	private var myInterval2:Number;
	
	private var check:MovieClip;
	
	private var emptyState:Number = 1;
	
	
	private var handlerEmpty:MovieClip;
	private var whitePresent:MovieClip;
	
	public function shopPreview() {
		handler["lastProductsCaption"].autoSize = true;
		handler["lastProductsCaption"].wordWrap = false;
		
		view = handler["view"];
		
		view["txt"].autoSize = true;
		view["txt"].wordWrap = false;
	
		check = handler["check"];
		check["txt"].autoSize = true;
		check["txt"].wordWrap = false;
		
		handler["total"].autoSize = true;
		handler["total"].wordWrap = false;
		
		handler["sum"].autoSize = true;
		handler["sum"].wordWrap = false;
		
		icon.onRollOver = Proxy.create(this, iconOnRolOver);
		icon.onRollOut = Proxy.create(this, iconOnRolOut);
		icon.onPress = icon.onRelease = icon.onReleaseOutside = null;
		
		actualIcon = icon["actualIcon"];
		actualIcon["over"]._alpha = 0;
		icon["bg"]._alpha = 0;
		var cor:Number = 13;
			if (whitePresent) {
				var cor:Number = 15;
			}
		hit._x = handler._x = handlerEmpty._x = defXHandler = Math.ceil( -handler._width + 75 + cor);
		hit._y = handler._y = handlerEmpty._y = defYHandler = 26;
		
		handler["bg"].onPress = null;
		handler["bg"].useHandCursor = false;
		
		handler._visible = handlerEmpty._visible = false;
		handler._x = handlerEmpty._x = Stage.width + 100;
		
	//	this.enabled = icon.enabled = false;
		//actualIcon["normal"]._alpha = 70;
		if (whitePresent) {
				check["txt2"].autoSize = true;
				check["txt2"].wordWrap = false;
				view["txt2"].autoSize = true;
				view["txt2"].wordWrap = false;
		
				hit._x = handler._x = handlerEmpty._x = defXHandler += 11
		}
		lst = handler["lst"];
	}
	
	private function iconOnRolOver() {
		if (openedState == 0) {
			Tweener.addTween(icon["bg"], { _alpha:100, time:.2, transition:"linear" } );
			Tweener.addTween(actualIcon["over"], { _alpha:100, time:.2, transition:"linear" } );
			permitRollOut = 0;
			
			openCart();
			clearInterval(myInterval2);
			clearInterval(myInterval);
			myInterval = setInterval(this, "scanCart", 30);
		}
	}
	
	private function iconOnRolOut() {
		if (permitRollOut == 1) {
			Tweener.addTween(icon["bg"], { _alpha:0, time:.2, transition:"linear" } );
			Tweener.addTween(actualIcon["over"], { _alpha:0, time:.2, transition:"linear" } );
		}
	}
	
	private function scanCart() {
		if (emptyState == 0) {
			if ((hit._xmouse > 0) && (hit._xmouse < hit._width) && (hit._ymouse > -4) && (hit._ymouse < hit._height)) {
				//trace("ok");
			}
			else {
				if ((icon["hit"]._xmouse > 0) && (icon["hit"]._xmouse < icon["hit"]._width) && (icon["hit"]._ymouse > 0) && (icon["hit"]._ymouse < icon["hit"]._height)) {
						//trace("ok");
				}
				else {
					//trace("not ok");
					permitRollOut = 1;
					iconOnRolOut();
					clearInterval(myInterval);
					hideCart();
				}
				
			}
		}
		else {
			if ((hit._xmouse > 0) && (hit._xmouse < hit._width) && (hit._ymouse > -4) && (hit._ymouse < handlerEmpty["bg"]._height)) {
				//trace("ok");
			}
			else {
				if ((icon["hit"]._xmouse > 0) && (icon["hit"]._xmouse < icon["hit"]._width) && (icon["hit"]._ymouse > 0) && (icon["hit"]._ymouse < icon["hit"]._height)) {
						//trace("ok");
				}
				else {
					//trace("not ok");
					permitRollOut = 1;
					iconOnRolOut();
					clearInterval(myInterval);
					hideCart();
				}
				
			}
		}
		
	}
	
	private function openCart() {
		if (handler.enabled == true) {
			handler._visible = true;
		}
		
		if (handlerEmpty.enabled == true) {
			handlerEmpty._visible = true;
		}
		
		clearInterval(myInterval);
		Tweener.addTween(handler, { _x:defXHandler, _y:defYHandler, time:.5, transition:"easeOutQuad" } );
		Tweener.addTween(handlerEmpty, { _x:defXHandler, _y:defYHandler, time:.5, transition:"easeOutQuad" } );
	}
	
	private function hideCart() {
		Tweener.addTween(handler, { _x:Stage.width + 100, _y:defYHandler, time:.5, transition:"easeOutQuad", onComplete:Proxy.create(this, invisHandler) } );
		Tweener.addTween(handlerEmpty, { _x:Stage.width + 100, _y:defYHandler, time:.5, transition:"easeOutQuad", onComplete:Proxy.create(this, invisHandlerEmpty) } );
	}
	
	private function invisHandler() {
		handler._visible = false;
	}
	
	private function invisHandlerEmpty() {
		handlerEmpty._visible = false;
	}
	
	public function init() {
		handler["lastProductsCaption"].text = _global.cartSettings.topCartLastProductsCaption;
		
		view["txt"].text = _global.cartSettings.topCartViewFullCartCaption;
		view["normal"]._width = view["over"]._width = Math.ceil(view["txt"].textWidth + 15);
		
		view._y += 54;
		view["over"]._alpha = 0
		view.onPress = Proxy.create(this, viewOnPress);
		view.onRollOver = Proxy.create(this, viewOnRollOver);
		view.onRollOut = Proxy.create(this, viewOnRollOut);
		
		
		handler["total"].text = _global.cartSettings.totalCaptionOnTop;
		handler["total"]._x = Math.ceil(380 - 120);
		
		handler["sum"]._x = Math.ceil(380 - 32);
		
		check["txt"].text = _global.cartSettings.topCartCheckoutButton;
		check["normal"]._width = check["over"]._width = Math.ceil(check["txt"].textWidth + 6 + 6 + 19);
		
		check["over"]._alpha = 0;
		check.onPress = Proxy.create(this, checkOnPress);
		check.onRollOver = Proxy.create(this,checkOnRollOver);
		check.onRollOut = Proxy.create(this, checkOnRollOut);
		
		check._y = view._y;
		check._x = Math.ceil(handler["bg"]._width - check._width - 17);
		handler["total"]._x = Math.ceil(view._x + view._width + 2);
		handler["sum"]._x = Math.ceil(handler["total"]._x + handler["total"].textWidth + 6)
		
		handler["total"]._y = handler["sum"]._y = view._y;
		
		if (whitePresent) {
			
		
	
		
			check["a"]._alpha = check["txt2"]._alpha = 0;
			check["txt2"].text = _global.cartSettings.topCartCheckoutButton;
			
			
				view["txt2"].text = _global.cartSettings.topCartViewFullCartCaption;
				view["txt2"]._alpha = 0;
		}
		UTf.initTextArea(handlerEmpty["txt"], true);
		handlerEmpty["txt"].htmlText =  _global.cartSettings.emptyCartCaption;
	}
	
	public function updateItems() {
		var idx:Number = 1;
		while (lst["shopPreviewItem" + idx]) {
			lst["shopPreviewItem" + idx].removeMovieClip();
			idx++;
		}
		
		var myArr:Array = _global.shopHandler.getCurrentList();
		var idx:Number = 1;
		var currentPos:Number = 0;
		
		for (idx = 1; idx <= 4; idx++) {
			if (myArr[myArr.length - idx]) {
				var currentItem:MovieClip = lst.attachMovie("IDshopPreviewItem", "shopPreviewItem" + idx, lst.getNextHighestDepth());
				currentItem.setData(myArr[myArr.length - idx]);
				currentItem._y = currentPos;
				currentPos += 29;
			}
		}

		var thePriceActualText:String = "";
		if (_global.cartSettings.currencyPosition == "after") {
			thePriceActualText = _global.totalCost + _global.cartSettings.currency;
		}
		else {
			thePriceActualText = _global.cartSettings.currency + _global.totalCost;
		}
		
		handler["sum"].text = thePriceActualText
		
		if (currentPos > 0) {
			view._visible = handler["total"]._visible = handler["sum"]._visible = true;
			
			this.enabled = icon.enabled = true;
			actualIcon["normal"]._alpha = 100;
			
			emptyState = 0;
			
		}
		else {
		//	permitRollOut = 1;
			//iconOnRolOut();
			//clearInterval(myInterval);
			//hideCart();
			//this.enabled = icon.enabled = false;
		//	actualIcon["normal"]._alpha = 70;
		 
			emptyState = 1;
		}
		
		
		if (emptyState == 1) {
			handler.enabled = false;
			handler._visible = false;
			handlerEmpty.enabled = true;
		}
		else {
			handler.enabled = true;
			handlerEmpty.enabled = false;
			handlerEmpty._visible = false;
		}
		var my_fmt:TextFormat = new TextFormat();
		my_fmt.bold = true;

		handler["sum"].setTextFormat(my_fmt);
		
		
		var sideSpace:Number = Math.ceil(check._x - view._x - view._width);
		
		handler["total"]._x = Math.ceil(view._x + view._width + 2);
		handler["sum"]._x = Math.ceil(handler["total"]._x + handler["total"].textWidth + 6);
		var totSpace = Math.ceil(handler["total"]._width + handler["sum"]._width + 6);
		var difSpace:Number = Math.ceil(sideSpace / 2 - totSpace / 2) - 1;
		
		handler["total"]._x += difSpace;
		handler["sum"]._x += difSpace;
	}
	
	private function viewOnPress() {
		viewOnRollOut();
				permitRollOut = 1;
				iconOnRolOut();
				clearInterval(myInterval);
				hideCart();
				
				clearInterval(myInterval2);
				myInterval2 = setInterval(this, "gogo", 500);
			
	}
	
	private function gogo() {
		clearInterval(myInterval2);
		_global.cartArray[0].ponRelease();
	}
	
	private function viewOnRollOver() {
		Tweener.addTween(view["over"], { _alpha:100, time:.2, transition:"linear" } );
		Tweener.addTween(view["txt2"], { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function viewOnRollOut() {
		Tweener.addTween(view["over"], { _alpha:0, time:.2, transition:"linear" } );
		Tweener.addTween(view["txt2"], { _alpha:0, time:.2, transition:"linear" } );
	}
	
	
	
	
	
	
	
	private function checkOnPress() {
		var settingsObj:Object = _global.cartSettings;
		
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
		
		
		if (settingsObj.checkoutHandledByAdmin == 1) {
			getURL(myUrl, "_self");
		}
		else {
			var thePUrl:String = settingsObj.paypalUrl 
								+ "?currency_code=" + settingsObj.currencyCode
								+ "&business=" + settingsObj.businessEmail
								+ "&cmd=_cart&upload=1" + payPalString;

			getURL(thePUrl, "_self");

		}
	}
	
	private function checkOnRollOver() {
		Tweener.addTween(check["over"], { _alpha:100, time:.2, transition:"linear" } );
		if (whitePresent) {
			Tweener.addTween(check["a"], { _alpha:100, time:.2, transition:"linear" } );
			Tweener.addTween(check["txt2"], { _alpha:100, time:.2, transition:"linear" } );
		}
	}
	
	private function checkOnRollOut() {
		Tweener.addTween(check["over"], { _alpha:0, time:.2, transition:"linear" } );
		if (whitePresent) {
			Tweener.addTween(check["a"], { _alpha:0, time:.2, transition:"linear" } );
			Tweener.addTween(check["txt2"], { _alpha:0, time:.2, transition:"linear" } );
		}
	}
	
	
}
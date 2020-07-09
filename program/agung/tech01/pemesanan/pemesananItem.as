import ascb.util.Proxy;
import caurina.transitions.*;

/**
 * This class handles the pemesanan item
 */
class agung.tech01.pemesanan.pemesananItem extends MovieClip
{
	private var bgNormal1:MovieClip;
	private var bgNormal2:MovieClip;
	
	private var bgOver:MovieClip;
	
	private var captions:MovieClip;
	private var captionsOver:MovieClip;
	
	
	private var theList:Object;
	private var settingsObj:Object;
	
	private var oldQ:Number = 0;
	
	private var removeButton:MovieClip;
	private var remObj:Object;
	
	private var low:MovieClip;
	private var high:MovieClip;
	
	public function pemesananItem() {
		this._x = 20;
		
		
		captionsOver._alpha = 0;
		captionsOver["title"].autoSize = true;
		captionsOver["title"].wordWrap = false;
		
		captions["title"].autoSize = true;
		captions["title"].wordWrap = false;
		
		captions["price"].autoSize = true;
		captions["price"].wordWrap = false;
		
		captions["total"].autoSize = true;
		captions["total"].wordWrap = false;
		
		
		low = captions["quantity"]["low"];
		low["over"]._alpha = 0;
		
		low.onRollOver = Proxy.create(this, lowOnRollOver);
		low.onRollOut = Proxy.create(this, lowOnRollOut);
		low.onPress = Proxy.create(this, lowOnPress);
		low.onReleaseOutside = Proxy.create(this, lowOnReleaseOutside);
		
		
		high = captions["quantity"]["high"];
		high["over"]._alpha = 0;
		high.onRollOver = Proxy.create(this, highOnRollOver);
		high.onRollOut = Proxy.create(this, highOnRollOut);
		high.onPress = Proxy.create(this, highOnPress);
		high.onReleaseOutside = Proxy.create(this, highOnReleaseOutside);

	}
	
	private function lowOnRollOver() {
		Tweener.addTween(low["over"], { _alpha:100, time:0.2, transition:"linear" } );
	}
	
	private function lowOnRollOut() {
		Tweener.addTween(low["over"], { _alpha:0, time:0.2, transition:"linear" } );
	}
	
	private function lowOnPress() {
		var nowNumber:Number = Number(captions["quantity"]["txt"].text);
		nowNumber--;
		if (nowNumber > 0) {
			captions["quantity"]["txt"].text = nowNumber;
			onChangeQuality();
		}
	
	}
	
	private function lowOnReleaseOutside() {
		lowOnRollOut();
	}
	
	
	
	private function highOnRollOver() {
		Tweener.addTween(high["over"], { _alpha:100, time:0.2, transition:"linear" } );
	}
	
	private function highOnRollOut() {
		Tweener.addTween(high["over"], { _alpha:0, time:0.2, transition:"linear" } );
	}
	
	private function highOnPress() {
		var nowNumber:Number = Number(captions["quantity"]["txt"].text);
		nowNumber++;
		captions["quantity"]["txt"].text = nowNumber;
		onChangeQuality();
	}
	
	private function highOnReleaseOutside() {
		highOnRollOut()
	}
	
	/**
	 * Here, the data and settings for one pemesanan item is being set
	 * @param	pTheList
	 * @param	pSettingsObj
	 * @param	pIdx
	 */
	public function setData(pTheList:Object, pSettingsObj:Object, pIdx:Number) {
		
		theList = pTheList;
		settingsObj = pSettingsObj;
		
		
		bgNormal1._width = bgNormal2._width = bgOver._width = settingsObj.moduleWidth - 16 - 20 - 4;
		bgNormal1._height = bgNormal2._height = bgOver._height = 34;
		bgOver._width += 3;
		
		bgNormal1._visible = bgNormal2._visible = false;
		bgOver._alpha = 0;
		
		if (pIdx % 2 == 0) {
			bgNormal1._visible = true;
		}
		else {
			bgNormal2._visible = true;
		}
		
		removeButton._x = Math.ceil(bgOver._width - removeButton._width - 12);
		removeButton._y = Math.ceil(bgOver._height/2 - removeButton._height / 2);
		removeButton["over"]._alpha = 0;
		
		removeButton.onRollOver = Proxy.create(this, removeButtonOnRollOver);
		removeButton.onRollOut = Proxy.create(this, removeButtonOnRollOut);
		removeButton.onPress = Proxy.create(this, removeButtonOnPress);
		
	
		
		captions["title"].text = captionsOver["title"].text = theList.name;
		
		var thePriceActualText:String = "";
		
		if (_global.cartSettings.currencyPosition == "after") {
			thePriceActualText = theList.price + _global.cartSettings.currency;
		}
		else {
			thePriceActualText = _global.cartSettings.currency + theList.price;
		}
		
		captions["price"].text = thePriceActualText;
		var my_fmt:TextFormat = new TextFormat();
		my_fmt.bold = true;

		captions["price"].setTextFormat(my_fmt);

		updateTotal();
		
		captions._y = captionsOver._y = Math.round(bgOver._height / 2 - captions._height / 2 + 3);
		
		
		var totalWidth:Number = settingsObj.moduleWidth - 12;
		captions["total"]._x = Math.ceil(totalWidth - settingsObj.totalColumnWidth);
		captions["quantity"]._x = Math.ceil(captions["total"]._x - settingsObj.quantityColumnWidth + 3);
		captions["price"]._x = Math.ceil(captions["quantity"]._x - settingsObj.priceColumnWidth);
		oldQ = theList.quantity;
		captions["quantity"]["txt"].text = oldQ;
		var my_fmt:TextFormat = new TextFormat();
		my_fmt.bold = true;

		captions["quantity"]["txt"].setTextFormat(my_fmt);
		
		captions["quantity"]["txt"].restrict = "0-9";
		captions["quantity"]._y = Math.ceil(bgOver._height / 2 - captions["quantity"]._height/2 - 7);
		captions["quantity"]["txt"].tabIndex = pIdx;
		captions["quantity"]["txt"].type = "input";
		captions["quantity"]["txt"].onSetFocus =  Proxy.create(this, onFocusQuality);
		captions["quantity"]["txt"].onKillFocus =  Proxy.create(this, onKillFocusQuality);
		
		captions["quantity"]["over"]._alpha = 0;
		captions["quantity"]["txt"].onChanged =  Proxy.create(this, onChangeQuality);
	
		if (_global.whitePresent) {
			Tweener.addTween(captions["quantity"]["txt"], { _alpha:50, time:0.2, transition:"linear" } );
		}

		
		
		var keyListener:Object = new Object();
		keyListener.onKeyDown = Proxy.create(this, kk);
		Key.addListener(keyListener);


		bgOver.onRollOver = Proxy.create(this, bgOverR);
		bgOver.onRollOut = bgOver.onReleaseOutside = Proxy.create(this, bgOut);
	
		
		captions["quantity"]._x += 16;
	}
	
	private function kk() {
		if (Key.getCode() == Key.ENTER) {
			onKillFocusQuality();
		}
	}
	private function onFocusQuality() {
		Stage.displayState = "normal";
		
		Tweener.addTween(captions["quantity"]["over"], { _alpha:100, time:0.2, transition:"linear" } );

		if (_global.whitePresent) {
			Tweener.addTween(captions["quantity"]["txt"], { _alpha:100, time:0.2, transition:"linear" } );
		}
	}
	
	private function onKillFocusQuality() {
		Tweener.addTween(captions["quantity"]["over"], { _alpha:0, time:0.2, transition:"linear" } );
		if (_global.whitePresent) {
			Tweener.addTween(captions["quantity"]["txt"], { _alpha:50, time:0.2, transition:"linear" } );
		}
	}
	
	
	private function onChangeQuality() {
		if ((captions["quantity"]["txt"].text == "") || (captions["quantity"]["txt"].text == undefined)) {
			oldQ = 0;
		}
		else {
			oldQ = Number(captions["quantity"]["txt"].text);
		}
		
		theList.quantity = oldQ;
		_global.shopHandler.updateQuantity(theList);
			
		updateTotal();
		
		var my_fmt:TextFormat = new TextFormat();
		my_fmt.bold = true;

		captions["quantity"]["txt"].setTextFormat(my_fmt);
	}
	
	
	private function updateTotal() {
		var thePriceActualText:String = "";
		if (_global.cartSettings.currencyPosition == "after") {
			thePriceActualText = theList.price * theList.quantity + _global.cartSettings.currency;
		}
		else {
			thePriceActualText = _global.cartSettings.currency + theList.price * theList.quantity;
		}
		
		captions["total"].text = thePriceActualText;
		
		_global.shopHandler.calculateTotalCost();
	}
	
	private function bgOverR() {
		Tweener.addTween(bgOver, { _alpha:100, time:0.2, transition:"linear" } );
		Tweener.addTween(captionsOver, { _alpha:100, time:0.2, transition:"linear" } );
	}
	
	private function bgOut() {
		Tweener.addTween(bgOver, { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(captionsOver, { _alpha:0, time:0.2, transition:"linear" } );
	}
	
		
	private function removeButtonOnRollOver() {
		bgOverR();
		Tweener.addTween(removeButton["over"], { _alpha:100, time:0.2, transition:"linear" } );
	
		_global.MainComponent.scrollerDesGlobal.setNewText(_global.cartSettings.cartRemoveCaption);
	}
	
	private function removeButtonOnRollOut() {
		Tweener.addTween(removeButton["over"], { _alpha:0, time:0.2, transition:"linear" } );
		
		_global.MainComponent.scrollerDesGlobal.hide();
	}
	
	private function removeButtonOnPress() {
		_global.MainComponent.scrollerDesGlobal.hide();
		_global.shopHandler.removeItemFromCart(theList);
		_global.totalSumCartDisplay.updateTheList();
		
		
	}
}
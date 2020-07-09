/*Kelas ini mengendalikan satu item untuk komponen blog.
 * Disini, Saya sudah mengatur semua data yang diperlukan
 * HINT: Jika kamu ingin mengganti modul blog ini kebentuk modul url browser yang terdapat popups kamu dapat mengubahnya seperti ini:
 * Tolong lihat:
 * 	public function onPress() {
		SWFAddress.setValue(urlAddress);
	}
	
	ganti dengan
	
	public function onPress() {
		getURL(node.attributes.browserUrl, "_blank");
	}
	
	Jadi, di dalam admin dimana kamu akan memasukkan alamat url dalam browser, kamu akan mampu untuk masuk kedalam url tersebut.
 * 
*/


import mx.events.EventDispatcher;
import flash.display.BitmapData;
import asual.sa.SWFAddress;
import caurina.transitions.*;
import agung.utils.UAddr;

class agung.tech01.blog.blogItem extends MovieClip 
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
			private var normalDate:MovieClip;
			private var normalAuthor:MovieClip;
			
		private var over:MovieClip;
			private var overBg:MovieClip;
			private var overTitle:MovieClip;
			private var overDate:MovieClip;
			private var overAuthor:MovieClip;
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	public var urlAddress:String;
	public var urlTitle:String;
	public var urlAddressPopupClose:String;
	public var urlTitlePopupClose:String;
	/**
	 * ini adalah konstruktor dimana semua variabel di referensikan dan diinisialisasikan
	 */
	public function blogItem() {
	
		EventDispatcher.initialize(this);
		
		normal = holder["normal"];
		normalBg = normal["bg"];
		normalTitle = normal["title"];
		normalDate = normal["date"];
		normalAuthor = normal["author"];
		
		normalTitle["txt"].autoSize = true;
		normalTitle["txt"].wordWrap = true;
		
		normalDate["txt"].autoSize = true;
		normalDate["txt"].wordWrap = false;
		
		normalAuthor["txt"].autoSize = true;
		normalAuthor["txt"].wordWrap = false;
		
		normalAuthor["defTxt"].autoSize = true;
		normalAuthor["defTxt"].wordWrap = false;
		
		over = holder["over"];
		overBg = over["bg"];
		overTitle = over["title"];
		overDate = over["date"];
		overAuthor = over["author"];
		
		overTitle["txt"].autoSize = true;
		overTitle["txt"].wordWrap = true;
		
		overDate["txt"].autoSize = true;
		overDate["txt"].wordWrap = false;
		
		overAuthor["txt"].autoSize = true;
		overAuthor["txt"].wordWrap = false;
		
		overAuthor["defTxt"].autoSize = true;
		overAuthor["defTxt"].wordWrap = false;
		
		over._alpha = 0;
		
	}
	

	public function setNode(pNode:XMLNode, pSettingsObj:Object, pItemWidth:Number)
	{
		node = pNode;
		settingsObj = pSettingsObj;
		itemWidth = pItemWidth;
	
		var firstLevel:String = _global.parentAddressLevelOne;
		var secondLevel:String = node.parentNode.attributes.browserUrl;
		var thirdLevel:String = node.attributes.browserUrl;
	
		
		var strArray2:Array = secondLevel.split("/");
		var strArray3:Array = thirdLevel.split("/");
		
		urlAddress = UAddr.contract(firstLevel + "/" + strArray2[1] + "/" + strArray3[1]) + "/";
		
		urlAddressPopupClose = UAddr.contract(firstLevel + "/" + strArray2[1]) + "/";
		
		var firstLevelTitle:String = _global.parentTitleLevelOne;
		var secondLevelTitle:String = node.parentNode.attributes.browserTitle;
		var thirdLevelTitle:String = node.attributes.browserTitle;
		
		urlTitle = firstLevelTitle + " " + _global.globalSettingsObj.urlTitleSeparator + " " + secondLevelTitle + " " + _global.globalSettingsObj.urlTitleSeparator + " " + thirdLevelTitle;
		urlTitlePopupClose = firstLevelTitle + " " + _global.globalSettingsObj.urlTitleSeparator + " " + secondLevelTitle;
		
		
		normalBg._width = overBg._width = itemWidth;
		normalAuthor["defTxt"].text = overAuthor["defTxt"].text = settingsObj.authorCaption;
		
		normalAuthor["txt"].text = overAuthor["txt"].text = node.attributes.author;
		normalAuthor["txt"]._x = overAuthor["txt"]._x = Math.round(normalAuthor["defTxt"]._width + 4);
		
		normalAuthor._x = overAuthor._x = Math.round(itemWidth - 18 - normalAuthor._width);

		normalDate["txt"].text = overDate["txt"].text = settingsObj.dateCaption + "   " + node.attributes.date;
		normalDate._x = overDate._x = Math.round(itemWidth - 18 - normalDate._width);

		normalTitle["txt"]._width = overTitle["txt"]._width = Math.round(normalDate._x - 15 - 18);
	
		normalTitle["txt"].text = overTitle["txt"].text = node.attributes.title;
		normalTitle._x = overTitle._x = 15;
		
		
		normalBg._height = overBg._height = Math.round(Math.max((normalTitle._height + 10 + 10), settingsObj.buttonHeight));
		
		totalHeight = normalBg._height;
		
		normalTitle._y = overTitle._y = Math.round(totalHeight / 2 - normalTitle["txt"].textHeight / 2 - 3);
		
		normalAuthor._y = overAuthor._y = Math.round(totalHeight / 2 - normalAuthor["txt"].textHeight);
		normalDate._y =  overDate._y = Math.round(normalAuthor._y + normalDate["txt"].textHeight + 3);
		if (settingsObj.enableOverActionsOnButtons == 0) {
			this.useHandCursor = false;
		}
		this._visible = true;
	}
	
	
	private function onRollOver() {
		if ((settingsObj.enableOverActionsOnButtons == 1) && (activated == 0)) {
			Tweener.addTween(over, { _alpha:100, time:.2, transition:"linear" } );
		}
		
	}
	
	private function onRollOut() {
		if ((settingsObj.enableOverActionsOnButtons == 1) && (activated == 0)) {
			Tweener.addTween(over, { _alpha:0, time:.3, transition:"linear" } );
		}
	}
	
	public function dispatchMc() {
		SWFAddress.setTitle(urlTitle);
		dispatchEvent( { target:this, type:"itemClicked", mc:this } );
	}
	
	public function onPress() {
		SWFAddress.setValue(urlAddress);
	}
	
	private function onRelease() {
		onRollOut();
	}
	
	private function onReleaseOutside() {
		onRelease();
	}
	
	public function activateItem() {
		onRollOver();
		activated = 1;
	}
	
	public function deactivateItem() {
		activated = 0;
		onRollOut();
	}
}
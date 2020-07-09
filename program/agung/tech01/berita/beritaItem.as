import mx.events.EventDispatcher;
import flash.display.BitmapData;
import asual.sa.SWFAddress;
import caurina.transitions.*;
import agung.utils.UAddr;

/**
 * kelas ini mengatur item berita
 */
class agung.tech01.berita.beritaItem extends MovieClip 
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
			private var normalArrow:MovieClip;
			
			
		private var over:MovieClip;
			private var overBg:MovieClip;
			private var overTitle:MovieClip;
			private var overDate:MovieClip;
			private var overArrow:MovieClip;
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	public var urlAddress:String;
	public var urlTitle:String;
	
	public function beritaItem() {
		EventDispatcher.initialize(this);
		
		normal = holder["normal"];
		normalBg = normal["bg"];
		normalTitle = normal["title"];
		normalDate = normal["date"];
		
		normalTitle["txt"].autoSize = true;
		normalTitle["txt"].wordWrap = true;
		
		normalDate["txt"].autoSize = true;
		normalDate["txt"].wordWrap = false;
		normalArrow = normal["arrow"];
		
		over = holder["over"];
		overBg = over["bg"];
		overTitle = over["title"];
		overDate = over["date"];
		
		overTitle["txt"].autoSize = true;
		overTitle["txt"].wordWrap = true;
		
		overDate["txt"].autoSize = true;
		overDate["txt"].wordWrap = false;
		
		overArrow = over["arrow"];
		
		over._alpha = 0;
		
	}
	

	/**
	 * Node dan pengaturan lebar item diatur dalam fungsi ini
	 * Setelah proses selesai, semua data akan dipasang dalam movieclip dan text fields
	 * @param	pNode
	 * @param	pSettingsObj
	 * @param	pItemWidth
	 */
	public function setNode(pNode:XMLNode, pSettingsObj:Object, pItemWidth:Number)
	{
		node = pNode;
		settingsObj = pSettingsObj;
		itemWidth = pItemWidth;
	
		urlTitle = _global.parentTitleLevelOne + " " + _global.globalSettingsObj.urlTitleSeparator + " " + node.attributes.browserTitle;
		
		var strArray:Array = node.attributes.browserUrl.split("/");
		
		urlAddress = UAddr.contract(_global.parentAddressLevelOne + strArray[1]) + "/";
		
		
		normalBg._width = overBg._width = itemWidth;
		
		normalDate["txt"].text = overDate["txt"].text = node.attributes.date;
		normalDate._x = overDate._x = Math.round(itemWidth - 33 - normalDate._width);
		normalArrow._x = overArrow._x = Math.ceil(normalDate._x + normalDate["txt"].textWidth + 8);
		
		normalTitle["txt"]._width = overTitle["txt"]._width = Math.round(normalDate._x - 15 - 33);
	
		normalTitle["txt"].text = overTitle["txt"].text = node.attributes.title;
		normalTitle._x = overTitle._x = 15;
		normalTitle._y = overTitle._y = 12;
		
		normalBg._height = overBg._height = Math.round(normalTitle._height + 10 + 13);
		
		totalHeight = normalBg._height;
		normalArrow._y = overArrow._y = Math.ceil(totalHeight / 2 - normalArrow._height / 2 - 1);
		normalDate._y = overDate._y = Math.ceil(totalHeight / 2 - normalDate._height / 2);
		
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
		if (settingsObj.enableOverActionsOnButtons == 1) {
			SWFAddress.setValue(urlAddress);
		}
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
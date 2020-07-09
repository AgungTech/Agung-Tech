import caurina.transitions.*;
import ascb.util.Proxy;
import asual.sa.SWFAddress;
/**
 * This is the main class for the popup, this handles the removing
 * and adding of a materi popup process
 */
class agung.tech01.materi.popupHandler extends MovieClip 
{
	private var oldpW:Number = 0;
	private var oldpH:Number = 0;
	
	private var node:XMLNode;
	private var settingsObj:Object

	private var popupMode:String = "right";
	
	private var protect:MovieClip;
	private var holder:MovieClip;
	private var bg:MovieClip;
	
	private var pressedItem:MovieClip;
	private var popupIdx:Number = -1;
	private var currentIdx:Number;
	private var currentPopup:MovieClip;
	private var prevPopup:MovieClip;
	
	public var urlAddress:String;
	public var urlTitle:String;
	
	private var itemsArray:Array;
	private var projectDescription:MovieClip;
	
	private var finalProtectTransparency:Number = 90;
	private var protectAnimationTime:Number = 0.9;
	private var parentToCancelScroll:MovieClip;
	
	private var cancelInterval:Number;
	
	public function popupHandler() {
		protect.onPress = null;
		protect.useHandCursor = false;
		protect._alpha = 0;
		protect._visible = false;
		
		_global.nowPopup = this;
	}
	
	/**
	 * this will launch the popup according to the given settings and at the same time will remove the old popup
	 * @param	pPressedItem
	 * @param	pItemsArray
	 * @param	pProjectDescription
	 * @param	pParentToCancelScroll
	 */
	public function launchPopup(pPressedItem:MovieClip, pItemsArray:Array, pProjectDescription:MovieClip, pParentToCancelScroll:MovieClip ) {
		itemsArray = pItemsArray;
		projectDescription = pProjectDescription;
		parentToCancelScroll = pParentToCancelScroll;
		projectDescription.disableMouseListener();
		
		protect._visible = true;
		Tweener.addTween(protect, { _alpha:finalProtectTransparency, time:protectAnimationTime, transition:"linear"} );
		
		pressedItem = pPressedItem;
		
		currentIdx = pressedItem.idx;
		
		prevPopup.hidePopup(popupMode);
		
		parentToCancelScroll.stopScrolling();
		popupIdx++;
		currentPopup = holder.attachMovie("IDpopup", "popup" + popupIdx, holder.getNextHighestDepth());
		currentPopup.addEventListener("nextPressed", Proxy.create(this, nextPressed));
		currentPopup.addEventListener("prevPressed", Proxy.create(this, prevPressed));
		currentPopup.addEventListener("closePressed", Proxy.create(this, closePressed));
		
		currentPopup.setNode(pressedItem.node, settingsObj, popupMode, pressedItem, itemsArray);
		
		prevPopup = currentPopup;
		
		urlAddress = pressedItem.urlAddressPopupClose;
		
		//urlAddress = _global.parentAddressLevelOne;
	}
	
	
	private function nextPressed(obj:Object) {
		popupMode = "right";
		itemsArray[pressedItem.idx + 1].onPress();

	}
	
	private function prevPressed(obj:Object) {
		popupMode = "left";
		itemsArray[pressedItem.idx - 1].onPress();
	}
	
	private function closePressed(obj:Object) {
		SWFAddress.setValue(urlAddress);
	}
	
	public function cancelPopup() {
		parentToCancelScroll.startScrolling();
		Tweener.addTween(protect, { _alpha:0, time:protectAnimationTime, transition:"linear", onComplete:Proxy.create(this, invisProtect) } );
		
		projectDescription.enableMouseListener();
		prevPopup.hidePopup(popupMode);
		currentPopup.hidePopup(popupMode);
		
		_global.MainComponent.showMainMenu();
	}
	
	private function invisProtect() {
		protect._visible = false;
	}
	
	public function setSettings(pSettingsObj:Object)
	{
		settingsObj = pSettingsObj;
		
		finalProtectTransparency = settingsObj.popupProtectTransparency;
		protectAnimationTime = settingsObj.popupProtectAnimationTime;
		
		loadStageResize();
	}
	
	
	
	
	private function resize(pW:Number, pH:Number) {
		if ((pW != oldpW) || (pH != oldpH)) {
			pW = Math.max(pW, _global.globalSettingsObj.templateMaxWidth);
			pH = Math.max(pH, _global.globalSettingsObj.templateMaxHeight);
			
			oldpW = pW;
			oldpH = pH;
			
			protect._width = pW;
			protect._height = pH-26;
			protect._y = -10;
			
			this._x = Math.round(-_global.moduleXPos);
			this._y = Math.round(-_global.moduleHandlerY - 80 );
		}
	}
	
	private function onResize() {
		resize(Stage.width, Stage.height);
	}
	
	private function loadStageResize() {
		Stage.addListener(this);
		onResize();
	}
}
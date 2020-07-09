import caurina.transitions.*;
import ascb.util.Proxy;
import asual.sa.SWFAddress;

class agung.tech01.karir.popupHandlerKarir extends MovieClip 
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
	
	private var finalProtectTransparency:Number = 90;
	private var protectAnimationTime:Number = 0.9;
	
	public var urlAddress:String;
	public var urlTitle:String;
	
	public function popupHandlerKarir() {
		protect.onPress = null;
		protect.useHandCursor = false;
		protect._alpha = 0;
		protect._visible = false;
		
	}
	
	public function launchPopup(pPressedItem:MovieClip) {
		_global.MainComponent.hideMainMenu();
		
		protect._visible = true;
		pressedItem = pPressedItem;
		currentIdx = pressedItem.idx;
		
		prevPopup.hidePopup(popupMode);
		
		protect._visible = true;
		Tweener.addTween(protect, { _alpha:finalProtectTransparency, time:protectAnimationTime, transition:"linear"} );
	
		popupIdx++;
		currentPopup = holder.attachMovie("IDpopupCareers", "popup" + popupIdx, holder.getNextHighestDepth());
		currentPopup.addEventListener("nextPressed", Proxy.create(this, nextPressed));
		currentPopup.addEventListener("prevPressed", Proxy.create(this, prevPressed));
		currentPopup.addEventListener("closePressed", Proxy.create(this, closePressed));
		
		currentPopup.setNode(pressedItem.node, settingsObj, popupMode, pressedItem);
		
		prevPopup = currentPopup;
	}
	
	private function nextPressed(obj:Object) {
		popupMode = "right";
		pressedItem.theParent.launchOneItem(pressedItem.idx + 1);
	}
	
	private function prevPressed(obj:Object) {
		popupMode = "left";
		pressedItem.theParent.launchOneItem(pressedItem.idx - 1);
	}
	
	private function closePressed(obj:Object) {
		SWFAddress.setValue(urlAddress);
	}
	
	public function closePopupFullNow() {
		SWFAddress.setTitle(urlTitle);
		pressedItem.theParent.enableMouseListener();
		pressedItem.theParent.resetItemAllState();
		prevPopup.hidePopup(popupMode);
		currentPopup.hidePopup(popupMode);
		Tweener.addTween(protect, { _alpha:0, time:protectAnimationTime, transition:"linear", onComplete:Proxy.create(this, invisProtect) } );
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
	
		urlTitle = _global.parentTitleLevelOne;
		
		urlAddress = _global.parentAddressLevelOne;
		
		loadStageResize();
	}
	
	
	private function resize(pW:Number, pH:Number) {
		if ((pW != oldpW) || (pH != oldpH)) {
			pW = Math.max(pW, _global.globalSettingsObj.templateMaxWidth);
			pH = Math.max(pH, _global.globalSettingsObj.templateMaxHeight);
			
			oldpW = pW;
			oldpH = pH;
			
			protect._width = pW;
			protect._height = pH-21;
			protect._y = -10;
			
			this._x = Math.round(-_global.moduleXPos);
			this._y = Math.round(-_global.moduleHandlerY - 84 );
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
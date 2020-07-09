import caurina.transitions.*;

class agung.tech01.main.fullScreenButton extends MovieClip
{
	private var normal:MovieClip;
	private var over:MovieClip;
	
	private var onn:MovieClip;
	private var off:MovieClip;
	
	public function fullScreenButton() {
		over._alpha = 0
		onn["over"]._alpha = 0;
		off["over"]._alpha = 0;
		
		if (Stage["displayState"] == "normal") {
			off._alpha = 0;
		}
		else {
			onn._alpha = 0;
		}
	}
	
	private function onRollOver() {
		Tweener.addTween(over, { _alpha:100, time:.2, transition:"linear" } );
		
		if (Stage["displayState"] == "normal") {
			_global.MainComponent.scrollerDesGlobal.setNewText(_global.globalSettingsObj.fsButtonOpenCaption);
			Tweener.addTween(onn["over"], {_alpha:100, time:.2, transition:"linear" } );
		}
		else {
			_global.MainComponent.scrollerDesGlobal.setNewText(_global.globalSettingsObj.fsButtonCloseCaption);
			Tweener.addTween(off["over"], {_alpha:100, time:.2, transition:"linear" } );
		}
		
		
		_global.theBottomShopPreview.killPanelOnBottom();
	}
	
	private function onRollOut() {
		Tweener.addTween(over, { _alpha:0, time:.2, transition:"linear" } );
		_global.MainComponent.scrollerDesGlobal.hide();
		if (Stage["displayState"] == "normal") {
			Tweener.addTween(onn["over"], {_alpha:0, time:.2, transition:"linear" } );
		}
		else {
			Tweener.addTween(off["over"], {_alpha:0, time:.2, transition:"linear" } );
		}
	}
	
	public function onRelease() {
		_global.MainComponent.scrollerDesGlobal.hide();
		Stage["displayState"] = Stage["displayState"] == "normal" ? "fullScreen" : "normal";
		if (Stage["displayState"] == "normal") {
			off._alpha = 0;
			onn._alpha = 100;
		}
		else {
			off._alpha = 100;
			onn._alpha = 0;
		}
		onRollOut();
	}
	
	private function onReleaseOutside() {
		onRelease();
	}
	
	public function setTheStatus() {
		if (Stage["displayState"] == "normal") {
			off._alpha = 0;
			off["over"]._alpha = 0;
			onn._alpha = 100;
			onn["over"]._alpha = 0;
		}
		else {
			off._alpha = 100;
			off["over"]._alpha = 0;
			onn._alpha = 0;
			onn["over"]._alpha = 0;
		}
	}
}
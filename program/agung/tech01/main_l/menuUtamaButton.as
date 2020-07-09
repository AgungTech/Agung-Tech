import caurina.transitions.*;

/**
 * Kelas ini mengatur Action untuk Tombol Menu Utama
 */
class agung.tech01.main_l.menuUtamaButton extends MovieClip
{
	private var over:MovieClip;
	
	private var onn:MovieClip;
	private var off:MovieClip;
	
	public function menuUtamaButton() {
		over._alpha = 0
		onn["over"]._alpha = 0;
		off["over"]._alpha = 0;
		off._alpha = 0;
	}
	
	private function onRollOver() {
		Tweener.addTween(over, { _alpha:100, time:.2, transition:"linear" } );
		_global.MainComponent.scrollerDesGlobal.setNewText(_global.globalSettingsObj.fsButtonOpenCaption);
		Tweener.addTween(onn["over"], {_alpha:100, time:.2, transition:"linear" } );		
		_global.theBottomShopPreview.killPanelOnBottom();
	}
	
	private function onRollOut() {
		Tweener.addTween(over, { _alpha:0, time:.2, transition:"linear" } );
		_global.MainComponent.scrollerDesGlobal.hide();
		Tweener.addTween(onn["over"], {_alpha:0, time:.2, transition:"linear" } );
	}
	public function onRelease() {
		loadMovieNum("preview.lnk",0);
		off._alpha = 0;
		onn._alpha = 100;
		onRollOut();
	}
	
	private function onReleaseOutside() {
		onRelease();
	}
	
	public function setTheStatus() {
		off._alpha = 0;
		off["over"]._alpha = 0;
		onn._alpha = 100;
		onn["over"]._alpha = 0;
	}
}
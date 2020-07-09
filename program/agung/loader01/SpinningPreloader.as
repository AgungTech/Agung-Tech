import caurina.transitions.*;

class agung.loader01.SpinningPreloader extends MovieClip {
	
	private var Szr:MovieClip;
	private var Msk:MovieClip;
	private var Spn:MovieClip;
	
	public function SpinningPreloader() {
		this._alpha = 0;
		Szr = this["mc0"];
		Spn = this["mc1"];
		Msk = this["mc2"];
		
		Spn._rotation = Math.round(Math.random() * 359);
		this.onEnterFrame = spin;
		
		Tweener.addTween(this, { _alpha:70, time:0.3, transition:"linear" } );
	}
	
	// spin preloader
	private function spin() {
		Spn._rotation += 10;
	}
	
	public function get width() {
		return Szr._width;
	}
	public function get height() {
		return Szr._height;
	}	
	
	public function cancelSpin() {
		delete this.onEnterFrame;
		
		Tweener.addTween(this, { _alpha:0, time:0.3, transition:"linear" } );
	}
}
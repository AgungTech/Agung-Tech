/* @last_update: 06/29/2015 (mm/dd/yyyy) */

import agung.utils.*;
class agung.EButton extends MovieClip {
		
	public function EButton() {
		this.stop();
	}
	private function onRollOver() {
		UMc.playTo(this, 0);
	}
	private function onRollOut() {
		UMc.playTo(this, 1);
	}
	private function onReleaseOutside() {
		this.onRollOut();
	}
}
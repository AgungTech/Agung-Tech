/* @last_update: 06/29/2015 (mm/dd/yyyy) */

class agung.utils.UStage {
	private function UStage() { trace("Kelas statik. Tidak dapat diInstantiasikan.") }
	
	/* Stage minimum width value. */
	public static var STAGE_MIN_WIDTH:Number = 0;
	/* Stage minimum height value. */
	public static var STAGE_MIN_HEIGHT:Number = 0;
	
	/* Get restricted stage width. */
	public static function getWidth():Number {
		return Math.max(Stage.width, STAGE_MIN_WIDTH);
	}
	/* Get restricted stage height. */
	public static function getHeight():Number {
		return Math.max(Stage.height, STAGE_MIN_HEIGHT);
	}
}
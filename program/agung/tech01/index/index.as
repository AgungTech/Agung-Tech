
class agung.tech01.index.index extends MovieClip
{
	private var mcl:MovieClipLoader;
	
	private var holder:MovieClip;
		
	
	public function index() {
		loadStageResize();
		
		mcl =  new MovieClipLoader();
		mcl.addListener(this);
	
		mcl.loadClip("main.lnk", holder);
	}
	
	private function onLoadStart() {
		_global.globalLoader.showLoader();
	}

	private function onLoadProgress(mc:MovieClip, bytesLoaded:Number, bytesTotal:Number) {
		_global.globalLoader.loaderProgressChange(Math.ceil(bytesLoaded / bytesTotal * 100));
	}
	
	private function onLoadInit(mc:MovieClip) {
		_global.globalLoader.hideLoader();
	}
	
	/**
	 * fungsi yang dipanggil jika jendela di resize
	 * @param	pW
	 * @param	pH
	 */
	private function resize(pW:Number, pH:Number) {
		
	}
	
	private function onResize() {
		resize(Stage.width, Stage.height);
	}
	
	private function loadStageResize() {
		Stage.addListener(this);
		onResize();
	}
}
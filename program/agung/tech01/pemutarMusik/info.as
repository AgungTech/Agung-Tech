import caurina.transitions.*;
import ascb.util.Proxy;
import agung.utils.UMc;

class agung.tech01.pemutarMusik.info extends MovieClip
{
	private var settingsObj:Object;
	
	private var infoHolder:MovieClip;
		private var bg:MovieClip;
		private var icon:MovieClip;
		private var holder:MovieClip;
			private var mask:MovieClip;
			private var textHolder:MovieClip;
			
	private var infoMask:MovieClip;
			
	private var textIdx:Number = 0;
	private var lastText:MovieClip;
	
	private var status:Number = 0;
	private var lastStr:String = "none";
	
	/**
	 * this class handles the right info panel
	 */
	public function info() {
		
		infoHolder.setMask(infoMask);
		
		holder = infoHolder["holder"];
		icon = infoHolder["icon"];
		bg = infoHolder["bg"];

		mask = holder["mask"];
		textHolder = holder["textHolder"];
		lastText = textHolder["a"];
		lastText["txt"].autoSize = true;
		textHolder.setMask(mask);
	}
	
	private function resizeAndPosition() {
		this._x = settingsObj.playerWidth;
		this._y = Math.round(settingsObj.playerHeight / 2 - bg._height / 2);
		mask._height = bg._height - 4;
		mask._y = 2;
		
		mask._width = bg._width - 10;
		
		icon._y = Math.round(bg._height / 2 - icon._height / 2);
		
		infoMask._height = bg._height;
		infoMask._width = bg._width;
		
		infoHolder._x = -infoMask._width - 6;
		
		if (settingsObj.autoPlay == 0) {
			setNewText("paused");
		}
	}
	
	/**
	 * here, the settings are being set
	 * @param	pSettings
	 */
	public function setSettings(pSettings:Object) {
		settingsObj = pSettings;
		
		resizeAndPosition();
	}
	
	/**
	 * a new text will be set
	 * @param	str
	 */
	public function setNewText(str:String) {
			Tweener.addTween(lastText, { _y:mask._height, time:.25, transition:"linear", onComplete:Proxy.create(this, removeLastText, lastText) } );
		
			textIdx++;
			
			lastText = textHolder["a"].duplicateMovieClip("textHolder" + textIdx, textIdx);
			
			lastText._y = -mask._height;
			
			lastText["txt"].autoSize = true;
			lastText["txt"].text = str;
			
			
			Tweener.addTween(lastText, { _y:-1, time:.25, transition:"linear" } );
			
			resizeMasks();
			
			lastStr = str;
	}
	
	private function resizeMasks() {
		if(status==1){
			Tweener.addTween(mask, { _width:Math.round(lastText._width + icon._width + 3 + 6), time:.5, transition:"linear" } );
			
			Tweener.addTween(bg["stroke"], { _width:Math.round(3 + icon._width + 8 + lastText._width + 6), time:.5, transition:"easeOutExpo" } );
			Tweener.addTween(bg["fill"], { _width:Math.round(3 + icon._width + 8 + lastText._width + 6 - 2), time:.5, transition:"easeOutExpo" } );
			
			Tweener.addTween(infoMask, { _width:Math.round(3 + icon._width + 8 + lastText._width + 6), time:.5, transition:"easeOutExpo"} );
		}
	}
	private function removeLastText(pLast:MovieClip) {
		pLast.removeMovieClip();
	}
	
	public function show() {
		status = 1;
		Tweener.addTween(infoHolder, { _x:0, time:.5, transition:"easeOutExpo" } );
		resizeMasks();
	}
	
	public function hide() {
		status = 0;
		
		Tweener.addTween(infoHolder, { _x:-infoMask._width, time:.5, transition:"easeOutExpo"} );
	}
}
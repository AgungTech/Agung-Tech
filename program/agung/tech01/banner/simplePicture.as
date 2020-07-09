import caurina.transitions.*;
import ascb.util.Proxy;
import flash.filters.BlurFilter;
import mx.events.EventDispatcher;
import flash.display.BitmapData;
import agung.utils.UStr;
import agung.utils.UTf;

/**
 * kelas ini mengatur gambar
 */
class agung.tech01.banner.simplePicture extends MovieClip  
{
	private var settingsObj:Object;
	private var node:XMLNode;
	
	public var idx:Number;
	private var holder:MovieClip;
		
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	private var mcl:MovieClipLoader;
	
	
	private var desHidden:Number = 1;
	
	private var des:MovieClip;
		private var desBg:MovieClip;
	
	private var loader:MovieClip;
		
	public function simplePicture() {
		EventDispatcher.initialize(this);
		
		UTf.initTextArea(des["txt"]);
		des._visible = false;
		
		desBg = des["bg"];
		
		this._visible = false;
	}
	
	/**
	 * fungsi ini menerima node dan melakukan pengaturan
	 * @param	pNode
	 * @param	pSettings
	 */
	
	public function setNode(pNode:XMLNode, pSettings:Object) {
		node = pNode;
		settingsObj = pSettings;
		
		if (!node.firstChild.nodeValue) {
			des._visible = false;
		}
		else {
			des["txt"].htmlText = node.firstChild.nodeValue;
			des["txt"].wordWrap = true;
			des["txt"].autoSize = true;
			
			
			desBg._width = settingsObj.picW;
			des["txt"]._width = Math.ceil(desBg._width - 20);
			desBg._height = Math.ceil(10 + des["txt"].textHeight + 20);
			
			
			des._y = -des._height - 10;
		}
		
		
			
		loader._x = Math.ceil(settingsObj.picW / 2 - loader._width / 2);
		loader._y = Math.ceil(settingsObj.picH / 2 - loader._height / 2);
		
		this._visible = true;
	}
	
	public function startLoad() {
		mcl = new MovieClipLoader();
		mcl.addListener(this);
		
		mcl.loadClip(node.attributes.src, holder);
	}
	
	private function onLoadInit(mc:MovieClip) {
		dispatchEvent( { target:this, type:"picLoaded", mc:this } );
		
		var ext:String = UStr.extension(node.attributes.src);
		if (ext != "swf") {
			getImage(mc, true);
		}
		
		mc._width = settingsObj.picW;
		mc._height = settingsObj.picH;
		
		des._visible = true;
		if (!node.firstChild.nodeValue) {
			des._visible = false;
		}
		
		loader.cancelSpin();
	}
	
	private function onLoadError(mc:MovieClip) {
		dispatchEvent( { target:this, type:"picLoaded", mc:this } );
		loader.cancelSpin();
	}
	
	
	private function onPress() {
		getURL(node.attributes.url, node.attributes.target);
	}
	
	
	public function showDes() {
		if (desHidden == 1) {
			desHidden = 0;
			Tweener.addTween(des, { _y:0, time:settingsObj.descriptionAnimationTime, transition:settingsObj.descriptionAnimationType} );
		}
		
	}
	
	public function hideDes() {
		if (desHidden==0) {
			desHidden = 1;
			Tweener.addTween(des, { _y:-des._height-10, time:settingsObj.descriptionAnimationTime, transition:settingsObj.descriptionAnimationType} );
		}
		
	}
	
	private function getImage(mc:MovieClip, smooth:Boolean) {
		smooth == undefined ? smooth = true : null;
		
		var mcDepth:Number 		= mc.getDepth();
		var mcName:String 		= mc._name;
		var mcParent:MovieClip 	= mc._parent;
		var mcAlpha:Number 		= mc._alpha;
		var mcVisible:Boolean 	= mc._visible;
		
		mc._xscale = 100;
		mc._yscale = 100;
		
		var bmp:BitmapData = new BitmapData(mc._width, mc._height, true, 0);
		bmp.draw(mc);
		
		mc.removeMovieClip();
		
		var newMc:MovieClip = mcParent.createEmptyMovieClip(mcName, mcDepth);
		newMc.attachBitmap(bmp, newMc.getNextHighestDepth(), "auto", smooth);
		
		newMc._alpha 	= mcAlpha;
		newMc._visible 	= mcVisible;
		
		return newMc;
	}
}
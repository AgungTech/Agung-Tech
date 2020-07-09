import ascb.util.Proxy;
import caurina.transitions.*;
import asual.sa.SWFAddress;
import agung.utils.UAddr;
import flash.display.BitmapData;
import mx.events.EventDispatcher;
import caurina.transitions.properties.ColorShortcuts;


/**
 * This class handles the big button from the sharing list
 */
class agung.tech01.main_l.shareBigItem extends MovieClip
{
	private var node:XMLNode;
	private var settingsObj:Object;
	

	private var mcc:MovieClip;
	private var hit:MovieClip;
	
	private var mcl:MovieClipLoader;
	
	private var origY:Number;
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	public function shareBigItem() {
		EventDispatcher.initialize(this);
		ColorShortcuts.init();
		this._visible = false;
		this._alpha = 0;
		mcl = new MovieClipLoader();
		mcl.addListener(this);
	}
	
	/**
	 * the xml node is being sent and processed
	 * @param	pNode
	 */
	public function setNode(pNode:XMLNode) {
		node = pNode;
		settingsObj = _global.shareModuleSettings;
		
		hit._width = settingsObj.bigButtonsWidth;
		hit._height = settingsObj.bigButtonsHeight + 15;
		hit._alpha = 0;
		
		hit.onRollOver = Proxy.create(this, hitOnRollOver);
		hit.onRollOut = Proxy.create(this, hitOnRollOut);
		hit.onPress = Proxy.create(this, hitOnPress);
		
		Tweener.addTween(mcc, { _saturation:0, _alpha:25, time: .1, transition: "linear" } );
		
		mcc.createEmptyMovieClip("a", mcc.getNextHighestDepth());
		mcl.loadClip(node.attributes.src, mcc["a"]);
	}
	
	private function onLoadInit(mc:MovieClip) {
		getImage(mc, true);
		var o:Object = getDims("fit", mc._width, mc._height, settingsObj.bigButtonsWidth, settingsObj.bigButtonsHeight, false);
		mc._width = o.w;
		mc._height = o.h;
		mc._x = o.x;
		mc._y = origY = 0;
		
		this._visible = true;
		Tweener.addTween(this, { _alpha:100, time: 1, transition: "linear" } );
	}
	
	private function hitOnRollOver() {
		Tweener.addTween(mcc, { _y:origY - 6, _saturation:1, _alpha:100, time: .4, transition: "easeOutBack" } );
		dispatchEvent( { target:this, type:"rolledOverBig", mc:this } );
	}
	
	private function hitOnRollOut() {
		Tweener.addTween(mcc, { _y:origY, _saturation:0, _alpha:25, time: .2, transition: "linear" } );
		dispatchEvent( { target:this, type:"rolledOutBig", mc:this } );
	}
	
	private function hitOnPress() {
	
		hitOnRollOut()
			getURL(node.attributes.url, node.attributes.target);
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
	
	// Utils.getDims("fit", 100, 200, 50, 50, true)
	// returns: new width and height in pixels
	// type:String - "fit" or "crop"
	// ow:Number, oh:Number - object original width and height
	// mw:Number, mh:Number - maximum width and height
	// scaleUp:Boolean - if true, the image will be scal;ed up even if it is smaller than mwxmh
	private function getDims(type:String, ow:Number, oh:Number, mw:Number, mh:Number, scaleUp:Boolean) {
		scaleUp == undefined ? scaleUp = false : null;
		
		var cw:Number = ow;
		var ch:Number = oh;
		
		if (scaleUp || ow > mw || oh > mh) {
		
			cw = mw;
			ch = mw * oh / ow;
			
			if ((ch > mh && type == "fit") || (ch < mh && type != "fit")) {
				ch = mh;
				cw = mh * ow / oh;
			}
			
		}
		
		var cx:Number = Math.round((mw - cw) / 2 );
		var cy:Number = Math.round((mh - ch) / 2 );
		
		return {w: cw, h: ch, x: cx, y: cy};
	}
}
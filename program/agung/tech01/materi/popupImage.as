import caurina.transitions.*;
import ascb.util.Proxy;
import mx.events.EventDispatcher;
import agung.utils.UNode;
import flash.display.BitmapData;

/**
 * This class handles the popup's image if an image needs to be loaded
 */
class agung.tech01.materi.popupImage extends MovieClip 
{
	private var oldpW:Number = 0;
	private var oldpH:Number = 0;
	
	private var node:XMLNode;
	private var settingsObjPopup:Object;
	public var settingsObj:Object;
	

	private var mask:MovieClip;
	private var holder:MovieClip;
		private var img:MovieClip;
	
	public var videoPlayer:MovieClip;
		
	private var origDims:Object;
	private var mcl:MovieClipLoader;
	
	public var currentDims:Object;
	private var popupDims:Object;
	
	public var myParent:MovieClip;
	public var imageLoaded:Number = 0;
	
	private var loader:MovieClip;
	
	public function popupImage() {
		EventDispatcher.initialize(this);
		
		this._visible = false;

		
		
		mcl = new MovieClipLoader();
		mcl.addListener(this);
		img = holder["img"];
		img._alpha = 0;
	}
	

	/**
	 * here, the node and popup settings are being sent and processed
	 * @param	pNode
	 * @param	pSettingsObjPopup
	 * @param	pPopupDims
	 */
	public function setNode(pNode:XMLNode, pSettingsObjPopup:Object, pPopupDims:Object)
	{
		node = pNode.firstChild;
		popupDims = pPopupDims;
		
		settingsObjPopup = pSettingsObjPopup;
		settingsObj = UNode.nodeToObj(node);
		
		var loadAddress:Array = node.attributes.imageAddress.split(".");
		var lastL:Number = loadAddress.length - 1;
		
		var myYArr:Array = node.attributes.imageAddress.split("/", 1);
			
		
	
		
		if ((loadAddress[lastL] == "flv") || (loadAddress[lastL] == "mov") || (loadAddress[lastL] == "mp4") || (loadAddress[lastL] == "h264") || (myYArr[0] == "http:") || (loadAddress[lastL] == "mp3")) {
		
			trace("video Present !");
				if (loadAddress[0] == "http://www") {
						trace("we have youtube !!!!!!!!!!!!!!!!!!!!");
						
						settingsObj.fixedSizeHeight = Math.ceil(settingsObj.fixedSizeHeight * 9 / 16);
					}
					
			videoPlayer = holder.attachMovie("IDvideoPlayer", "videoPlayer", holder.getNextHighestDepth());
			videoPlayer.myParent = myParent;
			videoPlayer.setNode(node, settingsObjPopup, settingsObj);
			mask._visible = false;
			myParent.videoLoadedResize();
			loader._visible = false
			
		}
		else {
			trace("image Present !");
			holder.setMask(mask);
			mcl.loadClip(node.attributes.imageAddress, img["mc"]);
		}
		
		loader._x = Math.ceil(myParent.innerStroke._width / 2 - loader._width / 2 - 50);
		loader._y = Math.ceil(myParent.innerStroke._height / 2 - loader._height / 2 - 50);
		
		this._visible = true;
	}
	
	/**
	 * this function launches after the image is loaded
	 * this function will also call the parent classes in order to properly resize the player
	 * @param	mc
	 */
	private function onLoadInit(mc:MovieClip) {
		getImage(mc, true);
		origDims = new Object();
		origDims.w = mc._width;
		origDims.h = mc._height;

		var o:Object = getDims("fit", origDims.w , origDims.h, popupDims.w, popupDims.h, false);
		
		img._width = mask._width = o.w;
		img._height = mask._height = o.h;
		
		myParent.imageLoadedResize();
		
		Tweener.addTween(img, { _alpha:100,time:settingsObjPopup.popupResizeAnimationTime, transition:settingsObjPopup.popupResizeAnimationType } );
			
		if ((settingsObj.launchUrlOnPress != "") || (settingsObj.launchUrlOnPress != " ") || (settingsObj.launchUrlOnPress != undefined)) {
			img.onPress = Proxy.create(this, bgOnPress);
		}
		imageLoaded = 1;
		
		loader._visible = false
	}
	
	private function bgOnPress() {
		getURL(settingsObj.launchUrlOnPress, settingsObjPopup.targetUrlOnPress);
	}
	private function resize(pPopupDims:Object) {
		popupDims = pPopupDims;
		
		var o:Object = getDims("fit", origDims.w , origDims.h, popupDims.w, popupDims.h, false);
		
		Tweener.addTween(img, { _width:o.w, _height:o.h, time:settingsObjPopup.popupResizeAnimationTime, transition:settingsObjPopup.popupResizeAnimationType,rounded:true } );
		Tweener.addTween(mask, { _width:o.w, _height:o.h, time:settingsObjPopup.popupResizeAnimationTime, transition:settingsObjPopup.popupResizeAnimationType,rounded:true } );
		
		myParent.resizaBackFromImage(o);
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
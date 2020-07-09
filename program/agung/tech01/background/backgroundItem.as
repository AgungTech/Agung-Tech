/**
  * Kelas ini mengatur satu item untuk komponen background.
  * Mengatur file video, gambar atau swf tanpa masalah
  * Fungsi setData akan mengirim alamat untuk media untuk loading dan setting
  *
*/

import agung.utils.UXml;
import agung.utils.UNode;
import caurina.transitions.*;
import ascb.util.Proxy;
import agung.utils.UArray;
import flash.display.BitmapData;
import agung.VideoPlaybackLight;
import mx.events.EventDispatcher;

class agung.tech01.background.backgroundItem extends MovieClip
{
	public var vidCtrl:Object;
	
	private var oldpW:Number = 0;
	private var oldpH:Number = 0;

	private var origW:Number;
	private var origH:Number;
	
	private var node:XMLNode;
	public var settingsObj:Object;
	
	private var holder:MovieClip;
	private var bg:MovieClip;
	
	private var mcl:MovieClipLoader;
	
	public var myParent:MovieClip;
	private var myInterval:Number;
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	private var myStr:String;
	/**
	 * Ini adalah konstruktor dimana semua variabel sedang direferensikan dan dijalankan
	 */
	public function backgroundItem() {
		EventDispatcher.initialize(this);
		this._visible = false;
		this._alpha = 0;
	}
	
	private function setData(pStr:String, pSettings:Object) {
		settingsObj = pSettings;
		var str:String = myStr = pStr;
		var arr:Array = str.split(".");
		if ((arr[arr.length - 1] == "flv") || ((arr[arr.length - 1] == "mp4")) || ((arr[arr.length - 1] == "mkv"))) {
				vidCtrl = new VideoPlaybackLight(this["mc"].vid);
				vidCtrl.autoPlay = true;
				vidCtrl.smothing = true;
				vidCtrl.repeat = false;
				vidCtrl.bufferTime = 3;
				
				vidCtrl.setVolume(0);
			
				vidCtrl.onPlaybackError = Proxy.create(this, PlaybackError);
				vidCtrl.onPlaybackComplete = Proxy.create(this, playbackComplete);
				vidCtrl.onPlaybackPause = Proxy.create(this, PlaybackPause);
			
				vidCtrl.load(str);
				
				loadStageResize();
				this._visible = true;
				show();
		}
		else {
			this["mc"]._visible = false;
			mcl = new MovieClipLoader();
			mcl.addListener(this);
			
			mcl.loadClip(pStr, holder);
		}
			
	}
	
	private function playbackComplete() {
		dispatchEvent( { target:this, type:"playbackComplete", mc:this } );
		
	}
	
	private function PlaybackError() {
		
	}
	
	private function PlaybackPause() {
		
	}
	
	private function show() {
		Tweener.addTween(this, { _alpha:settingsObj.imageFinalAlphaValue, time:settingsObj.animationTime, transition:settingsObj.animationType } );
	}
	
	public function hide() {
		vidCtrl.reset();
		Tweener.addTween(this, { _alpha:0, time:settingsObj.animationTime, transition:settingsObj.animationType } );
		myInterval = setInterval(this, "removeThis", settingsObj.animationTime * 1000);
	}
	
	private function removeThis() {
		clearInterval(myInterval);
		this.removeMovieClip();
	}
	
	private function onLoadInit(mc:MovieClip) {
		var str:String = myStr;
		var arr:Array = str.split(".");
		if (arr[arr.length - 1] != "swf") {
			getImage(mc, true);
		}
		
		
		
		
		origW = mc._width;
		origH = mc._height;
		
		this._visible = true;
		
		loadStageResize();
		
		show();
	}
	
	/**
	 * fungsi yang dipanggil ketika aplikasi diubah ukurannya
	 * @param	pW
	 * @param	pH
	 */
	private function resize(pW:Number, pH:Number) {
		if ((pW != oldpW) || (pH != oldpH)) {
			oldpW = pW;
			oldpH = pH;
			
			bg._width = pW;
			bg._height = pH;
			
			
			
		
			
		
			if (vidCtrl) {
				var o:Object = getDims("crop", this["mc"]._width, this["mc"]._height, pW, pH, true);
				this["mc"]._width = o.w;
				this["mc"]._height = o.h
				this["mc"]._x = o.x;
				this["mc"]._y = o.y;
			}
			else {
				switch(settingsObj.resizeMode) {
				case 0:
					holder._width = pW;
					holder._height = pH;
					break;
				case 1:
					var o:Object = getDims("fit", origW, origH, pW, pH, true);
					holder._x = o.x;
					holder._y = o.y;
					holder._width = o.w;
					holder._height = o.h;
					break;
				case 2:
					var o:Object = getDims("fit", origW, origH, pW, pH, false);
					holder._x = o.x;
					holder._y = o.y;
					holder._width = o.w;
					holder._height = o.h;
					break;
				case 3:
					var o:Object = getDims("crop", origW, origH, pW, pH, true);
					holder._x = o.x;
					holder._y = o.y;
					holder._width = o.w;
					holder._height = o.h;
					break;
				}
			}
			
		}
	}
	
	private function onResize() {
		resize(Stage.width, Stage.height);
	}
	
	private function loadStageResize() {
		Stage.addListener(this);
		onResize();
	}
	
	private function generateRand(min:Number, max:Number) {
		max = max - 1;
		var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
		return randomNum;
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
	// returns: lebar dan tinggi baru dalam satuan pixel
	// type:String - "fit" atau "crop"
	// ow:Number, oh:Number - lebar dan tinggi asli objek
	// mw:Number, mh:Number - lebar dan tinggi maksimum
	// scaleUp:Boolean - jika bernilai "true", gambar akan diperbesar jika lebih kecil dari (mw x mh)
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

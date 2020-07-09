import caurina.transitions.*;
import ascb.util.Proxy;
import agung.VideoPlaybackLight;
import agung.media.AudioPlaybackControl;
import mx.events.EventDispatcher;
import agung.utils.UNode;
import flash.display.BitmapData;
import LocalConnection;

class agung.tech01.materi.videoPlayer extends MovieClip 
{
	private var oldpW:Number = 0;
	private var oldpH:Number = 0;
	
	private var node:XMLNode;
	private var settingsObjPopup:Object;
	public var settingsObj:Object;
	private var vidCtrl:Object;

	private var audioPresent:Number = 0;
	private var apc:AudioPlaybackControl;
	private var artworkHolder:MovieClip;
	
	private var newDims:Object;
	public var myParent:MovieClip; 
	private var myInterval:Number;
	private var displayActive:Number = 0;
	
	private var mask:MovieClip;
	private var holder:MovieClip;
		private var bg:MovieClip;
		private var content:MovieClip;
		private var youtubeHolder:MovieClip;
		private var mcl:MovieClipLoader;
			private var vid:MovieClip;
			
	
		private var controls:MovieClip;
			private var displayMask:MovieClip;
			private var display:MovieClip;
				private var displayBg:MovieClip;
				private var stopButton:MovieClip;
				private var pauseButton:MovieClip;
				private var playButton:MovieClip;
				private var sound:MovieClip;
			private var progress:MovieClip;
				private var progressBg:MovieClip;
				private var actualProgressBgWidth:Number;
				private var loadingBg:MovieClip;
				private var playBar:MovieClip;
				private var playBar2:MovieClip;
	
	private var myInterval2:Number;
	private var myInterval3:Number;
	private var myInterval4:Number;
	private var myInterval5:Number;
	
	private var youtubeMode:Number = 0;
	
	private var resumedAudioOnmp3:Number = 0;
	
	private var oldSndPer:Number;
	private var oldPer:Number;
	private var soundInt:Number;
	public function videoPlayer() {
		this._visible = false;
		this._alpha = 0;
		
		holder.setMask(mask);
		bg = holder["bg"];
		content = holder["content"];
		vid = content["vid"];
		
		
		controls = holder["controls"];
			displayMask = controls["displayMask"];
			display = controls["display"];
				displayBg = display["bg"];
				stopButton = display["stopButton"];
				pauseButton = display["paus"];
				playButton = display["playButton"];
				sound = display["sound"];
			progress = controls["progress"];
				progressBg = progress["bg"];
				loadingBg = progress["loading"];
				playBar = progress["playBar"];
				playBar2 = progress["playBar2"];
				playBar2._alpha = 0;
				
		progress._y = Math.ceil(display._height);	
		
		display.setMask(displayMask);
		
		stopButton["over"]._alpha = 0;
		stopButton.onRollOver = Proxy.create(this, stopButtonOnRollOver);
		stopButton.onRollOut = stopButton.onReleaseOutside = Proxy.create(this, stopButtonOnRollOut);
		stopButton.onPress = Proxy.create(this, stopButtonOnPress);
		
		pauseButton["over"]._alpha = 0;
		pauseButton.onRollOver = Proxy.create(this,pauseButtonOnRollOver);
		pauseButton.onRollOut = pauseButton.onReleaseOutside = Proxy.create(this, pauseButtonOnRollOut);
		pauseButton.onPress = Proxy.create(this, pauseButtonOnPress);
		
		playButton["over"]._alpha = 0;
		playButton.onRollOver = Proxy.create(this,playButtonOnRollOver);
		playButton.onRollOut = playButton.onReleaseOutside = Proxy.create(this, playButtonOnRollOut);
		playButton.onPress = Proxy.create(this, playButtonOnPress);
		
		sound["over"]._alpha = 0;
			sound.onRollOver = Proxy.create(this,soundOnRollOver);
		sound.onRollOut = Proxy.create(this,soundonOnRollOut);
		sound.onPress = Proxy.create(this,soundOnPress);
		
		sound.onRelease = Proxy.create(this, soundOnRelease);
		sound.onReleaseOutside = Proxy.create(this, soundOnReleaseOutside);
		display._alpha = 80;
		controls._alpha = 0;
	}
	
	
	
	private function soundOnRollOver() {
		Tweener.addTween(sound["over"], { _alpha:100, time:.1, transition:"linear" } );
		Tweener.addTween(sound["soundController"]["over"], { _alpha:100, time:.1, transition:"linear" } );
	}
	
	private function soundonOnRollOut() {
		Tweener.addTween(sound["over"], { _alpha:0, time:.1, transition:"linear" } );
		Tweener.addTween(sound["soundController"]["over"], { _alpha:0, time:.1, transition:"linear" } );
	}
	
	private function calcSndProg() {
		var actualXPosSnd:Number = Math.max(0, sound["soundController"]._xmouse);
		actualXPosSnd = Math.min(actualXPosSnd, sound["soundController"]["bg"]._width);
		var per:Number =  actualXPosSnd / sound["soundController"]["bg"]._width * 100;
		
		if (per == 0) {
			if (oldPer == 0) {
				per = oldSndPer;
			}
			
		}
		
		
		vidCtrl.setVolume(per / 100);
		
		if (per != 0) {
			oldSndPer = per;
			oldPer = 1;
		}
		else {
			oldPer = 0;
		}
		
		var newSndWidth:Number = Math.ceil(sound["soundController"]["bg"]._width / 100 * per)
		
		Tweener.addTween(sound["soundController"]["normal"], { _width:newSndWidth, time:.2, transition:"linear" } );
		Tweener.addTween(sound["soundController"]["over"], { _width:newSndWidth, time:.2, transition:"linear" } );
		
		if (youtubeMode == 1) {
			youtubeHolder.setVolume(per);
		}
		
		if (audioPresent == 1) {
			apc.volume = per / 100;
		}
	}
	private function soundOnPress() {
		clearInterval(soundInt);
		soundInt = setInterval(this, "calcSndProg", 200);
		calcSndProg();
	}
	
	private function soundOnRelease() {
		clearInterval(soundInt);
	}
	
	private function soundOnReleaseOutside() {
		soundonOnRollOut()
		clearInterval(soundInt);
	}
	
	
	
	private function stopButtonOnRollOver() {
		Tweener.addTween(stopButton["over"], { _alpha:100, time:.1, transition:"linear" } );
	}
	
	private function stopButtonOnRollOut() {
		Tweener.addTween(stopButton["over"], { _alpha:0, time:.1, transition:"linear" } );
	}
	
	private function stopButtonOnPress() {
		vidCtrl.stop();
		Tweener.addTween(playBar, { _width:0, time:.5, transition:"linear" } );
		if (playBar2) {
				Tweener.addTween(playBar2, { _width:0, time:.5, transition:"linear" } );
		}
		pauseButtonOnRollOut()
		pauseButton._visible = false;
		playButton._visible = true;
		playButtonOnRollOut();
		
		if (youtubeMode == 1) {
			youtubeHolder.stopVideo();
		}
		
		if (audioPresent == 1) {
			pauseButtonOnPress();
			apc.seek(0, true);
		}
	}
	
	
	

	private function pauseButtonOnRollOver() {
		Tweener.addTween(pauseButton["over"], { _alpha:100, time:.1, transition:"linear" } );
	}
	
	private function pauseButtonOnRollOut() {
		Tweener.addTween(pauseButton["over"], { _alpha:0, time:.1, transition:"linear" } );
	}
	
	private function pauseButtonOnPress() {
		vidCtrl.pause();
		pauseButtonOnRollOut()
		pauseButton._visible = false;
		playButton._visible = true;
		playButtonOnRollOver();
		
		if (youtubeMode == 1) {
			youtubeHolder.pauseVideo();
		}
		
		if (audioPresent == 1) {
			apc.pause();
		}
	}
	
	
	private function playButtonOnRollOver() {
		Tweener.addTween(playButton["over"], { _alpha:100, time:.1, transition:"linear" } );
	}
	
	private function playButtonOnRollOut() {
		Tweener.addTween(playButton["over"], { _alpha:0, time:.1, transition:"linear" } );
	}
	
	private function playButtonOnPress() {
		vidCtrl.resume();
		
		pauseButtonOnRollOver()
		pauseButton._visible = true;
		playButton._visible = false;
		playButtonOnRollOut();
		
		if (youtubeMode == 1) {
			youtubeHolder.playVideo();
		}
		
		if (audioPresent == 1) {
			apc.play();
		}
	}


	public function setNode(pNode:XMLNode, pSettingsObjPopup:Object, pSettingsObj:Object)
	{
		_global.mp3player.pauseMp3Player();
		
		node = pNode;
		settingsObjPopup = pSettingsObjPopup;
		settingsObj = pSettingsObj;
		
		settingsObj.fixedSizeWidth = Math.min(settingsObj.fixedSizeWidth, Stage.width - 200);
		settingsObj.fixedSizeHeight = Math.min(settingsObj.fixedSizeHeight, Stage.height - 200);
		bg._width = settingsObj.fixedSizeWidth;
		bg._height = settingsObj.fixedSizeHeight;
		
		display["txt"].autoSize = true;
		display["txt"].wordWrap = false;
		display["txt"].text = node.attributes.videoTitle;
		
		oldSndPer = settingsObj.initialVolume;
		
		if (settingsObj.autoplay==1) {
			playButton._visible = false;
		}
		else {
			pauseButton._visible  = false
		}
		
		var myYArr:Array = node.attributes.imageAddress.split("/", 1);
		if (myYArr[0] == "http:") {
			trace("Youtube video Present !");
			youtubeMode = 1;
			stopButton._visible = false;
			youtubeHolder = content.createEmptyMovieClip("youtubeHolderA", content.getNextHighestDepth());
			youtubeHolder._alpha = 0;
			mcl = new MovieClipLoader();
			mcl.addListener(this);
			display["txt"]._x =  36;
			myInterval5 = setInterval(this, "startLoadingYoutube", 30);
		}
		else {
			var myYArr2:Array = node.attributes.imageAddress.split(".");
			
			if (myYArr2[myYArr2.length-1] == "mp3") {
				audioPresent = 1;
				trace("we have audio")
				
				apc = new AudioPlaybackControl();
				apc.autoPlay = Boolean(settingsObj.autoplay);
				apc.bufferTime = 3;
				apc.volume = settingsObj.initialVolume;
				
				var audObj:Object = new Object();
				audObj.onLoadProgress = Proxy.create(this, audioOnLoadProgress);
				audObj.onPlaybackTimeUpdate = Proxy.create(this, onPlaybackTimeUpdateAudio);
				
				apc.addListener(audObj);
				apc.load(node.attributes.imageAddress);
				
				newDims = new Object();
				newDims.w = settingsObj.fixedSizeWidth;
				newDims.h = settingsObj.fixedSizeHeight;
			
				myParent.resizaBackFromImage(newDims);
				Tweener.addTween(bg, { _width:newDims.w + 2, _height:newDims.h + 2, time:settingsObjPopup.popupResizeAnimationTime, transition:settingsObjPopup.popupResizeAnimationType, rounded:true } );
				
				actualProgressBgWidth = displayBg._width = displayMask._width = newDims.w;
				Tweener.addTween(progressBg, { _width:actualProgressBgWidth, time:settingsObjPopup.popupResizeAnimationTime, transition:settingsObjPopup.popupResizeAnimationType, rounded:true } );
				
				controls._y = Math.ceil(newDims.h + 2 - controls._height + 1);
				display._y = 50;
				Tweener.addTween(controls, { _alpha:100, time:5, transition:"linear", rounded:true } );
				sound._x = Math.ceil(newDims.w - sound._width - 10);
				
				myInterval = setInterval(this, "checkHitArea", 30);
				
				artworkHolder = holder["artworkHolder"];
				artworkHolder._alpha = 0;
				var mcl2:MovieClipLoader = new MovieClipLoader();
				var mclObj:Object = new Object();
				mclObj.onLoadInit = Proxy.create(this, artworkInit);
				mcl2.addListener(mclObj);
						
				var artworkString:String = node.attributes.audioArtwork;
				if (!node.attributes.audioArtwork) {
					var artworkString:String = "misc/default_artwork.jpg";
				}
				
				mcl2.loadClip(artworkString, artworkHolder);
			}
			else {
				vidCtrl = new Object();
				vidCtrl = new VideoPlaybackLight(vid.mc);
				vidCtrl.autoPlay = Boolean(settingsObj.autoplay);
				vidCtrl.smothing = Boolean(settingsObj.repeat);
				vidCtrl.bufferTime = 3;
				vidCtrl.$resizeMode = Number(settingsObj.resizeMode)
				vidCtrl.setVolume(settingsObj.initialVolume / 100);
				vidCtrl.setMaxSize(settingsObj.fixedSizeWidth - 2, settingsObj.fixedSizeHeight - 2);
				
				vidCtrl.onInit = Proxy.create(this, videoPlayerOnInit);
				vidCtrl.onPlaybackError = Proxy.create(this, PlaybackError);
				vidCtrl.onPlaybackComplete = Proxy.create(this, playbackComplete);
				vidCtrl.onPlaybackPause = Proxy.create(this, PlaybackPause);
				vidCtrl.onLoadProgress = Proxy.create(this, onLoadProgress);
				vidCtrl.onPlaybackTimeUpdate = Proxy.create(this, onPlaybackTimeUpdate);
				vidCtrl.load(node.attributes.imageAddress);
			}
			
			
			
		}
		
		
		var newSndWidth:Number = Math.ceil(sound["soundController"]["bg"]._width / 100 * settingsObj.initialVolume);
		
		Tweener.addTween(sound["soundController"]["normal"], { _width:newSndWidth, time:.5, transition:"linear" } );
		Tweener.addTween(sound["soundController"]["over"], { _width:newSndWidth, time:.5, transition:"linear" } );
		
		
		
		mask._width = playBar._width = playBar2._width = 0;
		mask._height = 0;
		
		Tweener.addTween(mask, { _width:settingsObj.fixedSizeWidth, _height:settingsObj.fixedSizeHeight, time:settingsObjPopup.popupResizeAnimationTime, transition:settingsObjPopup.popupResizeAnimationType, rounded:true } );
		
		Tweener.addTween(this, { _alpha:100, delay:.9, time:1, transition:"linear", rounded:true } );
		
		loadingBg.onPress = Proxy.create(this, scrubHere)
		if (playBar2) {
			loadingBg.onRollOver = Proxy.create(this, lbOver);
			loadingBg.onRollOut = Proxy.create(this, lbOut);
			loadingBg.onReleaseOutside = Proxy.create(this, lbRel);
		}
		
		
		this._visible = true;
	}	
	
	private function lbOver() {
		Tweener.addTween(playBar2, { _alpha:100, time:.5, transition:"linear" } );
		
	}
	
	private function lbOut() {
		Tweener.addTween(playBar2, { _alpha:0, time:.5, transition:"linear" } );
	}
	
	private function lbRel() {
		lbOut()
	}
	
	private function artworkInit(mc:MovieClip) {
		getImage(mc, true);
			
		var o:Object = getDims("fit", mc._width, mc._height,  settingsObj.fixedSizeWidth, settingsObj.fixedSizeHeight, true);
		
		mc._width = o.w;
		mc._height = o.h;
		mc._x = o.x;
		mc._y = o.y;
		
		Tweener.addTween(artworkHolder, { _alpha:100, time:1, transition:"linear", rounded:true } );
	
		if ((settingsObj.launchUrlOnPress != "") || (settingsObj.launchUrlOnPress != " ") || (settingsObj.launchUrlOnPress != undefined)) {
			mc.onPress = Proxy.create(this, bgOnPress);
		}
	}
	private function bgOnPress() {
		getURL(settingsObj.launchUrlOnPress, settingsObjPopup.targetUrlOnPress);
	}
	private function onPlaybackTimeUpdateAudio(e:Object) {
		var percentage:Number = e.totalTime ? e.currentTime / e.totalTime : 0;
percentage = percentage*100
		Tweener.addTween(playBar, { _width:Math.round(actualProgressBgWidth / 100 * percentage), time:.6, transition:"linear" } );
		if (playBar2) {
			Tweener.addTween(playBar2, { _width:Math.round(actualProgressBgWidth / 100 * percentage), time:.6, transition:"linear" } );
		}
	}
	
	private function audioOnLoadProgress(e:Object) {
		var percentage:Number = e.totalBytes > 0 ? e.loadedBytes / e.totalBytes : 0;
		percentage = percentage*100
		Tweener.addTween(loadingBg, { _width:Math.round(actualProgressBgWidth / 100 * percentage), time:.2, transition:"linear"} );

	}
	
	private function startLoadingYoutube() {
		clearInterval(myInterval5);
		mcl.loadClip("http://www.youtube.com/apiplayer", youtubeHolder);
	}

	private function checkLoaded() {
		if (youtubeHolder.isPlayerLoaded()) {
			clearInterval(myInterval2);
			
			var composeString:Array = node.attributes.imageAddress.split("=", 3);
				
			var newCompose:Array = composeString[1].split("&", 1);
				
			var theNewVideo:String = "http://www.youtube.com/v/" + newCompose[0] + "&hl=en_US&fs=1&"
				
			youtubeHolder.loadVideoByUrl(theNewVideo)
			
			youtubeHolder.setSize(settingsObj.fixedSizeWidth - 2, settingsObj.fixedSizeHeight - 2)
			youtubeHolder.setVolume(settingsObj.initialVolume);
			
			if (Boolean(settingsObj.autoplay)) {
				youtubeHolder.playVideo();
			}
			else {
				youtubeHolder.pauseVideo();
			}
			
			
			Tweener.addTween(youtubeHolder, { _alpha:100, time:3, transition:"linear", rounded:true } );
			
			newDims = new Object();
			newDims.w = settingsObj.fixedSizeWidth;
			newDims.h = settingsObj.fixedSizeHeight;
			
			Tweener.addTween(bg, { _width:newDims.w + 2, _height:newDims.h + 2, time:settingsObjPopup.popupResizeAnimationTime, transition:settingsObjPopup.popupResizeAnimationType, rounded:true } );
		
		actualProgressBgWidth = displayBg._width = displayMask._width = newDims.w;
		Tweener.addTween(progressBg, { _width:actualProgressBgWidth, time:settingsObjPopup.popupResizeAnimationTime, transition:settingsObjPopup.popupResizeAnimationType, rounded:true } );
		
			controls._y = Math.ceil(newDims.h + 2 - controls._height + 1);
			display._y = 50;
			sound._x = Math.ceil(newDims.w - sound._width - 10);
			
			myInterval = setInterval(this, "checkHitArea", 30);
			
			
			
			myInterval4 = setInterval(this, "waitForControls", 1000);
		}
	}
	
	private function waitForControls() {
		clearInterval(myInterval4);
		
		myInterval2 = setInterval(this, "checkLoadProgress", 500);
			
		myInterval3 = setInterval(this, "checkPlayProgress", 500);
		
		Tweener.addTween(controls, { _alpha:100, time:3, transition:"linear", rounded:true } );

	}
	
	
	private function checkPlayProgress() {	
		var per:Number =  Math.round(youtubeHolder.getCurrentTime() / youtubeHolder.getDuration()*100);
		
		Tweener.addTween(playBar, { _width:Math.round(actualProgressBgWidth / 100 * per), time:.6, transition:"linear" } );
		if (playBar2) {
			Tweener.addTween(playBar2, { _width:Math.round(actualProgressBgWidth / 100 * per), time:.6, transition:"linear"} );
		}
	}
	
	private function checkLoadProgress() {
		var per:Number =  Math.round(youtubeHolder.getVideoBytesLoaded()/youtubeHolder.getVideoBytesTotal()*100);
		Tweener.addTween(loadingBg, { _width:Math.round(actualProgressBgWidth / 100 * per), time:.6, transition:"linear" } );
	}
	
	private function onLoadInit(mc:MovieClip) {
		trace("loaded !")
	
		myInterval2 = setInterval(this, "checkLoaded", 30);
	}
	
	private function videoPlayerOnInit() {
		newDims = vidCtrl.scaleVideo();
		myParent.resizaBackFromImage(newDims);
		Tweener.addTween(bg, { _width:newDims.w + 2, _height:newDims.h + 2, time:settingsObjPopup.popupResizeAnimationTime, transition:settingsObjPopup.popupResizeAnimationType, rounded:true } );
		
		actualProgressBgWidth = displayBg._width = displayMask._width = newDims.w;
		Tweener.addTween(progressBg, { _width:actualProgressBgWidth, time:settingsObjPopup.popupResizeAnimationTime, transition:settingsObjPopup.popupResizeAnimationType, rounded:true } );
		
		controls._y = Math.ceil(newDims.h + 2 - controls._height + 1);
		display._y = 50;
		Tweener.addTween(controls, { _alpha:100, time:5, transition:"linear", rounded:true } );
		sound._x = Math.ceil(newDims.w - sound._width - 10);
		
		myInterval = setInterval(this, "checkHitArea", 30);
		
	}
	
	private function checkHitArea() {
		if (this._xmouse > 0 && this._xmouse < bg._width && this._ymouse > 0 && this._ymouse < (bg._height+10)) {
			if (displayActive == 0) {
				Tweener.addTween(display, { _y:0, time:.5, transition:"easeIn" } );
				displayActive = 1;
			}
		}
		else {
			if (displayActive == 1) {
				Tweener.addTween(display, { _y:50, time:.5, transition:"easeIn" } );
				displayActive = 0;
			}
		}
	}
	
	private function PlaybackError(mc:MovieClip) {
		
	}
	
	private function PlaybackPause(mc:MovieClip) {
		
	}
	
	private function playbackComplete(mc:MovieClip) {
		pauseButtonOnRollOut()
		pauseButton._visible = false;
		playButton._visible = true;
	}
	
	private function onLoadProgress(t:Number, l:Number) {
		var per:Number =  Math.round(100 / (t / l));
		Tweener.addTween(loadingBg, { _width:Math.round(actualProgressBgWidth / 100 * per), time:.2, transition:"linear"} );
		
	}
	
	private function onPlaybackTimeUpdate(t:Number, l:Number, ft:String, fl:String) {
		var per:Number =  Math.round(100/(t/l));
		
		Tweener.addTween(playBar, { _width:Math.round(actualProgressBgWidth / 100 * per), time:.5, transition:"linear"} );
	}
	
	private function scrubHere() {
		var per:Number = Math.round(this._xmouse / actualProgressBgWidth * 100);
		vidCtrl.seek(per / 100, true);
		
		if (youtubeMode == 1) {
			
			youtubeHolder.seekTo(per/100*youtubeHolder.getDuration(), false);
		}
		
		if (audioPresent == 1) {
			apc.seek(per/100, true);
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
	
	public function remThis() {
		if (resumedAudioOnmp3 == 0) {
			resumedAudioOnmp3 = 1;
			_global.mp3player.resumeMp3Player();
		}
		
		if (audioPresent == 1) {
			apc.stop();
			apc.reset();
		}
		
		//if (youtubeMode == 1) {	
			youtubeHolder.setVolume(0);
			youtubeHolder.stopVideo();
			youtubeHolder.destroy();
			youtubeHolder.unloadMovie();
	//	}
		
		clearInterval(myInterval);
		clearInterval(myInterval2);
		clearInterval(myInterval3);
		clearInterval(myInterval4);
		clearInterval(myInterval5);
		
		vidCtrl.reset();
	}
}
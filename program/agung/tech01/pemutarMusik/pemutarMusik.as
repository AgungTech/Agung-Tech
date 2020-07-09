import ascb.util.Proxy;
import caurina.transitions.*;
import caurina.transitions.properties.FilterShortcuts;
import agung.media.AudioPlaybackControl;
import agung.utils.UNode;
import agung.utils.UXml;
import agung.utils.UMc;


class agung.tech01.pemutarMusik.pemutarMusik extends MovieClip
{
	private var xml:XML;
	private var settingsObj:Object;
	
	private var mainMask:MovieClip;
	private var mainIcon:MovieClip;
		private var hiddenIcon:MovieClip;
		private var openedIcon:MovieClip;
	private var multiHolder:MovieClip;
	
	private var controls:MovieClip;
		private var prev:MovieClip;
		private var pp:MovieClip;
		private var next:MovieClip;
		private var info:MovieClip;
		private var pList:MovieClip;
		private var closeButton:MovieClip;
		private var snd:MovieClip;
			private var sndIcon:MovieClip;
			private var volumeScrubBar:MovieClip;
		private var scrubBar:MovieClip;
			private var scrubBarFill:MovieClip;
		
		
	private var playlist:MovieClip;
	private var playlistMask:MovieClip;
	private var bg:MovieClip;
	
	private var currentButton:MovieClip = undefined;
	
	private var infoPanel:MovieClip;
	
	private var currentState:Number = 0;
	
	private var playlistActive:Number = 0;
	
	private var infoActive:Number = 0;
	
	private var oldVol:Number = 80;
	
	private var currentVolume:Number;
	
	private var apc:AudioPlaybackControl;
	
	private var openStatus:Number = 0;
	
	private var myInterval:Number;
	
	private var oldPlayState:Number = 0;
	
	
	private var waitIntervalForResume:Number;
	
	private var sndInterval:Number;
	private var currentPer:Number;
	private var multiXDef:Number;
	

	private var repeatMode:Number = 0;
	private var randomizeMode:Number = 0;
	private var startup:Number = 1;
	private var permitSeekNow:Number = 0;
	private var theObject:Object;
	
	private var toggleWhite:MovieClip;
	
	private var sndPressedNow:Number = 0;
	
	private var permitInit:Number = 1;
	/**
	 * this class is the main class and handles everything from loading the xml file to attaching the playlist
	 */
	public function pemutarMusik() {
		FilterShortcuts.init();

		_global.mp3player = this;
		
		controls = multiHolder["controls"];
		
		bg = multiHolder["bg"];
	
		mainIcon["fill"].setMask(mainIcon["mainIconMask"]);
		
		this._visible = false;
		this._alpha = 0;
		
		playlist.setMask(playlistMask);
		
		prev = controls["prev"];
		pp = controls["pp"];
		
		next = controls["next"];
		info = controls["info"];
		pList = controls["pList"];
		snd = controls["snd"];
		scrubBar = controls["scrubBar"];
			scrubBarFill = scrubBar["fillNormal"];
			
		sndIcon = snd["icon"];
		volumeScrubBar = snd["volumeScrubBar"];
		
		closeButton = controls["closeButton"];
		
		closeButton["fill"].setMask(closeButton["mask"]);
		
		
		
		
		apc = new AudioPlaybackControl();
		apc.addListener(this);
		
		hiddenIcon = mainIcon["hidden"];
		openedIcon = mainIcon["opened"];
		
		activateListeners();
		loadMyXml();
	}
	
	
	/**
	 * here, I resize and position all the components
	 */
	private function resizeAndPosition() {
		
		bg._height = _global.MainComponent.footerFill._height;
		var extraAdd:Number = 0;
		if (toggleWhite) {
			extraAdd = 2;
			
		}
		multiHolder._x = multiXDef = -171 - 43;
		controls._y = Math.round(bg._height / 2 - controls._height / 2 - 4);
		
		pp._x = 0;
		pp._y = 0
		prev._x = Math.ceil(pp._width + 4 + extraAdd);
		prev._y = 0
		next._x = Math.round(prev._x + prev._width + 4 + extraAdd);
		next._y = 0
		info._x = Math.round(next._x + next._width + 4 + extraAdd);
		info._y = 0
		pList._x = Math.round(info._x + info._width + 4 +extraAdd);
		pList._y = 0
		
		
		
		snd._x = Math.round(pList._x + pList._width + 4 + extraAdd);
		
		scrubBar._x = 2;
		scrubBar._y = Math.ceil(pp._height + 2);
		
		closeButton._x = Math.round(snd._x + snd._width + 5);
		
		mainIcon._y = Math.round(bg._height / 2 - mainIcon._height / 2 - 9);
		
		mainMask._width = bg._width;
		mainMask._height = bg._height;
		multiHolder._x = mainMask._width;
		mainMask._x = multiXDef + 4;
		mainMask._y -= 4;
		multiHolder.setMask(mainMask);
		
		playlist._x = playlistMask._x = Math.ceil( -settingsObj.playlistWidth + 25);
	
		playlistMask._width = settingsObj.playlistWidth;
		playlistMask._height = settingsObj.playlistHeight + 2;
		playlistMask._y = -playlistMask._height-10;
		
		closeButton["mask"]._width = 0;
	}

	private function activateListeners() {
		prev["over"]._alpha = 0;
		prev.onRollOver = Proxy.create(this, prevOnRollOver);
		prev.onRollOut = Proxy.create(this, prevOnRollOut);
		prev.onPress = Proxy.create(this, prevOnPress);
		prev.onReleaseOutside = Proxy.create(this, prevOnRelease);
		
		
		next["over"]._alpha = 0;
		next.onRollOver = Proxy.create(this, nextOnRollOver);
		next.onRollOut = Proxy.create(this, nextOnRollOut);
		next.onPress = Proxy.create(this, nextOnPress);
		next.onReleaseOutside = Proxy.create(this, nextOnRelease);
		
		
		pp["over"]._alpha = 0;
		Tweener.addTween(pp["pl"]["over"], { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(pp["paus"]["over"], { _alpha:0, time:0.2, transition:"linear" } );
		pp.onRollOver = Proxy.create(this, ppOnRollOver);
		pp.onRollOut = Proxy.create(this,ppOnRollOut);
		pp.onPress = Proxy.create(this, ppOnPress);
		pp.onReleaseOutside = Proxy.create(this, ppOnRelease);
		
		pList["over"]._alpha = 0;	
		pList.onRollOver = Proxy.create(this, pListOnRollOver);
		pList.onRollOut = Proxy.create(this, pListOnRollOut);
		pList.onPress = Proxy.create(this, pListOnPress);
		pList.onReleaseOutside = Proxy.create(this, pListOnRelease);
		
		
		
		info["over"]._alpha = 0;
		info.onRollOver = Proxy.create(this, infoOnRollOver);
		info.onRollOut = Proxy.create(this, infoOnRollOut);
		info.onPress = Proxy.create(this, infoOnPress);
		info.onReleaseOutside = Proxy.create(this, infoOnRelease);
		
		
		snd["over"]._alpha = 0;
		snd["iconOver"]._alpha = 0;
		snd["volumeScrubBar"]["fillOver"]._alpha = 0;
		
		snd.onRollOver = Proxy.create(this, sndOnRollOver);
		snd.onRollOut = Proxy.create(this, sndOnRollOut);
		snd.onPress = Proxy.create(this, sndOnPress);
		snd.onReleaseOutside = snd.onRelease = Proxy.create(this, sndOnRelease);
		

			
			
		scrubBar["fillOver"]._alpha = 0;
		scrubBar.onRollOver = Proxy.create(this, scrubBarOnRollOver);
		scrubBar.onRollOut = Proxy.create(this, scrubBarOnRollOut);
		scrubBar.onPress = Proxy.create(this, scrubBarBarOnPress);
		scrubBar.onReleaseOutside = Proxy.create(this, scrubBarOnReleaseOutside);
		scrubBar.onRelease = Proxy.create(this, scrubBarOnRelease);
		
		
		hiddenIcon["over"]._alpha = openedIcon["over"]._alpha = 0;
		openedIcon._alpha = 0;
		
		mainIcon.onRollOver = Proxy.create(this, mainIconOnRollOver);
		mainIcon.onRollOut = hiddenIcon.onReleaseOutside = Proxy.create(this, mainIconOnRollOut);
		mainIcon.onPress = Proxy.create(this, mainIconOnPress);

		
		closeButton._alpha = 70;
		
		closeButton.onRollOver = Proxy.create(this, closeButtonOnRollOver);
		closeButton.onRollOut = Proxy.create(this, closeButtonOnRollOut);
		closeButton.onPress = Proxy.create(this, closeButtonOnPress);
		closeButton.onReleaseOutside = Proxy.create(this, closeButtonOnRelease);
		
		
	}
	

	private function sndOnRollOver() {
		
		clearInterval(sndInterval);
		Tweener.addTween(snd["over"], { _alpha:100, time:0.2, transition:"linear" } );
		Tweener.addTween(snd["iconOver"], { _alpha:100, time:0.2, transition:"linear" } );
		Tweener.addTween(snd["volumeScrubBar"]["fillOver"], { _alpha:100, time:0.2, transition:"linear" } );
		sndInterval = setInterval(this, "checkSnd", 30);
		
		
		_global.theBottomShopPreview.killPanelOnBottom();
	}
	
	private function sndOnRollOut() {
		_global.MainComponent.scrollerDesGlobal.hide();
		clearInterval(sndInterval);
		Tweener.addTween(snd["over"], { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(snd["iconOver"], { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(snd["volumeScrubBar"]["fillOver"], { _alpha:0, time:0.2, transition:"linear" } );
	}
	
	private function sndOnPress() {
		sndPressedNow = 1;
		
		settingVol()
		
		if (snd._xmouse < snd["volumeScrubBar"]._x) {
			sndPressedNow = 0;
		
		}
	}
	
	private function settingVol() {
		if (snd._xmouse < snd["volumeScrubBar"]._x) {
				if (currentVolume == 0) {
					
					setNewVolume(oldVol);
				}
				else {
					
					
					
					setNewVolume(0);
				}
		}
		else {
				var hitWidth:Number = volumeScrubBar["volumeScrubBarHit"]._width;
				var currentX:Number = Math.max(0, Math.min(volumeScrubBar._xmouse, hitWidth));
				var percentage:Number = Math.round(100 - ( hitWidth - currentX) / hitWidth * 100);
				
				setNewVolume(percentage, currentX);
		}
		if ((snd._xmouse > 0) && (snd._xmouse < snd._width) && (snd._ymouse > -6) && (snd._ymouse < snd._height))
		{
			
		}
		else {
			sndOnRollOut()
			sndOnRelease()
		}
	}
	
	private function sndOnRelease() {
		sndPressedNow = 0;
	}
	
	
	private function checkSnd() {
		if (snd._xmouse < snd["volumeScrubBar"]._x) {
			if (!sndPressedNow) {
				if (currentVolume == 0) {
					_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.unmuteCaption);
				}
				else {
					_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.muteCaption);
				}
			}
			
		}
		else {
			var hitWidth:Number = volumeScrubBar["volumeScrubBarHit"]._width;
			var currentX:Number = Math.max(0, Math.min(volumeScrubBar._xmouse, hitWidth));
			var percentage:Number = Math.round(100 - ( hitWidth - currentX) / hitWidth * 100);
			
			_global.MainComponent.scrollerDesGlobal.setNewTextAdjusted(settingsObj.setVolumeCaption + " " + percentage + settingsObj.setVolumePer);
		}
		
		if (sndPressedNow) {
			settingVol()
		}

	}
	
	
	/**
	 * behaviors for pp
	 */
	
	 private function ppOnPress() {
		clearInterval(waitIntervalForResume);
		
		if (currentState == 1) {
			enablePlay();
			oldPlayState = 0;
		}
		else {
			enablePause();
			oldPlayState = 1;
		}
		
		
		if (currentState == 1) {
			_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.pauseSongCaption);
		}
		else {
			_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.playSongCaption);
		}
	}
	
	private function ppOnRollOver() {
		Tweener.addTween(pp["over"], { _alpha:100, time:0.2, transition:"linear" } );
		
		Tweener.addTween(pp["pl"]["over"], { _alpha:100, time:0.2, transition:"linear" } );
		Tweener.addTween(pp["paus"]["over"], { _alpha:100, time:0.2, transition:"linear" } );
		
		if (currentState == 1) {
			_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.pauseSongCaption);
		}
		else {
			_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.playSongCaption);
		}
		
		
		_global.theBottomShopPreview.killPanelOnBottom();
	}
	
	private function ppOnRollOut() {
		Tweener.addTween(pp["over"], { _alpha:0, time:0.2, transition:"linear" } );
		
		Tweener.addTween(pp["pl"]["over"], { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(pp["paus"]["over"], { _alpha:0, time:0.2, transition:"linear" } );
		
		_global.MainComponent.scrollerDesGlobal.hide();
	}
	
	private function ppOnRelease() {
		ppOnRollOut();
	}
	
	
	private function enablePlay() {
		currentState = 0;
		Tweener.addTween(pp["pl"], { _alpha:100, time:0.2, transition:"linear" } );
		Tweener.addTween(pp["paus"], { _alpha:0, time:0.2, transition:"linear" } );

		apc.pause();
	}
	
	private function enablePause() {
		currentState = 1;
		Tweener.addTween(pp["pl"], { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(pp["paus"], { _alpha:100, time:0.2, transition:"linear" } );
		
		apc.play();
	}
	
	
	/**
	 * this will pause the mp3 player
	 */
	public function pauseMp3Player() {
		clearInterval(waitIntervalForResume);
		
		if (currentState == 1) {
			oldPlayState = 1;
			ppOnPressWhenCalled();
		}
	}
	
	/**
	 * this will resume the mp3 player
	 */
	public function resumeMp3Player() {
		if ((currentState == 0) && (oldPlayState == 1)) {
			waitIntervalForResume = setInterval(this, "doResume", 1500);
		}
	}
	
	public function doResume() {
		clearInterval(waitIntervalForResume);
		
		if ((currentState == 0) && (oldPlayState == 1)) {
			ppOnPressWhenCalled();
		}
	}
	
	private function ppOnPressWhenCalled() {
		clearInterval(waitIntervalForResume);
		
		blurOneButton(pp);
		
		if (currentState == 1) {
			enablePlay();
		}
		else {
			enablePause();
		}
	}

	
	private function onReady() {
		if (permitInit == 1) {
			permitInit = 0;
			if (settingsObj.autoPlay == 0) {
				enablePlay();
			}
			else {
				apc.play();
			}
		}
		else {
			apc.play();
		}
		
		
	}
	
	private function onLoadProgress(e:Object) {
		theObject = e;
		var percentage:Number = e.totalBytes > 0 ? e.loadedBytes / e.totalBytes : 0;
		Tweener.addTween(scrubBar["loaded"], { _width:scrubBar["hit"]._width * percentage, time:0.15, transition:"linear" } );
	}
	
	private function onPlaybackTimeUpdate(e:Object) {
		theObject = e;
		var percentage:Number = e.totalTime ? e.currentTime / e.totalTime : 0;
		scrubBar["fillNormal"]._width = scrubBar["fillOver"]._width = scrubBar["hit"]._width * percentage;
	}
	
	private function onPlaybackStart() {
		apc.autoPlay 		= true;
		
		currentState = 1;
		Tweener.addTween(pp["pl"], { _alpha:0, time:0.15, transition:"linear" } );
		Tweener.addTween(pp["paus"], { _alpha:100, time:0.15, transition:"linear" } );
	}
	
	public function toggleRepeat(value:Number) {
		repeatMode = value;
	}
	
	public function toggleRandomize(value:Number) {
		randomizeMode = value;
	}
	
	private function onPlaybackComplete() {		
		if (settingsObj.onCompleteJumpToNext == 1) {
			if (repeatMode == 0) {
				nextOnPress();
			}
			else {
				apc.replay();
			}
			
		}
		else {
			
			Tweener.addTween(pp["pl"], { _alpha:100, time:0.15, transition:"linear" } );
			Tweener.addTween(pp["paus"], { _alpha:0, time:0.15, transition:"linear" } );
			
			if (repeatMode == 0) {
				currentState = 0;
			}
			else {
				currentState = 1;
				apc.replay();
			}
		}
	}
	
	/**
	 * actions for pressing one button
	 * @param	obj
	 */
	private function buttonPressed(obj:Object) {
		if (obj.mc != currentButton) {
			if(currentButton)
				currentButton.deact();
				
			currentButton = obj.mc;
			infoPanel.setNewText(currentButton.settingsObj.artist + " - " + currentButton.settingsObj.songname);
			
			apc.load(currentButton.settingsObj.url);
			
		}
	}
	
	
	
	private function volumeScrubBarOnPress() {
		volumeScrubBar.onMouseMove = Proxy.create(this, calcVolume);
		volumeScrubBar.onMouseMove();
	}
	
	private function calcVolume() {
		var hitWidth:Number = volumeScrubBar["volumeScrubBarHit"]._width;
		var currentX:Number = Math.max(0, Math.min(volumeScrubBar._xmouse, hitWidth));
		var percentage:Number = Math.round(100 - ( hitWidth - currentX) / hitWidth * 100);
		
		setNewVolume(percentage, currentX);
	}
	
	private function setNewVolume(pPercentage:Number) {
		var hitWidth:Number = volumeScrubBar["volumeScrubBarHit"]._width;
		Tweener.addTween(volumeScrubBar["fillNormal"], { _width: Math.round(hitWidth / 100 * pPercentage), time:0.15, transition:"linear" } );
		Tweener.addTween(volumeScrubBar["fillOver"], { _width: Math.round(hitWidth / 100 * pPercentage), time:0.15, transition:"linear" } );
		currentVolume = pPercentage;
		apc.volume = currentVolume / 100;
		
		if (pPercentage != 0) {
			oldVol = pPercentage;
		}
		else {
			oldVol = Math.max(currentVolume, oldVol);
		}
	}
	
	private function sndIconOnPress() {
		if (currentVolume == 0) {
			setNewVolume(oldVol);
		}
		else {
			setNewVolume(0);
		}
	}

	private function prevOnPress() {
		playlist.prevPressed();
	}
	
	private function nextOnPress() {
		playlist.nextPressed();
	}
	


	
	
	
	/**
	 * here, the xml is being changed
	 * to change the default loading xml file, please alter the mp3player.xml string
	 */
	private function loadMyXml() { 
		var xmlString:String = _global.mp3PlayerXml == undefined ? "pemutar_musik.xml" : _global.mp3PlayerXml;
		xml = UXml.loadXml(xmlString, xmlLoaded, this, false, true);
	}
	
	/**
	 * function executed after the xml file has been loaded
	 * @param	s
	 */
	private function xmlLoaded(s:Boolean) {
		if (!s) { trace("XML error !"); return; }		
		
		settingsObj = UNode.nodeToObj(xml.firstChild.firstChild);
		
		if (settingsObj.togglePlayer == 1) {
			resizeAndPosition(); 
		
		
			apc.autoPlay 	= settingsObj.autoPlay;
			apc.bufferTime	= settingsObj.bufferTime;
			
			setNewVolume(settingsObj.initialVolume);
			
			
			infoPanel.setSettings(settingsObj);
			playlist.addEventListener("buttonPressed", Proxy.create(this, buttonPressed));
			playlist.setXml(xml, settingsObj);
			
			if (settingsObj.autoPlay == 1) {
				enablePause();
				currentState = 1;
			}
			else {
				enablePlay();
				currentState = 0;
			}
			
	
			if (settingsObj.showPlayerEnlargedAtLoad == 0) {
				this._visible = true;
				startup = 0;
			}
			else {
				
				mainIconOnPress();
				
				if (settingsObj.showPlaylistEnlargedAtLoad == 1) {
					pList.onRollOver()
					pList.onPress();
				}
				
				startup = 0;
				myInterval = setInterval(this, "visThis", 600);
			}
			
			Tweener.addTween(this, { _alpha:100, time:1, transition:"linear" } );
		}
		else {
			_global.MainComponent.reArrangeShopBottom();
			_global.mp3player = undefined;
			this._visible = false;
		}
	}
	
	private function visThis() {
		this._visible = true;
	}
	
	
	
	
	private function shrinkMainIcon() {

	}
	
	
	private function closeButtonOnPress() {
		if (openStatus == 1) {
			if ((playlistActive == 1) || (infoActive == 1)) {
				clearInterval(myInterval);
				if (playlistActive == 1){
					pListOnPress()
					pListOnRollOut();
				}
				
				if (infoActive == 1){
					infoOnPress();
					infoOnRollOut();
				}
				
			
				myInterval = setInterval(this, "waitClose", 500);
			}
			else {
				waitClose();
			}
			
			openStatus = 0;
			closeButton.enabled = false;
			closeButtonOnRollOut();
		}
	}
	
	private function waitClose() {
		clearInterval(myInterval);
		
		Tweener.addTween(closeButton["mask"], { _width:0, time:0.5, delay:.1, transition:"easeOutExpo" } );
		
	}
	
	private function continueMainIcon() {
	
	}
	
	public function forceClosePlayList() {
		if (playlistActive == 1) {
			pListOnPress();
			pListOnRollOut();
		}
		
	}
	
	private function pListOnPress() {
		if (playlistActive == 0) {
			playlistActive = 1;
			playlist.show();
		}
		else {
			playlistActive = 0;
			playlist.hide();
		}
		
		if (startup == 0) {
			if (playlistActive == 0) {
				_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.openPlaylistCaption);
			}
			else {
				_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.closePlaylistCaption);
			}
		}
		
	}
	
	
	private function infoOnPress() {
		if (infoActive == 0) {
			infoActive = 1;
			infoPanel.show();
		}
		else {
			infoActive = 0;
			infoPanel.hide();
		}
	}
	
	
	/**
	 * behaviors for prev
	 */
	private function prevOnRollOver() {
		
		_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.prevSongCaption);
		Tweener.addTween(prev["over"], { _alpha:100, time:0.2, transition:"linear" } );
		
		
		_global.theBottomShopPreview.killPanelOnBottom();
	}
	
	private function prevOnRollOut() {
		_global.MainComponent.scrollerDesGlobal.hide();
		Tweener.addTween(prev["over"], { _alpha:0, time:0.2, transition:"linear" } );
	}
	
	
	private function prevOnRelease() {
		prevOnRollOut();
	}
	

	/**
	 * behaviors for next
	 */
	private function nextOnRollOver() {
		_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.nextSongCaption);
		Tweener.addTween(next["over"], { _alpha:100, time:0.2, transition:"linear" } );
		
		
		_global.theBottomShopPreview.killPanelOnBottom();
	}
	
	private function nextOnRollOut() {
		_global.MainComponent.scrollerDesGlobal.hide();
		Tweener.addTween(next["over"], { _alpha:0, time:0.2, transition:"linear" } );
	}
	
	private function nextOnRelease() {
		nextOnRollOut();
	}
	
	
	
	/**
	 * behaviors for pList
	 */
	private function pListOnRollOver() {
		if (startup == 0) {
			if (playlistActive == 0) {
				_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.openPlaylistCaption);
			}
			else {
				_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.closePlaylistCaption);
			}
			
			trace(playlistActive)
		}
		
		Tweener.addTween(pList["over"], { _alpha:100, time:0.2, transition:"linear" } );
		
		
		_global.theBottomShopPreview.killPanelOnBottom();
	}
	
	private function pListOnRollOut() {
		if (playlistActive == 0) {
			Tweener.addTween(pList["over"], { _alpha:0, time:0.2, transition:"linear" } );
		}
		
		_global.MainComponent.scrollerDesGlobal.hide();
		
	}
	
	private function pListOnRelease() {
		pListOnRollOut();
	}
	
	
	
	/**
	 * behaviors for info
	 */
	private function infoOnRollOver() {
		_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.infoCaption + " "  + _global.mp3PlayerNowButton.settingsObj.artist + " - " +_global.mp3PlayerNowButton.settingsObj.songname );
	
		Tweener.addTween(info["over"], { _alpha:100, time:0.2, transition:"linear" } );
		
		
		_global.theBottomShopPreview.killPanelOnBottom();
	}
	
	private function infoOnRollOut() {
		_global.MainComponent.scrollerDesGlobal.hide();
		Tweener.addTween(info["over"], { _alpha:0, time:0.2, transition:"linear" } );
	}
	
	private function infoOnRelease() {
		infoOnRollOut();
	}
	
	
	/**
	 * behaviors for sndIcon
	 */
	private function sndIconOnRollOver() {
		Tweener.addTween(sndIcon, { _alpha:100, time:0.15, transition:"linear" } );
		
		
		_global.theBottomShopPreview.killPanelOnBottom();
	}
	
	private function sndIconOnRollOut() {	
		
		Tweener.addTween(sndIcon, { _alpha:70, time:0.15, transition:"linear" } );
	}
	
	private function sndIconOnRelease() {
		sndIconOnRollOut();
	}

	
	/**
	 * behaviors for volumeScrubBar
	 */
	private function volumeScrubBarOnRollOver() {
		Tweener.addTween(volumeScrubBar, { _alpha:100, time:0.15, transition:"linear" } );
		
		
		_global.theBottomShopPreview.killPanelOnBottom();
	}
	
	private function volumeScrubBarOnRollOut() {		
		Tweener.addTween(volumeScrubBar, { _alpha:70, time:0.15, transition:"linear" } );
	}
	
	private function volumeScrubBarOnRelease() {
		delete volumeScrubBar.onMouseMove;
	}
	
	private function volumeScrubBarOnReleaseOutside() {
		volumeScrubBarOnRollOut();
		delete volumeScrubBar.onMouseMove;
	}
	
	
	
	
	/**
	 * behaviors for scrubBar
	 */
	
	 private function scrubBarBarOnPress() {
		permitSeekNow = 1;
		delete scrubBar.onMouseMove;
		scrubBar.onMouseMove = Proxy.create(this, calcSeek);
		scrubBar.onMouseMove();
	}
	
	private function calcSeek() {
		var hitWidth:Number = scrubBar["hit"]._width;
		var currentX:Number = Math.max(0, Math.min(scrubBar._xmouse, hitWidth));
		var percentage:Number = Math.round(100 - ( hitWidth - currentX) / hitWidth * 100);
		
		if (permitSeekNow == 1) {
			apc.seek(percentage/100, true);
		}
		
		_global.MainComponent.scrollerDesGlobal.setNewTextAdjusted(settingsObj.seekToCaption + " " + percentage + "%" );
	}
	
	private function scrubBarOnRollOver() {
		permitSeekNow = 0;
		scrubBar.onMouseMove = Proxy.create(this, calcSeek);
		scrubBar.onMouseMove();
		Tweener.addTween(scrubBar["fillOver"], { _alpha:100, time:0.2, transition:"linear" } );
		
		
		_global.theBottomShopPreview.killPanelOnBottom();
	}
	
	private function scrubBarOnRollOut() {		
		permitSeekNow = 0;
		Tweener.addTween(scrubBar["fillOver"], { _alpha:0, time:0.2, transition:"linear" } );
		delete scrubBar.onMouseMove;
		
		_global.MainComponent.scrollerDesGlobal.hide();
	}

	private function scrubBarOnReleaseOutside() {
		scrubBarOnRollOut();
	}
	
	private function scrubBarOnRelease() {
		permitSeekNow = 0;
		delete scrubBar.onMouseMove;
		delete scrubBar.onMouseMove;
		scrubBar.onMouseMove = Proxy.create(this, calcSeek);
		scrubBar.onMouseMove();
	}
	
	
	
	
	/**
	 * behaviors for mainIcon
	 */
	private function mainIconOnRollOver() {
		if (openStatus == 0) {
			_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.openPlayerCaption);
		}
		else {
			_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.closePlayerCaption);
		}
		
		Tweener.addTween(hiddenIcon["over"], { _alpha:100, time:0.2, transition:"linear" } );
		Tweener.addTween(openedIcon["over"], { _alpha:100, time:0.2, transition:"linear" } );
		
		
		_global.theBottomShopPreview.killPanelOnBottom();
		
	}
	
	private function mainIconOnRollOut() {		
		_global.MainComponent.scrollerDesGlobal.hide();
		Tweener.addTween(hiddenIcon["over"], { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(openedIcon["over"], { _alpha:0, time:0.2, transition:"linear" } );
	}
	
	private function invisTxt() {
		mainIcon["txt"]._visible = false;
	}
	private function mainIconOnRelease() {
		
	}
	
	public function forceClosePlayer() {
		if (openStatus == 1) {
			mainIconOnPress(1);
			mainIconOnRollOut();
		}
	}
	
	private function mainIconOnPress(val:Number) {
		if (openStatus == 0) {
			Tweener.addTween(hiddenIcon, { _alpha:0, time:0.2, transition:"linear" } );
			Tweener.addTween(openedIcon, { _alpha:100, time:0.2, transition:"linear" } );
			Tweener.addTween(multiHolder, { _x:multiXDef, time:0.5, transition:"easeOutExpo" } );
			openStatus = 1;
			
			_global.MainComponent.reArrangeElementsOpen(bg._width);
			_global.shareModule.forceCloseBg();
			
			_global.MainComponent.openPlayer();
		}
		else {
			Tweener.addTween(hiddenIcon, { _alpha:100, time:0.2, transition:"linear" } );
			Tweener.addTween(openedIcon, { _alpha:0, time:0.2, transition:"linear" } );
			Tweener.addTween(multiHolder, { _x:mainMask._width, time:0.8, transition:"easeOutExpo" } );
			
			_global.MainComponent.reArrangeElementsClose();
			
			if ((playlistActive == 1) || (infoActive == 1)) {
				clearInterval(myInterval);
				
				if (playlistActive == 1){
					pListOnPress()
					pListOnRollOut();
				}
				
				if (infoActive == 1){
					infoOnPress();
					infoOnRollOut();
				}
			}
			openStatus = 0;
			
			if (val != 1) {
				_global.MainComponent.closePlayer();
			}
			
		}
		
		if (startup == 0) {
			if (openStatus == 0) {
				_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.openPlayerCaption);
			}
			else {
				_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.closePlayerCaption);
			}
		}
		
	}
	
	
	
	/**
	 * behaviors for closeButton
	 */
	private function closeButtonOnRollOver() {
		Tweener.addTween(closeButton, { _alpha:100, time:0.15, transition:"linear" } );
		
		
		_global.theBottomShopPreview.killPanelOnBottom();
	}
	
	private function closeButtonOnRollOut() {
		Tweener.addTween(closeButton, { _alpha:70, time:0.15, transition:"linear" } );
	}
	
	private function closeButtonOnRelease() {
		closeButtonOnRollOut();
	}
	
	
	private function blurOneButton(mc:MovieClip) {
		Tweener.addTween(mc, { _Blur_blurX:6, _Blur_blurY:0, time:0.1, transition:"linear", onComplete:Proxy.create(this, contBlur, mc)} );
	}
	private function contBlur(mc:MovieClip) {
		Tweener.addTween(mc, { _Blur_blurX:0, _Blur_blurY:0, time:0.1, transition:"linear"} );
	}
}
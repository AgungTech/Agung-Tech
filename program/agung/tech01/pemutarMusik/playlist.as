import ascb.util.Proxy;
import caurina.transitions.*;
import agung.utils.UNode;
import mx.events.EventDispatcher;

class agung.tech01.pemutarMusik.playlist extends MovieClip
{
	private var xml:XML;
	private var settingsObj:Object;
	
	private var songList:Array;
	
	private var title:MovieClip;
	
	private var repeat:MovieClip;
	private var randomize:MovieClip;
	
	private var holder:MovieClip;
		private var mask:MovieClip;
		private var lst:MovieClip;
		private var holderBg:MovieClip;
		private var scroller:MovieClip;
			private var stick:MovieClip;
			private var bar:MovieClip;
		
	private var bg:MovieClip;
	private var bottom:MovieClip;
	
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	private var currentIdx:Number = -1;
	private var totalIdx:Number = 0;
	
	private var topHit:MovieClip;
	private var myInterval2:Number;
	private var totalLstBottomY:Number;
	
	private var repeatActivated:Number;
	private var randomizedActivated:Number;
	private var randomArray:Array;
	private var perm:Array;
	
	/**
	 * this class handles the playlist
	 */
	public function playlist() {
		
		EventDispatcher.initialize(this);
		
		mask = holder["mask"];
		lst = holder["lst"];
		topHit = holder["topHit"];
			
		
		
		lst.setMask(mask);
		
	}
	
	
	
	/**
	 * this is for showing the playlist
	 */
	public function show() {
		
		Tweener.addTween(this, { _y:-bg._height-9, time:0.5, transition:"easeOutExpo", onComplete:Proxy.create(this, startScrolling) } );
	}
	
	/**
	 * this is for hiding the playlist
	 */
	public function hide() {
		stopScrolling()
		Tweener.addTween(this, { _y:2, time:0.5, transition:"easeOutExpo" } );
	}
	
	private function resizeAndPosition() {
		bg._width = settingsObj.playlistWidth;
		bg._height = settingsObj.playlistHeight;
		
		bottom._width = bg._width - 4;
		bottom._y = Math.ceil(bg._height - bottom._height) - 1;
		
		mask._width = topHit._width = Math.round(bg._width - 5 - 5 - 3 - 4); // 3 = scroller._width
		
		
		holder._y = Math.ceil(title._y + title["txt"].textHeight + 12);
		holder._x = title._x;
		
		mask._height = topHit._height =  Math.round(bg._height - 5 - 5 - holder._y );
		
		holderBg._width = mask._width + 2;
		holderBg._height = mask._height + 2;
		
		bg._height += 1;
		
		repeat._y = title._y + 2;
		repeat._x = Math.ceil(bg._width - repeat._width - 18);
		
		repeatActivated = 0;
		repeat["over"]._alpha = 0;
		repeat["act"]._alpha = 0;
		repeat.onRollOver = Proxy.create(this, repeatOnRollOver);
		repeat.onRollOut = repeat.onReleaseOutside = Proxy.create(this, repeatOnRollOut);
		repeat.onPress = Proxy.create(this, repeatOnPress);
		
		randomize._y = repeat._y;
		randomize._x = Math.ceil(repeat._x - randomize._width - 6);
		
		randomizedActivated = 0 ;
		randomize["over"]._alpha = 0;
		randomize["act"]._alpha = 0;
		randomize.onRollOver = Proxy.create(this, randomizeOnRollOver);
		randomize.onRollOut = randomize.onReleaseOutside = Proxy.create(this, randomizeOnRollOut);
		randomize.onPress = Proxy.create(this, randomizeOnPress);
		
		this._y = 2;
	}
	
	private function repeatOnRollOver() {
		if (repeatActivated == 0) {
			_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.repeatOnCaption);
		}
		else {
			_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.repeatOffCaption);
		}
		
		Tweener.addTween(repeat["over"], { _alpha:100, time:0.2, transition:"linear" } );
	}
	
	private function repeatOnRollOut() {
		if (repeatActivated == 0) {
			Tweener.addTween(repeat["act"], { _alpha:0, time:0.2, transition:"linear" } );
		}
		
		Tweener.addTween(repeat["over"], { _alpha:0, time:0.2, transition:"linear" } );
		_global.MainComponent.scrollerDesGlobal.hide();
	}
	
	private function repeatOnPress() {
		if (repeatActivated == 1) {
			repeatActivated = 0;
			Tweener.addTween(repeat["act"], { _alpha:0, time:0.2, transition:"linear" } );
			_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.repeatOnCaption);
		}
		else {
			repeatActivated = 1;
			Tweener.addTween(repeat["act"], { _alpha:100, time:0.2, transition:"linear" } );
			_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.repeatOffCaption);
		}
		
		_global.mp3player.toggleRepeat(repeatActivated);
	}
	
	
	private function randomizeOnRollOver() {
		if (randomizedActivated == 0) {
			_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.shuffleOnCaption);
		}
		else {
			_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.shuffleOffCaption);
		}
		
		Tweener.addTween(randomize["over"], { _alpha:100, time:0.2, transition:"linear" } );
	}
	
	private function randomizeOnRollOut() {
		if (randomizedActivated == 0) {
			Tweener.addTween(randomize["act"], { _alpha:0, time:0.2, transition:"linear" } );
			
		}
		
		Tweener.addTween(randomize["over"], { _alpha:0, time:0.2, transition:"linear" } );
		_global.MainComponent.scrollerDesGlobal.hide();
	}
	
	private function randomizeOnPress() {
		
		if (randomizedActivated == 1) {
			
			randomizedActivated = 0;
			randomArray = new Array();
			songList = new Array();
			
			for (var idx:Number = 0; idx < perm.length; idx++) {
				randomArray.push(idx);
				songList.push(idx);
			}
	
			Tweener.addTween(randomize["act"], { _alpha:0, time:0.2, transition:"linear" } );
			_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.shuffleOnCaption);
		}
		else {
			randomizedActivated = 1;
			Tweener.addTween(randomize["act"], { _alpha:100, time:0.2, transition:"linear" } );
		
				var theRandomNumber:Number = 0;
				randomArray = new Array();
				var actLength:Number = songList.length
				
				for (var idx:Number = 0; idx < actLength; idx++) {
					theRandomNumber = generateRand(0, songList.length);
					randomArray.push(songList.splice(theRandomNumber, 1)[0]);
					trace(idx)
				}
			
				songList = new Array();
				var idx:Number = 0;
				while (perm[idx]) {
					songList.push(perm[idx]);
					idx++;
				}
			
			
			_global.MainComponent.scrollerDesGlobal.setNewText(settingsObj.shuffleOffCaption);
		}
		
	
		_global.mp3player.toggleRandomize(randomizedActivated);
	}
	
	/**
	 * here, the xml data and settings are being sent
	 * @param	pXml
	 * @param	pSettingsObj
	 */
	public function setXml(pXml:XML, pSettingsObj:Object) {
		xml = pXml;
		settingsObj = pSettingsObj;
		
		title["txt"].autoSize = true;
		title["txt"].wordWrap = false;
		title["txt"].text = settingsObj.playlistTitleCaption;
		
		resizeAndPosition();
		
		
		
		var node:XMLNode = xml.firstChild.firstChild.nextSibling.firstChild;
		var node2:XMLNode = xml.firstChild.firstChild.nextSibling.firstChild;
		
		songList = new Array();
		randomArray = new Array();
		perm = new Array();
		
		for (var idx:Number = 0; node != null; node = node.nextSibling) {
			songList.push(idx);
			randomArray.push(idx);
			perm.push(idx);
			
			idx++;
		}
		
		
		if (settingsObj.shuffleSongs == 1) {
			var theRandomNumber:Number = 0;
			randomArray = new Array();
			var actLength:Number = songList.length
			
			for (var idx:Number = 0; idx < actLength; idx++) {
				theRandomNumber = generateRand(0, songList.length);
				randomArray.push(songList.splice(theRandomNumber, 1)[0]);
			}
			
			randomizedActivated = 1;
			Tweener.addTween(randomize["act"], { _alpha:100, time:0.2, transition:"linear" } );
		}
		
	
		var idx:Number = 0;
		var currentPos:Number = 4;
		for (; node2 != null; node2 = node2.nextSibling) {
			var currentButton:MovieClip = lst.attachMovie("IDplaylistButton", "IDplaylistButton" + idx, lst.getNextHighestDepth());
			currentButton.addEventListener("buttonPressed", Proxy.create(this, buttonPressed));
			currentButton.ord = idx;
			currentButton.setNode(node2, mask._width - 18);
			currentButton._y = currentPos;
			currentPos += currentButton.totalHeight + 2;
			idx++;
		}
	
		totalIdx = idx - 1;
		
		//if (settingsObj.autoPlay == 1) {
			nextPressed();
		//}
		
		
		totalLstBottomY = Math.ceil(currentPos + 4 - mask._height);
	}
	
	public function stopScrolling() {
		clearInterval(myInterval2);
	}
	
	public function startScrolling() {
		clearInterval(myInterval2);
		if (lst._height > mask._height) {
			myInterval2 = setInterval(this, "scrollThis", 30);
		}
	}
	
	private function scrollThis() {
		if (holder._xmouse > 0 && holder._xmouse < topHit._width && holder._ymouse > 0 && holder._ymouse < topHit._height) {
				var per:Number = Math.ceil(holder._ymouse / topHit._height * 100);
				
				if (per < 3) {
					per = 0;
				}
				
				if (per > 97) {
					per = 100;
				}

				var actualCurrentY:Number = Math.ceil(totalLstBottomY / 100 * per);
			
				Tweener.addTween(lst, { _y:-actualCurrentY, time:.05*settingsObj.scrollerAccelerationMultiplier, transition:"linear" } );
			
		}
	}
	
	/**
	 * actions for pressing the next button
	 */
	public function nextPressed() {
		currentIdx++;
		var currentButton:MovieClip = lst["IDplaylistButton" + randomArray[currentIdx]];
		
		if (!currentButton) {
			currentIdx = 0;
			var currentButton:MovieClip = lst["IDplaylistButton" + randomArray[currentIdx]];
		}
		
		
		currentButton.onPress();
	}
	
	/**
	 * actions for pressing the prev button
	 */
	public function prevPressed() {
		currentIdx--;
		var currentButton:MovieClip = lst["IDplaylistButton" + randomArray[currentIdx]];
		
		if (!currentButton) {
			currentIdx = totalIdx;
			var currentButton:MovieClip = lst["IDplaylistButton" + randomArray[currentIdx]];
			
		
		}
		
		trace(randomArray[currentIdx]+ " " + currentIdx)
		currentButton.onPress();
	}
	
	private function buttonPressed(obj:Object) {
		if (randomizedActivated == 0) {
			currentIdx = obj.mc.ord;
		}
		
		dispatchEvent( { target:this, type:"buttonPressed", mc:obj.mc } );
	}
	
	private function generateRand(min:Number, max:Number) {
		max = max - 1;
		var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
		return randomNum;
	}
	
}
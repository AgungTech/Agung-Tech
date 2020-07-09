/**
* Ini adalah kelas utama untuk komponen banner rotator
* Di sini, Anda dapat mengubah xml file di dalam fungsi loadMyXml, hanya mengganti string rotator.xml dengan
* Nama xml yang diinginkan jika Anda ingin menggunakan komponen ini secara eksternal ke projek lain
* Kode ini cukup sederhana sebenarnya, itu hanya mem-parsing semua node di dalam file xml dan menciptakan tombol dan gambar saja
* Petunjuk: Jika Anda ingin tombol panah next / prev Anda berada pada jarak yang lebih jauh dari banner yang sebenarnya silakan lihat
* Dalam fungsi continueAfterXmlLoaded pada statement next._x dan prev._x, di kode itu, hanya menambah atau mengurangi nilai tambahan -5 atau +5
*
*/

import caurina.transitions.*;
import ascb.util.Proxy;
import flash.filters.BlurFilter;

import agung.utils.UFilter;

class agung.tech01.banner.mainBanner extends MovieClip  
{
	private var settingsObj:Object;
	private var theXml:XML;	
	private var node:XMLNode;
	
	
	private var buttonsHolder:MovieClip;
	
	private var rot:MovieClip;
	private var rotMaxW:Number;
	
	private var pictureHolder:MovieClip;
		private var pictureLst:MovieClip;
		private var pictureMask:MovieClip;
	
	private var bg:MovieClip;
		private var bgOver:MovieClip;
	
	private var currentButton:MovieClip;
		
	private var currentPic:MovieClip;
	
	private var myInterval:Number;
	
	private var currentIdx:Number = 0;
	
	private var leftHit:MovieClip;
	private var rightHit:MovieClip;
	
	private var prev:MovieClip;
	private var next:MovieClip;
	
	private var arrowsDefs:Object;
	
	private var total:Number;
	
	private var waitInterval:Number;
	private var totalSum:Number = 0;
	private var totalAll:Number = 0;
	private var allDuration:Number;
	
	private var box:MovieClip;
	private var currentTimer:Number;
	/**
	 * Ini adalah konstruktor dimana semua variabel direferensikan dan dijalankan
	 */
	public function mainBanner() {
		bgOver = bg["over"];
		bgOver._alpha = 0;
		
		pictureLst = pictureHolder["lst"];
		pictureMask = pictureHolder["mask"];
		pictureLst.setMask(pictureMask);
		
		next["over"]._alpha = 0;
		next.onRollOver = Proxy.create(this, nextOnRollOver);
		next.onRollOut = Proxy.create(this, nextOnRollOut);
		next.onPress = Proxy.create(this, nextOnPress);
		next.onRelease = Proxy.create(this, nextOnRelease);
		next.onReleaseOutside = Proxy.create(this, nextOnReleaseOutside);
		
		prev["over"]._alpha = 0;
		prev.onRollOver = Proxy.create(this, prevOnRollOver);
		prev.onRollOut = Proxy.create(this, prevOnRollOut);
		prev.onPress = Proxy.create(this, prevOnPress);
		prev.onRelease = Proxy.create(this, prevOnRelease);
		prev.onReleaseOutside = Proxy.create(this, prevOnReleaseOutside);
		
		this._visible = false;

		loadMyXml();
		
		trace(">>> Modul Banner rotator dikompilasi . . .");
		trace(">>> Modul ini dapat digunakan tanpa file utama");
	}
	
	public function loadMyXml() {
		if (_global.theXmlFile) {
			theXml = _global.theXmlFile;
			continueAfterXmlLoaded()
		}
		else {
			var xmlOb:XML = new XML();
			theXml = xmlOb;
			xmlOb.ignoreWhite = true;
			xmlOb.onLoad = 	Proxy.create(this, continueAfterXmlLoaded);
			xmlOb.load(_level0.xml == undefined ? "rotator.xml" : _level0.xml);
		}	
	}
	
	private function continueAfterXmlLoaded()
	{
		node = theXml.firstChild.firstChild;
		
		settingsObj = parseSettingsNode(node);
		
		leftHit._y = rightHit._y = 0;
		leftHit._width = rightHit._width = 200;
		leftHit._x = -leftHit._width;
		rightHit._x = settingsObj.moduleWidth;
		
		leftHit._height = rightHit._height = settingsObj.moduleHeight;
		
		bg["outer"]._width = settingsObj.moduleWidth;
		bg["outer"]._height = settingsObj.moduleHeight;
		
		bg["outer2"]._width = settingsObj.moduleWidth+2;
		bg["outer2"]._height = settingsObj.moduleHeight+2;
		bg["outer2"]._x = bg["outer2"]._y = -1;
		bg["inner"]._width = bgOver["outer"]._width = settingsObj.moduleWidth - 8 - 8;
		bg["inner"]._height = bgOver["outer"]._height = settingsObj.moduleHeight - 8 - 8;
		
		bgOver["inner"]._width = settingsObj.moduleWidth - 8 - 8 - 4;
		bgOver["inner"]._height = settingsObj.moduleHeight - 8 - 8 - 4;
		
		var bNode:XMLNode = node.nextSibling.firstChild
		
		var idx:Number = 0;
		var currentPos:Number = 0;
		
		for (; bNode != null; bNode = bNode.nextSibling) {
			var currentItem:MovieClip = buttonsHolder.attachMovie("IDsimpleButton", "IDsimpleButton" + idx, buttonsHolder.getNextHighestDepth());
			currentItem.addEventListener("buttonPressed", Proxy.create(this, buttonPressed));
			currentItem.idx = idx;
			currentItem.setNode(bNode, idx);
			currentItem._x = currentPos;
			currentPos += 30 + 2;
			idx++;
		}
		

		
		total = idx - 1;
		
		buttonsHolder._x = Math.ceil(settingsObj.moduleWidth / 2 - currentPos / 2);
		buttonsHolder._y = Math.ceil(settingsObj.moduleHeight - 25 - 11);
		
		
		
		var picNode:XMLNode = node.nextSibling.firstChild;
		
		var idx:Number = 0;
		var currentPos:Number = 0;
		var picW:Number = settingsObj.picW = pictureMask._width = rotMaxW = Math.ceil(settingsObj.moduleWidth - 22);
		var picH:Number = settingsObj.picH = pictureMask._height = Math.ceil(settingsObj.moduleHeight - 22);
		
		
		for (; picNode != null; picNode = picNode.nextSibling) {
			var currentItem:MovieClip = pictureLst.attachMovie("IDsimplePicture", "IDsimplePicture" + idx, pictureLst.getNextHighestDepth());
			currentItem.addEventListener("picLoaded", Proxy.create(this, picLoaded));
			currentItem.idx = idx;
			currentItem.setNode(picNode, settingsObj);
			currentItem._x = currentPos;
			currentPos += picW;
			idx++;
		}
		
		pictureLst["IDsimplePicture" + 0].startLoad();
		buttonsHolder["IDsimpleButton" + 0].onPress();
		
		rot._y = Math.ceil(settingsObj.moduleHeight - 16);
		rot._x = Math.ceil(11);
		allDuration = settingsObj.autoplay * 1000;
		
		setInterval(this, "scanOver", 100);
		
		currentTimer = settingsObj.autoplay * 1000;
		
		
		
		arrowsDefs = new Object();
	
		if (!_global.whitePresent) {
			next._x = arrowsDefs.nx = Math.round(settingsObj.moduleWidth + 2);
		}
		else {
			next._x = arrowsDefs.nx = Math.round(settingsObj.moduleWidth + 1);
		}
		
		next._y = arrowsDefs.ny = 15;
		
		prev._x = arrowsDefs.px = -Math.round(prev._width + 2);
		prev._y = arrowsDefs.py = 15;
		
		if (total == 0) {
			next._visible = prev._visible = buttonsHolder._visible = rot._visible = false;
			
		}
		else {
			launchInterval();
			setInterval(this, "moveArrows", 30);
		}
		
		this._visible = true;
	}
	
	private function launchProg() {
		clearInterval(waitInterval);
		totalSum = 0;
		box._width = 0;
		
		Tweener.addTween(box, { _width:100, time: currentTimer / 1000, transition:"linear", onUpdate:Proxy.create(this, adjustProg) } );
		
		//waitInterval = setInterval(this, "adjustProg", totalAll/100);
	}
	
	private function adjustProg() {
		rot._width = Math.ceil(rotMaxW / 100 * box._width);
	}
	
	private function launchInterval() {
		if (settingsObj.autoplay != 0) {
			clearInterval(myInterval);
			myInterval = setInterval(this, "autoP", currentTimer);
			
			launchProg();
		}
	}
	
	private function autoP() {
		currentIdx++;
		if (!buttonsHolder["IDsimpleButton" + currentIdx]) {
			currentIdx = 0;
		}
	
		
		buttonsHolder["IDsimpleButton" + currentIdx].onPress();
		
	}
	
	private function autoPMinus() {
		currentIdx--;
		if (!buttonsHolder["IDsimpleButton" + currentIdx]) {
			currentIdx = total;
		}
	
		
		buttonsHolder["IDsimpleButton" + currentIdx].onPress();
	}
	
	private function picLoaded(obj:Object) {
		pictureLst["IDsimplePicture" + (obj.mc.idx + 1)].startLoad();
	}
	
	private function buttonPressed(obj:Object) {
		if (currentButton != obj.mc) {
			currentButton.deactivate();
			currentButton = obj.mc;
			currentButton.activate();
			
			currentIdx = currentButton.idx;
			
			if (currentButton.node.attributes.stay) {
				currentTimer = Number(currentButton.node.attributes.stay) * 1000;
			}
			else {
				currentTimer = settingsObj.autoplay * 1000;
			}
			launchInterval();
			
			goIdx(currentButton.idx);
		}
	}
	
	private function goIdx(pIdx:Number) {
			currentPic = pictureLst["IDsimplePicture" + pIdx];
		
			var idx:Number = 0 ;
			while (pictureLst["IDsimplePicture" + idx]) {
				if (pictureLst["IDsimplePicture" + idx] != currentPic) {
					pictureLst["IDsimplePicture" + idx].hideDes();
				}
				
				idx++;
			}
			
		blurAll();
		
		Tweener.addTween(pictureLst, { _x: -Math.ceil(pIdx * settingsObj.picW), time:settingsObj.animationTime, transition:settingsObj.animationType,onComplete:Proxy.create(this, doneTrans) } );
		
	}
	
	private function doneTrans() {
		blurAll(0);
	}
	
	private function blurAll(pAmount:Number) {
		if (pAmount != 0) {
			if (settingsObj.animationBlurAmount != 0) {
				var idx:Number = 0 ;
				while (pictureLst["IDsimplePicture" + idx]) {
					UFilter.setBlur(pictureLst["IDsimplePicture" + idx], settingsObj.animationBlurAmount, 0, 2);
					idx++;
				}
			}
			
		}
		else {
			if (settingsObj.animationBlurAmount != 0) {
				var idx:Number = 0 ;
				while (pictureLst["IDsimplePicture" + idx]) {
					UFilter.removeBlur(pictureLst["IDsimplePicture" + idx]);
					idx++;
				}
			}
			
		}
	}
	
	private function scanOver() {
		if ((this._xmouse > 0) && (this._xmouse < settingsObj.moduleWidth) && (this._ymouse > 0) && (this._ymouse < settingsObj.moduleHeight)) {
			if ((bgOver._alpha != 100) && (!Tweener.isTweening(bgOver))) {
				Tweener.addTween(bgOver, { _alpha:100, time:.5, transition:"linear" } );
			}
			
			currentPic.showDes();
		}
		else {
			if ((bgOver._alpha != 0) && (!Tweener.isTweening(bgOver))) {
				Tweener.addTween(bgOver, { _alpha:0, time:.5, transition:"linear" } );
			}
			
			currentPic.hideDes();
		}
	}
	
	
	private function moveArrows() {
		if (prev.enabled == true) {
			if ((this._xmouse < 0) && (this._xmouse > -leftHit._width) && (this._ymouse > 0) && (this._ymouse < leftHit._height)) {
				Tweener.addTween(prev, { _x:this._xmouse-prev._width / 2 - 4, _y:this._ymouse-prev._height / 2, time:.08, transition:"linear", rounded:true } );
			
			}
			else {
				if ((prev._x != arrowsDefs.px) || (prev._y != arrowsDefs.py)) {
					Tweener.addTween(prev, { _x:arrowsDefs.px, _y:arrowsDefs.py, time:.3, transition:"linear" } );
				}
			}
		}
		
		if (next.enabled == true) {
			if ((this._xmouse > bg._width) && (this._xmouse < bg._width +rightHit._width) && (this._ymouse > 0) && (this._ymouse < rightHit._height)) {
				Tweener.addTween(next, { _x:this._xmouse-next._width / 2 + 6, _y:this._ymouse-next._height / 2, time:.08, transition:"linear", rounded:true } );
			
			}
			else {
				if ((next._x != arrowsDefs.nx) || (next._y != arrowsDefs.ny)) {
					Tweener.addTween(next, { _x:arrowsDefs.nx, _y:arrowsDefs.ny, time:.3, transition:"linear" } );
				}
			}
		}
		
	}
	
	private function nextOnRollOver() {
		Tweener.addTween(next["over"], { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function nextOnRollOut() {
		Tweener.addTween(next["over"], { _alpha:0, time:.2, transition:"linear" } );
	}
	
	private function nextOnPress() {
		clearInterval(myInterval);
		autoP();
	}
	
	private function nextOnRelease() {
		
	}
	
	private function nextOnReleaseOutside() {
		nextOnRollOut()
	}
	
	
	
	
	
	
	private function prevOnRollOver() {
		Tweener.addTween(prev["over"], { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function prevOnRollOut() {
		Tweener.addTween(prev["over"], { _alpha:0, time:.2, transition:"linear" } );
	}
	
	private function prevOnPress() {
		clearInterval();
		autoPMinus()
	}
	
	private function prevOnRelease() {
		
	}
	
	private function prevOnReleaseOutside() {
		prevOnRollOut()
	}
	
	private function parseSettingsNode(n:XMLNode):Object {
		var o:Object = new Object();
		
		for (n = n.firstChild; n != null; n = n.nextSibling) {
			var rawStr:String = n.firstChild.nodeValue;
			var clnStr:String = (remWhiteSpace(rawStr)).toLowerCase();
			
			if 		(!isNaN(clnStr)) 	{ o[n.nodeName] = Number(clnStr); 		}
			else if (clnStr == "true") 	{ o[n.nodeName] = true; 				}
			else if (clnStr == "false") { o[n.nodeName] = false; 				}
			else 						{ o[n.nodeName] = remSideSpace(rawStr);	}
		}
		
		return o;
	}
	
	/**
	 * kode ini digunakan untuk menghapus spasi berlebihan pada .xml file
	 * @param	str
	 */
	private function remWhiteSpace(str:String) {
		var newStr:String = "";
		
		for (var i = 0; i < str.length; i++) {
			var c:String = str.charAt(i);
			
			(c != ' ' && c != '\t' && c != '\n' && c != '\r') ? (newStr += c) : null;
		}
		
		return newStr;
	}
	
	private function remSideSpace(str:String) {
		var newStr:String = "";
		var innSpc:String = "";
		
		for (var i = 0; i < str.length; i++) {
			var c:String = str.charAt(i);
			
			if (c == ' ' || c == '\n' || c == '\t' || c == '\r') {
				innSpc += c;
			}else {
				newStr += (newStr == "") ? c : (innSpc + c);
				innSpc = "";
			}
		}
		
		return newStr;
	}
	
	
	
}
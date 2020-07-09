/**
	* Ini adalah kelas utama untuk background
	* Kelas ini harus menerima file xml menggunakan fungsi loadMyXml
	* Dapat digunakan untuk project lain tapi harus mengedit ulang kode, Jika Anda memiliki pengalaman dengan flash
	* Ini adalah modul utama fla, melihat bagaimana semua proses terjadi
	* 
 */

import agung.utils.UXml;
import agung.utils.UNode;
import caurina.transitions.*;
import ascb.util.Proxy;
import agung.utils.UArray;

class agung.tech01.background.komponenBackground extends MovieClip
{
	private var oldpW:Number = 0;
	private var oldpH:Number = 0;

	private var xml:XML;
	public var settingsObj:Object;
	
	private var playlist:Array;
	
	private var holder:MovieClip;
	private var idx:Number = 0;
	private var currentSlide:MovieClip;
	private var currentData:String;
	private var myInterval:Number;
	private var settted:Number = 0;
	
	private var myInterval2:Number;
	private var currentIdx:Number = -1;
	/**
	 * Ini adalah konstruktor dimana semua variabel direferensikan dan dijalankan
	 */
	public function komponenBackground() {
		this._visible = false;
		
		_global.mainBackground = this;
	}
	
	private function loadMyXml(str:String) { 
		var xmlString:String = str;
		xml = UXml.loadXml(xmlString, xmlLoaded, this, false, true);
	}
	
	private function xmlLoaded(s:Boolean) {
		if (!s) { trace("XML gagal dimuat !"); return; }	
		
		var node = xml.firstChild.firstChild;
		
		
		settingsObj = UNode.nodeToObj(node);
			
		node = node.nextSibling.firstChild;
		
		if (settingsObj.activateDynamicBackground == 1) {
			var nowP:Array = new Array();
		
			playlist = new Array();
			
			for (; node != null; node = node.nextSibling) {
				nowP.push(node.attributes.src);
				playlist.push(node.attributes.src);
			}
			
			if (settingsObj.random == 1) {
				
				var theLength:Number = nowP.length;
				var theN:Number;
				playlist = new Array();
				
				for (var some:Number = 0; some < theLength; some++) {
					theN = generateRand(0, nowP.length);
					playlist.push(nowP.splice(theN, 1)[0]);
				}
			}
			
			
			if ((settingsObj.activateSlideshow == 1) && (playlist.length != 1)) {
				myInterval2 = setInterval(this, "autoplay", settingsObj.slideShowTimer * 1000);
				autoplay();
			}
			else {
				currentIdx = 0;
				setBackground(playlist[0]);
			}
			
			loadStageResize();
			
			this._visible = true;
		}
		
	}
	
	public function pauseAutoplay() {
		clearInterval(myInterval2);
	}
	
	public function resumeAutoplay() {
		if ((settingsObj.activateSlideshow == 1) && (playlist.length != 1)) {
			clearInterval(myInterval2)
			myInterval2 = setInterval(this, "autoplay", settingsObj.slideShowTimer * 1000);
			autoplay();
		}
	}
	
	
	private function autoplay() {
		currentIdx++;
		if (!playlist[currentIdx]) {
			currentIdx = 0;
		}
		
		setBackground(playlist[currentIdx]);
	}
	
	public function setBackground(str:String) {
		if (str == "random") {
			str = playlist[generateRand(0, playlist.length)];
		}
		
		currentData = str;
		
		gogo();
	}
	
	private function gogo() {
		clearInterval(myInterval);
		currentSlide.hide();
		idx++;
		currentSlide = holder.attachMovie("IDbackgroundItem", "item" + idx, holder.getNextHighestDepth());
		currentSlide.addEventListener("playbackComplete", Proxy.create(this, resumeAutoplay));
		var str:String = currentData;
		var arr:Array = str.split(".");
		if ((arr[arr.length - 1] == "flv") || ((arr[arr.length - 1] == "mp4")) || ((arr[arr.length - 1] == "mkv"))) {
			pauseAutoplay();
		}
		currentSlide.setData(currentData, settingsObj);
		
		

	}
	
	/**
	 * Fungsi yang dipanggil ketika aplikasi diubah ukurannya
	 * @param	pW
	 * @param	pH
	 */
	private function resize(pW:Number, pH:Number) {
		if ((pW != oldpW) || (pH != oldpH)) {
			oldpW = pW;
			oldpH = pH;
			
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
}

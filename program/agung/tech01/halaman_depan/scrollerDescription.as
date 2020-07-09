import caurina.transitions.*;
import ascb.util.Proxy;
import agung.utils.UMc;
import agung.utils.UTf;

class agung.tech01.halaman_depan.scrollerDescription extends MovieClip
{
	private var settingsObj:Object;
	public var node:XMLNode;
	
	private var theWidth:Number;
	
	private var holder:MovieClip;
		private var textHolder:MovieClip;
		private var mask:MovieClip;
	
	private var bg:MovieClip;
	
			
	private var textIdx:Number = 0;
	private var lastText:MovieClip;
	
	private var status:Number = 0;
	private var lastStr:XMLNode;
	
	private var defaultDescription:XMLNode;
	
	private var yDefPos:Number;
	private var yOverPos:Number;
	
	private var myInterval:Number;
	
	
	public function scrollerDescription() {
		
		textHolder = holder["lst"];
		mask = holder["mask"];
	
		
		lastText = textHolder["a"];
		lastText["txt"].autoSize = true;
		textHolder.setMask(mask);
	}
	
	
	private function resizeAndPosition(pWidth:Number) {
		theWidth = pWidth;
		
		this._x = Math.round(-12 + settingsObj.correctDescriptionXPos);
		this._y = Math.round( -bg._height - 7 + settingsObj.correctDescriptionYPos);
	
			yDefPos = this._y + 10;
		
			
		
		if (_global.whitePresent) {
			yOverPos = this._y + 7;

		}
		else {
			yOverPos = this._y - 1;

		}
		
		textHolder._x = 12;
		
		bg._width = Math.round(12 + theWidth);
		
		holder._y = 2;
		
		mask._width = bg._width;
		mask._height = bg._height - 14;
		
	
		this._alpha = 0;
	
			this._y = yDefPos;
	
		
		
		myInterval = setInterval(this, "initActivate", 700);
		
	}
	
	private function initActivate() {
		clearInterval(myInterval);
		if (settingsObj.enableDefaultText == 1) {
			setNewText(defaultDescription);
		}
		
	}
	/**
	 * @param	pSettings
	 */
	public function setSettings(pNode:XMLNode, pSettings:Object) {
		settingsObj = pSettings;
		node = pNode;
		
		defaultDescription = node.firstChild;
	}
	
	/**
	 * @param	str
	 */
	public function setNewText(pNode:XMLNode) {
		clearInterval(myInterval);
		
		Tweener.addTween(lastText, { _y:-mask._height-20, time:.3, transition:"easeOutQuad", onComplete:Proxy.create(this, removeLastText, lastText) } );
		
		textIdx++;
	
		lastText = textHolder["a"].duplicateMovieClip("textHolder" + textIdx, textIdx);
			
		lastText._y = mask._height + 10;
			
		UTf.initTextArea(lastText["txt"], true);
		lastText["txt"].htmlText = pNode.nodeValue;
		lastText["txt"]._width = bg._width - 30;
			
			
		Tweener.addTween(lastText, { _y:-1, time:.4, transition:"easeOutQuad", rounded:true } );
		
		if ((pNode.nodeValue != "") && (pNode.nodeValue != " ") && (pNode.nodeValue != undefined)) {
			normalShow();
		}
		else {
			normalHide();
		}
		
		
		lastStr = pNode;
	}

	private function removeLastText(pLast:MovieClip) {
		pLast.removeMovieClip();
	}
	
	public function displayNormal() {
		clearInterval(myInterval);
		myInterval = setInterval(this, "goDefault", 700);
	}
	
	private function goDefault() {
		clearInterval(myInterval);
		
		if (settingsObj.enableDefaultText == 1) {
			setNewText(defaultDescription);
		}
		else {
			normalHide();
		}
	}
	
	private function normalHide() {
		if (this._y != 0) {
			Tweener.addTween(this, { _alpha:0, _y:yDefPos, time:.5, transition:"easeOutQuart" } );
		}
	}
	
	private function normalShow() {
		if (this._y != -12) {
			Tweener.addTween(this, { _alpha:100, _y:yOverPos, time:.5, transition:"easeOutQuart" } );
		}
	}
}
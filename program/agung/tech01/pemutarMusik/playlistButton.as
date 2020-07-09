import agung.utils.UMc;
import agung.utils.UNode;
import caurina.transitions.*;
import mx.events.EventDispatcher;

class agung.tech01.pemutarMusik.playlistButton extends MovieClip
{
	private var node:XMLNode;
	public var settingsObj:Object;
	
	public var totalHeight:Number;
	public var ord:Number;
	
	
	
	private var over:MovieClip;
	private var activated:MovieClip;
	private var normal:MovieClip;

	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;

	private var status:Number = 0;
	
	/**
	 * this class handles the playlist button
	 */
	public function playlistButton() {
		EventDispatcher.initialize(this);
		
		totalHeight = normal["bg"]._height;
		normal._y = activated._y = over._y = 0;
		activated._alpha = over._alpha = 0;
		
		normal["txt"].autoSize = activated["txt"].autoSize = over["txt"].autoSize = normal["nr"].autoSize = activated["nr"].autoSize = over["nr"].autoSize = true;
		normal["txt"].wordWrap = activated["txt"].wordWrap = over["txt"].wordWrap = normal["nr"].wordWrap = activated["nr"].wordWrap = over["nr"].wordWrap = false;
		
	}
	
	/**
	 * here, the node data is being sent
	 * @param	n
	 * @param	pButtonWidth
	 */
	public function setNode(n:XMLNode, pButtonWidth:Number) {
		node = n;
		settingsObj = UNode.nodeToObj(node);
		normal["bg"]._width = activated["bg"]._width = over["bg"]._width = pButtonWidth;
		
		normal["txt"].text = activated["txt"].text = over["txt"].text = settingsObj.artist + " - " + settingsObj.songname;
		
		normal["nr"].text = activated["nr"].text = over["nr"].text = ord + 1 +".";
	}
	
	/**
	 * on roll over behavior
	 */
	private function onRollOver() {
		Tweener.addTween(over, { _alpha:100, time:0.15, transition:"linear" } );
	}
	
	/**
	 * on roll out behavior
	 */
	private function onRollOut() {
		if (status == 0) {
			Tweener.addTween(over, { _alpha:0, time:0.3, transition:"linear" } );
		}
	}
	
	/**
	 * on press behavior
	 */
	public function onPress() {
		_global.mp3PlayerNowButton = this;
		act();
		dispatchEvent( { target:this, type:"buttonPressed", mc:this } );
	}
	
	/**
	 * on release behavior
	 */
	private function onRelease() {
		onRollOut();
	}
	
	private function onReleaseOutside() {
		onRelease();
	}
	
	public function act() {
		status = 1;
		onRollOver();
		Tweener.addTween(activated, { _alpha:100, time:0.3, transition:"linear" } );
		Tweener.addTween(over, { _alpha:0, time:0.3, transition:"linear" } );
	}
	
	public function deact() {
		status = 0;
		onRollOut();
		Tweener.addTween(activated, { _alpha:0, time:0.3, transition:"linear" } );
	}
}
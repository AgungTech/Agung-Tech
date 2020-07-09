import caurina.transitions.*;
import ascb.util.Proxy;
import flash.filters.BlurFilter;
import mx.events.EventDispatcher;
/**
 * kelas ini mengatur tombol
 */
class agung.tech01.banner.simpleButton extends MovieClip  
{
	private var settingsObj:Object;
	private var node:XMLNode;
	
	
	private var over:MovieClip;
		private var overBg:MovieClip;
	
	private var normal:MovieClip;
		private var bg:MovieClip;
	
	private var activated:Number = 0;
		
	
		public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	public function simpleButton() {
		EventDispatcher.initialize(this);
		
		bg = normal["bg"];
		bg._alpha = 60;
	
		over._alpha = 0;
		
		overBg = over["bg"];
		this._visible = false;
	}
	
	/**
	 * disini, node dan nomor tombol akan dikirim
	 * @param	pNode
	 * @param	pIdx
	 */
	public function setNode(pNode:XMLNode, pIdx:Number) {
		node = pNode;
		normal["txt"].text = over["txt"].text =  String(pIdx+1)

		
		var format1_fmt:TextFormat = new TextFormat();
		format1_fmt.bold = true;
		normal["txt"].setNewTextFormat(format1_fmt);
		over["txt"].setTextFormat(format1_fmt);



		this._visible = true;
	}
	
	private function onRollOver() {
		Tweener.addTween(over, { _alpha:100, time:.2, transition:"linear" } );
		Tweener.addTween(bg, { _alpha:100, time:.2, transition:"linear"} );
	}
	
	private function onRollOut() {
		if (activated == 0) {
			Tweener.addTween(over, { _alpha:0, time:.2, transition:"linear" } );
			Tweener.addTween(bg, { _alpha:60, time:.2, transition:"linear"} );
		}
		
	}
	
	public function onPress() {
		dispatchEvent( { target:this, type:"buttonPressed", mc:this } );
	}
	
	private function onRelease() {
		onRollOut();
	}
	
	private function opReleaseOutside() {
		onRelease()
	}
	
	public function activate() {
		activated = 1;
		Tweener.addTween(over, { _alpha:100, time:.2, transition:"linear" } );
		Tweener.addTween(bg, { _alpha:100, time:.2, transition:"linear"} );
	}
	
	public function deactivate() {
		activated = 0;
		onRollOut();
	}
}
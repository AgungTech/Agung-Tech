import caurina.transitions.*;
import ascb.util.Proxy;

class agung.tech01.index.loaderInstance extends MovieClip
{
	private var myInterval:Number;
	

	private var holder:MovieClip;
	
	private var actualBar:MovieClip;
		private var fill:MovieClip;
		private var fillEnd:MovieClip;
	
	private var actualMask:MovieClip;
	
	private var defW:Number = 138;
	private var defH:Number = 36;
	private var actualMaskDefW:Number = 122;
	
	private var animationTime:Number = 0.8;
	private var animationTypeShow:String = "easeOutBack";
	private var animationTypeHide:String = "easeInBack";
	
	public function loaderInstance() {
		_global.globalLoader = this;
		
		actualBar = holder["bar"]["actualBar"];
			fillEnd = actualBar["end"];
			fill = actualBar["prgBar"];
		actualMask = holder["bar"]["actualMask"];
		
		actualBar.setMask(actualMask);
		
		this._alpha = 0;
		
		loadStageResize();
	}
	
	private function initialState() {
		/*actualMask._width = 0;
		fillEnd._x = Math.ceil(actualMask._x - fillEnd._width);*/
		
		holder["txt"].text = "MENUNGGU...";
		Tweener.addTween(actualMask, { _width:0, time: .1, transition: "linear", rounded:true } );
		Tweener.addTween(fillEnd, { _x:-fillEnd._width, time: .1, transition: "linear", rounded:true } );
	}
	
	public function loaderProgressChange(per:Number) {
		holder["txt"].text = "LOADING " + per + "%";
		actualMask._width = Math.ceil(actualMaskDefW / 100 * per + 4);
		fill._width = actualMask._width - 4
		fillEnd._x = Math.ceil(actualMask._width - 4); 
	}
	
	public function showLoader() {
		initialState();
		
		clearInterval(myInterval);
		myInterval = setInterval(this, "nowShow", 200);
	}
	
	private function nowShow() {
		clearInterval(myInterval);
		
		Tweener.addTween(holder, { _x:0, _y:0, _xscale:100, _yscale:100,  time: animationTime, transition: animationTypeShow, rounded:true } );
		Tweener.addTween(this, { _alpha:100,  time: animationTime, transition: "linear", rounded:true } );
	}
	
	public function hideLoader() {
		clearInterval(myInterval);
		holder["txt"].text = "SUKSES !";
		myInterval = setInterval(this, "nowHide", 100);
	}
	
	private function nowHide() {
		clearInterval(myInterval);
		Tweener.addTween(holder, { _x:defW / 2, _y:defH / 2, _xscale:0, _yscale:0,  time: animationTime, transition: animationTypeHide, rounded:true } );
		Tweener.addTween(this, { _alpha:0,  delay:.2, time: animationTime, transition: "linear", rounded:true } );
	}
	
	
	
	
	
	private function resize(pW:Number, pH:Number) {
		this._x = Math.ceil(pW / 2 - defW / 2);
		this._y = Math.ceil(pH / 2 - defH / 2);
	}
	
	private function onResize() {
		resize(Stage.width, Stage.height);
	}
	
	private function loadStageResize() {
		Stage.addListener(this);
		onResize();
	}
}
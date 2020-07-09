class agung.loader01.Loader01 extends MovieClip {
	// movie clips used
	private var Bg:MovieClip;
	private var Ldr:MovieClip;
	private var LblMc:MovieClip;
	private var LblTxt:TextField;
	
	// width and height vars
	private var w:Number;
	private var h:Number;
	
	public function Loader01() {		
		Bg 		= this["mc0"];
		Ldr 	= this["mc1"];
		LblMc 	= this["mc2"];
		LblTxt 	= LblMc["mc0"];
		
		this.blendMode = "layer";
		
		w = Bg._width;
		h = Bg._height;
		
		// setup text
		LblTxt.autoSize 		= "none";
		LblTxt.condenseWhite 	= true;
		
		// init text
		setText("", null, true);
	}
	// get width/height
	public function get width() {
		return w;
	}
	public function get height() {
		return h;
	}
	// set width, height is read-only
	public function set width(nw:Number) {
		w 				= Math.round(nw);
		Bg._width 		= w;
		LblTxt.autoSize = "none";
		LblTxt._width 	= w - 10;
	}
	// set text method
	public function setText(str:String, dim:Object, noText:Boolean) {
		LblTxt.htmlText = str;
		
		dim != "same" && isNaN(dim) ? dim = "auto" : null;
		noText == true ? dim = "same" : null;
		
		if (noText) {
			
			LblMc._visible 	= false;
			this.width 		= Ldr.width + 2 * Ldr._x;
			
		} else {
			
			LblMc._visible 	= true;
			
			switch(dim) {
				case "same": break;
				case "auto":
					LblTxt.autoSize = "left";
					this.width 		= LblTxt._width + 10;
					break;			
				default:
					this.width = Number(dim);
					break;
			}
			
		}
	}
	
	public function cancelSpin() {
		Ldr.cancelSpin();
	}
	
}
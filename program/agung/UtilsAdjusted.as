// Library dari AS 2 function
import flash.display.BitmapData;
import flash.filters.BlurFilter;
import flash.geom.ColorTransform;
import flash.filters.ColorMatrixFilter;

class agung.UtilsAdjusted {
	
	// delegasi dengan argument
	// Utils.Delegate(scope, func, arg1, arg2, ...);
	// mengembalikan function dengan specified(detail) scope	
	public static function delegate(scope:Object, func:Function) {
		var f:Function = function ():Void {
			var o:Object = arguments.callee;
			o["func"].apply(o["scope"], o["args"].concat(arguments));
		};
		
		f["func"] 	= func;
		f["scope"] 	= scope;
		f["args"] 	= arguments.slice(2);
		
		return f;
	}
	
	// Utils.mcPlay(mc, 23);
	public static function mcPlay(mc:MovieClip, fr:Number) {
		fr == 0 || fr > mc._totalframes ? fr = mc._totalframes : (fr < 0 ? fr = 1 : null);
		
		mc.stop();
		mc.onEnterFrame = function() {
			var cf:Number = this._currentframe;
			
			if (cf == fr) {
				delete this.onEnterFrame;
			} else {
				(cf > fr) ? this.prevFrame() : this.nextFrame();
			}
		};
	}
	
	// Utils.drawShape(mc, 100, 120, 8);  menggambar rectangle(kotak) dengan semua corner(pojok) radius ke 8 
	// Utils.drawShape(mc, 100, 120, 8, 15, 16, 20); menggambar rectangle(kotak) dengan setiap corner(pojok) radius sesuai yang ditentukan
	// Utils.drawShape(mc, 100, 200); menggambar kotak dengan tidak ada rounded corner(lengkungan pojok)
	public static function drawRShape(mc:MovieClip, w:Number, h:Number, r1:Number, r2:Number, r3:Number, r4:Number) {
		isNaN(r1) ? r1 = 00 : r1 = Math.abs(r1);
		isNaN(r2) ? r2 = r1 : r2 = Math.abs(r2);
		isNaN(r3) ? r3 = r1 : r3 = Math.abs(r3);
		isNaN(r4) ? r4 = r1 : r4 = Math.abs(r4);
		
		mc.clear();
		mc.beginFill(0, 100);
		
		mc.moveTo(r1, 0);
		mc.lineTo(w - r2, 0);
		r2 > 0 ? mc.curveTo(w, 0, w, r2) : null;
		mc.lineTo(w, h - r3);
		r3 > 0 ? mc.curveTo(w, h, w - r3, h) : null;
		mc.lineTo(r4, h);
		r4 > 0 ? mc.curveTo(0, h, 0, h - r4) : null;
		mc.lineTo(0, r1);
		r1 > 0 ? mc.curveTo(0, 0, r1, 0) : null;
		mc.endFill();
	}
	
	// Utils.getDims("fit", 100, 200, 50, 50, true)
	// returns: width dan height baru dalam pixel
	// type:String - "fit" atau "crop"
	// ow:Number, oh:Number - object original width dan height
	// mw:Number, mh:Number - maximum width dan height
	// scaleUp:Boolean - jika bernilai true, image akan di scale up  jika lebih kecil dari mwxmh
	public static function getDims(type:String, ow:Number, oh:Number, mw:Number, mh:Number, scaleUp:Boolean) {
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
	
	// - mengembalikan MovieClip
	// - load external image kedalam movie clip 
	//   selanjutnya menggunakan Utils.getImage untuk di transform ke movie clip
	//   denan bitmap data yang dipakai
	// Utils.getImage(mc, false); - tidak memakai smoothing(penghalusan)
	// Utils.getImage(mc)l - memakai smoothing(penghalusan)
	public static function getImage(mc:MovieClip, smooth:Boolean) {
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
	
	// Utils.remExtraSpaces("   a   b   cbv e .   ");
	// akan return(mengembalikan) "a b cbv e ."
	public static function remExtraSpace(str:String) {
		var found:Number 	= -1;
		var newStr:String 	= "";
		
		for (var i = 0; i < str.length; i++) {
			var c:String = str.charAt(i);
			
			if (c != '' && c != '\t' && c != '\n' && c != '\t') {
				
				if (found == 1) newStr += ' ' + c;
				else { newStr += c; found = 0; }
				
			}else {
				
				if (found == 0) found = 1;
				
			}
		}
		
		return newStr;
	}
	
	// menhapus spaces dari string
	public static function remWhiteSpace(str:String) {
		var newStr:String = "";
		
		for (var i = 0; i < str.length; i++) {
			var c:String = str.charAt(i);
			
			(c != ' ' && c != '\t' && c != '\n' && c != '\r') ? (newStr += c) : null;
		}
		
		return newStr;
	}
	
	// menghapus sides spaces(kelebihan spasi) dari string
	public static function remSideSpace(str:String) {
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
	
	// TextField Trim
	// Utils.TFTrim(tf, "Lorem ipsum dolor sit amet", 30)
	// akan muncul dalam text field seperti ini "Lorem ipsum do..." jadi
	// that the text field akan mempunyai textWidth(lebar) ke 30px
	//
	// Utils.TFTrim(tf, "Lorem ipsum dolor sit amet", 30, "---");
	// akan muncul "Lorem ipsum do---"
	public static function TFTrim(tf:TextField, str:String, maxw:Number, endStr:String) {
		tf.autoSize = true;
		tf.text 	= str;
		
		if (tf.textWidth <= maxw) return;

		endStr == undefined ? endStr = "..." : null;
		tf.text = endStr;
		
		maxw -= tf.textWidth;
		tf.text = "O";
		maxw -= tf.textWidth;
		tf.text = "";
		
		for (var i = 0; i < str.length; i++) {
			tf.text += str.charAt(i);
			
			if (tf.textWidth > maxw) {
				tf.text += endStr;
				break;
			}
		}
	}
	
	// mengecek jika mouse ada di area yang telah ditentukan didalam movie clip
	// Utils.overHitZone(mc, 100, 200, 30,40);
	// mendefinisikan zone dari width, height, x position dan y position
	// x, y akan di tentukan dan di set default ke 0
	public static function overHitZone(target:MovieClip, w:Number, h:Number, x:Number, y:Number) {
		x == undefined ? x = 0 : null;
		y == undefined ? y = 0 : null;
		
		var xm:Number = target._xmouse;
		var ym:Number = target._ymouse;
		
		return (xm >= x) && (xm <= x + w) && (ym >= y) && (ym <= y + h);
		
	}
	
	// trunc number (1.365436 -> 1.36 jika l = 2)
	public static function truncNr(v:Number, l:Number):Number {
		l == undefined ? l = 2 : null;
		var p:Number = Math.pow(10, l);
		
		return (Math.round(v*p)/p);
	}
	
	// format waktu string seperti (hh:mm:ss), hanya jam yang ditampilkan jika diperlukan
	public static function formatTime(t:Number) {
		var hours:Number 	= Math.floor(t/3600);
		var minutes:Number  = Math.floor((t %= 3600)/60);
		var seconds:Number  = Math.round(t % 60);
		
		var $hours:String   = String(hours);
		var $minutes:String = String(minutes);
		var $seconds:String = String(seconds);
		
		hours 	< 10 ? $hours 	= "0" + $hours 	 : null;
		minutes < 10 ? $minutes = "0" + $minutes : null;
		seconds < 10 ? $seconds = "0" + $seconds : null;
		
		var $time:String = $minutes + ":" + $seconds;
		
		hours > 0 ? $time = $hours + ":" + $time : null;
		
		return $time;
	}
	
	// mengecek email address yang valid
	public static function isValidEmail(str:String) {
		
		// mendapatkan char terakhir index
		var n:Number 		= str.length - 1;
		// @ position (-1 apabila tidak muncul)
		var atPos:Number 	= -1;
		// point position (-1 apabila tidak muncul)
		var ptPos:Number 	= -1;
		
		// cek setiap char jika bebentuk point atau @
		for (var i:Number = 0; i <= n; i++) {
			
			switch(str.charAt(i)) {
				case ".":	
					// if point is the first char or you do not have at least 2 chars at the end that are diffrent from point
					if (i == 0 || i > n - 2) 		return false;
					// jika point mendekati @ (setelah @)
					if (Math.abs(i - atPos) == 1) 	return false;
					// jika 2 point mendekati satu sama lain
					if (Math.abs(ptPos - i) == 1) 	return false;
					// jika tidak ada yang seperti diatase, akan memperingatkan point index
					ptPos = i;
					break;
				
				case "@":
					// jika @ ada di awal atau akhir char
					if (i == 0 || i == n) 			return false;
					// jika kita sebelumnya menemukan @, variable ini akan bernilai lebih dari 0 jika kita punya lebih dari satu @
					if (atPos > 0)					return false;
					// jika point mendekati @ (sebelum @)
					if (Math.abs(i - ptPos) == 1) 	return false;
					// jika tidak ada yang seperti diatas, akan memperingatkan @ index
					atPos = i;				
					break;
			}
			
		}
		// jika tidak menemukan sedikitnya satu point
		if (ptPos == -1) 	return false;
		// jika @ tdak ditemukan
		if (atPos == -1)	return false;
		// jika point terakhir ditemukan sebelum @
		if (ptPos < atPos) 	return false;
		// jika chars ditemukan setelah point terakhir lebih dari 4 (contoh yang benar: .co, .com, .info )
		if (ptPos < n - 4 ) return false;
		// jika chars ditemukan setelah point terakhir mempunyai values a-z A-Z
		for (i = ptPos + 1; i <= n; i++) {
			var cc:Number = str.charCodeAt(i);
			if (! ((cc >= 65 && cc <= 90) || (cc >= 97 && cc <= 122))) return false;
		}
		
		return true;
	}
	
	// mendapatkan char code
	public static function getCharCode(c:String) {
		return c.charCodeAt(0);
	}
	
	// string clean up (hanya a-z 0-9 dan /)
	public static function strCleanup(str:String):String {
		str = str.toLowerCase();
		
		var $a:Number = getCharCode('a');
		var $z:Number = getCharCode('z');
		var $0:Number = getCharCode('0');
		var $9:Number = getCharCode('9');
		
		var temp:String = "";
		for (var i:Number = 0; i < str.length; i++) {
			var c:String 	= str.charAt(i);
			var cc:Number	= str.charCodeAt(i);
			var lc:String	= temp.charAt(temp.length - 1);
			
			((cc >= $a && cc <= $z) || (cc >= $0 && cc <= $9) || (c == '/' && lc != '/')) ? (temp += c) : null;
		}
		
		(temp.charAt(0) != '/') ? (temp = '/' + temp) : null;
		(temp.charAt(temp.length - 1) != '/') ? (temp += '/') : null;
		
		return temp;
	}
	
	// cek jika string kosong(blank)
	public static function strIsBlank(str:String) {
		for (var i:Number = 0; i < str.length; i++) {
			if (str.charAt(i) != ' ') return false;
		}
		
		return true;
	}
	
	// mendapatkan bitmap data
	public static function getBitmapData(mc:MovieClip):BitmapData {	
		var ow:Number = Math.round(mc._width  * 100 / mc._xscale);
		var oh:Number = Math.round(mc._height * 100 / mc._yscale);
		
		return new BitmapData(ow, oh, true, 0);
	}
	
	// mendapatkan extensi file string
	public static function getFileStrExt(str:String):String {
		
		var ext:String = "";
		var pointFound:Boolean = false;
		
		for (var i:Number = str.length - 1; i >= 0; i-- ) {
			var c:String = str.charAt(i);
			if (c == '.') {
				pointFound = true;
				break;
			}else {
				ext = c + ext;
			}
		}
		
		return pointFound ? ext : "";
	}
	
	// mendapatkan / set warna movie clip
	public static function getMcColor(mc:MovieClip):Number {
		var col:Color 	= new Color(mc);
		
		return col.getRGB();
	}
	public static function setMcColor(mc:MovieClip, val:Number):Void {
		var col:Color 	= new Color(mc);
		
		col.setRGB(val);
	}
	
	// mendapatkan / set brightness(kecerahan) movie clip  ( [-1; 1] )
	// -2.55 - total black(hitam)
	// 2.55 - total white(putih)
	// mengambil dari Tweener, bekerja baik dengan Tweener untuk inisialisasi
	public static function getMcBrightness (mc:MovieClip):Number {
		var col:Color 	= new Color(mc);
		var o:Object 	= col.getTransform();
		
		var p:Number 	= ((o.rb + o.gb + o.bb) / 3) / 100;
		
		return truncNr(p ,2);	
	}
	public static function setMcBrightness (mc:MovieClip, p:Number):Void {
		// p < -2.55 ? p = -2.55 : (p > 2.55 ? p = 2.55 : null);
		
		var col:Color 	= new Color(mc);
		var v:Number 	= Math.round(p * 100);
		
		col.setTransform({ ra:100, rb: v, ga: 100, gb: v, ba: 100, bb: v });
	}
	
	// mendapatkan / set contrast(kontras) movie clip  ( [-1; 1] )
	// -1 - solid gray
	// mengambil dari Tweener, bekerja baik dengan Tweener untuk inisialisasi
	public static function getMcContrast(mc:MovieClip):Number {
		var col:Color 	= new Color(mc);
		var o:Object 	= col.getTransform();
		var p1:Number 	= (((o.ra + o.ga + o.ba) / 3) / 100 ) -1;
		var p2:Number	= ((o.rb + o.gb + o.bb) / 3) / ( -128);
		
		var p:Number 	= (p1 + p2) / 2;
		
		return truncNr(p, 2);
	}
	public static function setMcContrast(mc:MovieClip, p:Number):Void {
		// p < -1 ? p = -1 : (p > 1 ? p = 1 : null);
		
		var col:Color 	= new Color(mc);
		var v1:Number 	= Math.round((p + 1) * 100);
		var v2:Number 	= Math.round( p * ( -128));
		
		col.setTransform({ ra:v1, rb: v2, ga: v1, gb: v2, ba: v1, bb: v2 });
	}
	
	// get / set movie clip saturation ( [0; 2] )
	// 0 - full grayscale (effect bagus :D dari gray(hitam putih) untuk warna)
	// mengambil dari Tweener, bekerja baik dengan Tweener untuk inisialisasi
	private static function setMcMatrix(mc:MovieClip, m:Array): Void {
		var $filt:Array 	= mc.filters.concat();
		var found:Boolean 	= false;
		
		for (var i = 0; i < $filt.length; i++) {
			if ($filt[i] instanceof ColorMatrixFilter) {
				$filt[i].matrix = m.concat();
				found = true;
			}
		}
		
		if (!found) {
			var cmf:ColorMatrixFilter 	= new ColorMatrixFilter(m);
			$filt[$filt.length] 		= cmf;
		}
		
		mc.filters = $filt;
	}
	private static function getMcMatrix(mc:MovieClip): Array {

		for (var i = 0; i < mc.filters.length; i++) {
			if (mc.filters[i] instanceof ColorMatrixFilter) {
				return mc.filters[i].matrix.concat();
			}
		}
		
		return [
			1, 0, 0, 0, 0,
			0, 1, 0, 0, 0,
			0, 0, 1, 0, 0,
			0, 0, 0, 1, 0
		];
	}
	
	public static function getMcSaturation(mc:MovieClip):Number {
		var m:Array = getMcMatrix(mc);
		
		var lumR:Number = 0.212671;
		var lumG:Number = 0.715160;
		var lumB:Number = 0.072169;
		
		var p1:Number 	= ((m[0] - lumR) / (1 - lumR) + (m[6] - lumG) / (1 - lumG) + (m[12] - lumB) / (1 - lumB)) / 3;
		var p2:Number 	= 1 - ((m[1] / lumG + m[2] / lumB + m[5] / lumR + m[7] / lumB + m[10] / lumR + m[11] / lumG) / 6);
		
		var p:Number 	= (p1 + p2) / 2;
		
		return truncNr(p, 2);
	}
	
	// p = [0; 2]
	public static function setMcSaturation(mc:MovieClip, p:Number):Void {
		// p < 0 ? p = 0 : (p > 2 ? p = 2 : null);
		
		var lumR:Number = 0.212671;
		var lumG:Number = 0.715160;
		var lumB:Number = 0.072169;
		
		var sf:Number 	= p;
		var nf:Number 	= 1 - sf;
		var nr:Number 	= lumR * nf;
		var ng:Number 	= lumG * nf;
		var nb:Number 	= lumB * nf;

		var m:Array 	= [
			nr + sf,	ng,			nb,			0,	0,
			nr,			ng + sf,	nb,			0,	0,
			nr,			ng,			nb + sf,	0,	0,
			0,  		0, 			0,  		1,  0
		];
		
		setMcMatrix(mc, m);
	}
	
	// set movie clip blur (ini akan menghapus semua filter aktif lain)
	public static function setMcBlur(mc:MovieClip, blurX:Number, blurY:Number, quality:Number) {
		blurX 	== undefined ? blurX 	= 0 	: null;
		blurY 	== undefined ? blurY 	= 0 	: null;
		quality == undefined ? quality 	= 2 	: null;
		
		mc.filters = (blurX == 0 && blurY == 0) ? [] : [new BlurFilter(blurX, blurY, quality)];
	}
	
	// membuat movie clip unik
	public static function newMc(holder:MovieClip) {
		var d:Number = holder.getNextHighestDepth();
		return holder.createEmptyMovieClip("$newMc$" + d, d);
	}
	
	// attach cepat Library movie clip
	public static function newLibMc(holder:MovieClip, libId:String) {
		var d:Number = holder.getNextHighestDepth();
		return holder.attachMovie(libId, "$newLibMc$" + d, d);
	}
	
	// duplicate cepat movie clip
	public static function dupMc(source:MovieClip) {
		var d:Number = source._parent.getNextHighestDepth();
		return source.duplicateMovieClip("$dupMc$" + d, d);
	}
	
	// bring to front(selalu di depan) - movie clip
	public static function bring2Front(mc:MovieClip):Void {
		mc.swapDepths(mc._parent.getNextHighestDepth());
	}
	
	// set multiline html text field
	public static function initMhtf(tf:TextField, fixedHeight:Boolean) {
		fixedHeight == undefined ? fixedHeight = false : null;
		
		tf.autoSize 			= !fixedHeight;
		tf.multiline 			= true;
		tf.wordWrap 			= true;
		tf.condenseWhite 		= true;
		tf.mouseWheelEnabled 	= false;
		tf.html					= true;
	}
	
	// get next node; jika parameter ada di akhir node, akan dikembalikan ke sebelumnya (circular node list)
	public static function nextNode(node:XMLNode):XMLNode {
		return node.nextSibling 	== null ? node.parentNode.firstChild : node.nextSibling;
	}
	// get prev node; jika parameter ada di awal node, akan dikembalikan ke setelahnya (circular node list)
	public static function prevNode(node:XMLNode):XMLNode {
		return node.previousSibling == null ? node.parentNode.lastChild : node.previousSibling;
	}
	
	// menampilkan Javascript alert
	public static function alert(msg:String) {
		getURL("javascript:alert(" + msg + ");");
	}
	
	// set / get / menghapus cookie (Shared Object)	
	// convert ke milliseconds, dari
	// 0 - seconds, 1 - minutes, 2 - hours, 3 - days, 4 - weeks, 5 - months, 6 - years, default - days
	public static function toMs(t:Number, from:Number) {
		
		switch(from) {
			case 0:
				return t * 1000; // 1000 ms
				break;
			case 1:
				return toMs(t, 0) * 60; // 60 sec	
				break;
			case 2:
				return toMs(t, 1) * 60; // 60 min
				break;
			case 3:				
				return toMs(t, 2) * 24; // 24 hrs
				break;
			case 4:				
				return toMs(t, 3) * 7; // 7 dys
				break;
			case 5:				
				return toMs(t, 4) * 4.35; // 4.35 wks
				break;
			case 6:
				return toMs(t, 5) * 12; // 12 months
				break;
			default:
				return toMs(t, 3);
				break;
		}
	}
	public static function setCookie(name:String, val:String, expires:Number) {
		var d:Date 			= new Date();
		var so:SharedObject = SharedObject.getLocal(escape(name));
		so.data["value"] 	= escape(val);
		so.data["expires"] 	= (expires == null) ? "never" : String(d.getTime() + expires);
		
		so.flush();
	}
	
	public static function getCookie(name:String) {		
		var so:SharedObject = SharedObject.getLocal(escape(name));		
		var ct:Number 		= Number(so.data["expires"]);
		var val:String		= unescape(so.data["value"]);
		
		var d:Date 			= new Date();
		var t:Number 		= d.getTime();
		
		if ((ct >= t || isNaN(ct)) && val != null) {
			return unescape(so.data["value"]);
		}else {
			deleteCookie(name);
			return null;
		}		
	}
	
	public static function deleteCookie(name:String) {
		var so:SharedObject = SharedObject.getLocal(escape(name));
		so.clear();
	}
	
	// parse(menguraikan) setingan node (<var> value </var>) -> (o.var == value (String ke Number))
	public static function parseSettingsNode(n:XMLNode):Object {
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
	
	// cek cepat jika mouse ada dalam movie clip (tidak memperdulikan bentuk)
	public static function mouseOverMc(mc:MovieClip):Boolean {		
		return overHitZone(mc._parent, mc._width, mc._height, mc._x, mc._y);
	}
	
	// get sign dari number (returns -1 or 1)
	public static function getSign(n:Number) {
		return (n == 0) ? 1 : (n / Math.abs(n));
	}
	
	// get persentasi
	public static function getPercent(val:Number, maxVal:Number, forceSubunit:Boolean) {
		forceSubunit == undefined ? forceSubunit = true : null;
		
		var p:Number = (maxVal == 0) ? 0 : (val / maxVal);
		(forceSubunit && p > 1) ? (p = 1) : null;
		
		return p;
	}
	
	// trim string
	public static function strTrim(str:String, len:Number, endStr:String) {	
		if (str.length <= len) return str;
		
		endStr 		= (endStr == null) ? "..." : null;		
		var endIdx 	= len - endStr.length;
		
		if (endIdx < 0) {
			endIdx = 0;
			endStr = "";
		}
		
		return str.slice(0, endIdx) + endStr;
	}
	
	// mengganti bagian string dengan string lain
	public static function strPartReplace(str:String, part:String, repl:String) {
		
		var sl:Number = str.length;
		var pl:Number = part.length;
		
		if (pl > sl) return str;
		
		var temp:String = "";
		var pfc:String = part.charAt(0);
		
		for (var i:Number = 0; i < sl; i++) {
			var sc:String = str.charAt(i);
			
			if (sc != pfc) {
				temp += sc;
			} else {
				var match:Boolean = true;
				
				for (var j:Number = 1; j < pl; j++) {
					if (str.charAt(i + j) != part.charAt(j)) {
						match = false;
						break;
					}
				}
				
				if (match) {
					temp += repl;
					i += pl - 1;
				}
			}
		}
		
		return temp;
		
	}
}

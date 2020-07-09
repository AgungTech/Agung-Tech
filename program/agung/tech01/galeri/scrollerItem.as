import mx.events.EventDispatcher;
import flash.display.BitmapData;
import caurina.transitions.*;
import ascb.util.Proxy;
import asual.sa.SWFAddress;
import agung.utils.UAddr;
import agung.utils.UStr;

class agung.tech01.galeri.scrollerItem extends MovieClip 
{
	public var node:XMLNode;
	public var settingsObj:Object
	
	private var allHolder:MovieClip;
		private var graph:MovieClip;
	private var hit:MovieClip; 
	public var idx:Number;
	

	private var captions:MovieClip;
		private var captionsBg:MovieClip;
		private var captionsNormal:MovieClip;
		private var captionsOver:MovieClip;
		
	private var normal:MovieClip;
		private var normalBg1:MovieClip;
		private var normalBg2:MovieClip;
		private var normalBg3:MovieClip;
		
	private var over:MovieClip;
		private var overBg1:MovieClip;
		private var overBg2:MovieClip;
		private var overBg3:MovieClip;
		private var overBg4:MovieClip;
	
	private var holder:MovieClip;
		private var holderMc:MovieClip;
		
	private var mask:MovieClip;
		
	private var mcl:MovieClipLoader;
	private var mcl2:MovieClipLoader;
	
	private var dims:Object;
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	private var imageOrig:Object;
	
	public var urlAddress:String;
	public var urlTitle:String;
	
	public var urlAddressPopupClose:String;
	public var urlTitlePopupClose:String;
	
	private var currentGraphIdent:String;
	
	private var loader:MovieClip;
	
	public function scrollerItem() {
		EventDispatcher.initialize(this);
		this._visible = false;
		this.enabled = false;
		
		normal = allHolder["normal"];
		over = allHolder["over"];
		mask = allHolder["mask"];
		holder = allHolder["holder"];
		
		graph = allHolder["graph"];
		
		
		
	normalBg1 = normal["normalBg1"];
		normalBg2 = normal["normalBg2"];
		normalBg3 = normal["normalBg3"];
		
		overBg1 = over["overBg1"];
		overBg2 = over["overBg2"];
		overBg3 = over["overBg3"];
		overBg4 = over["overBg4"];
		
		over._alpha = 0;
			
		holderMc = holder["mc"];
		holder.setMask(mask);
		
		mcl = new MovieClipLoader();
		mcl.addListener(this);
		
		var lobj:Object = new Object();
		lobj.onLoadInit = Proxy.create(this, graphInit);
		lobj.onLoadError = Proxy.create(this, graphError);
		
		mcl2 = new MovieClipLoader();
		mcl2.addListener(lobj);
		
		captions = allHolder["captions"];
		captionsBg = captions["bg"];
		captionsNormal = captions["normal"];
		captionsOver = captions["over"];
		
		captionsOver._alpha = 0;
		captions._visible = false;
		captions._alpha = 80;
		captionsNormal["txt"].autoSize = captionsOver["txt"].autoSize = true;
		captionsNormal["txt"].wordWrap = captionsOver["txt"].wordWrap = false;
		
		if (_global.whitePresent) {
			captions._alpha = graph._alpha = 0;
		}
	}
	
	private function graphInit() {
		
		var o:Object = getDims("fit", graph._width, graph._height, settingsObj.graphWidth, settingsObj.graphHeight, false);
			graph["a"]._width = o.w;
			graph["a"]._height = o.h;
			graph["a"]._x = Math.ceil( settingsObj.graphWidth - o.w - 5);
			graph["a"]._y = Math.ceil(settingsObj.graphHeight - o.h - 5);
			
		
	}
	
	private function graphError() {
		trace("the graph will be loaded from library " + currentGraphIdent);
		
		graph.createEmptyMovieClip("b", graph.getNextHighestDepth());
		graph["b"].attachMovie(currentGraphIdent, "gr", graph["b"].getNextHighestDepth());
		
		var o:Object = getDims("fit", graph._width, graph._height, settingsObj.graphWidth, settingsObj.graphHeight, false);
			graph["b"]._width = o.w;
			graph["b"]._height = o.h;
			graph["b"]._x = Math.ceil( settingsObj.graphWidth - o.w - 3);
			graph["b"]._y = Math.ceil(settingsObj.graphHeight - o.h - 3);
			

	
	}

	/**
	 * disini data diset
	 * @param	pNode
	 * @param	pSettingsObj
	 */
	public function setNode(pNode:XMLNode, pSettingsObj:Object)
	{
		node = pNode;
		settingsObj = pSettingsObj;
	
		
		
		var firstLevel:String = _global.parentAddressLevelOne;
		var secondLevel:String = node.parentNode.parentNode.parentNode.attributes.browserUrl;
		var thirdLevel:String = node.firstChild.nextSibling.attributes.browserUrl;
		
	
		var strArray2:Array = secondLevel.split("/");
		var strArray3:Array = thirdLevel.split("/");
		
		urlAddress = UAddr.contract(firstLevel + "/" + strArray2[1] + "/" + strArray3[1]) + "/";
		
		urlAddressPopupClose = UAddr.contract(firstLevel + "/" + strArray2[1]) + "/";
		
		var firstLevelTitle:String = _global.parentTitleLevelOne;
		var secondLevelTitle:String = node.parentNode.parentNode.parentNode.attributes.browserTitle;
		var thirdLevelTitle:String = node.firstChild.nextSibling.attributes.browserTitle;
		
		urlTitle = firstLevelTitle + " " + _global.globalSettingsObj.urlTitleSeparator + " " + secondLevelTitle + " " + _global.globalSettingsObj.urlTitleSeparator + " " + thirdLevelTitle;
		urlTitlePopupClose = firstLevelTitle + " " + _global.globalSettingsObj.urlTitleSeparator + " " + secondLevelTitle;
		
		
		normalBg1._width = overBg1._width = Math.round(11 + settingsObj.thumbWidth + 11);
		normalBg1._height = overBg1._height = Math.round(11 + settingsObj.thumbHeight + 11);
		
		normalBg2._width = overBg2._width =  Math.round(3 + settingsObj.thumbWidth + 3);
		normalBg2._height = overBg2._height = Math.round(3 + settingsObj.thumbHeight + 3);
		
		normalBg2._x = overBg2._x = 8;
		normalBg2._y = overBg2._y = 8;
		
		
		if (_global.whitePresent) {
			overBg1._x = overBg1._y = 1;
			overBg4._width = overBg1._width;
			overBg4._height = overBg1._height;
			
			overBg1._width -= 2;
			overBg1._height -= 2;
			
			
			normalBg1._x = normalBg1._y = 1;
			normalBg3._width = normalBg1._width;
			normalBg3._height = normalBg1._height;
			
			normalBg1._width -= 2;
			normalBg1._height -= 2;
			
		}
		 
		overBg3._width = Math.round(1 + settingsObj.thumbWidth + 1);
		overBg3._height = Math.round(1 + settingsObj.thumbHeight + 1);
		
		overBg3._x = overBg2._x + 2;
		overBg3._y = overBg2._y + 2;
		
		holder._alpha = 0;
		holder._x = holder._y = mask._x = mask._y = 11;
		mask._width = settingsObj.thumbWidth;
		mask._height = settingsObj.thumbHeight;
		
		dims = new Object();
		dims.x = 0;
		dims.y = 0;
		dims.w = this._width;
		dims.h = this._height;
		
		hit._width = dims.w;
		hit._height = dims.h;
		
		captionsNormal["txt"].text = captionsOver["txt"].text = "";
		
			loader._x = Math.ceil(this._width / 2 - loader._width / 2);
		loader._y = Math.ceil(this._height / 2 - loader._height / 2);
		
		this._visible = true;
	}
	
	public function startLoad() {
		mcl.loadClip(node.attributes.thumb, holderMc);
	}
	
	private function onLoadInit(mc:MovieClip) {
		getImage(mc, true);
		
		imageOrig = new Object();
		
		imageOrig.w = mc._width;
		imageOrig.h = mc._height;
		
		if (settingsObj.toggleProportionalResizeOnThumb == 0) {
			mc._width = settingsObj.thumbWidth;
			mc._height = settingsObj.thumbHeight;
			
			graph._x = Math.ceil(11 + mc._width - settingsObj.graphWidth);
			graph._Y = Math.ceil(11 + mc._height - settingsObj.graphHeight);
			
			captions._x = 11;
			captions._y = Math.ceil(11 + mc._height - captionsBg._height);
			captionsBg._width = mc._width;
		}
		else {
			var o:Object = getDims(settingsObj.proportionalResizeType, mc._width, mc._height, settingsObj.thumbWidth, settingsObj.thumbHeight, true);
			
				mc._width = o.w;
				mc._height = o.h;
				
			if (settingsObj.proportionalResizeType == "fit") {
				var newWidth:Number = Math.round(11 + o.w + 11);
				var newHeight:Number = Math.round(11 + o.h + 11);
				
				
				Tweener.addTween(normalBg2, { _width:Math.round(3 + o.w + 3), _height:Math.round(3 + o.h + 3), time:0.2, transition:"linear" } );
				

				Tweener.addTween(overBg2, { _width:Math.round(3 + o.w + 3), _height:Math.round(3 + o.h + 3), time:0.2, transition:"linear" } );
				
				Tweener.addTween(overBg3, { _width:Math.round(1 + o.w + 1), _height:Math.round(1 + o.h + 1), time:0.2, transition:"linear" } );
				
				Tweener.addTween(allHolder, { _x:Math.round(dims.x + dims.w / 2 - newWidth / 2), _y:Math.round(dims.y + dims.h / 2 - newHeight / 2), time:0.2, transition:"linear" } );
				
				
				 if (_global.whitePresent) {
					 Tweener.addTween(normalBg1, { _width:Math.round(11 + o.w + 11 - 2), _height:Math.round(11 + o.h + 11 - 2), time:0.2, transition:"linear" } );
					 Tweener.addTween(overBg1, { _width:Math.round(11 + o.w + 11 - 2), _height:Math.round(11 + o.h + 11 - 2), time:0.2, transition:"linear" } );
					 
					 Tweener.addTween(overBg4, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
					 Tweener.addTween(normalBg3, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
				 }
				 else {
					 Tweener.addTween(normalBg1, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
					 Tweener.addTween(overBg1, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
				 }
				graph._x = Math.ceil(Math.round(11 + o.w) - settingsObj.graphWidth);
				graph._y = Math.ceil(Math.round(11 + o.h) - settingsObj.graphHeight);
				
				captions._x = 11;
				captions._y = Math.ceil(11 + o.h - captionsBg._height);
				captionsBg._width = o.w;
			}
			else {
				mc._x = o.x;
				mc._y = o.y;
				
				graph._x = Math.ceil(mask._width + mask._x - settingsObj.graphWidth);
				graph._y = Math.ceil(mask._height + mask._y - settingsObj.graphHeight);
				
				captions._x =mask._x;
				captions._y = Math.ceil(mask._x + mask._height - captionsBg._height);
				captionsBg._width = mask._width;
			}
		}
		
		Tweener.addTween(holder, { _alpha:100, time:0.2, transition:"linear" } );
		
		dispatchEvent( { target:this, type:"thumbLoaded", mc:this } );
		
		var loadAddress:Array = String(node.firstChild.nextSibling.firstChild.attributes.imageAddress).split(".");
		
		var lastL:Number = loadAddress.length - 1;
		
		var myYArr:Array = String(node.firstChild.nextSibling.firstChild.attributes.imageAddress).split("/", 1);

		graph.createEmptyMovieClip("a", graph.getNextHighestDepth());
		if ((loadAddress[lastL] == "flv") || (loadAddress[lastL] == "mov") || (loadAddress[lastL] == "mp4") || (loadAddress[lastL] == "h264") || (myYArr[0] == "http:")) {
			
				
			if (myYArr[0] == "http:") {
				
				trace("Youtube Present !");
				captionsNormal["txt"].text = captionsOver["txt"].text = settingsObj.youtubeCaption;
				
				currentGraphIdent = settingsObj.youtubeGraf;
				
				var myAr:Array = settingsObj.youtubeGraf.split("");
				var compStr:String = myAr[0] + myAr[1];
				if (compStr != "ID") {
					mcl2.loadClip(settingsObj.youtubeGraf, graph["a"]);
				}
				else {
					graphError()
				}
				
			}
			else {
				trace("video Present !");
				captionsNormal["txt"].text = captionsOver["txt"].text = settingsObj.videoCaption;
				currentGraphIdent = settingsObj.videoGraf
				var myAr:Array = settingsObj.videoGraf.split("");
				var compStr:String = myAr[0] + myAr[1];
				if (compStr != "ID") {
					mcl2.loadClip(settingsObj.videoGraf, graph["a"]);
				}
				else {
					graphError();
				}
			}
			
			
		}
		else {
			if (loadAddress[lastL] == "mp3") {
				trace("audio Present !");
			
				currentGraphIdent = settingsObj.audioGraf
				var myAr:Array = settingsObj.audioGraf.split("");
				var compStr:String = myAr[0] + myAr[1];
				trace(compStr + " " +settingsObj.audioGraf)
				if (compStr != "ID") {
					mcl2.loadClip(settingsObj.audioGraf, graph["a"]);
				}
				else {
					graphError()
				}
				
				
				captionsNormal["txt"].text = captionsOver["txt"].text = settingsObj.audioCaption;
			}
			else {
				if (loadAddress[lastL] == "swf") {
					trace("swf Present !");
			
					currentGraphIdent = settingsObj.swfGraf
					var myAr:Array = settingsObj.swfGraf.split("");
					var compStr:String = myAr[0] + myAr[1];
					if (compStr.toUpperCase() != "ID") {
						mcl2.loadClip(settingsObj.swfGraf, graph["a"]);
					}
					else {
						graphError()
					}
					captionsNormal["txt"].text = captionsOver["txt"].text = settingsObj.swfCaption;
				}
				else {
					trace("image Present !");
			
					currentGraphIdent = settingsObj.pictureGraf
						var myAr:Array = settingsObj.pictureGraf.split("");
					var compStr:String = myAr[0] + myAr[1];
					if (compStr != "ID") {
						mcl2.loadClip(settingsObj.pictureGraf, graph["a"]);
					}
					else {
						graphError()
					}
					
				
					captionsNormal["txt"].text = captionsOver["txt"].text = settingsObj.imageCaption;
				}
				
			}
		}
		
		var my_fmt:TextFormat = new TextFormat();
		my_fmt.bold = true;

		captionsNormal["txt"].setTextFormat(my_fmt);
		captionsOver["txt"].setTextFormat(my_fmt);
		
		captions._visible = true;
		
		loader.cancelSpin();
		this.enabled = true;
	}
	

	private function onLoadError(mc:MovieClip) {
		dispatchEvent( { target:this, type:"thumbLoaded", mc:this } );
		graph._visible = false;
		captions._visible = false;
		loader.cancelSpin();
		this.enabled = true;
	}
	
	private function onRollOver() {
		if ((settingsObj.toggleProportionalResizeOnThumb == 1) && (settingsObj.proportionalResizeType == "crop")) {
			var o:Object = getDims("fit", imageOrig.w, imageOrig.h, settingsObj.thumbWidth, settingsObj.thumbHeight, true);
			Tweener.addTween(holder["mc"], { _width:o.w, _height:o.h, _x:0, _y:0, time:0.2, transition:"linear" } );
		
			var newWidth:Number = Math.round(11 + o.w + 11);
			var newHeight:Number = Math.round(11 + o.h + 11);
				
				
			Tweener.addTween(normalBg2, { _width:Math.round(3 + o.w + 3), _height:Math.round(3 + o.h + 3), time:0.2, transition:"linear" } );
				
			Tweener.addTween(overBg2, { _width:Math.round(3 + o.w + 3), _height:Math.round(3 + o.h + 3), time:0.2, transition:"linear" } );
				
			Tweener.addTween(overBg3, { _width:Math.round(1 + o.w + 1), _height:Math.round(1 + o.h + 1), time:0.2, transition:"linear" } );
				
			Tweener.addTween(allHolder, { _x:Math.round(dims.x + dims.w / 2 - newWidth / 2), _y:Math.round(dims.y + dims.h / 2 - newHeight / 2), time:0.2, transition:"linear" } );
				
			
			 if (_global.whitePresent) {
					 Tweener.addTween(normalBg1, { _width:Math.round(11 + o.w + 11 - 2), _height:Math.round(11 + o.h + 11 - 2), time:0.2, transition:"linear" } );
					 Tweener.addTween(overBg1, { _width:Math.round(11 + o.w + 11 - 2), _height:Math.round(11 + o.h + 11 - 2), time:0.2, transition:"linear" } );
					 
					 Tweener.addTween(overBg4, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
					 Tweener.addTween(normalBg3, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
				 }
				 else {
					 Tweener.addTween(normalBg1, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
					 Tweener.addTween(overBg1, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
				 }
				
			Tweener.addTween(graph, { _x:Math.ceil(11 + o.w - settingsObj.graphWidth), _y:Math.ceil(11 + o.h - settingsObj.graphHeight), time:0.2, transition:"linear" } );
		
			Tweener.addTween(captions, { _alpha:100, _x:Math.ceil(11), _y:Math.ceil(11 + o.h - captionsBg._height), time:0.2, transition:"linear" } );
		
		}
		else {
			Tweener.addTween(captions, { _alpha:100, time:0.2, transition:"linear" } );
		}
			
		if (_global.whitePresent) {
			Tweener.addTween(graph, { _alpha:100, time:0.2, transition:"linear" } );
		}
		
		Tweener.addTween(captionsOver, { _alpha:100, time:0.2, transition:"linear" } );
		Tweener.addTween(captionsNormal, { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(over, { _alpha:100, time:0.2, transition:"linear" } );
		
		
		
		dispatchEvent( { target:this, type:"thumbRollOver", mc:this } );
	}
	
	private function onRollOut() {
		if ((settingsObj.toggleProportionalResizeOnThumb == 1) && (settingsObj.proportionalResizeType == "crop")) {
			var o:Object = getDims("crop", imageOrig.w, imageOrig.h, settingsObj.thumbWidth, settingsObj.thumbHeight, true);
			Tweener.addTween(holder["mc"], { _width:o.w, _height:o.h, _x:o.x, _y:o.y, time:0.2, transition:"linear" } );
		
			
			
			
				var newWidth:Number = dims.w;
				var newHeight:Number = dims.h;
				o.w = settingsObj.thumbWidth;
				o.h = settingsObj.thumbHeight;
				
				Tweener.addTween(normalBg2, { _width:Math.round(3 + o.w + 3), _height:Math.round(3 + o.h + 3), time:0.2, transition:"linear" } );
				
				Tweener.addTween(overBg2, { _width:Math.round(3 + o.w + 3), _height:Math.round(3 + o.h + 3), time:0.2, transition:"linear" } );
				
				Tweener.addTween(overBg3, { _width:Math.round(1 + o.w + 1), _height:Math.round(1 + o.h + 1), time:0.2, transition:"linear" } );
				
				Tweener.addTween(allHolder, { _x:Math.round(dims.x + dims.w / 2 - newWidth / 2), _y:Math.round(dims.y + dims.h / 2 - newHeight / 2), time:0.2, transition:"linear" } );
				
				 if (_global.whitePresent) {
					 Tweener.addTween(normalBg1, { _width:Math.round(11 + o.w + 11 - 2), _height:Math.round(11 + o.h + 11 - 2), time:0.2, transition:"linear" } );
					 Tweener.addTween(overBg1, { _width:Math.round(11 + o.w + 11 - 2), _height:Math.round(11 + o.h + 11 - 2), time:0.2, transition:"linear" } );
					 
					 Tweener.addTween(overBg4, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
					 Tweener.addTween(normalBg3, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
				 }
				 else {
					 Tweener.addTween(normalBg1, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
					 Tweener.addTween(overBg1, { _width:Math.round(11 + o.w + 11), _height:Math.round(11 + o.h + 11), time:0.2, transition:"linear" } );
				 }
				Tweener.addTween(graph, { _x:Math.ceil(11 + o.w - settingsObj.graphWidth), _y:Math.ceil(11 + o.h - settingsObj.graphHeight), time:0.2, transition:"linear" } );
		
		
				
				if (_global.whitePresent) {
					Tweener.addTween(captions, { _alpha:0, _x:Math.ceil(11), _y:Math.ceil(11 + o.h - captionsBg._height), time:0.2, transition:"linear" } );
					
				}
				else {
					Tweener.addTween(captions, { _alpha:80, _x:Math.ceil(11), _y:Math.ceil(11 + o.h - captionsBg._height), time:0.2, transition:"linear" } );
				}
		
		}
		else {
			if (_global.whitePresent) {
					Tweener.addTween(captions, { _alpha:0,time:0.2, transition:"linear" } );
					
				}
				else {
					Tweener.addTween(captions, { _alpha:80, time:0.2, transition:"linear" } );
				}
		}
		
		
		Tweener.addTween(captionsOver, { _alpha:0, time:0.2, transition:"linear" } );
		Tweener.addTween(captionsNormal, { _alpha:100, time:0.2, transition:"linear" } );
		Tweener.addTween(over, { _alpha:0, time:0.2, transition:"linear" } );
		if (_global.whitePresent) {
			Tweener.addTween(captions, { _alpha:0, time:0.2, transition:"linear" } );
		}
		else {
			Tweener.addTween(captions, { _alpha:80, time:0.2, transition:"linear" } );
		}
		
		if (_global.whitePresent) {
			Tweener.addTween(graph, { _alpha:0, time:0.2, transition:"linear" } );
		}
		dispatchEvent( { target:this, type:"thumbRollOut", mc:this } );
	}
	

	private function onRelease() {
		onRollOut();
	}
	
	private function onReleaseOutside() {
		onRelease();
	}
	
	
	
	public function dispatchMc() {
		SWFAddress.setTitle(urlTitle);
		dispatchEvent( { target:this, type:"thumbClicked", mc:this } );
	}
	
	public function onPress() {
		onRollOut()
		SWFAddress.setValue(urlAddress);
	}
	
	public function closePopup() {
		//SWFAddress.setTitle(urlTitlePopupClose);
		//SWFAddress.setValue(urlAddressPopupClose);
		
		_global.nowPop.closePopupFullNow();
	}
	
	private function getImage(mc:MovieClip, smooth:Boolean) {
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
	
	private function getDims(type:String, ow:Number, oh:Number, mw:Number, mh:Number, scaleUp:Boolean) {
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
	
}
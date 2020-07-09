import ascb.util.Proxy;
import caurina.transitions.*;
import mx.data.types.Obj;
import mx.data.types.Str;
import agung.utils.UNode;

import mx.events.EventDispatcher;
import asual.sa.SWFAddress;
import agung.utils.UAddr;

class agung.tech01.materi.projectThumbScroller extends MovieClip 
{
	private var theXml:XML;	
	public var node:XMLNode;
	private var mainSettingsObj:Object;
	private var settingsObj:Object
	
	private var holder:MovieClip;
		private var lst:MovieClip;
		private var mask:MovieClip;
		private var topHit:MovieClip;
		
	private var addedToThumbWidth:Number = 11 + 11;
	private var addedToThumbHeight:Number = 11 + 11;
	
	private var thumbArray:Array;
	private var thumbLoadingIdx:Number = -1;

	public var totalHeight:Number;
	

	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	private var myInterval:Number;
	private var myInterval2:Number;
	
	private var projectDescription:MovieClip;
	
	private var totalLstBottomY:Number;
	
	private var scrollableBoxIs:Number = 1;
	
	public function projectThumbScroller() {
		this._visible = false;
		EventDispatcher.initialize(this);
		
		lst = holder["lst"];
		mask = holder["mask"];
	
		topHit = holder["topHit"];
	
		topHit._alpha = 0;
		
		lst.setMask(mask);
		
	}
	
	public function setNode(pNode:XMLNode, pMainSettingsObj:Object, pProjectDescription:MovieClip)
	{
		
		node = pNode;
		mainSettingsObj = pMainSettingsObj;
	
		projectDescription = pProjectDescription;
		
		node = node.firstChild;
		
		
		settingsObj = UNode.nodeToObj(node);
		
		
		totalHeight = Math.round(mainSettingsObj.moduleHeight)
		
		mask._width = Math.round((settingsObj.thumbWidth + addedToThumbWidth) * settingsObj.horizontalNumberOfItems + settingsObj.horizontalSpace * (settingsObj.horizontalNumberOfItems - 1));
	
		mask._height = totalHeight;
		
		
		thumbArray = new Array();
		var currentXPos:Number = 0;
		var currentYPos:Number = 0;
		var idx:Number = 0;
		
		node = node.nextSibling.firstChild;
		
	
		var xJump:Number = 0;
		var yJump:Number = 0;
		
		for (; node != null; node = node.nextSibling) {
			var currentItem:MovieClip = lst.attachMovie("IDprojectThumbItem", "projectThumbItem" + idx, lst.getNextHighestDepth());
			
			currentItem.addEventListener("thumbLoaded", Proxy.create(this, thumbLoaded));
			currentItem.addEventListener("thumbClicked", Proxy.create(this, thumbClicked));
			
			currentItem._x = currentXPos;
			currentItem._y = currentYPos;
			currentItem.idx = idx;
			currentItem.setNode(node, settingsObj);

			
			yJump++;
			/*if (yJump == settingsObj.verticalNumberOfItems) {
				yJump = 0;
				currentXPos += Math.round(settingsObj.thumbWidth + addedToThumbWidth + settingsObj.horizontalSpace);
			}*/
			
			currentYPos = Math.ceil(yJump*(settingsObj.thumbHeight + addedToThumbHeight + settingsObj.verticalSpace))
			thumbArray.push(currentItem);
			
			
			idx++;
		}
		
		if (currentYPos < mask._height) {
			scrollableBoxIs = 0;
		}
		startScrolling();
	
		totalLstBottomY = Math.ceil(lst._height - mask._height);
		
		_global.portfolioPopupHandler.setSettings(settingsObj);
		
		myInterval = setInterval(this, "startLoading", 2000);
			
		topHit._height = mask._height;
		topHit._width = mask._width;

		this._visible = true;
	}
	
	public function treatAddress() {
		var str:String = UAddr.contract(SWFAddress.getValue());
		var strArray:Array = str.split("/");
		var idx:Number = 0;
		
		if (strArray[4]) {
			
			var idx:Number = 0;
			while (lst["projectThumbItem" + idx]) {
				
			
				if (lst["projectThumbItem" + idx].urlAddress == (str + "/")) {
					lst["projectThumbItem" + idx].dispatchMc();
					break;
				}
				
				
				idx++;
			}
		}
	}
	
	public function stopScrolling() {
		clearInterval(myInterval2);
	}
	
	public function startScrolling() {
		clearInterval(myInterval2);
		if (scrollableBoxIs == 1) {
			myInterval2 = setInterval(this, "scrollThis", 30);
		}
		
	}
	
	private function scrollThis() {
		if (this._xmouse > 0 && this._xmouse < topHit._width && this._ymouse > 0 && this._ymouse < topHit._height) {
				var per:Number = Math.ceil(this._ymouse / topHit._height * 100);
				
				if (per < 10) {
					per = 0;
				}
				
				if (per > 90) {
					per = 100;
				}

				var actualCurrentY:Number = Math.ceil(totalLstBottomY / 100 * per);
			
				Tweener.addTween(lst, { _y:-actualCurrentY, time:.05*settingsObj.scrollerAccelerationMultiplier, transition:"linear" } );
			
		}
	}
	
	private function startLoading() {
		clearInterval(myInterval);
		
		thumbLoaded();
	}
	
	
	private function thumbClicked(obj:Object) {
		
		_global.portfolioPopupHandler.launchPopup(obj.mc, thumbArray, projectDescription, this);
	}
	
	private function thumbLoaded(obj:Object) {
		thumbLoadingIdx++;
		if (thumbArray[thumbLoadingIdx]) {
			thumbArray[thumbLoadingIdx].startLoad();
		}
	}
}
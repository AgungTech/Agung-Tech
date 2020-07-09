import ascb.util.Proxy;
import caurina.transitions.*;
import mx.data.types.Obj;
import mx.data.types.Str;
import agung.utils.UNode;

import mx.events.EventDispatcher;
import asual.sa.SWFAddress;
import agung.utils.UAddr;

/**
 * This class handles the actual thumb scroller images
 */
class agung.tech01.tentang_orang.thumbScroller extends MovieClip 
{
	private var theXml:XML;	
	private var node:XMLNode;
	private var mainSettingsObj:Object;
	private var settingsObj:Object
	
	private var leftHit:MovieClip;
	private var rightHit:MovieClip;
	
	private var holder:MovieClip;
		private var lst:MovieClip;
		public var mask:MovieClip;
	
	private var addedToThumbWidth:Number = 11 + 11;
	private var addedToThumbHeight:Number = 11 + 11;
	
	private var thumbArray:Array;
	private var thumbLoadingIdx:Number = -1;
	private var currentJump:Number = 0;
	private var totalItems:Number;
	
	public var totalHeight:Number;
	
	public var scrollerDescription:MovieClip;
	
	private var myInterval2:Number;
	private var totalLstBottomX:Number;
	
	public var myParent:MovieClip;
	
	public function thumbScroller() {
		this._visible = false;
		
		lst = holder["lst"];
		mask = holder["mask"];
	
		leftHit._visible = false;
		
		lst.setMask(mask);
	}
	
	/**
	 * 
	 * @param	pNode
	 * @param	pMainSettingsObj
	 * @param	pSettingsObj
	 */
	public function setNode(pNode:XMLNode, pMainSettingsObj:Object, pSettingsObj:Object)
	{
		
		node = pNode;
		
		mainSettingsObj = pMainSettingsObj;
	
		settingsObj = pSettingsObj;
		
		
		mask._width = leftHit._width = Math.round((settingsObj.thumbWidth + addedToThumbWidth) * settingsObj.horizontalNumberOfItems + settingsObj.horizontalSpace * (settingsObj.horizontalNumberOfItems - 1));
		
		mask._height = totalHeight = leftHit._height = Math.round((settingsObj.thumbHeight + addedToThumbHeight) * settingsObj.verticalNumberOfItems + settingsObj.verticalSpace * (settingsObj.verticalNumberOfItems - 1));
	
		
		
		thumbArray = new Array();
		var currentXPos:Number = 0;
		var currentYPos:Number = 0;
		var idx:Number = 0;
		var idx2:Number = 0;
		var idd:Number = 0;
		
		node = node.firstChild.nextSibling.firstChild;
		
	
		
		for (; node != null; node = node.nextSibling) {
			var currentItem:MovieClip = lst.attachMovie("IDscrollerItem", "scrollerItem" + idx, lst.getNextHighestDepth());
			
			currentItem.addEventListener("thumbLoaded", Proxy.create(this, thumbLoaded));
			
			currentItem._x = currentXPos;
			currentItem._y = currentYPos;
			idd++;
			
			currentItem.setNode(node, settingsObj);

			idx2++;
			
			if (idx2 == settingsObj.verticalNumberOfItems) {
				idx2 = 0;
				currentXPos += Math.round(settingsObj.thumbWidth + addedToThumbWidth + settingsObj.horizontalSpace);
				currentYPos = 0;
			}
			else {
				currentYPos += Number(Math.round(settingsObj.thumbHeight + addedToThumbHeight + settingsObj.verticalSpace));
			}
			
			trace(idd + " " + currentYPos + " " + settingsObj.thumbHeight + " " +addedToThumbHeight + " " + settingsObj.verticalSpace + " " +settingsObj.verticalNumberOfItems )

			thumbArray.push(currentItem);
			
			idx++;
			if (!node.nextSibling.nextSibling) {
				break;
			}
		
		}
		
		totalItems = idx - 1;
		
	
		totalLstBottomX = Math.ceil(lst._width - mask._width);
		
		//thumbLoaded();
		
		if (idx > settingsObj.horizontalNumberOfItems) {
			startScrolling();
		}
		
		this._visible = true;
	}
	
	private function thumbLoaded(obj:Object) {
		thumbLoadingIdx++;
		if (thumbArray[thumbLoadingIdx]) {
			thumbArray[thumbLoadingIdx].startLoad();
		}
		else {
			myParent.allThumbsLoaded();
		}
	}
	
	public function startScrolling() {
		clearInterval(myInterval2);
		myInterval2 = setInterval(this, "scrollThis", 30);
	}
	
	private function scrollThis() {
		if (this._xmouse > 0 && this._xmouse < leftHit._width && this._ymouse > 0 && this._ymouse < leftHit._height) {
				var per:Number = Math.ceil(this._xmouse / leftHit._width * 100);
				
				if (per < 3) {
					per = 0;
				}
				
				if (per > 97) {
					per = 100;
				}

				var actualCurrentX:Number = Math.ceil(totalLstBottomX / 100 * per);
			
				Tweener.addTween(lst, { _x:-actualCurrentX, time:.05*settingsObj.scrollerAccelerationMultiplier, transition:"linear" } );
			
		}
	}
}
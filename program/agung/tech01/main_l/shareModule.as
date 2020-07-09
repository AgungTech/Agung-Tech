import ascb.util.Proxy;
import caurina.transitions.*;
import asual.sa.SWFAddress;
import agung.utils.UAddr;
import agung.utils.UNode;

/**
 * This is the main class of the share module
 * Here, the small and big buttons are being initialized and here are the
 * actions for opening / closing the small sharing list if available
 */
class agung.tech01.main_l.shareModule extends MovieClip
{
	private var shortList:MovieClip;
	private var settingsObj:Object;
	
	private var scrollerDescription:MovieClip;
	
	private var plus:MovieClip;
	private var minus:MovieClip;
	
	private var holder:MovieClip;
		private var scrl:MovieClip;
			private var mask:MovieClip;
			private var lst:MovieClip; 
			private var leftHit:MovieClip;
		
		private var mc:MovieClip;
			private var bg:MovieClip;
				private var fill:MovieClip;
				private var bgStroke:MovieClip;
				private var bgStroke2:MovieClip;
		
	private var bgObj:Object;
	private var myInterval2:Number;
	private var totalLstBottomX:Number;
	private var scrollable:Number = 0;
	private var less:XMLNode;
	private var more:XMLNode;
	
	public function shareModule() {
		scrl = holder["scrl"];
		mask = scrl["mask"];
		lst = scrl["lst"];
		leftHit = scrl["leftHit"];
		
		mc = holder["mc"];
		mask._visible = false;
		
		bg = mc["bg"];
		fill = bg["fill"];
		bgStroke2 = bg["bgStroke2"];
		bgStroke = bg["bgStroke"];
		
		
	}
	
	/**
	 * This function is called externally from the main component
	 * right after the xml file has been properly loaded and the settings parsed
	 */
	public function init() {
		var node:XMLNode = _global.shareModuleNode.firstChild.nextSibling.firstChild;
		settingsObj = _global.shareModuleSettings;
		if(settingsObj.enabled != 0) {
			var currentPos:Number = 0;
			var idx:Number = 0;
			var smallNode:XMLNode = node.parentNode.nextSibling.firstChild;
			more = node.parentNode.nextSibling.nextSibling;
		
			less =  node.parentNode.nextSibling.nextSibling.nextSibling;

			
			for (; node != null; node = node.nextSibling) {
				var currentItem:MovieClip = shortList.attachMovie("IDshareBigItem", "bgItem" + idx, shortList.getNextHighestDepth());
				currentItem.addEventListener("rolledOverBig", Proxy.create(this, rolledOverBig));
				currentItem.addEventListener("rolledOutBig", Proxy.create(this, rolledOutBig));
			
				currentItem.setNode(node);
				currentItem._x = currentPos;
				currentPos += Math.ceil(settingsObj.bigButtonsWidth + settingsObj.spaceBetweenBigButtons);
				idx++;
			}
			
			_global.shareMaxWidth = currentPos + settingsObj.correctPosX + settingsObj.smallListWidth + 20;
			
			plus._x = minus._x = Math.ceil(currentPos);
			plus._y = minus._y = Math.ceil(settingsObj.bigButtonsHeight / 2 - plus._height / 2 - 1);
			
			plus["over"]._alpha = minus["over"]._alpha = 0;
			plus.onRollOver = Proxy.create(this, plusOnRollOver);
			plus.onRollOut = Proxy.create(this, plusOnRollOut);
			plus.onPress = Proxy.create(this, plusOnPress);
			plus._alpha = 0;
			
			minus.enabled = false;
			minus._visible = false;
			
			minus.onRollOver = Proxy.create(this, minusOnRollOver);
			minus.onRollOut = Proxy.create(this, minusOnRollOut);
			minus.onPress = Proxy.create(this, minusOnPress);
			minus._alpha = 0;
			
			Tweener.addTween(plus, { _alpha:100, delay:.5, time: 1, transition: "linear" } );
		
			holder._x = Math.ceil(plus._x + plus._width - 4);
			holder._y = -settingsObj.correctSmallListYPos;
			
			bgObj = new Object();
			bgObj.strokeW = settingsObj.smallListWidth;
			bgObj.stroke2W = settingsObj.smallListWidth - 2;
			bgObj.fillW = settingsObj.smallListWidth - 4;
			
			bgStroke._height = bgStroke2._height = fill._height =  _global.MainComponent.footerFill._height;
			bgStroke._width = bgStroke2._width = fill._width =  0;
			
			
			
			if (smallNode) {
				var currentPos:Number = 10;
				var idx:Number = 0;
				
				for (; smallNode != null; smallNode = smallNode.nextSibling) {
					var currentItem:MovieClip = lst.attachMovie("IDshareSmallItem", "smItem" + idx, lst.getNextHighestDepth());
					currentItem.addEventListener("rolledOverSmall", Proxy.create(this, rolledOverSmall));
					currentItem.addEventListener("rolledOutSmall", Proxy.create(this, rolledOutSmall));
				
					currentItem.setNode(smallNode);
					currentItem._x = currentPos;
					currentPos += Math.ceil(settingsObj.smallButtonsWidth + settingsObj.spaceBetweenSmallButtons);
					
					idx++;
				}
				
				scrl._x = 7;
				scrl._y = Math.ceil(bgStroke._height / 2 - settingsObj.smallButtonsHeight / 2);
				
				mask._height = leftHit._height = bgStroke._height;
				mask._width = fill._width - 12;
				mask._y -= 5;
				mask.cacheAsBitmap = lst.cacheAsBitmap = true;
				lst.setMask(mask);
				leftHit._visible = false;
				leftHit._width = bgObj.fillW - 12;
				totalLstBottomX = Math.ceil(currentPos + 20 - mask._width);
				
			
				if (mask._width < (currentPos + 20)) {
					scrollable = 1;
				}
				else {
						settingsObj.smallListWidth = currentPos + 20
						bgObj = new Object();
						bgObj.strokeW = settingsObj.smallListWidth;
						bgObj.stroke2W = settingsObj.smallListWidth - 2;
						bgObj.fillW = settingsObj.smallListWidth - 4;
						
		
				}
				
				mask._width = 0;
				
			}
			else {
				minus._visible = plus._visible = holder._visible = false;
				minus.enabled = plus.enabled = holder.enabled = false;
				
				plus._y = minus._y = holder._y = 100;
			}
		
			
			scrollerDescription.setSettings(settingsObj, settingsObj);
		}
		else {
			this._visible = false;
		}
		
		
	}
	

	private function rolledOverSmall(obj:Object) {
		scrollerDescription.setSettings(settingsObj, settingsObj);
		scrollerDescription.setNewText(obj.mc.node);
	}
	
	private function rolledOutSmall(obj:Object) {
		scrollerDescription.hide();
	}
	
	public function startScrolling() {
		if (scrollable) {
			clearInterval(myInterval2);
			myInterval2 = setInterval(this, "scrollThis", 30);
		}
	}
	
	private function scrollThis() {
	
		if ((holder._xmouse + 7)> 0 && (holder._xmouse+7) < leftHit._width && holder._ymouse > 0 && holder._ymouse < leftHit._height) {
				var per:Number = Math.ceil((holder._xmouse+7)/ leftHit._width * 100);
				
				if (per < 5) {
					per = 0;
				}
				
				if (per > 97) {
					per = 100;
				}

				
				var actualCurrentX:Number = Math.ceil(totalLstBottomX / 100 * per);
			
				Tweener.addTween(lst, { _x:-actualCurrentX, time:.05*settingsObj.scrollerAccelerationMultiplierForSmallList, transition:"linear" } );
			
		}
	}

	private function openBg() {
		Tweener.addTween(bgStroke, { _width:bgObj.strokeW, time: settingsObj.animationTimeForSmallList, transition: settingsObj.animationTypeForSmallList } );
		Tweener.addTween(bgStroke2, { _width:bgObj.stroke2W, time: settingsObj.animationTimeForSmallList, transition: settingsObj.animationTypeForSmallList } );
		Tweener.addTween(fill, { _width:bgObj.fillW, time: settingsObj.animationTimeForSmallList, transition: settingsObj.animationTypeForSmallList } );
		Tweener.addTween(mask, { _width:bgObj.fillW - 12, time: settingsObj.animationTimeForSmallList, transition: settingsObj.animationTypeForSmallList } );

		startScrolling();
		
		_global.MainComponent.openedShare();
	}
	
	private function closeBg() {
		Tweener.addTween(bgStroke, { _width:0, time: settingsObj.animationTimeCloseForSmallList, transition: settingsObj.animationTypeCloseForSmallList } );
		Tweener.addTween(bgStroke2, { _width:0, time: settingsObj.animationTimeCloseForSmallList, transition: settingsObj.animationTypeCloseForSmallList } );
		Tweener.addTween(fill, { _width:0, time: settingsObj.animationTimeCloseForSmallList, transition: settingsObj.animationTypeCloseForSmallList } );
		Tweener.addTween(mask, { _width:0, time: settingsObj.animationTimeCloseForSmallList, transition: settingsObj.animationTypeCloseForSmallList } );
	
		clearInterval(myInterval2);
		
		_global.MainComponent.closedShare();
	}
	
	public function forceCloseBg() {
		minusOnPress();
	}
	
	private function rolledOverBig(obj:Object) {
		scrollerDescription.setSettings(settingsObj, settingsObj);
		scrollerDescription.setNewText(obj.mc.node);
	}
	
	private function rolledOutBig(obj:Object) {
		scrollerDescription.hide();
	}
	
	
	private function plusOnRollOver() {
		scrollerDescription.setNewText(more);
		Tweener.addTween(plus["over"], { _alpha:100, time: .2, transition: "linear" } );
	}
	
	private function plusOnRollOut() {
		scrollerDescription.hide();
		Tweener.addTween(plus["over"], { _alpha:0, time: .2, transition: "linear" } );
	}
	
	private function plusOnPress() {
		openBg();
		/////
		plusOnRollOut();
		plus.enabled = false;
		
		minus._visible = true;
		minus.enabled = true;
		Tweener.addTween(minus, { _alpha:100, time: .2, transition: "linear"} );
		Tweener.addTween(plus, { _alpha:0, delay:.1, time: .2, transition: "linear", onComplete:Proxy.create(this, disablePlus) } );
		
		
		_global.mp3player.forceClosePlayer()
	}
	
	private function disablePlus() {
		plus._visible = false;
		plus.enabled = false;
	}
	
	private function minusOnRollOver() {
		scrollerDescription.setNewText(less);
		Tweener.addTween(minus["over"], { _alpha:100, time: .2, transition: "linear" } );
	}
	
	private function minusOnRollOut() {
		scrollerDescription.hide();
		Tweener.addTween(minus["over"], { _alpha:0, time: .2, transition: "linear" } );
	}
	
	private function minusOnPress() {
		closeBg()
		//////////
		minusOnRollOut();
		minus.enabled = false;
		plus._visible = true;
		
		Tweener.addTween(plus, { _alpha:100, time: .2, transition: "linear"} );
		Tweener.addTween(minus, { _alpha:0, delay:.1, time: .2, transition: "linear",onComplete:Proxy.create(this, enablePlus) } );
	}
	
	private function enablePlus() {
		minus._visible = false;
		minus.enabled = false;
		
		plus.enabled = true;
	}
}
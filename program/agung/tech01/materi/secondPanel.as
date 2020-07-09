import caurina.transitions.*;
import ascb.util.Proxy;
import agung.utils.UMc;
import agung.utils.UTf;
import agung.utils.UNode;
import agung.utils.UAddr;
import asual.sa.SWFAddress;

class agung.tech01.materi.secondPanel extends MovieClip
{
	private var settingsObj:Object;
	private var node:XMLNode
	private var globalSettings:Object;

	
	private var holder:MovieClip;
		private var lst:MovieClip;
		private var mask:MovieClip;
		
	private var next:MovieClip;
	private var prev:MovieClip;
		
	private var myInterval:Number;
	
	private var currentJump:Number = 0;
	private var totalItems:Number;
	
	public var activated:Boolean = false;
	
	private var thumbScroller:MovieClip;
	
	private var myParent:MovieClip;
	
	public function secondPanel() {
		this._visible = false;
		
		lst = holder["lst"];
		mask = holder["mask"];
		
		lst.setMask(mask);
		
		
		
		next.onRollOver = Proxy.create(this, nextOnRollOver);
		next.onRollOut = Proxy.create(this, nextOnRollOut);
		next.onPress = Proxy.create(this, nextOnPress);
		next.onRelease = Proxy.create(this, nextOnRelease);
		next.onReleaseOutside = Proxy.create(this, nextOnReleaseOutside);
		
		prev.onRollOver = Proxy.create(this, prevOnRollOver);
		prev.onRollOut = Proxy.create(this, prevOnRollOut);
		prev.onPress = Proxy.create(this, prevOnPress);
		prev.onRelease = Proxy.create(this, prevOnRelease);
		prev.onReleaseOutside = Proxy.create(this, prevOnReleaseOutside);
	}
	
	public function setNode(pNode:XMLNode, pGlobalSettings:Object, pThumbScroller:MovieClip, pMyParent:MovieClip){
		globalSettings = pGlobalSettings;
		node = pNode;
		thumbScroller = pThumbScroller;
		myParent = pMyParent;
		
		mask._width = globalSettings.moduleWidth - 60;
		mask._height = globalSettings.moduleHeight;
		
		node = node.firstChild.firstChild.nextSibling.firstChild;
		
		this._x = 30;
		
		var currentPos:Number = 0;
		var idx:Number = 0;
		for (; node != null; node = node.nextSibling) {
			var currentSPItem:MovieClip = lst.attachMovie("IDsecondPanelItem", "secondPanelItem" + idx, lst.getNextHighestDepth());
			currentSPItem._x = currentPos;
			currentSPItem.setNode(node, globalSettings);
			currentPos += mask._width;
			idx++;
		}
		
		totalItems = idx-1;
		
		prev._x = Math.ceil( -prev._width - 1);
		next._x = Math.ceil(mask._width + 1);
		next._y = prev._y = Math.ceil(15);
		
		if (totalItems == 0) {
			next._visible = prev._visible = false;
		}
	}
	
	public function treatAddress() {
		var str:String = UAddr.contract(SWFAddress.getValue());
		var strArray:Array = str.split("/");
		var idx:Number = 0;
		
		if (strArray[4]) {
			var idx:Number = 0;
			while (lst["secondPanelItem" + idx]) {
				
				var actualUrlAddress:String = "/" + strArray[1] + "/" + strArray[2] + "/" + strArray[3] + "/";

				if (lst["secondPanelItem" + idx].urlAddress == ("/" + strArray[3] + "/")) {
					myParent.showSecondPanel(idx);
					goToIdx(idx);
					lst["secondPanelItem" + idx].treatAddress();
					break;
				}
				
				idx++;
			}
		}
	}
	
	
	public function goToIdx(pIdx:Number) {
		currentJump = pIdx;
		var newPos:Number = -Math.ceil((globalSettings.moduleWidth - 60) * pIdx);

		if (activated == true) {
			lst._x = newPos;
			activated = false;
		}
		else {
			Tweener.addTween(lst, { _x:newPos, time:globalSettings.projectScrollAnimationTime, transition:globalSettings.projectScrollAnimationType } );
		}
		
		if (!thumbScroller.thumbArray[currentJump + 1]) {
			nextOnRollOut()
			next.enabled = false;
		}
		else {
			nextOnRollOut()
			next.enabled = true;
		}
		
		if (!thumbScroller.thumbArray[currentJump - 1]) {
			prevOnRollOut()
			prev.enabled = false;
		}
		else {
			prevOnRollOut()
			prev.enabled = true;
		}
		
	}
	
	private function nextOnRollOver() {
		Tweener.addTween(next["over"], { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function nextOnRollOut() {
		Tweener.addTween(next["over"], { _alpha:0, time:.2, transition:"linear" } );
	}
	
	private function nextOnPress() {
		currentJump++;
		thumbScroller.thumbArray[currentJump].onPress();
	}
	
	private function nextOnRelease() {
		nextOnRollOut()
	}
	
	private function nextOnReleaseOutside() {
		nextOnRelease();
	}
	
	
	private function prevOnRollOver() {
		Tweener.addTween(prev["over"], { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function prevOnRollOut() {
		Tweener.addTween(prev["over"], { _alpha:0, time:.2, transition:"linear" } );
	}
	
	private function prevOnPress() {
		currentJump--;
		thumbScroller.thumbArray[currentJump].onPress();
	}
	
	private function prevOnRelease() {
		prevOnRollOut()
	}
	
	private function prevOnReleaseOutside() {
		prevOnRelease()
	}
}
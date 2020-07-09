import caurina.transitions.*;
import ascb.util.Proxy;
import agung.utils.UMc;
import agung.utils.UTf;

class agung.tech01.materi.scrollerBox extends MovieClip
{
	private var settingsObjScroller:Object;
	private var globalSettings:Object;

	public var node:XMLNode;
	
	
	public var holder:MovieClip;
		private var mask:MovieClip;
		private var lst:MovieClip;
		
		private var scrollerDescription:MovieClip;
	
	
	private var init:Number = 1;
	
	private var totalWidth:Number;
	private var currentHolder:MovieClip;
	
	private var currentIdx:Number = -1;
	
	private var lastNode:XMLNode;
	
	public function scrollerBox() {
		this._visible = false;
		mask = holder["mask"];
		lst = holder["lst"];
		
		scrollerDescription = holder["scrollerDescription"];
		
		lst.setMask(mask);
	}
	
	
	public function setDetails(pNode:XMLNode) {
		if (lastNode != pNode) {
			lastNode = pNode;
		
			currentIdx++;
			
			hide(currentHolder);
			
			currentIdx++;
			currentHolder = lst.createEmptyMovieClip("description" + currentIdx, lst.getNextHighestDepth());
			currentHolder._y = Math.round( -mask._height - 50);
			
			currentHolder.attachMovie("IDdetails", "details" + currentIdx, currentHolder.getNextHighestDepth());
			currentHolder["details" + currentIdx].scrollerDescription = scrollerDescription;
			currentHolder["details" + currentIdx].setNode(pNode, globalSettings);
			
			show(currentHolder);
		}
		else {
			show(currentHolder);
			currentHolder["details" + currentIdx].treatAddress();
		}
	}
	
	private function show(pMc:MovieClip ) {
		if (init == 1) {
			pMc._y = 0;
			init = 0;
		}
		else {
			Tweener.addTween(pMc, { _x:0, _y:0, time:globalSettings.detailsShowAnimationTime, transition:globalSettings.detailsShowAnimationType } );
		}
	}
	
	private function hide(pMc:MovieClip) {
		Tweener.addTween(pMc, { _y:mask._height + 50, time:globalSettings.detailsHideAnimationTime, transition:globalSettings.detailsHideAnimationType, onComplete:Proxy.create(this, removeThis, pMc) } );
	}
	
	private function removeThis(pMc:MovieClip) {
		trace(pMc + " removed");
		pMc.removeMovieClip();
	}
	
	public function setSettings(pGlobalSettings:Object) {
		globalSettings = pGlobalSettings;
		
		mask._width = globalSettings.moduleWidth;
		mask._height = globalSettings.moduleHeight;
	
		this._visible = true;
	}
}
import caurina.transitions.*;
import ascb.util.Proxy;
import agung.utils.UMc;
import agung.utils.UTf;

class agung.tech01.blog.popupDetails extends MovieClip
{
	private var settingsObjPopup:Object;
	private var globalSettings:Object;
	private var descriptionSettings:Object;
	private var commentsSettings:Object;
	private var contactSettings:Object;
	
	public var node:XMLNode;
	
	
	public var holder:MovieClip;
	private var mask:MovieClip;
	
	
	private var init:Number = 1;
	
	private var totalWidth:Number;
	private var currentHolder:MovieClip;
	
	private var currentIdx:Number = -1;

	public function popupDetails() {
		this._visible = false;
		
		holder.setMask(mask);
	}
	
	public function setDetails(pType:String) {
		currentIdx++;
		
		hide(currentHolder);
		
		if (pType == "description") {
			currentHolder = holder.createEmptyMovieClip("description" + currentIdx, holder.getNextHighestDepth());
			currentHolder._y = Math.round(-mask._height - 50);
			currentHolder.attachMovie("IDpopupDescriptionBlog", "descr" + currentIdx, currentHolder.getNextHighestDepth());
			currentHolder["descr" + currentIdx].setNode(node, descriptionSettings);
			show(currentHolder);
			return;
		}
		
		if (pType == "comments") {
			currentHolder = holder.createEmptyMovieClip("comments" + currentIdx, holder.getNextHighestDepth());
			currentHolder._y = Math.round(-mask._height - 50);
			currentHolder.attachMovie("IDpopupComments", "comm" + currentIdx, currentHolder.getNextHighestDepth());
			currentHolder["comm" + currentIdx].myParent = this;
			currentHolder["comm" + currentIdx].setNode(node, commentsSettings, globalSettings);
			show(currentHolder);
			return;
		}
		
		if (pType == "contact") {
			currentHolder = holder.createEmptyMovieClip("contact" + currentIdx, holder.getNextHighestDepth());
			currentHolder._y = Math.ceil(-mask._height - 50);
			currentHolder.attachMovie("IDcontactHolder", "contact" + currentIdx, currentHolder.getNextHighestDepth());
			currentHolder["contact" + currentIdx].setNode(node, contactSettings, globalSettings);
			show(currentHolder);
			return;
		}
	}
	

	
	private function show(pMc:MovieClip ) {
		if (init == 1) {
			pMc._y = 0;
			init = 0;
		}
		else {
			Tweener.addTween(pMc, { _x:0, _y:0, time:globalSettings.popupDetailsShowAnimationTime, transition:globalSettings.popupDetailsShowAnimationType, rounded:true } );
		}
	}
	
	private function hide(pMc:MovieClip) {
		Tweener.addTween(pMc, { _y:mask._height + 4, time:globalSettings.popupDetailsHideAnimationTime, transition:globalSettings.popupDetailsHideAnimationType, onComplete:Proxy.create(this, removeThis, pMc) } );
	}
	
	private function removeThis(pMc:MovieClip) {
		pMc.removeMovieClip();
		
	}
	public function setNode(pNode:XMLNode, pSettingsPopup:Object, pGlobalSettings:Object){
		node = pNode;
		settingsObjPopup = pSettingsPopup;
		globalSettings = pGlobalSettings;
		
		totalWidth = Math.round(settingsObjPopup.w);
		
		
		mask._width = totalWidth;
		mask._height = settingsObjPopup.h;
		descriptionSettings = new Object();
		commentsSettings = new Object();
		contactSettings = new Object();
		
		descriptionSettings.w = commentsSettings.w = Math.round(mask._width - 12);
		descriptionSettings.h = commentsSettings.h = contactSettings.h = mask._height;
		contactSettings.w = Math.round(mask._width)
		
		mask._width += 80;
		mask._x = -39;
		mask._height += 36;
		mask._y -= 10;
		
		this._visible = true;
	}
}
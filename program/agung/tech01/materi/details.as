import caurina.transitions.*;
import ascb.util.Proxy;
import agung.utils.UMc;
import agung.utils.UTf;
import agung.utils.UNode;
import agung.utils.UAddr;
import asual.sa.SWFAddress;

/**
 * this class handles all the module's variations according to the .xml settings
 */
class agung.tech01.materi.details extends MovieClip
{
	private var settingsObjScroller:Object;
	private var node:XMLNode
	private var globalSettings:Object;

	
	private var holder:MovieClip;
	
	private var thumbScroller:MovieClip;
	private var theDescription:MovieClip;
	public var scrollerDescription:MovieClip;
	
	private var secondPanel:MovieClip;
	
	private var line:MovieClip;
	
	public function details() {
		this._visible = false;
		thumbScroller = holder["thumbScroller"];
		theDescription = holder["theDescription"];
		secondPanel = holder["secondPanel"];
		
		line = holder["line"];
		line._alpha = 0;
		
	}
	
	/**
	 * the xml node and settings are being processed in this function plus the cont() function
	 * @param	pNode
	 * @param	pGlobalSettings
	 * @param	pSettingsObjScroller
	 */
	public function setNode(pNode, pGlobalSettings, pSettingsObjScroller){
		globalSettings = pGlobalSettings;
		node = pNode;
		
		line._width = globalSettings.moduleWidth;
		
		onEnterFrame = Proxy.create(this, cont);
		
		this._visible = true;
	}
	
	private function cont() {
	
		var thumbScrollerHeight:Number = 0;
		
		if (node.firstChild.attributes.toggleProjectsDisplay == 0) {
			thumbScroller._visible = false;
			theDescription._y = 0;
			scrollerDescription.hide();
		}
		else {
			var tSNode:XMLNode = node.firstChild.firstChild
			var tSSettings:Object = UNode.nodeToObj(tSNode);
			
			scrollerDescription.setSettings(globalSettings, tSSettings);
			if (tSSettings.toggleTooltip == 0) {
				scrollerDescription.hide();
			}
			
			thumbScroller.scrollerDescription = scrollerDescription;
			thumbScroller.addEventListener("thumbClicked", Proxy.create(this, thumbClicked));
			thumbScroller.setNode(node, globalSettings);
			thumbScrollerHeight = thumbScroller.totalHeight
			theDescription._y = thumbScrollerHeight + 40;
		}
		
		if (node.firstChild.nextSibling.attributes.toggleDescription == 0) {
			theDescription._visible = false;
		}
		else {
			if (thumbScrollerHeight != 0) {
				line._y = Math.ceil(theDescription._y - 20);
				Tweener.addTween(line, { _alpha:100, delay:.2, time:globalSettings.detailsShowAnimationTime, transition:"linear" } );
			}
			else {
				line._visible = false;
			}
			
			theDescription.setNode(node, globalSettings, thumbScrollerHeight);
		}
		
		
		secondPanel._y = -Math.ceil(globalSettings.moduleHeight);
		
		secondPanel.setNode(node, globalSettings, thumbScroller, this);
		
		treatAddress();
		
		delete this.onEnterFrame;
	}
	
	public function treatAddress() {
		
		if (node.firstChild.attributes.toggleProjectsDisplay != 0) {
			thumbScroller.treatAddress();
		}
		
		var str:String = UAddr.contract(SWFAddress.getValue());
		var strArray:Array = str.split("/");
		var idx:Number = 0;
		
		if (strArray[3]) {
			if (strArray[4]) {
				
				secondPanel.treatAddress();
			}
			else {
				_global.portfolioPopupHandler.cancelPopup()
			}
		}
		else {
			hideSecondPanel();
		}
		
		
	}
	
	private function thumbClicked(obj:Object) {
		showSecondPanel(obj.mc.idx);
	}
	
	public function showSecondPanel(objIdx:Number) {
		
		if (holder._y != Math.ceil(globalSettings.moduleHeight)) {
			secondPanel.activated = true;
			Tweener.addTween(holder, { _y:Math.ceil(globalSettings.moduleHeight), time:globalSettings.projectDetailsShowAnimationTime, transition:globalSettings.projectDetailsShowAnimationType } );
		}
		else {
			secondPanel.activated = false;
		}
		
			
		secondPanel._visible = true;
		secondPanel.goToIdx(objIdx);
	}
	
	public function hideSecondPanel() {
		_global.portfolioPopupHandler.cancelPopup()
		if (holder._y != 0) {
			secondPanel.activated = false;
			Tweener.addTween(holder, { _y:0, time:globalSettings.projectDetailsHideAnimationTime, transition:globalSettings.projectDetailsHideAnimationType, onComplete:Proxy.create(this, invisSecondPanel) } );
		}
		
	}
	
	private function invisSecondPanel() {
		secondPanel._visible = false;
	}
}
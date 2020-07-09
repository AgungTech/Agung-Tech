import caurina.transitions.*;
import ascb.util.Proxy;
import agung.utils.UMc;
import agung.utils.UTf;
import agung.utils.UNode;

/**
 * this function sets up the details for the panel and makes
 * the necessary adjustments taking into consideration
 * the settings and the multiple variations
 */
class agung.tech01.tentang_tempat.details extends MovieClip
{
	private var settingsObjScroller:Object;
	private var node:XMLNode
	private var globalSettings:Object;

	
	private var holder:MovieClip;
	
	private var thumbScroller:MovieClip;
	private var theDescription:MovieClip;
	public var scrollerDescription:MovieClip;
	
	private var line:MovieClip;
	
	public function details() {
		this._visible = false;
		thumbScroller = holder["thumbScroller"];
		theDescription = holder["theDescription"];
		
		line = holder["line"];
		line._alpha = 0;
		
	}
	
	public function setNode(pNode, pGlobalSettings, pSettingsObjScroller){
		globalSettings = pGlobalSettings;
		node = pNode;
		
		line._width = globalSettings.moduleWidth;
		
		onEnterFrame = Proxy.create(this, cont)
		
		this._visible = true;
	}
	
	private function cont() {
	
		
		
		var thumbScrollerHeight:Number = 0;
		
		if (node.firstChild.attributes.toggleProductsDisplay == 0) {
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
		
		delete this.onEnterFrame;
	}
}
import caurina.transitions.*;
import ascb.util.Proxy;
import agung.utils.UMc;
import agung.utils.UTf;
import agung.utils.UNode;
/**
 * This class handles the list for the tentang_orang module
 */
class agung.tech01.tentang_orang.theList extends MovieClip
{
	private var settingsObjScroller:Object;
	private var node:XMLNode
	private var globalSettings:Object;

	private var holder:MovieClip;
	public var totalHeight:Number;
	
	private var thumbScroller:MovieClip;
	private var theDescription:MovieClip;
	private var line:MovieClip;
	
	public var myParent:MovieClip;
	
	public function theList() {
		this._visible = line._visible = false;
		
	}
	
	/**
	 * Here, the node, global settings, counter and buttons array is being sent
	 * @param	pNode
	 * @param	pGlobalSettings
	 * @param	crIdx
	 * @param	crAr
	 */
	public function setNode(pNode, pGlobalSettings, crIdx:Number, crAr:Array){
		globalSettings = pGlobalSettings;
		node = pNode;
			
		onEnterFrame = Proxy.create(this, cont)
		
		if ((crIdx == 0) && (crAr.length == 1)) {
			line._visible = false;
		}
		else {
			line._visible = true;
		}
		this._visible = true;
	}
	
	private function cont() {
		delete this.onEnterFrame;
	
		
		node = node;
		settingsObjScroller = UNode.nodeToObj(node.firstChild);
		
		thumbScroller.myParent = this;
		thumbScroller.setNode(node, globalSettings, settingsObjScroller);
		
		if (settingsObjScroller.toggleImageScroller == 1) {
			theDescription._x = Math.ceil(thumbScroller.mask._width + 12);
		}
		else {
			thumbScroller._visible = false;
			theDescription._x = 0;
		}
		
		
		if (settingsObjScroller.toggleDescription == 1) {
			theDescription.setNode(node, globalSettings, settingsObjScroller);
		}
		else {
			theDescription._visible = false;
			if (settingsObjScroller.centerScrollerIfDescriptionDisabled == 1) {
				thumbScroller._x = Math.ceil(globalSettings.moduleWidth / 2 - thumbScroller.mask._width / 2);
			}
		}
		
		totalHeight = Math.ceil(Math.max(thumbScroller.mask._height, theDescription._height) + 12 + 12);
		holder._y = 12;
		
		if ((settingsObjScroller.toggleImageScroller == 1)&&(settingsObjScroller.toggleDescription == 1)) {
			thumbScroller._y = Math.ceil(totalHeight / 2 - thumbScroller.mask._height / 2 - 12);
		}
		
		line._y = Math.ceil(totalHeight - line._height);
		line._width = globalSettings.moduleWidth
		
		thumbScroller._y += 12;
		myParent.createNext(totalHeight);
	}
	
	public function startLoad() {
		if (settingsObjScroller.toggleImageScroller == 1) {
			thumbScroller.thumbLoaded();
		}
		else {
			allThumbsLoaded();
		}
	}
	
	public function allThumbsLoaded() {
		myParent.loadNextSet();
	}
}
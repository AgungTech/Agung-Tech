import caurina.transitions.*;
import ascb.util.Proxy;
import agung.utils.UMc;
import agung.utils.UTf;

/**
 * This class handles the description inside the tentang_orang module
 */
class agung.tech01.tentang_orang.description extends MovieClip
{
	private var mainSettings:Object;
	private var settingsObj:Object;
	public var node:XMLNode;

	public var holder:MovieClip;
		private var lst:MovieClip;

	public function description() {
		this._visible = false;

		lst = holder["lst"];
	
		UTf.initTextArea(lst["txt"], true);
	}
	
	
	/**
	 * here, the node, settings and main settings are being sent for later use in another class
	 * @param	pNode
	 * @param	pMainSettings
	 * @param	pSettingsObj
	 */
	public function setNode(pNode:XMLNode, pMainSettings:Object, pSettingsObj:Number){
		node = pNode;
		mainSettings = pMainSettings;
		settingsObj = pSettingsObj;
		
		lst["txt"]._width = Math.ceil(mainSettings.moduleWidth - this._x - 14);
		
		lst["txt"].htmlText = node.firstChild.nextSibling.lastChild.nodeValue;
	
		this._visible = true;
	}

}
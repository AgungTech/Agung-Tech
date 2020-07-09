import caurina.transitions.*;
import ascb.util.Proxy;
import agung.utils.UMc;
import agung.utils.UTf;
import agung.utils.UNode;
import asual.sa.SWFAddress;
import agung.utils.UAddr;

class agung.tech01.penjualan.details extends MovieClip
{
	private var settingsObjScroller:Object;
	private var node:XMLNode
	private var globalSettings:Object;

	
	private var holder:MovieClip;
	
	private var thumbScroller:MovieClip;
	
	public var scrollerDescription:MovieClip;
	
	private var line:MovieClip;
	
	public function details() {
		this._visible = false;
		thumbScroller = holder["thumbScroller"];
		
	}
	
	public function setNode(pNode, pGlobalSettings, pSettingsObjScroller){
		globalSettings = pGlobalSettings;
		node = pNode;
		
		line._width = globalSettings.moduleWidth;
		
		onEnterFrame = Proxy.create(this, cont)
		
		this._visible = true;
	}
	
	private function cont() {
		delete this.onEnterFrame;
			
		thumbScroller.setNode(node, globalSettings);
	}
	
	public function treatAddress() {
		thumbScroller.treatAddress();
	}
}
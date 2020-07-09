import caurina.transitions.*;
import ascb.util.Proxy;
import agung.utils.UMc;
import agung.utils.UTf;
import agung.utils.UNode;
import agung.utils.UAddr;
import asual.sa.SWFAddress;

class agung.tech01.materi.secondPanelItem extends MovieClip
{
	private var settingsObj:Object;
	private var node:XMLNode
	private var globalSettings:Object;

	
	private var holder:MovieClip;
		private var projectThumbScroller:MovieClip;
		private var projectDescription:MovieClip;
		
	public var urlAddress:String;
	
	public function secondPanelItem() {
		this._visible = false;
		
		projectThumbScroller = holder["projectThumbScroller"];
		projectDescription = holder["projectDescription"];
		
	}
	
	public function setNode(pNode, pGlobalSettings){
		globalSettings = pGlobalSettings;
		node = pNode;
		urlAddress = UAddr.contract(node.attributes.browserUrl) + "/";
		
		node = node.firstChild.nextSibling;
		
	
		onEnterFrame = Proxy.create(this, cont);
	
	}
	
	private function cont() {
		delete this.onEnterFrame;
		
		projectDescription.setNode(node, globalSettings);
		
		projectThumbScroller.setNode(node, globalSettings, projectDescription);
		
		treatAddress();
		
		this._visible = true;
	}
	
	public function treatAddress() {
		var str:String = UAddr.contract(SWFAddress.getValue());
		var strArray:Array = str.split("/");
		
		if (strArray[4]) {
			projectThumbScroller.treatAddress();
		}
	}
}
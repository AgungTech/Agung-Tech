import caurina.transitions.*;
import ascb.util.Proxy;
import agung.utils.UMc;
import agung.utils.UTf;
import agung.utils.UNode;
import asual.sa.SWFAddress;
import agung.utils.UAddr;
import mx.events.EventDispatcher;

class agung.tech01.blog.details extends MovieClip
{
	private var settingsObjScroller:Object;
	private var node:XMLNode
	private var globalSettings:Object;

	
	private var holder:MovieClip;
	
	private var scrollerBox:MovieClip;
	
	public var scrollerDescription:MovieClip;
	
	private var line:MovieClip;
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	public function details() {
		EventDispatcher.initialize(this);
		this._visible = false;
		
	}
	
	public function setNode(pNode, pGlobalSettings, pSettingsObjScroller){
		globalSettings = pGlobalSettings;
		node = pNode.firstChild;
		
		
		onEnterFrame = Proxy.create(this, cont)
		
		this._visible = true;
	}
	
	private function cont() {
		delete this.onEnterFrame;
		
		scrollerBox = holder["scrollerBox"];
		
		scrollerBox.addEventListener("itemClicked", Proxy.create(this, itemClicked));
		scrollerBox.addEventListener("closePopupFull", Proxy.create(this, closePopupFull));
		scrollerBox.setNode(node, globalSettings);
	}
	
	private function closePopupFull(obj:Object) {
		dispatchEvent( { target:this, type:"closePopupFull", mc:obj.mc } );
	}
	private function itemClicked(obj:Object) {
		dispatchEvent( { target:this, type:"itemClicked", mc:obj.mc } );
	}
	public function treatAddress() {
		scrollerBox.treatAddress();
	}
}
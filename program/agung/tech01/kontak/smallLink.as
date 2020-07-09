import ascb.util.Proxy;
import caurina.transitions.*;
import mx.data.types.Obj;
import mx.data.types.Str;
import agung.utils.UTf;

import mx.events.EventDispatcher;
import asual.sa.SWFAddress;
import agung.utils.UXml;
import agung.utils.UNode;

class agung.tech01.kontak.smallLink extends MovieClip 
{
	private var caption:MovieClip;
	private var link:MovieClip;
	
	private var node:XMLNode;
		
	public var maxW:Number;
	
	public function smallLink() {
		this._visible = false;
	
		this._alpha = 90;
		
		caption["txt"].autoSize = true;
		caption["txt"].wordWrap = false;
		
		UTf.initTextArea(link["txt"]);
		link["txt"].wordWrap = false;
		link["txt"].autoSize = true;
	}
	
	/**
	 * @param	pNode
	 */
	private function setNode(pNode:XMLNode) {
		node = pNode;
		
		caption["txt"].text = node.attributes.title;
		var my_fmt:TextFormat = new TextFormat();
		my_fmt.bold = true;
		caption["txt"].setNewTextFormat(my_fmt);


	
		link["txt"].htmlText = node.firstChild.nodeValue;
		
		maxW = Math.ceil(caption["txt"].textWidth + 14);
		
		if ((!node.attributes.url) || (node.attributes.url == "") || (node.attributes.url == " ")) {
			this.enabled = false;
		}
		
		this._visible = true;
	}
	
	public function arrange(pM:Number) {
		link._x = Math.ceil(pM);
	}

	private function onRollOver() {
		this._alpha = 100;
	}
	
	private function onRollOut() {
		this._alpha = 90;
	}
	
	private function onPress() {
		onRollOut()
		getURL(node.attributes.url, node.attributes.target);
	}
}
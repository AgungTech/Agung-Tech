
import caurina.transitions.*;
import ascb.util.Proxy;
import agung.utils.UMc;
import agung.utils.UTf;

class agung.tech01.blog.commentItem extends MovieClip
{
	private var settingsObj:Object;
	private var settingsComments:Object;
	public var node:XMLNode;

	private var holder:MovieClip;
	private var line:MovieClip;
	private var refBg:MovieClip;
	
	
	private var bg:MovieClip;
	public var totalHeight:Number;
	
	public function commentItem() {
		this._visible = false;
		
		UTf.initTextArea(holder["txt"], true);
		holder["author"].autoSize = holder["onn"].autoSize =  true;
	}
	
	
	public function setNode(pNode:XMLNode, pSettingsComments:Object, pGlobalSettings:Object){
		node = pNode;

	
		holder._y = 10;
		
		holder["author"].text = node.attributes.author;
		holder["onn"].text = pGlobalSettings.dateCaption + "   " + node.attributes.date;
		
		holder["onn"]._y = Math.round(holder["author"].textHeight);
		
		holder["txt"]._width = pSettingsComments.w;
		holder["txt"].htmlText = node.firstChild.nodeValue;
		
		holder["txt"]._y = Math.round(holder["onn"]._y + holder["onn"].textHeight + 4);
		
		refBg._width = pSettingsComments.w;
		refBg._height = totalHeight = Math.ceil(holder._height + 23);
		
		line._width = refBg._width;
		
		line._y = Math.ceil(refBg._height - line._height);
		
		this._visible = true;
	}

}
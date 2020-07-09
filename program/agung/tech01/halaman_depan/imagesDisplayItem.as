import caurina.transitions.*;
import ascb.util.Proxy;
import agung.utils.UMc;
import agung.utils.UTf;

class agung.tech01.halaman_depan.imagesDisplayItem extends MovieClip
{
	private var settingsObj:Object;

	private var oneButtonWidth:Number;
	
	public var node:XMLNode;
	
	private var holder:MovieClip;
		private var normal:MovieClip;
		private var normalTitle:MovieClip;
		private var normalArrow:MovieClip
	
		private var over:MovieClip;
		private var overTitle:MovieClip;
		private var overArrow:MovieClip;
		private var bgOver:MovieClip;
		
		private var refBg:MovieClip;
		
	public var totalHeight:Number;
	
	private var defArrowX:Number;
	
	public function imagesDisplayItem() {
		this._visible = false;

			
		normal = holder["normal"];
		normalTitle = normal["title"];
		normalArrow = normal["arrow"];
		
		over = holder["over"];
		over._alpha = 0;
		overTitle = over["title"];
		overArrow = over["arrow"];
		bgOver = over["bg"];
		
		refBg = holder["refBg"];
		
		UTf.initTextArea(normalTitle["txt"], true);
		UTf.initTextArea(overTitle["txt"], true);
		
	}
			
	/**
	 * @param	pNode
	 * @param	pSettings
	 * @param	pOneButtonWidth
	 */
	public function setNode(pNode:XMLNode, pSettings:Object, pOneButtonWidth:Number) {
		node = pNode;
		settingsObj = pSettings;
		oneButtonWidth = pOneButtonWidth;
	
		normal._x = over._x = 8;
		normal._y = over._y = 4;
		
		bgOver._x = -8
		bgOver._y = -4;
		
		normalTitle._x = overTitle._x = 10;
		normalTitle._y = overTitle._y = 4;
		
		normalArrow._y = overArrow._y = Math.round(5+ 8 + normalTitle._y);
		
		normalTitle["txt"]._width = overTitle["txt"]._width = Math.round(oneButtonWidth - 8 - normalArrow._width - 10 - 8);
		 
		normalTitle["txt"].htmlText = overTitle["txt"].htmlText = node.firstChild.nodeValue;
		
		refBg._width = oneButtonWidth;
		refBg._height = totalHeight = Math.ceil(6 + normalTitle["txt"].textHeight + 6);
		
		bgOver._width = Math.round(refBg._width);
		bgOver._height = Math.round(refBg._height + 8);
		
		if (node.attributes.toggleLaunchUrl == 0) {
			this.useHandCursor = false;
		}
		
		if (settingsObj.enableOverActionsOnButtons == 0) {
			this.useHandCursor = false;
		}
		
		defArrowX = normalArrow._x;
		
		this._visible = true;
	}
	
	private function onRollOver() {
		if (settingsObj.enableOverActionsOnButtons == 1) {
			Tweener.addTween(over, { _alpha:100, time:.2, transition:"linear" } );
			if (_global.whitePresent) {
				Tweener.addTween(normalArrow, { _x:defArrowX + 3, time:.2, transition:"linear" } );
				Tweener.addTween(overArrow, { _x:defArrowX+3, time:.2, transition:"linear" } );
			}
		}
		
	}
	
	private function onRollOut() {
		if (settingsObj.enableOverActionsOnButtons == 1) {
			Tweener.addTween(over, { _alpha:0, time:.2, transition:"linear" } );
			
			if (_global.whitePresent) {
				Tweener.addTween(normalArrow, { _x:defArrowX, time:.2, transition:"linear" } );
				Tweener.addTween(overArrow, { _x:defArrowX, time:.2, transition:"linear" } );
			}
		}
	}
	
	private function onPress() {
		if (settingsObj.enableOverActionsOnButtons == 1) {
				if (node.attributes.toggleLaunchUrl == 1) {
					getURL(node.attributes.url, node.attributes.target);
				}
		}
		
	}
	
	private function onRelease() {
		onRollOut();
	}
	
	private function onReleaseOutside() {
		onRelease();
	}
	
}
import caurina.transitions.*;
import ascb.util.Proxy;

/**
 * This class handles the module title
 * The title is common for all classes and it will adjust accordingly to each module's settings
 */
class agung.tech01.main_l.moduleTitle extends MovieClip
{
	
	private var settingsObj:Object;
	private var currentModuleSettings:Object;
	private var currentModuleSecondSettings:Object;
	
	private var scrollerBoxTotalWidth:Number = 0;
	
	private var bg:MovieClip
	private var title:MovieClip;
	private var mask:MovieClip;
	
	private var currentX:Number = 0;
	private var correctX:Number = 0;
	
	private var newWidth:Number = 0;
	
	private var lastText:MovieClip;
	private var textIdx:Number = -1;
	
	public function moduleTitle() {
		this._visible = false;
		this._y = 16;
		
		title._y = 5;
		title.setMask(mask);
	}
	
	public function setNewText(pSettingsObj:Object, pCurrentModuleSettings:Object, pCurrentModuleSecondSettings:Object) {
		settingsObj = pSettingsObj
		currentModuleSettings = pCurrentModuleSettings;
		currentModuleSecondSettings = pCurrentModuleSecondSettings;
		
		newWidth = currentModuleSettings.moduleWidth;
		
	
										
		if (currentModuleSecondSettings.enableScrollerBox == 1) {
			scrollerBoxTotalWidth = Math.round((currentModuleSecondSettings.thumbWidth + 22) * currentModuleSecondSettings.horizontalNumberOfItems
										+ currentModuleSecondSettings.horizontalSpace * (currentModuleSecondSettings.horizontalNumberOfItems - 1) + 30);
			correctX = 26
		}
		else {
			scrollerBoxTotalWidth = correctX = 0;
			
		}
		
		Tweener.addTween(bg, { _width:Math.round(newWidth - scrollerBoxTotalWidth), time: settingsObj.moduleShowAnimationTime, transition: settingsObj.moduleShowAnimationType } );
		Tweener.addTween(mask, { _width:Math.round(newWidth - scrollerBoxTotalWidth), time: settingsObj.moduleShowAnimationTime, transition: settingsObj.moduleShowAnimationType } );
		
		position();
		
		
		Tweener.addTween(lastText, { _y:-mask._width - 20, time: settingsObj.moduleShowAnimationTime, transition: settingsObj.moduleShowAnimationType, onComplete:Proxy.create(this, removeLastText, lastText) } );
		
		textIdx++;
	
		lastText = title["a"].duplicateMovieClip("textHolder" + textIdx, textIdx);
		lastText._alpha  = 0 ;
		lastText._x = mask._width - 100;
			
		lastText["txt"].autoSize = true;
		lastText["txt"].wordWrap = false;
		
		if (currentModuleSettings.moduleMainTitle) {
			lastText["txt"].text = currentModuleSettings.moduleMainTitle;
			Tweener.addTween(this, { _alpha:100,  time: settingsObj.moduleShowAnimationTime + 0.2, transition: settingsObj.moduleShowAnimationType, rounded:true } );
		}
		else {
			Tweener.addTween(this, { _alpha:0,  time: settingsObj.moduleShowAnimationTime + 0.2, transition: settingsObj.moduleShowAnimationType, rounded:true } );
		}
		
			
			
		Tweener.addTween(lastText, { _x:10,_alpha:100,  time: settingsObj.moduleShowAnimationTime + 0.2, transition: settingsObj.moduleShowAnimationType, rounded:true } );
		
		this._visible = true;
	}
	
	private function removeLastText(pLast:MovieClip) {
		pLast.removeMovieClip();
	}
	
	public function position() {
		currentX = _global.moduleXPos;
			
		Tweener.addTween(this, { _x:Math.round(currentX + scrollerBoxTotalWidth + correctX), time: settingsObj.moduleShowAnimationTime, transition: settingsObj.moduleShowAnimationType } );
	}
	
}
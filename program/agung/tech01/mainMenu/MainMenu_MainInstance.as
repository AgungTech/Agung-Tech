import ascb.util.Proxy;
import caurina.transitions.*;
import mx.data.types.Obj;
import mx.data.types.Str;
import agung.utils.UNode;


import mx.events.EventDispatcher;
import asual.sa.SWFAddress;
import agung.utils.UAddr;

/**
 * This class is very important because it directly handles all modules
 * and all swf address behavior for the template
 * The first level menu is created here
 * The second level menu actions are also handled in this class
 */
class agung.tech01.mainMenu.MainMenu_MainInstance extends MovieClip 
{
	private var theXml:XML;	
	private var node:XMLNode;
	private var settingsObj:Object;
	public var totalWidth:Number;
	
	private var holder:MovieClip;
	private var bg:MovieClip;
	private var moveBg:MovieClip;
	
	private var newBgWidth:Number;
	private var origX:Number;
	
	private var activatedButtons:Object;
	
	private var firstLoad:Number = 1;
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	private var firstLevelButtons:Array;
	
	private var firstLevelArray:Array;
	private var secondLevelArray:Array;
	
	private var defWBgOver:Number;
	
	private var universH:Number;
	
	public function MainMenu_MainInstance() {
		EventDispatcher.initialize(this);
		
		moveBg._alpha = 0;
		
		activatedButtons = new Object();
		activatedButtons.firstLevel = undefined;
		activatedButtons.secondLevel = undefined;
		
		_global.mainMenuVisibleWidth = 0;
		
		this._visible = false;
	}
	

	/**
	 * the main node for the menu is being set here
	 * @param	pNode
	 */
	public function setNode(pNode:XMLNode)
	{
		node = pNode;
		
		node = node.firstChild
		settingsObj = UNode.nodeToObj(node);
		
		node = node.nextSibling.firstChild;
		
		defWBgOver = moveBg["centers"]._width
		var currentPos:Number = 0;
		var idx:Number = 0;
		
		firstLevelArray = new Array();
		
		for (; node != null; node = node.nextSibling) {
			var but:MovieClip = holder.attachMovie("IDFirstLevelButton", "FirstLevelButton_" + idx, holder.getNextHighestDepth());
			
			but.addEventListener("FirstLevelButtonPressed", Proxy.create(this, FirstLevelButtonPressed));
			but.addEventListener("overFirstLevelButton", Proxy.create(this, overFirstLevelButton));
			but.addEventListener("outFirstLevelButton", Proxy.create(this, outFirstLevelButton));
			but.addEventListener("SecondLevelButtonPressed", Proxy.create(this, SecondLevelButtonPressed));
			
			but.parentMC = this;
			but._x = currentPos;
			but.idx = idx;
			but.setNode(node, settingsObj);
			if (node.attributes.hiddenModule != 1) {
				currentPos += but.totalWidth;
			}
			else { 
				but._visible = false;
				but._alpha = 0;
			}
			
			
			firstLevelArray.push(but);
			
			if (idx == 0) {
				universH = but.refBg._height;
			}
			idx++;
		}
		
		_global.mainMenuVisibleWidth = currentPos;
		
		var idx:Number = 0;
		secondLevelArray = new Array();
		while (holder["FirstLevelButton_" + idx]) {
			var currentSubMenu:MovieClip = holder["FirstLevelButton_" + idx].subMenu;
			if (currentSubMenu) {
				var i:Number = 0;
				while (currentSubMenu.holder["lst"]["SecondLevelButton_" + i]) {
					secondLevelArray.push(currentSubMenu.holder["lst"]["SecondLevelButton_" + i]);
					i++;
				}
			}
			idx++;
		}
		
		bg._width = totalWidth  = currentPos + 2;
		bg._height = but._height + 2;
	
		loadStageResize();
		
		initSwfAddressHandler();
		
		this._visible = true;
	}
	
	/**
	 * this function will properly calculate and move the background under the menu
	 */
	public function moveTheBg(theMc:MovieClip) {
		
		
		if (!_global.whitePresent) {
			Tweener.addTween(moveBg["inside"], { _width:Math.ceil(theMc.refBg._width), 
											_height:Math.ceil(universH), 
											time: _global.globalSettingsObj.mainMenuMovingBgAnimationTime, 
											transition: _global.globalSettingsObj.mainMenuMovingBgAnimationType } );
		
			var newWCen:Number = Math.ceil(moveBg["centers"]._width);
			var dec:Number = 0;
			
			if (defWBgOver > theMc.refBg._width) {
				newWCen = theMc.refBg._width - 26;
				dec = -0.5;
			}
			else {
				newWCen = defWBgOver;
			}
												
			Tweener.addTween(moveBg["centers"], { _x:Math.ceil(theMc.refBg._width / 2 - newWCen / 2), 
												  _width:newWCen,
												time: _global.globalSettingsObj.mainMenuMovingBgAnimationTime, 
												transition: _global.globalSettingsObj.mainMenuMovingBgAnimationType } );
			
										
		//	Tweener.addTween(moveBg["centers"]["down"], {_y:Math.ceil(universH - moveBg["centers"]._height + 9 + dec), 
			//									time: _global.globalSettingsObj.mainMenuMovingBgAnimationTime, 
			//									transition: _global.globalSettingsObj.mainMenuMovingBgAnimationType } );
												
												
		}
		else {
			Tweener.addTween(moveBg["bg"], { _width:Math.ceil(theMc.refBg._width), 
											_height:Math.ceil(theMc.refBg._height), 
											time: _global.globalSettingsObj.mainMenuMovingBgAnimationTime, 
											transition: _global.globalSettingsObj.mainMenuMovingBgAnimationType } );
			Tweener.addTween(moveBg["arrow"], { _x:Math.ceil(theMc.refBg._width/2-moveBg["arrow"]._width/2), 
											_y:Math.ceil(theMc.refBg._height), 
											time: _global.globalSettingsObj.mainMenuMovingBgAnimationTime, 
											transition: _global.globalSettingsObj.mainMenuMovingBgAnimationType } );
		}
		
		
		Tweener.addTween(moveBg, { _alpha:theMc._alpha, _x:Math.round(theMc._x), time: _global.globalSettingsObj.mainMenuMovingBgAnimationTime, transition: _global.globalSettingsObj.mainMenuMovingBgAnimationType } );
		
	

	}
	private function FirstLevelButtonPressed(pObj:Object) {
		if (activatedButtons.firstLevel != pObj.mc) {
			if (_global.moduleLoadingState == 0) {
				
				
			
				activatedButtons.secondLevel.off();
				activatedButtons.secondLevel = undefined;
	
				
			
				var id:Number = 0;
				while (holder["FirstLevelButton_" + id]) {
					if (holder["FirstLevelButton_" + id] != pObj.mc) {
						holder["FirstLevelButton_" + id].subMenuReset();
					}
					id++
					
				}
				
				activatedButtons.firstLevel.subMenuReset();
				activatedButtons.firstLevel = pObj.mc;
				activatedButtons.firstLevel.blockActivated();
				moveTheBg(pObj.mc);
				dispatchEvent( { target:this, type:"buttonPressed", mc:pObj.mc } );
				
				
			}
			
		}
		else {
			moveTheBg(pObj.mc);
			dispatchEvent( { target:this, type:"buttonPressedTheSame", mc:pObj.mc } );
			
			
		}
	}
	
	private function SecondLevelButtonPressed(pObj:Object) {	
		if (activatedButtons.secondLevel != pObj.mc) {
			if (_global.moduleLoadingState == 0) {
				
				activatedButtons.secondLevel.off();
				activatedButtons.secondLevel = pObj.mc;
				activatedButtons.secondLevel.onn();
				
				var id:Number = 0;
				while (holder["FirstLevelButton_" + id]) {
					if (holder["FirstLevelButton_" + id] != pObj.mc.mcParent) {
						holder["FirstLevelButton_" + id].subMenuReset();
					}
					id++
					
				}
			
			
					activatedButtons.firstLevel.subMenuReset();
					activatedButtons.firstLevel = pObj.mc.mcParent;
					activatedButtons.firstLevel.blockActivated();
					trace(activatedButtons.firstLevel + " m,enu")
				moveTheBg(pObj.mc.mcParent)
				dispatchEvent( { target:this, type:"buttonPressed", mc:pObj.mc } );
				
				
			}
			
		}
		else {
			moveTheBg(pObj.mc.mcParent)
			dispatchEvent( { target:this, type:"buttonPressedTheSame", mc:pObj.mc } );
			
			
		}
		
		
	}
	
	public function initSwfAddressHandler() {
		SWFAddress.setHistory(true);
		SWFAddress.setStrict(true);
		
		SWFAddress.onChange = Proxy.create(this, swfAddressOnChangeEvent);
	}
	
	private function swfAddressOnChangeEvent() {
		var str:String = UAddr.contract(SWFAddress.getValue());
		var strArray:Array = str.split("/");
	
		if (strArray[1]) {
			var i:Number = 0;
			var launched:Boolean = false;
			while (firstLevelArray[i]) {
				var actualUrlAddress:Array = firstLevelArray[i].urlAddress.split("/");
				if (strArray[1] == actualUrlAddress[1]) {
					firstLevelArray[i].dispatchMc();
					launched = true;
					break;
				}
				i++;
			}
			
			if (!launched) {
				activatedButtons.firstLevel = undefined;
				var i:Number = 0;
				while (secondLevelArray[i]) {
					var actualUrlAddress:Array = secondLevelArray[i].urlAddress.split("/");
					if (strArray[1] == actualUrlAddress[1]) {
						secondLevelArray[i].dispatchMc();
						break;
					}
					i++;
				}
			}
		}
		else {
			var i:Number = 0;
			var launched:Boolean = false;
			while (firstLevelArray[i]) {
				if ((!firstLevelArray[i].subMenu) && (firstLevelArray[i].node.attributes.externalLink == 0) && (firstLevelArray[i].node.attributes.hiddenModule != 1)) {
					firstLevelArray[i].ponRelease();
					launched = true;
					break;
				}
				i++;
			}
			
			if (!launched) {
				var i:Number = 0;
				while (secondLevelArray[i]) {
					if (secondLevelArray[i].node.attributes.externalLink == 0){
						secondLevelArray[i].onRelease();
						break;
					}
					i++;
				}
			}
			
		}
	}
	
	private function overFirstLevelButton(pObj:Object)
	{
		var idx:Number = 0;
		var cB:MovieClip = firstLevelArray[idx];
		
		while (cB) {
			if (cB != pObj.mc) {
				cB.cancelSubMenu();
				cB.showNormalState();
			}
			idx++;
			cB = firstLevelArray[idx];
		}
	}
	
	
	private function outFirstLevelButton(pObj:Object){
		
	}
	
	
	
	public function overStateMainButton() {
		
	}
	
	
	
	
	/**
	 * this function will place the menu taking into consideration the settings from the xml file
	 * @param	pW
	 * @param	pH
	 */
	private function resize(pW:Number, pH:Number) {
		var openAnimTime:Number = settingsObj.openAnimTime;
		var openAnimType:String = settingsObj.openAnimType;
		
		if (firstLoad == 1) {
			openAnimTime = 0;
			firstLoad = 0;
		}
		
		switch(settingsObj.scrollBehavior) {
			case "center":
				Tweener.addTween(this, { _x:Math.round(origX + pW / 2 - newBgWidth / 2), time: openAnimTime, transition: openAnimType } );
				break;
			case "left":
				this._x = origX;
				break;
			case "right":
				Tweener.addTween(this, { _x:Math.round(origX + pW - newBgWidth - settingsObj.rightMargin), time: openAnimTime, transition: openAnimType } );
				break;
		}
	}
	
	
	private function onResize() {
		if (settingsObj.fullscreen == "on") {
			resize(Stage.width, Stage.height);
		}
		else {
			resize(settingsObj.fixedAreaWidth, Stage.height);
		}
	}
	
	
	/**
	 * this will load the stage resize and it will listen to it
	 */
	private function loadStageResize() {
		Stage.addListener(this);
		onResize();
	}
}
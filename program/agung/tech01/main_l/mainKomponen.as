import agung.utils.UXml;
import agung.utils.UNode;
import caurina.transitions.*;
import ascb.util.Proxy;
import asual.sa.SWFAddress;
import agung.utils.UAddr;
import agung.utils.UTf;

/**
 * This is the most important class from the template
 * This handles the process of loading and removing modules,
 * the full screen button, the sharing list, the mp3 player loading,
 * the shopping carts and the background
 */
class agung.tech01.main_l.mainKomponen extends MovieClip
{
	private var oldpW:Number = 0;
	private var oldpH:Number = 0;
	
	private var shopPreviewBottom:MovieClip;
	
	private var shopPreview:MovieClip;
	
	private var shopHandler:MovieClip;
	
	private var whitePresent:MovieClip;
	
	private var footer:MovieClip;
		public var footerFill:MovieClip;
		private var footerTop2:MovieClip;
		private var footerTop:MovieClip;
		private var footerTitle:MovieClip;
		
		
	private var totalBackground:MovieClip;
	private var fsButton:MovieClip;
	private var mp3Holder:MovieClip;
	private var topGraphic:MovieClip;
	private var bottomGraphic:MovieClip;
	private var mainMenu:MovieClip;
	private var logo:MovieClip;
	
	private var protect:MovieClip;
	
	public var scrollerDesGlobal:MovieClip;
	
	private var moduleHandler:MovieClip;
		private var moduleTitle:MovieClip;
		private var moduleHolder:MovieClip;
		private var moduleMask:MovieClip;
		private var moduleBg:MovieClip;
			private var bgTopLine:MovieClip;
			private var bgBottomLine:MovieClip;
			private var bgFill:MovieClip;
	
	private var mcl:MovieClipLoader;
			
	private var xml:XML;
	private var settingsObj:Object;
	
	private var init:Number = 1;
	private var prevModule:MovieClip;
	private var currentModule:MovieClip;
	private var currentModuleSettings:Object;
	private var currentModuleSecondSettings:Object;
	
	private var myInterval:Number;
	private var currentModuleIdx:Number = -1;
	private var loading:Number = 0;
	private var currentPressedMc:MovieClip;
	private var currentSwfFile:String;
	private var currentXmlFile:String;
	
	private var defMenuY:Number;
	
	private var loadingWaitInterval:Number;
	private var withoutXml:Number = 1;

	
	private var shareModule:MovieClip;
	
	private var posObj:Object;
	private var playerOn:Number = 1;
	
	private var nowCorrectFooterTitle:Number = 0;

	public function mainKomponen() {
		this._visible = false;
		
		_global.moduleLoadingState = 0;
		_global.MainComponent = this;
		
		protect.onPress = Proxy.create(this, protectPress);
		protect.useHandCursor = false;
		protect._alpha = 0;
		protect._visible = false;
		
		footerFill = footer["footerFill"];
		footerTop = footer["footerTop"];
		footerTop2 = footer["footerTop2"];
		footerTitle = footer["footerTitle"];
		
		moduleHandler._alpha = 0
		moduleHolder = moduleHandler["moduleHolder"];
		
		moduleMask = moduleHandler["moduleMask"];
			
		moduleBg = moduleHandler["moduleBg"];
			bgTopLine = moduleBg["bgTopLine"];
			bgBottomLine = moduleBg["bgBottomLine"];
			bgFill = moduleBg["bgFill"];
			
		moduleTitle = moduleHandler["moduleTitle"];
			
		mcl = new MovieClipLoader();
		mcl.addListener(this);
		
		loadMyXml();
	}
	
	private function protectPress() {
		
	}
	
	/**
	 * this function loads the main xml files, the default xml name is main.xml but this can either be changed here or
	 * in the flashvars
	 */
	private function loadMyXml() { 
		var xmlString:String = _level0.xml == undefined ? "main-l.xml" : _level0.xml;
		xml = UXml.loadXml(xmlString, xmlLoaded, this, false, true);
	}
	
	private function xmlLoaded(s:Boolean) {
		if (!s) { trace("XML error !"); return; }	
		
	
		settingsObj = UNode.nodeToObj(xml.firstChild.firstChild);
		
		this.onEnterFrame = Proxy.create(this, mainEnteredFrame);
	}
	
	/**
	 * this function is launched in the next available frame right after the .xml file is loaded
	 */
	private function mainEnteredFrame() {
		delete this.onEnterFrame;
	
		_global.globalSettingsObj = settingsObj;
		_global.cartXmlNode = xml.firstChild.firstChild.nextSibling.nextSibling;
		_global.theModuleTitle = moduleTitle;
		_global.cartSettings = UNode.nodeToObj(_global.cartXmlNode.firstChild);
		_global.shopsArray = new Array();
		_global.cartArray = new Array();
		_global.theTopShopPreview = shopPreview;
		_global.theBottomShopPreview = shopPreviewBottom;
		_global.shopHandler = shopHandler;
		_global.shareModule = shareModule;
		if (whitePresent) {
			_global.whitePresent = whitePresent;
		}
		
		if (_global.cartSettings.cartPosition == "bottom") {
			_global.theTopShopPreview._visible = false;
		}
		else {
			_global.theTopShopPreview.init();
		}
		
		if (_global.cartSettings.cartPosition == "top") {
			_global.theBottomShopPreview._visible = false;
		}
		else {
			_global.theBottomShopPreview.init();
		}
		
		
		_global.shopHandler.init();
		
		
		
		_global.shareModuleNode = xml.firstChild.firstChild.nextSibling.nextSibling.nextSibling;
		_global.shareModuleSettings = UNode.nodeToObj(_global.shareModuleNode.firstChild);
		
		
		
	
		
		logo._alpha = 0;
		var mcl2:MovieClipLoader = new MovieClipLoader();
		var objLogo:Object  = new Object();
		objLogo.onLoadInit = Proxy.create(this, logoInit);
		mcl2.addListener(objLogo);
		mcl2.loadClip(settingsObj.logoAddress, logo["mc"]);
		
		
		
		mainMenu.addEventListener("buttonPressed", Proxy.create(this, buttonPressed));
		mainMenu.addEventListener("buttonPressedTheSame", Proxy.create(this, buttonPressedTheSame));
		var menuNode:XMLNode = xml.firstChild.firstChild.nextSibling;
		
		mainMenu.setNode(menuNode);
	
		
		if (_global.shopsArray.length==0) {
			_global.theBottomShopPreview._visible = false;
			_global.theTopShopPreview._visible = false;
		}
		
		if (settingsObj.displayTopGraphic == 0) {
			topGraphic._visible = false;
		}
		
		if (settingsObj.displayBottomGraphic == 0) {
			bottomGraphic._visible = false;
		}
		
		if (settingsObj.displayModuleBehindGraphic == 0) {
			moduleBg._visible = false;
		}
		
		if (settingsObj.displayModuleTitleGraphic == 0) {
			moduleTitle["bg"]._visible = false;
		}
		
		if (settingsObj.enableFullScreenButton == 0) {
			fsButton._visible = false;
		}
		
		
		UTf.initTextArea(footerTitle["txt"], true);
		footerTitle._alpha = 0;
		footerTitle["txt"].autoSize = true;
		footerTitle["txt"].wordWrap = false;
		footerTitle["txt"].htmlText = settingsObj.copyrightTitle;
		Tweener.addTween(footerTitle, { _alpha:100, time: 2, transition:"linear" } );
	
		footerFill._height = Math.ceil(10 + footerTitle["txt"].textHeight + 10);
		mp3Holder._y = Math.ceil(footerFill._height / 2 - 20 / 2 + settingsObj.mp3PlayerAdjustYPos);
		fsButton._y = Math.ceil(footerFill._height / 2 - fsButton._height / 2);
		
		
		
		posObj = new Object();
	
		
		
		loadStageResize();
			
			
		_global.mp3PlayerXml = settingsObj.mp3PlayerXml;

		var mclM:MovieClipLoader = new MovieClipLoader();
		var objM:Object = new Object();
		objM.onLoadError = Proxy.create(this, mp3Err);
		objM.onLoadInit = Proxy.create(this, mp3Init);
	
		mclM.addListener(objM);
		mclM.loadClip(settingsObj.mp3PlayerSwf, mp3Holder);
		

	
		
		shareModule.init();
		
		
		
		this._visible = true;
		
		scrollerDesGlobal.setSettings(settingsObj, settingsObj);
		totalBackground.loadMyXml(settingsObj.backgroundSlideShowXmlFile);
		
		oldpH = 0;
		onResize();
	}
	
	private function mp3Err() {
			playerOn = 0;
			oldpH = 0;
			onResize();
	}
	
	private function mp3Init() {
			playerOn = 1;
			oldpH = 0;
			onResize();
	}
	
			
	private function buttonPressedTheSame(obj:Object) {
		currentModule["module"].treatAddress();
	}
	
	/**
	 * this function gets the data from the current pressed button, either one or two level menu button
	 * the swf address parsing has already been made inside the menu
	 * this will load the xml file and the swf
	 * @param	obj
	 */
	private function buttonPressed(obj:Object) {
		
		
		if (currentPressedMc != obj.mc) {
			
			clearInterval(loadingWaitInterval);
			
			_global.nowPopup.cancelPopup();
			
			_global.apc.reset()
			_global.vidCtrl.reset();
			_global.youtubeHolder.destroy();
			
			_global.moduleLoadingState = 1;
			
			currentPressedMc = obj.mc;
			protect._visible = true;
			loading = 1;
			
			_global.theXmlFile = undefined;
			
			var strArray = currentPressedMc.node.attributes.swfData.split(".swf");
			currentSwfFile = strArray[0] + ".swf";
			
			var strArray = currentPressedMc.node.attributes.swfData.split("?xml=");
			currentXmlFile = unescape(strArray[1]);

			_global.globalLoader.showLoader();
			
			if (strArray[1]) {
				xml = UXml.loadXml(currentXmlFile, xmlLoadedForModule, this, false, true);
			}
			else {
				trace("XML error but skipped !"); 
				withoutXml = 1; 
				
				continueLoadingModule();  
			
				currentModuleSettings = new Object();
				currentModuleSettings.moduleWidth = _global.cartSettings.moduleWidth;
				currentModuleSettings.moduleHeight = _global.cartSettings.moduleHeight;

				positionModule();
				
			}
			
		}
		else{
			currentModule["module"].treatAddress();
		}
	}
	
	/**
	 * this is launched after the .xml file for the module has been loaded
	 * @param	s
	 */
	private function xmlLoadedForModule(s:Boolean) {
		if (!s) { 
			trace("XML error on loading module!"); 
			withoutXml = 1; 
			
			continueLoadingModule();  
		
			currentModuleSettings = new Object();
			currentModuleSettings.moduleWidth = _global.cartSettings.moduleWidth;
			currentModuleSettings.moduleHeight = _global.cartSettings.moduleHeight;

			positionModule();
			
			return; 
		}
		
		withoutXml = 0;
		
		_global.theXmlFile = xml;
		
		currentModuleSettings = UNode.nodeToObj(xml.firstChild.firstChild);
		
		var ndd:XMLNode = xml.firstChild.firstChild.nextSibling.firstChild.firstChild;
		
		currentModuleSecondSettings = UNode.nodeToObj(ndd);

		positionModule();
		
		continueLoadingModule();
	}
	
	/**
	 * this is used to position the module taking into consideration the settings from the xml
	 */
	private function positionModule() {
		switch(settingsObj.moduleXPosition) {
				case "left":
					_global.moduleXPos = Math.round(12 + settingsObj.moduleAdjustXPosition);
					break;
				case "center":
					_global.moduleXPos = Math.round(oldpW / 2 - currentModuleSettings.moduleWidth / 2);
					break;
				case "right":
					_global.moduleXPos = Math.round(oldpW - currentModuleSettings.moduleWidth - 12);
					break;
					
				case "alignWithMenu":
					_global.moduleXPos = mainMenu._x;
					break;
		}
	}
	
	/**
	 * this is launched after the module's xml file is loaded or if the .xml file loading
	 * has triggered an error, in this case the .xml file used for the module will be the default one
	 * found inside each module's main class
	 */
	private function continueLoadingModule() {
		currentModuleIdx++;
		prevModule = currentModule;
		currentModuleIdx++;
		currentModule = moduleHolder.createEmptyMovieClip("mc" + currentModuleIdx, moduleHolder.getNextHighestDepth());
		currentModule._x = Stage.width;
		mcl.loadClip(currentSwfFile, currentModule);
	}
	
	/**
	 * this is used to scan for the load progress of the module
	 * @param	mc
	 * @param	bytesLoaded
	 * @param	bytesTotal
	 */
	private function onLoadProgress(mc:MovieClip, bytesLoaded:Number, bytesTotal:Number) {
		_global.globalLoader.loaderProgressChange(Math.ceil(bytesLoaded / bytesTotal * 100));
	}
	
	/**
	 * this function is triggered when the module is loaded
	 * @param	mc
	 */
	private function onLoadInit(mc:MovieClip) {
		_global.globalLoader.hideLoader();
		
		_global.MainComponent.showMainMenu();
		
		moduleHolder.setMask(moduleMask);
	
		clearInterval(myInterval);
		myInterval = setInterval(this, "enableAll", settingsObj.moduleShowAnimationTime * 1000);
			
		_global.moduleHandlerY = Math.round(oldpH / 2 - Math.round(currentModuleSettings.moduleHeight + 80 + 20) / 2);
		var bgNewHeight:Number = Math.round(currentModuleSettings.moduleHeight + 80 + 20)
		
		if (_global.moduleHandlerY < 80) {
			_global.moduleHandlerY = 80;
		}
		
		Tweener.addTween(moduleHandler, { _y:_global.moduleHandlerY, time: settingsObj.moduleShowAnimationTime, transition: settingsObj.moduleShowAnimationType } );
		Tweener.addTween(bgFill, { _height: bgNewHeight, time: settingsObj.moduleShowAnimationTime, transition: settingsObj.moduleShowAnimationType, onUpdate:Proxy.create(this, updateOthers) } );
		
		Tweener.addTween(currentModule, { _x:_global.moduleXPos, time: settingsObj.moduleShowAnimationTime, transition: settingsObj.moduleShowAnimationType } );
		Tweener.addTween(prevModule, { _x: -Stage.width, time: settingsObj.moduleHideAnimationTime, transition: settingsObj.moduleHideAnimationType } );
		
		if (withoutXml == 0) {
			moduleTitle.setNewText(settingsObj, currentModuleSettings, currentModuleSecondSettings);
		
		}
		
		clearInterval(loadingWaitInterval);
		loadingWaitInterval = setInterval(this, "permitNewModuleLoad", 700);
	}
	
	private function permitNewModuleLoad() {
		clearInterval(loadingWaitInterval);
		protect._visible = false;
		_global.moduleLoadingState = 0;
	}
	

	private function enableAll() {
		clearInterval(myInterval);
		prevModule.removeMovieClip();
		
		loading = 0;
		
		onResize();
		
		
		
		if (init == 1) {
			init = 0;
			Tweener.addTween(moduleHandler, { _alpha:100, time: .5, transition: "easeIn" } );
		}
		
		moduleHolder.setMask(null);
	}
	
	private function logoInit() {
		Tweener.addTween(logo, { _alpha:100, time:0.5, transition:"linear" } );
		
		oldpW = oldpH = 0;
		onResize();
	}
	/**
	 * function called when the browser is resized
	 * here all the elements are being positioned when the browser is resized or when this function is called
	 * from another class
	 * @param	pW
	 * @param	pH
	 */
	private function resize(pW:Number, pH:Number) {
		if ((pW != oldpW) || (pH != oldpH)) {
			pW = Math.max(pW, settingsObj.templateMaxWidth);
			pH = Math.max(pH, settingsObj.templateMaxHeight);
			
			oldpW = pW;
			oldpH = pH;
			
			
			
			footerTitle._x = Math.ceil(nowCorrectFooterTitle + (Stage.width - nowCorrectFooterTitle - 200) / 2 - footerTitle._width / 2 + 150- 50)
			
			footerFill._width = footerTop._width = footerTop2._width = pW + 4;
			
			footer._y = Math.round(pH - footerFill._height + 1);
			
			fsButton._x = Math.round(pW - 30 - fsButton._width);
			var fsButtonAdjust:Number = Math.round(footer._height / 2 - fsButton._height / 2);
			fsButton._y = Math.round(pH - fsButton._height - fsButtonAdjust + 2);
			fsButton.setTheStatus();
			topGraphic._x = Math.round(pW / 2 - topGraphic._width / 2);
			bottomGraphic._x = Math.round(pW / 2 - bottomGraphic._width / 2);
			bottomGraphic._y = Math.round(pH - bottomGraphic._height - footer._height+3);
			
			
			
			bgFill._width = moduleMask._width = bgTopLine._width = bgBottomLine._width = Math.round(pW + 4);
			
			
			mp3Holder._x = Math.ceil(fsButton._x - 30 + settingsObj.mp3PlayerAdjustXPos);
			
			mp3Holder._y = Math.round(pH - footerFill._height + settingsObj.mp3PlayerAdjustYPos - 1);
			
			
			logo._x = Math.round(42 + settingsObj.correctLogoXPos);
			logo._y = Math.round(16 + settingsObj.correctLogoYPos);
			
			var menuMinXPos:Number = Math.round(300);
			
			switch(settingsObj.menuPosition) {
				case "left":
					mainMenu._x = Math.round(menuMinXPos + settingsObj.correctMenuXpos);
					break;
				case "center":
					mainMenu._x = Math.round(pW / 2 - mainMenu.totalWidth / 2 + settingsObj.correctMenuXpos);
					break;
				case "right":
					mainMenu._x = Math.round(pW - mainMenu.totalWidth - 20 - settingsObj.correctMenuXpos);
					break;
			}
			
			mainMenu._y = defMenuY = Math.round(19 + settingsObj.correctMenuYPos);
			
			if (mainMenu._x < logo._x + logo._width) {
				mainMenu._x = Math.ceil(logo._x + logo._width + settingsObj.correctMenuXpos + 14);
			}
			
			shopPreview._x = Math.ceil(mainMenu._x + _global.mainMenuVisibleWidth + 10);
			shopPreview._y = Math.ceil(mainMenu._y + 7);
			
		
			switch(settingsObj.moduleXPosition) {
				case "left":
					_global.moduleXPos = Math.round(12 + settingsObj.moduleAdjustXPosition);
					break;
				case "center":
					_global.moduleXPos = Math.round(pW / 2 - currentModuleSettings.moduleWidth / 2);
					break;
				case "right":
					_global.moduleXPos = Math.round(pW - currentModuleSettings.moduleWidth - 12);
					break;
				case "alignWithMenu":
					_global.moduleXPos = mainMenu._x;
					break;
			}
			
			if (loading == 0) {
				Tweener.addTween(currentModule, { _x:_global.moduleXPos, time: settingsObj.moduleShowAnimationTime, transition: settingsObj.moduleShowAnimationType } );
			
				_global.moduleHandlerY = Math.round(oldpH / 2 - Math.round(currentModuleSettings.moduleHeight + 80 + 20) / 2);
				var bgNewHeight:Number = Math.round(currentModuleSettings.moduleHeight + 80 + 20)
				
				if (_global.moduleHandlerY < 80) {
					_global.moduleHandlerY = 80;
				}
				
				Tweener.addTween(moduleHandler, { _y:_global.moduleHandlerY, time: settingsObj.moduleShowAnimationTime, transition: settingsObj.moduleShowAnimationType } );
				Tweener.addTween(bgFill, { _height: bgNewHeight, time: settingsObj.moduleShowAnimationTime, transition: settingsObj.moduleShowAnimationType, onUpdate:Proxy.create(this, updateOthers) } );
			}
			else {
				currentModule._x = pW + 200;
			}
			
			
			protect._width = pW;
			protect._height = pH - footer._height;
			
			moduleTitle.position();
			
			shareModule._x = _global.shareModuleSettings.correctPosX;
			shareModule._y = Math.ceil(pH - _global.shareModuleSettings.correctPosY - _global.shareModuleSettings.bigButtonsHeight - Math.ceil(_global.MainComponent.footerFill._height/2 - (_global.shareModuleSettings.bigButtonsHeight + 27)/2) - 10);
			trace(shareModule._y)
			shopPreviewBottom._y = Math.ceil(fsButton._y - 4);
			
			if (playerOn == 1) {
				shopPreviewBottom._x = 	posObj.sx = Math.ceil(fsButton._x - 155);
			}
			else {
				shopPreviewBottom._x = 	posObj.sx = Math.ceil(fsButton._x - 127);
			}
		
		}
	}
	
	public function openPlayer() {
		nowCorrectFooterTitle = -250;
		Tweener.addTween(footerTitle, { _x:Math.ceil(nowCorrectFooterTitle + (Stage.width - nowCorrectFooterTitle - 200) / 2 - footerTitle._width / 2 + 150 - 50), time:0.5, transition:"easeOutExpo" } );
	}
	
	public function closePlayer() {
		closedShare();
	}
	
	public function openedShare() {
		nowCorrectFooterTitle = _global.shareMaxWidth - _global.shareModuleSettings.smallListWidth;
		Tweener.addTween(footerTitle, { _x:Math.ceil(nowCorrectFooterTitle + (Stage.width - nowCorrectFooterTitle - 200) / 2 - footerTitle._width / 2 + 150- 50 ), time:0.5, transition:"easeOutExpo" } );
	}
	
	public function closedShare() {
		nowCorrectFooterTitle = 0;
		Tweener.addTween(footerTitle, { _x:Math.ceil(nowCorrectFooterTitle + (Stage.width - nowCorrectFooterTitle - 200) / 2 - footerTitle._width / 2 + 150 - 50 ), time:0.5, transition:"easeOutExpo" } );
	}
	
	public function reArrangeShopBottom() {
		playerOn = 0;
		oldpH = 0;
		onResize();
	}
	
	public function reArrangeElementsOpen(newAdded:Number) {
		Tweener.addTween(shopPreviewBottom["icon"], { _x:Math.ceil(-newAdded+4), time:0.5, transition:"easeOutExpo" } );
	}
	
	public function reArrangeElementsClose() {
		Tweener.addTween(shopPreviewBottom["icon"], { _x:Math.ceil(0), time:0.5, transition:"easeOutExpo" } );
	}

	private function updateOthers() {
		bgBottomLine._y = moduleMask._height =  bgFill._height;
	}
	
	private function onResize() {
		resize(Stage.width, Stage.height);
	}
	
	private function loadStageResize() {
		Stage.addListener(this);
		onResize();
	}
	
	public function hideMainMenu() {
		Tweener.addTween(mainMenu, { _alpha:0, _y:defMenuY - 10, time:.2, transition:"linear", onComplete:Proxy.create(this, invisMainMenu) } );
		Tweener.addTween(shopPreview, { _alpha:0, _y:defMenuY - 10, time:.2, transition:"linear"} );
	}
	
	private function invisMainMenu() {
		mainMenu._visible = false;
	}
	
	public function showMainMenu() {
		mainMenu._visible = true;
		Tweener.addTween(mainMenu, { _alpha:100, _y:defMenuY, time:.2, transition:"linear" } );
		Tweener.addTween(shopPreview, { _alpha:100, _y:defMenuY +7, time:.2, transition:"linear"} );
	}
}
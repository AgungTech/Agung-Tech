import ascb.util.Proxy;
import caurina.transitions.*;
import mx.data.types.Obj;
import mx.data.types.Str;
import agung.utils.UNode;

import mx.events.EventDispatcher;
import asual.sa.SWFAddress;
import agung.utils.UAddr;
import agung.utils.UStr;
import agung.utils.UArray;
import agung.utils.UTf;

class agung.tech01.penjualan.thumbScroller extends MovieClip 
{
	private var theXml:XML;	
	private var node:XMLNode;
	private var mainSettingsObj:Object;
	private var settingsObj:Object
	
	private var holder:MovieClip;
		private var lst:MovieClip;
		private var mask:MovieClip;
		private var scroller:MovieClip;
			private var bar:MovieClip;
			private var stick:MovieClip;

	private var addedToThumbWidth:Number = 11 + 11;
	private var addedToThumbHeight:Number = 11 + 11;
	
	private var addedAtSidesWidth:Number = 11 + 11;
	private var addedAtSidesHeight:Number = 11 + 11;
	
	private var thumbArray:Array;
	private var thumbLoadingIdx:Number = -1;
	private var currentJump:Number = 0;
	private var totalItems:Number;
	
	
	public var scrollerDescription:MovieClip;
	private var myWaitInterval:Number;
	private var HitZone:MovieClip;
	private var ScrollArea:MovieClip;
	private var ScrollButton:MovieClip;
	private var ContentMask:MovieClip;
	private var Content:MovieClip;
	private var viewHeight:Number;
	private var totalHeight:Number;
	private var ScrollHeight:Number;
	private var scrollable:Boolean;
	
	private var myInterval2:Number;
	
	
	private var changedThumbArray:Array;
	private var searchPanel:MovieClip;
		private var searchInput:MovieClip;
		
		
	private var sortPanel:MovieClip;
		private var sortPanelLst:MovieClip;
	
	private var currentButtonSortActive:MovieClip;
	private var currentButtonOrderActive:MovieClip;
		
	
	private var orderPanel:MovieClip;
		private var orderPanelLst:MovieClip;
	
	private var emptySearch:MovieClip;
		private var emptySearchDefaultY:Number = 0;
	
		
	public function thumbScroller() {
		this._visible = false;
		
		lst = holder["lst"];
		mask = holder["mask"];
	
		scroller = holder["scroller"];
		bar =  scroller["bar"];
		stick = scroller["stick"];
		
		scroller._visible = false;
		lst.setMask(mask);
		
		searchInput = searchPanel["search"];
		
		sortPanel = searchPanel["sort"];
			sortPanelLst = sortPanel["lst"];
			
		orderPanel = searchPanel["order"];
			orderPanelLst = orderPanel["lst"];
	}
	

	public function setNode(pNode:XMLNode, pMainSettingsObj:Object)
	{
		
		node = pNode;
		mainSettingsObj = pMainSettingsObj;
	
		
		node = node.firstChild;
		
		settingsObj = UNode.nodeToObj(node);
		
		
		mask._width = Math.round((settingsObj.thumbWidth + addedToThumbWidth + addedAtSidesWidth) * settingsObj.horizontalNumberOfItems + settingsObj.horizontalSpace * (settingsObj.horizontalNumberOfItems - 1));
		
		mask._height = Math.round((settingsObj.thumbHeight + addedToThumbHeight + addedAtSidesHeight + settingsObj.thumbDescriptionHeight) * settingsObj.verticalNumberOfItemsThatFitOnMask + settingsObj.verticalSpace * (settingsObj.verticalNumberOfItemsThatFitOnMask - 1));
		
		
		thumbArray = new Array();
		var currentXPos:Number = 0;
		var currentYPos:Number = 0;
		var idx:Number = 0;
		
		node = node.nextSibling.firstChild;
		
	
		var idd:Number = 0;
		for (; node != null; node = node.nextSibling) {
			var currentItem:MovieClip = lst.attachMovie("IDscrollerItem", "scrollerItem" + idx, lst.getNextHighestDepth());
			
			currentItem.addEventListener("thumbClicked", Proxy.create(this, thumbClicked));
			currentItem.addEventListener("thumbLoaded", Proxy.create(this, thumbLoaded));
			currentItem.addEventListener("thumbRollOver", Proxy.create(this, thumbRollOver));
			currentItem.addEventListener("thumbRollOut", Proxy.create(this, thumbRollOut));
			currentItem.idx = idx;
			
			currentItem._x = currentXPos;
			currentItem._y = currentYPos;
			
			
			currentItem.setNode(node, settingsObj, mainSettingsObj);

			currentXPos += Math.round(settingsObj.thumbWidth + addedToThumbWidth + settingsObj.horizontalSpace + addedAtSidesWidth);

			idd++;
			
			if (idd == settingsObj.horizontalNumberOfItems) {
				idd = 0;
				currentXPos = 0;
				currentYPos += Math.round(settingsObj.thumbHeight + addedToThumbHeight + addedAtSidesHeight + settingsObj.thumbDescriptionHeight + settingsObj.verticalSpace);
			}
			
			thumbArray.push(currentItem);
			
			idx++;
		}
		
		changedThumbArray = thumbArray;
		
		totalItems = idx - 1;
		
		if (settingsObj.enableAutoCentering == 1) {
			holder._x = Math.ceil(mainSettingsObj.moduleWidth / 2 - Math.min(mask._width, lst._width) / 2);
			holder._y = Math.ceil(mainSettingsObj.moduleHeight / 2 - Math.min(mask._height, lst._height) / 2);
			stick._height = Math.min(mask._height, lst._height);
			scroller._x = Math.ceil(lst._width + 10 + settingsObj.adjustScrollerXPos);
		}
		else {
			holder._x = 0;
			holder._y = 0;
			stick._height = mask._height;
			scroller._x = Math.ceil(mainSettingsObj.moduleWidth - scroller._width + settingsObj.adjustScrollerXPos);
		}
		
		
		
		
		myWaitInterval = setInterval(this, "ScrollBox", 500);
		
		thumbLoaded();
		
		if (mainSettingsObj.enableSearch == 1) {
			if (!_global.whitePresent) {
				searchPanel["bg"]._width = Math.ceil(mainSettingsObj.moduleWidth - 40);
				searchPanel._x = 16;
			}
			else {
				searchPanel["bg"]._width = Math.ceil(mainSettingsObj.moduleWidth - 0);
				searchPanel._x = 0;
			}
			
			searchPanel._y -= 14;
			
			searchInput["bg"]["over"]._alpha = 0;
			if (!_global.whitePresent) {
				Tweener.addTween(searchInput["txt"], { _alpha:60, time:0.1, transition:"linear" } );
			}
			else {
				Tweener.addTween(searchInput["txt"], { _alpha:40, time:0.1, transition:"linear" } );
			}
			
		
			searchInput["txt"].text = mainSettingsObj.defaultSearchTextInBox;
			searchInput["txt"].onSetFocus = Proxy.create(this, focused);
		
			searchInput["txt"].onChanged = Proxy.create(this, textChanged);
			holder._y += 40;
			
			if (settingsObj.enableAutoCentering == 1) {
				holder._x = Math.ceil(mainSettingsObj.moduleWidth / 2 - Math.min(mask._width, lst._width) / 2);
				holder._y = Math.ceil(mainSettingsObj.moduleHeight / 2 - Math.min(mask._height, lst._height) / 2 );
					holder._y+=20
				stick._height = Math.min(mask._height, lst._height);
				scroller._x = Math.ceil(lst._width + 10 + settingsObj.adjustScrollerXPos);
			}
			
			myInterval2 = setInterval(this, "overActivate", 100);
		
		}
		else {
			searchPanel._visible = false;
		}
		
		
			
		sortPanel["txt"].autoSize = true;
		sortPanel["txt"].wordWrap = false;
		sortPanel["txt"].text = mainSettingsObj.sortByCaption;
		
		sortPanelLst._x = Math.ceil(sortPanel["txt"].textWidth + 7);
		var idx:Number = 0;
		var currentPos:Number = 0;
		sortPanelLst._y = 1
		for (idx = 0; idx < 4; idx++) {
			var currentItem = sortPanelLst.attachMovie("IDsearchPanelItem", "IDsearchPanelItem" + idx, sortPanelLst.getNextHighestDepth());
			currentItem.addEventListener("buttonClickedGeneral", Proxy.create(this, buttonClickedGeneral));
			switch (idx) {
				case 0:
					currentItem.setNode(mainSettingsObj.sortByPriceCaption, mainSettingsObj, "price");
					break;
				case 1:
					currentItem.setNode(mainSettingsObj.sortByNameCaption, mainSettingsObj, "name");
					break;
				case 2:
					currentItem.setNode(mainSettingsObj.sortByDateCaption, mainSettingsObj, "date");
					break;
				case 3:
					currentItem.setNode(mainSettingsObj.sortBySalesCaption, mainSettingsObj, "sales");
					break;
			}
			
			currentItem._x = currentPos;
			
			currentPos += Math.ceil(currentItem.bg._width);
		}
		
		

		
		orderPanel["txt"].autoSize = true;
		orderPanel["txt"].wordWrap = false;
		orderPanel["txt"].text = mainSettingsObj.orderByCaption;
		
		orderPanelLst._x = Math.ceil(orderPanel["txt"].textWidth + 7);
		var idx:Number = 0;
		var currentPos:Number = 0;
		orderPanelLst._y = 1
		for (idx = 0; idx < 2; idx++) {
			var currentItem = orderPanelLst.attachMovie("IDsearchPanelItem", "IDsearchPanelItem" + idx, orderPanelLst.getNextHighestDepth());
			currentItem.addEventListener("buttonClickedGeneral", Proxy.create(this, buttonClickedGeneral));
			switch (idx) {
				case 0:
					currentItem.setNode(mainSettingsObj.orderByAscendingCaption, mainSettingsObj, "ascending");
					break;
				case 1:
					currentItem.setNode(mainSettingsObj.orderByDescendingCaption, mainSettingsObj, "descending");
					break;
			}
			
			currentItem._x = currentPos;
			
			currentPos += Math.ceil(currentItem.bg._width);
		}
		
		orderPanel._x = Math.ceil(searchPanel["bg"]._width - orderPanel._width - 8);
		sortPanel._x = Math.ceil(orderPanel._x - sortPanel._width - 16);
		
		
		if ((mainSettingsObj.forceInitialSortBy) && (mainSettingsObj.enableSearch == 1)) {
				switch (mainSettingsObj.forceInitialSortBy) {
					case "price":
						sortPanelLst["IDsearchPanelItem" + 0].onPress();
						break;
					case "name":
						sortPanelLst["IDsearchPanelItem" + 1].onPress();
						break;
					case "date":
						sortPanelLst["IDsearchPanelItem" + 2].onPress();
						break;
					case "sales":
						sortPanelLst["IDsearchPanelItem" + 3].onPress();
						break;
				}
				
				if (mainSettingsObj.forceInitialOrderBy) {
					if (mainSettingsObj.forceInitialOrderBy == "ascending") {
						orderPanelLst["IDsearchPanelItem" + 0].onPress();
					}
					else {
						orderPanelLst["IDsearchPanelItem" + 1].onPress();
					}
				}
		}
			
		
		UTf.initTextArea(emptySearch["txt"], true);
		emptySearch["txt"].htmlText = mainSettingsObj.emptySearchResultCaption;
		emptySearch._x = Math.ceil(mainSettingsObj.moduleWidth / 2 - emptySearch._width / 2);
		emptySearch._y = emptySearchDefaultY = Math.ceil(mainSettingsObj.moduleHeight / 2 - emptySearch._height / 2);
		
		emptySearch._alpha = 0;
		emptySearch._y -= 20;
		
		treatAddress();
		this._visible = true;
	}
	
	private function focused() {
		if (searchInput["txt"].text == mainSettingsObj.defaultSearchTextInBox) {
			searchInput["txt"].text = "";
		}
	}
	
	
	private function overActivate() {
		if ((searchInput._xmouse > 0) && (searchInput._xmouse < searchInput._width) && (searchInput._ymouse > 0) && (searchInput._ymouse < searchInput._height)) {
			if (searchInput["bg"]["over"]._alpha != 100) {
				Tweener.addTween(searchInput["bg"]["over"], { _alpha:100, time:0.09, transition:"linear" } );
				Tweener.addTween(searchInput["txt"], { _alpha:100, time:0.09, transition:"linear" } );
			}
			
		}
		else {
			if (searchInput["bg"]["over"]._alpha != 0) {
				Tweener.addTween(searchInput["bg"]["over"], { _alpha:0, time:0.09, transition:"linear" } );
					if (!_global.whitePresent) {
						Tweener.addTween(searchInput["txt"], { _alpha:60, time:0.09, transition:"linear" } );
					}
					else {
						Tweener.addTween(searchInput["txt"], { _alpha:40, time:0.09, transition:"linear" } );
					}
				
			}	
		}
	}
	
	private function findValueInArray(pValue:String, pArray:Array) {
		var found:Boolean = false;
		for (var i in pArray) {
			if (pArray[i] == pValue) {
				found = true;
				break;
			}
		}
		
		return found;
	}
	
	private function findPartOfTextInArray(pValue:String, pStr:String) {
		var found:Boolean = true;
		var valueArray:Array = pValue.split("");
	
		var strArray:Array = pStr.split("");
		
		var i:Number = 0; 
		for (i = 0; i < valueArray.length; i++) {
			if (valueArray[i] != strArray[i]) {
				found = false;
				break;
			}
		}
	
		
		return found;
	}
	
	private function textChanged() {
		
		var testStrArray:Array = UStr.squeeze(searchInput["txt"].text).split(" ");
		changedThumbArray = new Array();
			
		if (searchInput["txt"].text != mainSettingsObj.defaultSearchTextInBox) {
			
			if ((searchInput["txt"].text == "") || (searchInput["txt"].text == " ") || (searchInput["txt"].text == "  ")) {
				var idx:Number = 0;
				while (thumbArray[idx]) {
					changedThumbArray.push(thumbArray[idx]);
					thumbArray[idx].foundInSearch = 1;
					idx++;
				}
			
			}
			else {
				var idx:Number = 0;
				while (thumbArray[idx]) {
						var currentText:String = thumbArray[idx].mySearchTags;
						
						var i:Number = 0;
						var found:Number = 0;
						
						while (testStrArray[i]) {
							if (UStr.replaceMod(currentText, testStrArray[i], "FOUND", false, false, false)) {
								found++;
							}
							else {
								found = 0;
								break;
							}
							
							i++;
						}
						
						if (found == testStrArray.length) {
							changedThumbArray.push(thumbArray[idx]);
							thumbArray[idx].foundInSearch = 1;
						}
						else {
							thumbArray[idx].foundInSearch = 0;
						}

					idx++;
				}
			}			
		}
		else {
				changedThumbArray = new Array();
				var idx:Number = 0;
				while (thumbArray[idx]) {
					changedThumbArray.push(thumbArray[idx]);
					thumbArray[idx].foundInSearch = 1;
					idx++;
				}
		}
		
		
		if (currentButtonSortActive) {
				
				switch (currentButtonSortActive.theType) {
					case "price":
						sortByPrice();
						break;
					case "name":
						sortByName();
						break;
					case "date":
						sortByDate();
						break;
					case "sales":
						sortBySales();
						break;
				}
			}
			
			
				
			
			
			var idx:Number = 0;
			var currentXPos:Number = 0;
			var currentYPos:Number = 0;
			var idd:Number = 0;
		
			while (changedThumbArray[idx]) {
						var currentItem:MovieClip = changedThumbArray[idx];
						currentItem.idx = idx;
						currentItem._x = currentXPos;
						currentItem._y = currentYPos;
						
						currentXPos += Math.round(settingsObj.thumbWidth + addedToThumbWidth + settingsObj.horizontalSpace + addedAtSidesWidth);

						idd++;
				
						if (idd == settingsObj.horizontalNumberOfItems) {
							idd = 0;
							currentXPos = 0;
							currentYPos += Math.round(settingsObj.thumbHeight + addedToThumbHeight + addedAtSidesHeight + settingsObj.thumbDescriptionHeight + settingsObj.verticalSpace);
						}
			
						thumbArray[idx]._visible = true;
				idx++;
			}
			
			var idx:Number = 0;
			while (thumbArray[idx]) {
				var currentItem:MovieClip = thumbArray[idx];

				if (thumbArray[idx].foundInSearch == 0) {
					thumbArray[idx]._visible = false;
					thumbArray[idx]._x = thumbArray[idx]._y = 0;
				}
				else {
					thumbArray[idx]._visible = true;
				}
				
				
				idx++;
			}
			
			
		
			stopScrolling();
			delete this.onEnterFrame;
			delete lst.onEnterFrame;
			lst._y = 0;
			ScrollBox();
			
		
			if (changedThumbArray.length == 0) {
				Tweener.addTween(emptySearch, { _alpha:100, _y:emptySearchDefaultY, time:0.5, transition:"easeOutQuad" } );
			}
			else {
				Tweener.addTween(emptySearch, { _alpha:0, _y:emptySearchDefaultY - 20, time:0.5, transition:"easeOutQuad" } );
			}
	}
	
	private function sortByPriceInArray(a, b) {
		return parseFloat(a.node.attributes.price) > parseFloat(b.node.attributes.price);
	}
	
	private function sortBySalesInArray(a, b) {
		return parseFloat(a.node.attributes.sales) > parseFloat(b.node.attributes.sales);
	}
	
	private function sortByNameInArray(a, b) {
		return String(a.node.attributes.title) > String(b.node.attributes.title);
	}
	
	private function sortByDateInArray(a, b) {
		return parseFloat(a.theDate) > parseFloat(b.theDate);
	}
	
	private function sortByPrice() {
		changedThumbArray.sort(sortByPriceInArray);
		orderElements();
	}
	
	private function orderElements() {
		if (currentButtonOrderActive) {
			if(currentButtonOrderActive.theType=="descending") {
				changedThumbArray =	UArray.reverse(changedThumbArray);
			}
		}
	}
	
	private function sortByName() {
		changedThumbArray.sort(sortByNameInArray);
		orderElements();
	}
	
	private function sortByDate() {
		changedThumbArray.sort(sortByDateInArray);
		orderElements();
	}
	
	private function sortBySales() {
		changedThumbArray.sort(sortBySalesInArray);
		orderElements();
	}
	
	private function buttonClickedGeneral(obj:Object) {
		if ((obj.mc.theType != "ascending") && (obj.mc.theType != "descending")) {
			if (obj.mc != currentButtonSortActive) {
				currentButtonSortActive.deactivate();
				currentButtonSortActive = obj.mc;
				currentButtonSortActive.activate();
				
				textChanged();
			}
		}
		else {
			if (obj.mc != currentButtonOrderActive) {
				currentButtonOrderActive.deactivate();
				currentButtonOrderActive = obj.mc;
				currentButtonOrderActive.activate();
				
				switch (obj.mc.theType) {
					case "price":
						sortByPrice();
						break;
					case "name":
						sortByName();
						break;
					case "date":
						sortByDate();
						break;
					case "sales":
						sortBySales();
						break;
				}
				
				textChanged();
			}
		}	
	}
	
	public function treatAddress() {
		var str:String = UAddr.contract(SWFAddress.getValue());
		var strArray:Array = str.split("/");
		var idx:Number = 0;
		
		if (strArray[3]) {
			var idx:Number = 0;
			while (lst["scrollerItem" + idx]) {
				
				var actualUrlAddress:String = "/" + strArray[1] + "/" + strArray[2] + "/" + strArray[3] + "/";

				if (lst["scrollerItem" + idx].urlAddress == (actualUrlAddress)) {
					lst["scrollerItem" + idx].dispatchMc();
					break;
				}
				idx++;
			}
		}
		else {
			_global.portfolioPopupHandler.cancelPopup()
		}
		
		
		
	}
	
		
	private function thumbClicked(obj:Object) {
		_global.portfolioPopupHandler.launchPopup(obj.mc, changedThumbArray, this);
	}
	
	private function thumbRollOver(obj:Object) {
		scrollerDescription.setNewText(obj.mc.node);
	}
	
	private function thumbRollOut(obj:Object) {
		scrollerDescription.hide();
	}
	
	private function thumbLoaded(obj:Object) {
		
		thumbLoadingIdx++;
		if (thumbArray[thumbLoadingIdx]) {
			thumbArray[thumbLoadingIdx].startLoad();
		}
	}
	
	public function stopScrolling() {
		Mouse.removeListener(this);
	}
	
	public function startScrolling() {
		Mouse.addListener(this);
	}
	
	private function ScrollBox() {
		
		clearInterval(myWaitInterval);
		
		ScrollArea = stick;
		ScrollButton = bar;
		Content = lst;
		ContentMask = mask;
		
		HitZone = ContentMask.duplicateMovieClip("_hitzone_", this.getNextHighestDepth());
		HitZone._alpha = 0;
		HitZone._width = ContentMask._width;
		HitZone._height = ContentMask._height;
		
		Content.setMask(ContentMask);
		ScrollArea.onPress = Proxy.create(this, startScroll);
		ScrollArea.onRelease = ScrollArea.onReleaseOutside = Proxy.create(this, stopScroll);
		
		totalHeight = Content._height + 4;
		scrollable = false;
		
		updateScrollbar();
		
		Mouse.addListener(this);
		
		ScrollButton.onRollOver = Proxy.create(this, barOnRollOver);
		ScrollButton.onRollOut = Proxy.create(this, barOnRollOut);
		ScrollButton.onPress = Proxy.create(this, startScroll);
		ScrollButton.onRelease = ScrollButton.onReleaseOutside = Proxy.create(this, stopScroll);
		
		barOnRollOut();
	}
	
	private function updateScrollbar() {
		viewHeight = ContentMask._height;
		
		var prop:Number = viewHeight/(totalHeight-4);
		
		if (prop >= 1) {
			scrollable = false;
			scroller._alpha = 0
			ScrollArea.enabled = false;
			ScrollButton._y = 0;
			Content._y = 0;
			scroller._visible = false;
		} else {
			ScrollButton["normal"]._height = ScrollButton["over"]._height = ScrollArea._height * prop;
			scrollable = true;
			ScrollButton._visible = true;
			ScrollArea.enabled = true;
			ScrollButton._y = 0;
			Tweener.addTween(scroller, { _alpha:100, time:2, transition:"linear" } );
			
			ScrollHeight = ScrollArea._height - ScrollButton._height;
			
			if(ScrollButton._height>(ScrollArea._height)){
				scrollable = false;
				scroller._alpha = 0
				ScrollArea.enabled = false;
				ScrollButton._y = 0;
				Content._y = 0;
			}
			
			scroller._visible = true;
		}
	}
	
	private function startScroll() {
		
		var center:Boolean = !ScrollButton.hitTest(_level0._xmouse, _level0._ymouse, true);
		var sbx:Number = ScrollButton._x;
		if (center) {
			var sby:Number = ScrollButton._parent._ymouse-ScrollButton._height/2;
			sby<0 ? sby=0 : (sby>ScrollHeight ? sby=ScrollHeight : null);
			ScrollButton._y = sby;
		}

			
		ScrollButton.startDrag(false, sbx, 0, sbx, ScrollHeight);
		ScrollButton.onMouseMove = Proxy.create(this, updateContentPosition);
		updateContentPosition();
	}
	
	private function stopScroll() {
		ScrollButton.stopDrag();
		delete ScrollButton.onMouseMove;
		barOnRollOut();

	}
	
	private function updateContentPosition() {
		if (scrollable == true) {
			var contentPos:Number = (viewHeight-totalHeight)*(ScrollButton._y/ScrollHeight);
		this.onEnterFrame = function() {
			if (Math.abs(Content._y-contentPos)<1) {
				Content._y = contentPos;
				delete this.onEnterFRame;
				return;
			}
			Content._y += (contentPos - Content._y) / 6;
		};
		}
		else{
			Content._y = 0;
			delete Content.onEnterFrame;
		}
		
	}
	
	private function scrollDown() {
		var sby:Number = ScrollButton._y+ScrollButton._height/4;
		if (sby>ScrollHeight) {
			sby = ScrollHeight;
		}
		ScrollButton._y = sby;
		updateContentPosition();
	}
	
	private function scrollUp() {
		var sby:Number = ScrollButton._y-ScrollButton._height/4;
		if (sby<0) {
			sby = 0;
		}
		ScrollButton._y = sby;
		updateContentPosition();
	}
	
	private function onMouseWheel(delt:Number) {
		if (!HitZone.hitTest(_level0._xmouse, _level0._ymouse, true)) {
			return;
		}
		var dir:Number = delt/Math.abs(delt);
		if (dir<0) {
			scrollDown();
		} else {
			scrollUp();
		}
	}
	
	private function barOnRollOver() {
		Tweener.addTween(bar["over"], { _alpha:100, time:0.15, transition:"linear" } );
	}
	
	private function barOnRollOut() {
		Tweener.addTween(bar["over"], { _alpha:0, time:0.15, transition:"linear" } );
	}
}
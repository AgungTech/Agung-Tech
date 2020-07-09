import caurina.transitions.*;
import ascb.util.Proxy;
import mx.events.EventDispatcher;

class agung.tech01.blog.blogPopup extends MovieClip 
{
	private var oldpW:Number = 0;
	private var oldpH:Number = 0;
	
	private var node:XMLNode;
	private var settingsObj:Object

	private var holder:MovieClip;
	
	public var popupDetails:MovieClip;

	private var leftHit:MovieClip;
	private var rightHit:MovieClip;
	private var arrowsDefs:Object;
	private var myInterval2:Number;
	private var myInterval3:Number;
	
	private var bgBody:MovieClip;
		private var outerBg:MovieClip;
		private var innerFill:MovieClip;
		private var innerStroke:MovieClip;
	
	private var topData:MovieClip;
	private var upControl:MovieClip;
		private var bgUC:MovieClip;
			private var bgUCStroke:MovieClip;
			private var bgUCFill:MovieClip;
		private var UCTitle:MovieClip;
		private var UCComments:MovieClip;
		private var UCCommentsOver:MovieClip;
		
		private var UCCAddComment:MovieClip;
			private var normalAddComment:MovieClip;
			private var overAddComment:MovieClip;
		
		private var backToPost:MovieClip;
			
		private var closeButton:MovieClip;
			private var closeButtonOver:MovieClip;
			private var closeButtonNormal:MovieClip;
		
	private var next:MovieClip;
	private var prev:MovieClip;
		
	private var popupMode:String;
	private var pressedItem:MovieClip;
	
	private var myInterval:Number;
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	
	public function blogPopup() {
		EventDispatcher.initialize(this);
		
		this._visible = false;
		
		
		bgBody = holder["bgBody"];
		
		outerBg = bgBody["outerBg"];
		innerFill = bgBody["innerFill"];
		innerStroke = bgBody["innerStroke"];
		
		upControl = holder["upControl"];
		bgUC = upControl["bg"];
		bgUCStroke = bgUC["stroke"];
		bgUCFill = bgUC["fill"];
		
		UCTitle = upControl["title"];
		UCComments = UCTitle["comments"];
		UCCommentsOver = UCTitle["commentsOver"];
		
		UCCAddComment = UCTitle["addComment"];
		normalAddComment = UCCAddComment["normal"];
		overAddComment = UCCAddComment["over"];
		overAddComment._alpha = 0;
		normalAddComment["txt"].autoSize = overAddComment["txt"].autoSize = true;
		
		UCComments["txt"].autoSize = UCComments["leftSide"].autoSize = UCComments["txtNumber"].autoSize = UCComments["rightSide"].autoSize = true;
		UCCommentsOver["txt"].autoSize = UCCommentsOver["leftSide"].autoSize = UCCommentsOver["txtNumber"].autoSize = UCCommentsOver["rightSide"].autoSize = true;
		
		backToPost = UCTitle["backToPost"];
		backToPost["normal"]["txt"].autoSize = backToPost["over"]["txt"].autoSize = true;
		backToPost["normal"]["txt"].wordWrap = backToPost["over"]["txt"].wordWrap = false;
		
		
		topData = holder["topData"];
		
		closeButton = upControl["closeButton"];
		closeButtonNormal = closeButton["normal"];
		closeButtonOver = closeButton["over"];
		closeButtonOver._alpha = 0;
		
		next = holder["next"];
		prev = holder["prev"];
		
		next["over"]._alpha = 0;
		next.onRollOver = Proxy.create(this, nextOnRollOver);
		next.onRollOut = Proxy.create(this, nextOnRollOut);
		next.onPress = Proxy.create(this, nextOnPress);
		next.onRelease = Proxy.create(this, nextOnRelease);
		next.onReleaseOutside = Proxy.create(this, nextOnReleaseOutside);
		
		prev["over"]._alpha = 0;
		prev.onRollOver = Proxy.create(this, prevOnRollOver);
		prev.onRollOut = Proxy.create(this, prevOnRollOut);
		prev.onPress = Proxy.create(this, prevOnPress);
		prev.onRelease = Proxy.create(this, prevOnRelease);
		prev.onReleaseOutside = Proxy.create(this, prevOnReleaseOutside);
		
		
		
		closeButton.onRollOver = Proxy.create(this, closeButtonOnRollOver);
		closeButton.onRollOut = Proxy.create(this, closeButtonOnRollOut);
		closeButton.onPress = Proxy.create(this, closeButtonOnPress);
		closeButton.onRelease = Proxy.create(this,closeButtonOnRelease);
		closeButton.onReleaseOutside = Proxy.create(this, closeButtonOnReleaseOutside);
		
		UCCommentsOver._alpha = 0;
		UCComments.onRollOver = Proxy.create(this, UCCommentsOnRollOver);
		UCComments.onRollOut = Proxy.create(this, UCCommentsOnRollOut);
		UCComments.onPress = Proxy.create(this, UCCommentsOnPress);
		UCComments.onRelease = Proxy.create(this, UCCommentsOnRelease);
		UCComments.onReleaseOutside = Proxy.create(this, UCCommentsOnReleaseOutside);
		
		
		UCCAddComment.onRollOver = Proxy.create(this, UCCAddCommentOnRollOver);
		UCCAddComment.onRollOut = Proxy.create(this, UCCAddCommentOnRollOut);
		UCCAddComment.onPress = Proxy.create(this, UCCAddCommentOnPress);
		UCCAddComment.onRelease = Proxy.create(this, UCCAddCommentOnRelease);
		UCCAddComment.onReleaseOutside = Proxy.create(this, UCCAddCommentOnReleaseOutside);
		
		
		//bgUCFill.onPress = Proxy.create(this, bgUCFillOnPress);
		
		rightHit = holder["rightHit"];
		
		leftHit = holder["leftHit"];
	}
	

	public function setNode(pNode:XMLNode, pSettingsObj:Object, pPopupMode:String, pPressedItem:MovieClip )
	{
		node = pNode;
		settingsObj = pSettingsObj;
		popupMode = pPopupMode;
		pressedItem = pPressedItem;
		
		outerBg._x = outerBg._y  = -6;
		outerBg._width = Math.round(6 + settingsObj.popupWidth + 6);
		outerBg._height = Math.round(6 + settingsObj.popupHeight + 6);
		
		innerStroke._width = settingsObj.popupWidth;
		innerStroke._height = settingsObj.popupHeight;
		
		innerFill._x = innerFill._y = 1;
		innerFill._width = Math.round(settingsObj.popupWidth - 2);
		innerFill._height = Math.round(settingsObj.popupHeight - 2);
		
			
		
		upControl._y = upControl._x = 31;
		bgUCStroke._width = Math.round(settingsObj.popupWidth - 31 - 31);
		bgUCFill._width = Math.round(bgUCStroke._width - 2);
		
		
		
		var commNode:Number = node.firstChild.nextSibling.attributes.commentsNumber;
		
		if (commNode!=0) {
			
			UCComments["txt"].text = settingsObj.commentsCaption;
			UCComments["leftSide"].text = settingsObj.commentsLeftSideCaption;
			UCComments["txtNumber"].text = commNode;
			UCComments["rightSide"].text = settingsObj.commentsRightSideCaption;
			
			UCComments["leftSide"]._x = Math.round(UCComments["txt"].textWidth + 4);
			UCComments["txtNumber"]._x = Math.round(UCComments["leftSide"]._x + UCComments["leftSide"].textWidth + 1);
			UCComments["rightSide"]._x = Math.round(UCComments["txtNumber"]._x + UCComments["txtNumber"].textWidth + 2);
			
			
			UCCommentsOver["txt"].text = settingsObj.commentsCaption;
			UCCommentsOver["leftSide"].text = settingsObj.commentsLeftSideCaption;
			UCCommentsOver["txtNumber"].text = commNode;
			UCCommentsOver["rightSide"].text = settingsObj.commentsRightSideCaption;
			
			UCCommentsOver["leftSide"]._x = Math.round(UCComments["txt"].textWidth + 4);
			UCCommentsOver["txtNumber"]._x = Math.round(UCComments["leftSide"]._x + UCComments["leftSide"].textWidth + 1);
			UCCommentsOver["rightSide"]._x = Math.round(UCComments["txtNumber"]._x + UCComments["txtNumber"].textWidth + 2);
		}
		else {
			UCComments._visible = false;
		}
			
		
		if (node.firstChild.nextSibling.attributes.enableAddComments==1) {
			normalAddComment["txt"].text = overAddComment["txt"].text = settingsObj.addCommentCaption;
			UCCAddComment._x =  Math.round(settingsObj.popupWidth - 40 - 40 - closeButton._width - UCCAddComment._width - 4);
		}
		else {
			UCCAddComment._visible = false;
		}
		
		if ((UCCAddComment._visible == false) && (UCComments._width == false)) {
			backToPost._visible = false;
		}
		else {
			backToPost["normal"]["txt"].text = backToPost["over"]["txt"].text = settingsObj.backToPostCaption;
			backToPost["over"]._alpha = 0;
			backToPost._x = 0;
			
			backToPost._visible = backToPost.enabled = false;
			
			backToPost.onRollOver = Proxy.create(this,backToPostOnRollOver);
			backToPost.onRollOut = backToPost.onRelease = backToPost.onReleaseOutside = Proxy.create(this, backToPostOnRollOut);
			backToPost.onPress = Proxy.create(this, backToPostOnPress);
		}
		
		topData._x = 40;
		topData._y = 80;
		
		topData["title"].autoSize = true;
		topData["title"]._width = Math.round(settingsObj.popupWidth - 40 - 40);
		topData["title"].text = node.attributes.title;
		
		
		topData["authorTxt"].autoSize = true;
		topData["authorTxt"].text = settingsObj.authorCaption;
		
		topData["author"].autoSize = true;
		topData["author"].text = node.attributes.author;
		
		var my_fmt:TextFormat = new TextFormat();
		my_fmt.bold = true;

		topData["author"].setTextFormat(my_fmt);
		
		topData["author"]._x = Math.round(topData["authorTxt"]._width + 4);
		
		topData["authorTxt"]._y = topData["author"]._y = Math.round(topData["title"].textHeight + 4);
		if(!_global.whitePresent){
			topData["authorTxt"]._y += 4
		}
		else {
			topData["authorTxt"]._y += 0
		}
		
		
		
		topData["onAllTxt"].autoSize = true;
		topData["onAllTxt"].text = settingsObj.dateCaption + "   " + node.attributes.date;
		
	
		topData["onAllTxt"]._y = topData["onn"]._y = Math.round(topData["author"]._y + topData["author"].textHeight + 4);
		
		
		var popupSettings:Object = new Object();
		popupSettings.w = Math.round(settingsObj.popupWidth - 40 - 40);
		popupSettings.h = Math.round(settingsObj.popupHeight - 80 - 30 - topData._height - 8 - 10);
	
		popupDetails = holder.attachMovie("IDpopupDetails", "popupDetails", holder.getNextHighestDepth());
		popupDetails._x = 40;  
		popupDetails._y = Math.round(80 + topData._height + 20);
		
		popupDetails.setNode(node, popupSettings, settingsObj);
		popupDetails.setDetails("description");
		
		bgUCFill.enabled = false;
		
		
		closeButton._x = Math.round(bgUCStroke._width - closeButton._width - 7 + 7);
		
		
		holder._alpha = settingsObj.animationAlpha;
		holder._xscale = settingsObj.animationScale;
		
		if (popupMode == "right") {
			holder._x = Stage.width;
		}
		else {
			holder._x = -Stage.width;
		}
		
		if (pressedItem.idx == pressedItem.theParent.totalItems) {
			next.enabled = false;
		}
		
		if (pressedItem.idx == 0) {
			prev.enabled = false;
		}
		
		leftHit._alpha = rightHit._alpha = 0;
		leftHit._x = -leftHit._width;
		rightHit._x = settingsObj.popupWidth + 6
		
		leftHit._height = rightHit._height = settingsObj.popupHeight;
		
		arrowsDefs = new Object();
		if (!_global.whitePresent) {
			next._x = arrowsDefs.nx = Math.round(settingsObj.popupWidth);
		}
		else {
			next._x = arrowsDefs.nx = Math.round(settingsObj.popupWidth - 1);
		}
		
		next._y = arrowsDefs.ny = 15;
		if (!_global.whitePresent) {
			prev._x = arrowsDefs.px = -Math.round(prev._width);
		}
		else {
			prev._x = arrowsDefs.px = -Math.round(prev._width);
		}
		
		prev._y = arrowsDefs.py = 15;
		
		
		
		
		myInterval3 = setInterval(this, "launchListener", 300);
		
		loadStageResize();
		
		showPopup();
		
		this._visible = true;
	}
	
		
			

	
	private function launchListener() {
		clearInterval(myInterval3);
		myInterval2 = setInterval(this, "moveArrows", 30);
		
	}
	private function moveArrows() {
		if (prev.enabled == true) {
			if ((this._xmouse < 0) && (this._xmouse > -leftHit._width) && (this._ymouse > 0) && (this._ymouse < leftHit._height)) {
				Tweener.addTween(prev, { _x:this._xmouse-prev._width / 2 - 4, _y:this._ymouse-prev._height / 2, time:.08, transition:"linear", rounded:true } );
			
			}
			else {
				if ((prev._x != arrowsDefs.px) || (prev._y != arrowsDefs.py)) {
					Tweener.addTween(prev, { _x:arrowsDefs.px, _y:arrowsDefs.py, time:.3, transition:"linear" } );
				}
			}
		}
		
		if (next.enabled == true) {
			if ((this._xmouse > innerFill._width) && (this._xmouse < innerFill._width +rightHit._width) && (this._ymouse > 0) && (this._ymouse < rightHit._height)) {
				Tweener.addTween(next, { _x:this._xmouse-next._width / 2 + 6, _y:this._ymouse-next._height / 2, time:.08, transition:"linear", rounded:true } );
			
			}
			else {
				if ((next._x != arrowsDefs.nx) || (next._y != arrowsDefs.ny)) {
					Tweener.addTween(next, { _x:arrowsDefs.nx, _y:arrowsDefs.ny, time:.3, transition:"linear" } );
				}
			}
		}
		
	}
	
	private function showPopup() {
		Tweener.addTween(holder, { _x:0, _xscale:100, _alpha:100, time:settingsObj.popupShowAnimationTime, transition:settingsObj.popupShowAnimationType } );
	}
	
	public function hidePopup(pPopupMode:String) {
		popupMode = pPopupMode;
		clearInterval(myInterval);
		
		if (popupMode == "right") {
			Tweener.addTween(holder, { _x: -Stage.width-40, _xscale:settingsObj.animationScale, _alpha:settingsObj.animationAlpha, 
										time:settingsObj.popupHideAnimationTime, transition:settingsObj.popupHideAnimationType } );
		}
		else {
			Tweener.addTween(holder, { _x: Stage.width, _xscale:settingsObj.animationScale, _alpha:settingsObj.animationAlpha, 
										time:settingsObj.popupHideAnimationTime, transition:settingsObj.popupHideAnimationType } );
		}
		
		myInterval = setInterval(this, "removeThis", settingsObj.popupHideAnimationTime * 1000);
		
	}
	
	private function removeThis() {
		clearInterval(myInterval);
		this.removeMovieClip();
	}
	
	private function resize(pW:Number, pH:Number) {
		if ((pW != oldpW) || (pH != oldpH)) {
			pW = Math.max(pW, _global.globalSettingsObj.templateMaxWidth);
			pH = Math.max(pH, _global.globalSettingsObj.templateMaxHeight);
			
			oldpW = pW;
			oldpH = pH;
			
			this._x = Math.round(pW / 2 - settingsObj.popupWidth / 2);
			this._y = Math.round(pH / 2 - settingsObj.popupHeight / 2);
			
		}
	}
	
	private function onResize() {
		resize(Stage.width, Stage.height);
	}
	
	private function loadStageResize() {
		Stage.addListener(this);
		onResize();
	}
	
	
	
	
	
	
	
	
		
	private function nextOnRollOver() {
		Tweener.addTween(next["over"], { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function nextOnRollOut() {
		Tweener.addTween(next["over"], { _alpha:0, time:.2, transition:"linear" } );
	}
	
	private function nextOnPress() {
		nextOnRollOut();
		dispatchEvent( { target:this, type:"nextPressed", mc:this } );
	}
	
	private function nextOnRelease() {
		nextOnRollOut()
	}
	
	private function nextOnReleaseOutside() {
		nextOnRelease();
	}
	
	
	
	
	
	
	private function prevOnRollOver() {
		Tweener.addTween(prev["over"], { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function prevOnRollOut() {
		Tweener.addTween(prev["over"], { _alpha:0, time:.2, transition:"linear" } );
	}
	
	private function prevOnPress() {
		prevOnRollOut();
		dispatchEvent( { target:this, type:"prevPressed", mc:this } );
	}
	
	private function prevOnRelease() {
		prevOnRollOut()
	}
	
	private function prevOnReleaseOutside() {
		prevOnRelease()
	}
	
	
	private function closeButtonOnRollOver() {
		Tweener.addTween(closeButtonOver, { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function closeButtonOnRollOut() {
		Tweener.addTween(closeButtonOver, { _alpha:0, time:.2, transition:"linear" } );
	}
	
	private function closeButtonOnPress() {
		dispatchEvent( { target:this, type:"closePressed", mc:this } );
	}
	
	private function closeButtonOnRelease() {
		closeButtonOnRollOut();
	}
	
	private function closeButtonOnReleaseOutside() {
		closeButtonOnRelease();
	}
	
	
	
	private function disableArrows() {
		
		Tweener.addTween(prev, { _alpha:0, time:.2, transition:"linear" } );
		Tweener.addTween(next, { _alpha:0, time:.2, transition:"linear" } );
		
		next.enabled = prev.enabled = false;
	}
	
	private function enableArrows() {
		Tweener.addTween(prev, { _alpha:100, time:.2, transition:"linear" } );
		Tweener.addTween(next, { _alpha:100, time:.2, transition:"linear" } );
		
		next.enabled = prev.enabled = true;
	}
	
	
	private function UCCommentsOnRollOver() {
		Tweener.addTween(UCCommentsOver, { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function UCCommentsOnRollOut() {
		Tweener.addTween(UCCommentsOver, { _alpha:0, time:.2, transition:"linear" } );
	}
	
	private function UCCommentsOnPress() {
		showBackToPost();
		
		hideComm();
		
		UCComments.enabled = false;
		
		UCCAddComment.enabled = true;
		UCCAddCommentOnRollOut();
			
		popupDetails.setDetails("comments");
		disableArrows();
	}
	
	private function UCCommentsOnRelease() {
		UCCommentsOnRollOut();
	}
	
	private function UCCommentsOnReleaseOutside() {
		UCCommentsOnRelease();
	}
	
	private function hideComm() {
		UCComments.enabled = false		
		Tweener.addTween(UCCommentsOver, { _alpha:0, time:.2, transition:"linear" } );
		Tweener.addTween(UCComments, { _alpha:0, time:.2, transition:"linear" } );
	}
	
	
	private function showComm() {
		UCComments.enabled = true;
		Tweener.addTween(UCComments, { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function hideAdd() {
		UCCAddComment.enabled = false;
		UCCAddCommentOnRollOut();
	}
	
	private function showAdd() {
		UCCAddComment.enabled = true;
		UCCAddCommentOnRollOut();
	}
	
	
	
	

	private function UCCAddCommentOnRollOver() {
		Tweener.addTween(overAddComment, { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function UCCAddCommentOnRollOut() {
		Tweener.addTween(overAddComment, { _alpha:0, time:.2, transition:"linear" } );
	}
	
	private function UCCAddCommentOnPress() {
		UCCAddComment.enabled = false;
		
		popupDetails.setDetails("contact");
		disableArrows();
		
		
		showBackToPost();
		hideComm()
	}
	
	private function UCCAddCommentOnRelease() {
		UCCAddCommentOnRollOut();
	}
	
	private function UCCAddCommentOnReleaseOutside() {
		UCCAddCommentOnRelease();
	}
	
	
	
	
	
	private function showBackToPost() {
		backToPost.enabled = true;
		backToPost._visible = true
		backToPostOnRollOut();
		Tweener.addTween(backToPost, { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function hideBackToPost() {
		backToPost.enabled = false;
		Tweener.addTween(backToPost, { _alpha:0, time:.2, transition:"linear", onComplete:Proxy.create(this, hideB) } );
		backToPostOnRollOut();
	}
	
	private function hideB() {
		backToPost._visible = false;
	}
	
	private function backToPostOnRollOver() {
		Tweener.addTween(backToPost["over"], { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function backToPostOnRollOut() {
		Tweener.addTween(backToPost["over"], { _alpha:0, time:.2, transition:"linear" } );
	}
	
	private function backToPostOnPress() {
		hideBackToPost();
		
		
		UCCAddComment.enabled = true;
		UCCAddCommentOnRollOut();
		
		UCComments.enabled = true;
		UCCommentsOnRollOut();
		
		enableArrows();
		
		popupDetails.setDetails("description");
		
		
		showComm();
	
		showAdd();
	}
}
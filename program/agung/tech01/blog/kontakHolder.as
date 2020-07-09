import ascb.util.Proxy;
import caurina.transitions.*;
import caurina.transitions.properties.TextShortcuts;
import agung.utils.UStr;

class agung.tech01.blog.kontakHolder extends MovieClip
{
	private var settingsObj:Object;
	private var globalSettings:Object;
	
	public var node:XMLNode;

	private var title:MovieClip;
	
	private var fields:MovieClip;
		private var name:MovieClip;
			private var nameInput:MovieClip;
			private var nameCaption:MovieClip;
			
	
		private var email:MovieClip;
			private var emailInput:MovieClip;
			private var emailCaption:MovieClip;
			
		private var mes:MovieClip;
			private var mesInput:MovieClip;
			private var mesCaption:MovieClip;
		
		private var status:MovieClip;
	private var sendButton:MovieClip;
	
	private var lv:LoadVars;
	
	private var myInterval:Number;
	
	public function kontakHolder() {
		this._visible = false;
		TextShortcuts.init();
		
		fields._y = 2;
		name = fields["name"];
		nameInput = name["input"];
		nameCaption = name["caption"];
		
		email = fields["email"];
		emailInput = email["input"];
		emailCaption = email["caption"];
		
		mes = fields["mes"];
		mesInput = mes["input"];
		mesCaption = mes["caption"];
		
		title["txt"].autoSize = true;
		title["txt"].wordWrap = false;
		
		lv = new LoadVars();
		lv.onLoad = Proxy.create(this, varsLoaded);
		
		TextField.prototype.setText2 = function(s:String) {
			Tweener.addTween(this, {_text:s, time:1, transition:"easeoutquad"});
		};
		
		TextField.prototype.getText2 = function() {
			return this.text;
		};
		
		TextField.prototype.addProperty("text2", TextField.prototype.getText2, TextField.prototype.setText2);
		
	}
	
	public function setNode(pNode:XMLNode, pSettings:Object, pGlobalSettings:Object){
		node = pNode;
		settingsObj = pSettings;
		globalSettings = pGlobalSettings;
	
		title["txt"].text = globalSettings.contactTitle;
		fields._y = Math.ceil(title._height);
		
		var maxCaptionWidth:Number = 130;
		
		name["caption"]["over"]._alpha = 0;
		name["caption"]["normal"]["caption"].autoSize = name["caption"]["over"]["caption"].autoSize = true;
		name["caption"]["normal"]["caption"].text = name["caption"]["over"]["caption"].text = globalSettings.contactNameCaption;
		
		nameInput._x = Math.ceil(maxCaptionWidth);
		nameInput["bg"]["normal"]._width = nameInput["bg"]["over"]._width = Math.ceil(settingsObj.w - nameInput._x - 2);
		nameInput["txt"]._width = Math.ceil(nameInput["bg"]._width - 12);
		nameInput["bg"]["over"]._alpha = 0;
		
		email["caption"]["over"]._alpha = 0;
		email["caption"]["normal"]["caption"].autoSize = email["caption"]["over"]["caption"].autoSize = true;
		email["caption"]["normal"]["caption"].text = email["caption"]["over"]["caption"].text = globalSettings.contactEmailCaption;
		emailInput._x = Math.ceil(maxCaptionWidth);
		emailInput["bg"]["normal"]._width = emailInput["bg"]["over"]._width = Math.ceil(settingsObj.w - emailInput._x - 2);
		emailInput["txt"]._width = Math.ceil(emailInput["bg"]._width - 12);
		email._y = Math.ceil(name._y + name._height + 8);
		emailInput["bg"]["over"]._alpha = 0;
		
		mes["caption"]["over"]._alpha = 0;
		mes["caption"]["normal"]["caption"].autoSize = mes["caption"]["over"]["caption"].autoSize = true;
		mes["caption"]["normal"]["caption"].text = mes["caption"]["over"]["caption"].text = globalSettings.contactMessageCaption;
		mesInput._x = Math.ceil(maxCaptionWidth);
		mesInput["bg"]["normal"]._width = mesInput["bg"]["over"]._width = Math.ceil(settingsObj.w - mesInput._x - 2);
		mesInput["txt"]._width = Math.ceil(mesInput["bg"]._width - 12);
		mes._y = Math.ceil(email._y + email._height + 8);
		mesInput["bg"]["over"]._alpha = 0;
		
		sendButton._y = Math.round(mes._y + mes._height + 8 + fields._y);
		sendButton._x = mesInput._x;
		sendButton["txt"].autoSize = true;
		sendButton["txt"].text = globalSettings.contactSendButtonCaption;
		sendButton["bg"]["normal"]._width = sendButton["bg"]["over"]._width = Math.ceil(8 + sendButton["txt"].textWidth + 17);
		
		sendButton["txt2"].autoSize = true;
		sendButton["txt2"].text = globalSettings.contactSendButtonCaption;
		sendButton["txt2"]._alpha = 0;
		
		status["txt"].autoSize = true;
		status["txt"].wordWrap = true;
		status._x = Math.ceil(sendButton._x + sendButton._width + 10);
		status._y = Math.ceil(sendButton._y - 2 );
		status["txt"]._width = Math.ceil(settingsObj.w - status._x - 2);
		
		sendButton["bg"]["over"]._alpha = 0;
		sendButton.onRollOver = Proxy.create(this, sendButtonOnRollOver);
		sendButton.onRollOut = Proxy.create(this, sendButtonOnRollOut);
		sendButton.onPress = Proxy.create(this, sendButtonOnPress);
		sendButton.onRelease = Proxy.create(this, sendButtonOnRelease);
		sendButton.onReleaseOutside = Proxy.create(this, sendButtonOnReleaseOutside);
		
		nameInput["txt"].text = "";
		emailInput["txt"].text = "";
		mesInput["txt"].text = "";
			
		nameInput["txt"].onSetFocus =  Proxy.create(this, onFocusName);
		emailInput["txt"].onSetFocus =  Proxy.create(this, onFocusEmail);
		mesInput["txt"].onSetFocus =  Proxy.create(this, onFocusMes);
		
		nameInput["txt"].onKillFocus =  Proxy.create(this, onKillFocusName);
		emailInput["txt"].onKillFocus =  Proxy.create(this, onKillFocusEmail);
		mesInput["txt"].onKillFocus =  Proxy.create(this, onKillFocusMes);
		
		nameInput["txt"].tabIndex = 0;
		emailInput["txt"].tabIndex = 1;
		mesInput["txt"].tabIndex = 2;
		
	
		this._visible = true;
	}
	
	private function onFocusName() {
		
		Tweener.addTween(nameInput["bg"]["over"], { _alpha:100, time:.2, transition:"linear" } );
		Tweener.addTween(name["caption"]["over"], { _alpha:100, time:.2, transition:"linear" } );
		Stage.displayState = "normal";
		
		if (_global.whitePresent) {
			Tweener.addTween(nameInput["txt"], { _alpha:100, time:.2, transition:"linear" } );
		}

	}
	
	private function onFocusEmail() {
		Tweener.addTween(email["caption"]["over"], { _alpha:100, time:.2, transition:"linear" } );
		Tweener.addTween(emailInput["bg"]["over"], { _alpha:100, time:.2, transition:"linear" } );
		Stage.displayState = "normal";
				if (_global.whitePresent) {
			Tweener.addTween(emailInput["txt"], { _alpha:100, time:.2, transition:"linear" } );
		}

	
	}
	
	private function onFocusMes() {
		Tweener.addTween(mesInput["bg"]["over"], { _alpha:100, time:.2, transition:"linear" } );
		Tweener.addTween(mes["caption"]["over"], { _alpha:100, time:.2, transition:"linear" } );
		Stage.displayState = "normal";
		if (_global.whitePresent) {
			Tweener.addTween(mesInput["txt"], { _alpha:100, time:.2, transition:"linear" } );
		}
	}
	
	
	
	
	private function onKillFocusName() {
		Tweener.addTween(nameInput["bg"]["over"], { _alpha:0, time:.2, transition:"linear" } );
		Tweener.addTween(name["caption"]["over"], { _alpha:0, time:.2, transition:"linear" } );
			if (_global.whitePresent) {
			Tweener.addTween(nameInput["txt"], { _alpha:70, time:.2, transition:"linear" } );
		}
	}
	
	private function onKillFocusEmail() {
		Tweener.addTween(email["caption"]["over"], { _alpha:0, time:.2, transition:"linear" } );
		Tweener.addTween(emailInput["bg"]["over"], { _alpha:0, time:.2, transition:"linear" } );
			if (_global.whitePresent) {
			Tweener.addTween(emailInput["txt"], { _alpha:70, time:.2, transition:"linear" } );
		}
	}
	
	private function onKillFocusMes() {
		Tweener.addTween(mesInput["bg"]["over"], { _alpha:0, time:.2, transition:"linear" } );
		Tweener.addTween(mes["caption"]["over"], { _alpha:0, time:.2, transition:"linear" } );
		if (_global.whitePresent) {
			Tweener.addTween(mesInput["txt"], { _alpha:70, time:.2, transition:"linear" } );
		}
	}
	
	private function varsLoaded(s:Boolean) {
		if (!s) {
			unBlockFields();
			status["txt"].text2 = globalSettings.failText;
		}
		else {
			unBlockFields(1);
		}
	}
	
	private function unBlockFields(how:Number) {
		sendButton.enabled = true;

		if (how == 1) {
			clearInterval(myInterval)
			myInterval = setInterval(this, "waitABit", 3000);
			
			nameInput["txt"].text2 = "";
			emailInput["txt"].text2 = "";
			mesInput["txt"].text2 = "";
		}
		else {
			nameInput["txt"].type = "input";
			emailInput["txt"].type = "input";
			mesInput["txt"].type = "input";
		}
	}
	
	private function waitABit() {
		status["txt"].text2 = globalSettings.succesText;
		clearInterval(myInterval)
		myInterval = setInterval(this, "resetFields", 3000);
	}
	
	private function resetFields() {
		clearInterval(myInterval);
		sendButton.enabled = true;
		
		nameInput["txt"].type = "input";
		emailInput["txt"].type = "input";
		mesInput["txt"].type = "input";
	}
	
	private function startSend() {
		sendButton.enabled = false;
		nameInput["txt"].type = "dynamic";
		emailInput["txt"].type = "dynamic";
		mesInput["txt"].type = "dynamic";
		checkFields();
	}
	
	private function checkFields() {
		if ((globalSettings.toggleContactNameRequired == 1) && ((nameInput["txt"].text == "") || (nameInput["txt"].text == " "))) {
			status["txt"].text2 = globalSettings.wrongNameText;
			unBlockFields();
			return;
		}
		
		if (!UStr.isEmail(emailInput["txt"].text)) {
			status["txt"].text2 = globalSettings.wrongEmailText;
			unBlockFields();
			return;
		}
		
		
		
		if ((globalSettings.toggleContactMessageRequired == 1) && ((mesInput["txt"].text == "") || (mesInput["txt"].text == " "))) {
			status["txt"].text2 = globalSettings.wrongMessageText;
			unBlockFields();
			return;
		}
		
		status["txt"].text2 = globalSettings.sendingMessageText;
		
		lv["name"] = nameInput["txt"].text;
		lv["email"] = emailInput["txt"].text;
		lv["message"] = mesInput["txt"].text;
		lv["orderId"] = node.attributes.orderId;
		
	
		lv.sendAndLoad(globalSettings.script, lv, "POST");
	}
	
private function sendButtonOnRollOver() {
		Tweener.addTween(sendButton["bg"]["over"], { _alpha:100, time:.2, transition:"linear" } );
		Tweener.addTween(sendButton["txt2"], { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function sendButtonOnRollOut() {
		Tweener.addTween(sendButton["bg"]["over"], { _alpha:0, time:.2, transition:"linear" } );
		Tweener.addTween(sendButton["txt2"], { _alpha:0, time:.2, transition:"linear" } );
	}
	
	private function sendButtonOnPress() {
		sendButton.enabled = false;
		checkFields();
	}
	
	private function sendButtonOnRelease() {
		sendButtonOnRollOut();
	}
	
	private function sendButtonOnReleaseOutside() {
		sendButtonOnRelease();
	}
}
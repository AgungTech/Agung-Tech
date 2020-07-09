
import ascb.util.Proxy;
import caurina.transitions.*;
import caurina.transitions.properties.TextShortcuts;
import agung.utils.UStr;
import flash.net.FileReference;

class agung.tech01.karir.kontakHolder extends MovieClip
{
	private var settingsObj:Object;
	private var globalSettings:Object;
	
	private var title:MovieClip;
	
	public var node:XMLNode;

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
			
		private var phone:MovieClip;
			private var phoneInput:MovieClip;
			private var phoneCaption:MovieClip;
			
		private var status:MovieClip;
	private var sendButton:MovieClip;
	
	private var lv:LoadVars;
	
	private var myInterval:Number;
	private var fr:FileReference;	
	private var attachButton:MovieClip;
	
	private var allTypes:Array;
	private var allowedExt:Array;
	
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
		
		phone = fields["phone"];
		phoneInput = phone["input"];
		phoneCaption = phone["caption"];
		
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
	
	/**
	 * This function gets the .xml node and sets up all the settings
	 */
	public function setNode(pNode:XMLNode, pSettings:Object, pGlobalSettings:Object){
		node = pNode;
		settingsObj = pSettings;
		globalSettings = pGlobalSettings;
	
		title["txt"].text = globalSettings.contactTitle;
		fields._y = Math.ceil(title._height + 8);
		
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
		
		
		phone["caption"]["over"]._alpha = 0;
		phone["caption"]["normal"]["caption"].autoSize = phone["caption"]["over"]["caption"].autoSize = true;
		phone["caption"]["normal"]["caption"].text = phone["caption"]["over"]["caption"].text = globalSettings.contactPhoneCaption;
		phoneInput._x = Math.ceil(maxCaptionWidth);
		phoneInput["bg"]["normal"]._width = phoneInput["bg"]["over"]._width = Math.ceil(settingsObj.w - phoneInput._x - 2);
		phoneInput["txt"]._width = Math.ceil(phoneInput["bg"]._width - 12);
		phone._y = Math.ceil(email._y + email._height + 8);
		phoneInput["bg"]["over"]._alpha = 0;
		
		mes["caption"]["over"]._alpha = 0;
		mes["caption"]["normal"]["caption"].autoSize = mes["caption"]["over"]["caption"].autoSize = true;
		mes["caption"]["normal"]["caption"].text = mes["caption"]["over"]["caption"].text = globalSettings.contactMessageCaption;
		mesInput._x = Math.ceil(maxCaptionWidth);
		mesInput["bg"]["normal"]._width = mesInput["bg"]["over"]._width = Math.ceil(settingsObj.w - mesInput._x - 2);
		mesInput["txt"]._width = Math.ceil(mesInput["bg"]._width - 12);
		mes._y = Math.ceil(phone._y + phone._height + 8);
		mesInput["bg"]["over"]._alpha = 0;
		
		sendButton._y = Math.round(mes._y + mes._height + 8 + fields._y);
		sendButton._x = mesInput._x;
		sendButton["txt"].autoSize = true;
		sendButton["txt"].text = globalSettings.contactSendButtonCaption;
		sendButton["bg"]["normal"]._width = sendButton["bg"]["over"]._widthMath.ceil(8 + sendButton["txt"].textWidth + 17);
		
			
		sendButton["txt2"].autoSize = true;
		sendButton["txt2"].text = globalSettings.contactSendButtonCaption;
		sendButton["txt2"]._alpha = 0;
	
		
		status["txt"].autoSize = true;
		status["txt"].wordWrap = true;
		status._x = Math.ceil(sendButton._x + sendButton._width + 4);
		status._y = Math.ceil(sendButton._y - 2 );
		status["txt"]._width = Math.ceil(settingsObj.w - status._x - 2);
		
		sendButton["bg"]["over"]._alpha = 0;
		sendButton.onRollOver = Proxy.create(this, sendButtonOnRollOver);
		sendButton.onRollOut = Proxy.create(this, sendButtonOnRollOut);
		sendButton.onPress = Proxy.create(this, sendButtonOnPress);
		sendButton.onRelease = Proxy.create(this, sendButtonOnRelease);
		sendButton.onReleaseOutside = Proxy.create(this, sendButtonOnReleaseOutside);
		
		phoneInput["txt"].restrict = "0-9 - \\- +  ( ) [ ] /";


		
		nameInput["txt"].text = "";
		emailInput["txt"].text = "";
		phoneInput["txt"].text = "";
		mesInput["txt"].text = "";
			
		nameInput["txt"].onSetFocus =  Proxy.create(this, onFocusName);
		emailInput["txt"].onSetFocus =  Proxy.create(this, onFocusEmail);
		phoneInput["txt"].onSetFocus =  Proxy.create(this, onFocusPhone);
		mesInput["txt"].onSetFocus =  Proxy.create(this, onFocusMes);
		
		nameInput["txt"].onKillFocus =  Proxy.create(this, onKillFocusName);
		emailInput["txt"].onKillFocus =  Proxy.create(this, onKillFocusEmail);
		phoneInput["txt"].onKillFocus =  Proxy.create(this, onKillFocusPhone);
		mesInput["txt"].onKillFocus =  Proxy.create(this, onKillFocusMes);
		
		nameInput["txt"].tabIndex = 0;
		emailInput["txt"].tabIndex = 1;
		phoneInput["txt"].tabIndex = 2;
		mesInput["txt"].tabIndex = 3;
		
		if (globalSettings.enableUploadButton == 0) {
			attachButton._visible = false;
		}
		else {
			attachButton._y = Math.round(sendButton._y);
			attachButton["txt"].autoSize = true;
			attachButton["txt"].text = globalSettings.uploadResumeCaptionOnPopup;
			attachButton["bg"]["normal"]._width = attachButton["bg"]["over"]._width = Math.ceil(8 + attachButton["txt"].textWidth + 8 + 8 + 6);
			attachButton._x = Math.ceil(sendButton._x + mesInput["bg"]._width - attachButton["bg"]._width)
			
			attachButton["txt2"].autoSize = true;
			attachButton["txt2"].text = globalSettings.uploadResumeCaptionOnPopup;
			attachButton["txt2"]._alpha = attachButton["ar2"]._alpha = 0;
		
			
			attachButton["bg"]["over"]._alpha = 0;
			
		
			attachButton.onRollOver = Proxy.create(this,attachButtonOnRollOver);
			attachButton.onRollOut = Proxy.create(this, attachButtonOnRollOut);
			attachButton.onPress = Proxy.create(this, attachButtonOnPress);
			attachButton.onRelease = Proxy.create(this, attachButtonOnRelease);
			attachButton.onReleaseOutside = Proxy.create(this, attachButtonOnReleaseOutside);
			
			fr = new FileReference();
			fr.addListener(this);
			
			allTypes = new Array();
			var imageTypes:Object = new Object();
			
			
			allowedExt = globalSettings.allowedExtensionsForUpload.split("|");
			var allExts:String = "";
			var theBasDes:String = globalSettings.descriptionForUploadFileTypes + " ";
			for (var tt:Number = 0; tt < allowedExt.length; tt++) {
				allExts += "*." + allowedExt[tt];
				theBasDes += allowedExt[tt];
				if ((tt + 1) != allowedExt.length) {
					theBasDes += ", ";
				}
				allExts += ";";
			}


			imageTypes.description = theBasDes;
			imageTypes.extension = allExts;
			
			allTypes.push(imageTypes);
			
			status._y = Math.ceil(sendButton._y + sendButton._height + 2);
			status._x = Math.ceil(sendButton._x);
			
		}
		
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
	
	private function onFocusPhone() {
		Tweener.addTween(phone["caption"]["over"], { _alpha:100, time:.2, transition:"linear" } );
		Tweener.addTween(phoneInput["bg"]["over"], { _alpha:100, time:.2, transition:"linear" } );
		Stage.displayState = "normal";
		if (_global.whitePresent) {
			Tweener.addTween(phoneInput["txt"], { _alpha:100, time:.2, transition:"linear" } );
		}
	}
	
	private function onFocusMes() {
		Tweener.addTween(mes["caption"]["over"], { _alpha:100, time:.2, transition:"linear" } );
		Tweener.addTween(mesInput["bg"]["over"], { _alpha:100, time:.2, transition:"linear" } );
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
		Tweener.addTween(emailInput["bg"]["over"], { _alpha:0, time:.2, transition:"linear" } );
		Tweener.addTween(email["caption"]["over"], { _alpha:0, time:.2, transition:"linear" } );
		if (_global.whitePresent) {
			Tweener.addTween(emailInput["txt"], { _alpha:70, time:.2, transition:"linear" } );
		}
	}
	
	private function onKillFocusPhone() {
		Tweener.addTween(phone["caption"]["over"], { _alpha:0, time:.2, transition:"linear" } );
		Tweener.addTween(phoneInput["bg"]["over"], { _alpha:0, time:.2, transition:"linear" } );
		if (_global.whitePresent) {
			Tweener.addTween(phoneInput["txt"], { _alpha:70, time:.2, transition:"linear" } );
		}
	}
	
	
	private function onKillFocusMes() {
		Tweener.addTween(mes["caption"]["over"], { _alpha:0, time:.2, transition:"linear" } );
		Tweener.addTween(mesInput["bg"]["over"], { _alpha:0, time:.2, transition:"linear" } );
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
			
			fr.name = null;
			nameInput["txt"].text2 = "";
			emailInput["txt"].text2 = "";
			phoneInput["txt"].text2 = "";
			mesInput["txt"].text2 = "";
		}
		else {
			nameInput["txt"].type = "input";
			emailInput["txt"].type = "input";
			phoneInput["txt"].type = "input";
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
		phoneInput["txt"].type = "input";
		mesInput["txt"].type = "input";
	}
	
	private function startSend() {
		sendButton.enabled = false;
		nameInput["txt"].type = "dynamic";
		emailInput["txt"].type = "dynamic";
		mesInput["txt"].type = "dynamic";
		phoneInput["txt"].type = "dynamic";
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
		
		if ((globalSettings.togglePhoneRequired == 1) && ((phoneInput["txt"].text == "") || (phoneInput["txt"].text == " "))) {
			status["txt"].text2 = globalSettings.wrongPhoneText;
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
		lv["phone"] = phoneInput["txt"].text;
		lv["message"] = mesInput["txt"].text;
		lv["orderId"] = node.attributes.orderId;
		lv["file"] = fr.name == null ? "nofile" : fr.name;
			
		
		lv.sendAndLoad(globalSettings.script, lv, "POST");
	}
	
	private function onCancel() {
		if (fr.name != null) {
			onSelect();
		}
		else {
			status["txt"].text2 = "";
		}
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
		if (fr.name != null) {
			fr.upload(globalSettings.uploadScript);
		}
		else {
			checkFields();
		}
	}
	
	private function sendButtonOnRelease() {
		sendButtonOnRollOut();
	}
	
	private function sendButtonOnReleaseOutside() {
		sendButtonOnRelease();
	}
	
	
	
	
	private function onSelect() {
			var myYArr2:Array = fr.name.split(".");
			var found:Number = 0;
			
	
			var theBasDes:String = globalSettings.wrongExtensionAlert + " ";
			
			for (var tt:Number = 0; tt < allowedExt.length; tt++) {
				
				if (myYArr2[myYArr2.length - 1] == allowedExt[tt]) {
					found = 1;
				}
				
				theBasDes += allowedExt[tt];
				if ((tt + 1) != allowedExt.length) {
					theBasDes += ", ";
				}
			}
			
		if (found == 1) {
			status["txt"].text2 = fr.name + " ( " + String(Math.round(fr.size / 102.4) / 10) + " KB ) ";
		}
		else {
			fr.name = null;
			status["txt"].text2 = theBasDes;
		}
	}
	
	private function onHTTPError() {
		status["txt"].text2 = "( onHTTPError ) Tidak bisa Upload file. Tolong, ulangi lain waktu";
		checkFields();
	
	}
		
	private function onIOError() {
		status["txt"].text2 = "( onHTTPError ) Tidak bisa Upload file. Tolong, ulangi lain waktu";
		checkFields();
	
	}
	
	private function onProgress(xxx, bl, bt) {
		var per = "";
		if (!isNaN(bl) && !isNaN(bt) && bt>0) {
			per = String(Math.floor(100*bl/bt))+"%";
		}
	
		status["txt"].text = "Sedang di Upload. Silangkan tunggu . . . " + per;
	}
	
	private function onComplete() {
		startSend()
	}
	
	private function attachButtonOnRollOver() {
		Tweener.addTween(attachButton["bg"]["over"], { _alpha:100, time:.2, transition:"linear" } );
		Tweener.addTween(attachButton["txt2"], { _alpha:100, time:.2, transition:"linear" } );
		Tweener.addTween(attachButton["ar2"], { _alpha:100, time:.2, transition:"linear" } );
	}
	
	private function attachButtonOnRollOut() {
		Tweener.addTween(attachButton["bg"]["over"], { _alpha:0, time:.2, transition:"linear" } );
		Tweener.addTween(attachButton["txt2"], { _alpha:0, time:.2, transition:"linear" } );
		Tweener.addTween(attachButton["ar2"], { _alpha:0, time:.2, transition:"linear" } );
	}
	
	private function attachButtonOnPress() {
		attachButtonOnRollOut()
		status["txt"].text2 = globalSettings.attachButtonBrowsingCaption;
		fr.browse(allTypes);
	}
	
	private function attachButtonOnRelease() {
		attachButtonOnRollOut();
	}
	
	private function attachButtonOnReleaseOutside() {
		attachButtonOnRelease();
	}

}
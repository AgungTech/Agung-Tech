/* @last_update: 06/29/2015 (mm/dd/yyyy) */

import agung.utils.UFunc;
import agung.utils.UObj;
 
class agung.utils.UMenu {
	private function UMenu() { trace("Kelas statik. Tidak dapat diInstantiasikan.") }
	
	/* Add context menu to a MovieClip. 
	 * MenuData item: {caption:String, data:Object, separatorBefore:Boolean, enabled:Boolean, visible:Boolean} */
	public static function addMenu(mc:MovieClip, menuData:Array, handler:Function, scope:Object, hideBuiltInItems:Boolean):Void {
		var cm:ContextMenu = new ContextMenu();
		if (UObj.valueOrAlt(hideBuiltInItems, true)) cm.hideBuiltInItems();
		
		var n:Number = UObj.valueOrAlt(menuData.length, 0);
		for (var i:Number = 0; i < n; i++) {
			var mid:Object 			= menuData[i];
			var cmi:ContextMenuItem = new ContextMenuItem();			
			cmi.caption				= UObj.valueOrAlt(mid.caption, "<caption_not_set>");
			cmi.separatorBefore 	= UObj.valueOrAlt(mid.separatorBefore, false);
			cmi.enabled 			= UObj.valueOrAlt(mid.enabled, true);
			cmi.visible 			= UObj.valueOrAlt(mid.visible, true);			
			cmi.onSelect 			= UFunc.delegate(scope, handler, mid.data);
			cm.customItems.push(cmi);
		}
		mc.menu = cm;
	}
	/* Clear MovieClip context menu. */
	public static function clearMenu(mc:MovieClip):Void {
		addMenu(mc);
	}
}
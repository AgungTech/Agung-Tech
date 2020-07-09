import agung.utils.UTf;
import agung.utils.UStr;

/**
 * This class handles the top shop preview item
 */

class agung.tech01.main_l.shopPreviewItem extends MovieClip
{
	private var holder:MovieClip;
	
	private var bg:MovieClip;
	
	private var whitePresent:MovieClip;
	
	public function shopPreviewItem() {
		holder["title"].autoSize = true;
		holder["title"].wordWrap = false;
		
		UTf.initTextArea(holder["price"]);
		
		holder["total"].autoSize = true;
		holder["total"].wordWrap = false;
	}
	

	public function setData(pItem:Object) {
		holder["title"].text = pItem.name;
		UStr.truncate(holder["title"], 35, " ...");
		
		holder["price"]._x = Math.ceil(bg._width - 160);
		
		var str:String = "";
		
		var thePriceActualText:String = "";
		var g:Number = 0;
		
		if (_global.cartSettings.currencyPosition == "after") {
			if (!whitePresent) {
				str += "<font color='#b2b2b2'><b>" + pItem.price + "</b></font>";
				str += "<font color='#b2b2b2'><b>" + _global.cartSettings.currency + "</b></font>";
				str += "<font color='#717171'> x " + pItem.quantity + "</font>";
			}
			else {
				str += "<font color='#5b5b5b'><b>" + pItem.price + "</b></font>";
				str += "<font color='#5b5b5b'><b>" + _global.cartSettings.currency + "</b></font>";
				str += "<font color='#858585'> x " + pItem.quantity + "</font>";
			}
			
			g = 1;
			
		}
		else {
			if (!whitePresent) {
				str += "<font color='#b2b2b2'><b>" + _global.cartSettings.currency + "</b></font>";
				str += "<font color='#b2b2b2'><b>" + pItem.price + "</b></font>";
				str += "<font color='#717171'> x " + pItem.quantity + "</font>";
			}
			else {
				str += "<font color='#5b5b5b'><b>" + _global.cartSettings.currency + "</b></font>";
				str += "<font color='#5b5b5b'><b>" + pItem.price + "</b></font>";
				str += "<font color='#858585'> x " + pItem.quantity + "</font>";
			}
			
			
			
		}
		
		holder["price"].htmlText = str;
		
		holder["total"]._x = Math.ceil(bg._width - 70);
		if (g == 1) {
			holder["total"].text = pItem.price * pItem.quantity + "" + _global.cartSettings.currency;
		}
		else {
			holder["total"].text =  _global.cartSettings.currency + "" +pItem.price * pItem.quantity;
		}
		
		
		var my_fmt:TextFormat = new TextFormat();
		my_fmt.bold = true;

		holder["total"].setTextFormat(my_fmt);
	}
}
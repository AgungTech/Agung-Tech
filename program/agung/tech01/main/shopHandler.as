import agung.utils.UArray;
import agung.utils.UCookie;

/**
 * This class handles the shop data
 * Here, the data is being placed and extracted from the cookies
 * In any shop or cart module, if you remove or add an item, this class will handle it and at the same
 * time call other function to update everything inside the template
 * The data is being stored in the coockies immediately
 */
class agung.tech01.main.shopHandler extends MovieClip
{
	public var itemsToPurchase:Array;
	
	public function shopHandler() {
		itemsToPurchase = new Array();
	
		_global.totalCost = 0;
	}
	
	public function deleteAllData() {
		UCookie.deleteCookie("productList");
		itemsToPurchase = new Array();
		UCookie.setCookie("productList", itemsToPurchase);
	}
	
	public function init() {
		itemsToPurchase = getCurrentList();
		calculateTotalCost();
		
	}
	
	//_global.shopHandler
	public function addNewItemToCart(theItem:Object) {
		// name, price, quantity, id
	
		if (UArray.indexOf(itemsToPurchase, theItem.id) == -1) {
			itemsToPurchase.push(theItem);
			calculateTotalCost();
		}
		else {
			updateQuantityOnPopup(theItem);
		}
	}
	
	public function removeItemFromCart(theItem:Object) {
		UCookie.deleteCookie("productList");
		UArray.remove(itemsToPurchase, theItem.id);
		UCookie.setCookie("productList", itemsToPurchase);
		
		calculateTotalCost();
	}
	
	public function updateQuantityOnPopup(theItem:Object) {
		var idx:Number = 0;
		while (itemsToPurchase[idx]) {
			var currentId:String = itemsToPurchase[idx].id;
			
			if (currentId == theItem.id) {
				itemsToPurchase[idx].quantity++;
				break;
			}
			
			idx++;
		}
		
		calculateTotalCost();
	}
	
	public function updateQuantity(theItem:Object) {
		var idx:Number = 0;
		while (itemsToPurchase[idx]) {
			var currentId:String = itemsToPurchase[idx].id;
			
			if (currentId == theItem.id) {
				itemsToPurchase[idx].quantity = theItem.quantity;
				break;
			}
			
			idx++;
		}
		
		calculateTotalCost();
	}
	
	public function calculateTotalCost() {
		var idx:Number = 0;
		_global.totalCost = 0;
		
		while (itemsToPurchase[idx]) {
			var currentPrice:Number = itemsToPurchase[idx].price;
			var currentQuantity:Number = itemsToPurchase[idx].quantity;
			
			_global.totalCost += (currentPrice * currentQuantity);
			idx++;
		}
		

		UCookie.deleteCookie("productList");
		UCookie.setCookie("productList", itemsToPurchase);
		
		_global.totalSumCartDisplay.updateTotal();
		_global.theTopShopPreview.updateItems();
		_global.theBottomShopPreview.updateItems();
	}
	
	public function getCurrentList() {
		var fromCuchie:Object = UCookie.getCookie("productList");
		
		var idx:Number = 0;
		var pItemsToPurchase:Array = new Array();
		while (fromCuchie[idx]) {
			var currentPrice:Number = fromCuchie[idx].price;
			var currentQuantity:Number = fromCuchie[idx].quantity;
			var currentId:String = fromCuchie[idx].id;
			var currentName:String = fromCuchie[idx].name;
			var obj:Object = new Object();
			obj.name = currentName;
			obj.id = currentId;
			obj.quantity = currentQuantity;
			obj.price = currentPrice;
			
			pItemsToPurchase.push(obj);
			
			idx++;
		}
		
		
		return pItemsToPurchase;
	}
}
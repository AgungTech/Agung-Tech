/* @last_update: 06/29/2015 (mm/dd/yyyy) */

class agung.utils.UFunc {
	private function UFunc() { trace("Kelas statik. Tidak dapat diInstantiasikan.") }
	
	/* Function Delegate with arguments
	 * Utils.Delegate(scope, funcName, arg1, arg2, ...);
	 * Returns a function reference with the specified scope. */
	public static function delegate(scope:Object, funcName:Function):Function {
		if (scope == undefined || funcName == undefined) return new Function();
		
		var f:Function = function ():Void {
			var o:Object = arguments.callee;
			o["funcName"].apply(o["scope"], o["args"].concat(arguments));
		};		
		f["funcName"] 	= funcName;
		f["scope"] 		= scope;
		f["args"] 		= arguments.slice(2);
		
		return f;
	}
	/* Call function after given number of seconds.
	 * You can add arguments at the end. */
	public static function timedCall(scope:Object, funcName:Function, callDelay:Number):Number {
		if (funcName == undefined || isNaN(callDelay)) return null;
		
		var f:Function = function ():Void {
			var o:Object = arguments.callee;
			o["funcName"].apply(o["scope"], o["args"].concat(arguments));
		};		
		f["funcName"] 	= funcName;
		f["scope"] 		= scope;
		f["args"] 		= arguments.slice(3);
		return _global.setTimeout(f, callDelay * 1000);
	}
	/* Clear timed function call. */
	public static function clearTimedCall(id:Number):Void {
		_global.clearTimeout(id);
	}
}
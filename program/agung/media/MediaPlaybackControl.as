/* @last_update: 06/29/2015 (mm/dd/yyyy) */

class agung.media.MediaPlaybackControl {	
	private var SndOb:Sound;
	private var SndMc:MovieClip;
	
	private var $ready:Boolean;
	private var $playing:Boolean;
	private var $buffering:Boolean;		
	private var $autoPlay:Boolean;
	private var $repeat:Boolean;	
	private var $mute:Boolean;	
	private var $volume:Number;	
	private var $media:String;		
	private var $totalTime:Number;
	private var $currentTime:Number;	
	private var $totalBytes:Number;
	private var $loadedBytes:Number;
	private var $bufferTime:Number;	
	private var $listeners:Array;	
	
	private var $loaded:Boolean = false;
	
	private var $eventsChk:Number;
	private var $events:Array;
	
	/* Called when loading updates. */ 
	public static var LD_PROGRESS:String 		= "onLoadProgress";
	/* Called when media is buffering. */ 
	public static var LD_BUFFERING:String 		= "onBuffering";
	/* Called when media stops buffering. */ 
	public static var LD_BUFFER_FULL:String 	= "onBufferFull";
	/* Called when media is ready and playback can begin. */ 
	public static var PB_READY:String 			= "onReady";
	/* Called when playback time updates. */ 
	public static var PB_TIME_UPDATE:String 	= "onPlaybackTimeUpdate";
	/* Called when playback starts. */ 
	public static var PB_START:String 			= "onPlaybackStart";
	/* Called when playback stops. */ 
	public static var PB_STOP:String 			= "onPlaybackStop";
	/* Called when playback is complete. */ 
	public static var PB_COMPLETE:String 		= "onPlaybackComplete";
	/* Called when a playback error occurs. */ 
	public static var PB_ERROR:String 			= "onPlaybackError";
	
	public function MediaPlaybackControl() {
		var d:Number 	= _level0.getNextHighestDepth();
		SndMc 			= _level0.createEmptyMovieClip("$_mediaPlaybackSoundObjectTargetId" + d, d);
		SndOb 			= new Sound(SndMc);
		
		$listeners		= new Array();
		
		$ready 			= false;
		$playing 		= false;
		$buffering 		= false;
		$autoPlay 		= true;
		$repeat 		= false;
		$mute 			= false;
		$volume 		= 0.75;
		$bufferTime 	= 1;
		
		this.bufferTime = $bufferTime;
		this.volume		= $volume;
	}
	/* Add object listener for media loading and playback events. */
	public function addListener(ob):Boolean {
		if (ob) {
			$listeners.push(ob);
			return true;
		} 		
		return false;		
	}
	/* Remove object listener for media loading and playback events. */
	public function removeListener(ob):Boolean {
		var i:Number = $listeners.length;
		while (--i >= 0) {
			if (ob === $listeners[i]) {
				$listeners.splice(i, 1);
				return true;
			}
		}
		return false;
	}
	private function dispatch(event:String):Void {
		var i:Number = $listeners.length;
		while (--i >= 0) {
			var lsn:Object = $listeners[i];
			lsn[event].call(lsn, this);
		}
	}
	
	// METHODS
	/* Reset media playback. */
	public function reset() {
		this.stop();
		clearInterval($eventsChk);
		delete $events;
		
		$ready 			= false;		
		$media 			= null;			
		$totalBytes 	= 0;
		$loadedBytes 	= 0;
		$buffering		= false;
		$totalTime 		= 0;
		$currentTime 	= 0;
		
		dispatch(PB_TIME_UPDATE);		
		dispatch(LD_BUFFER_FULL);
		dispatch(LD_PROGRESS);
	}
	/* Load media. */
	public function load(url:String):Boolean {
		this.reset();		
		if (url == undefined) return false;
		
		$media 		= url;
		$buffering 	= true;		
		dispatch(LD_BUFFERING);
		
		$loaded = false;
		this.$load(url);
		
		this.volume = $volume;
	}
	private function $load(url:String) { }
	/* Start/resume media playback. */
	public function play() {
		$playing = true;
		dispatch(PB_START);
		
		this.$play();
	}
	private function $play() { }
	/* Pause media playback. */
	public function pause() {
		$playing = false;
		dispatch(PB_STOP);
		
		this.$pause();
	}
	private function $pause(){ }
	/* Stop media playback. */
	public function stop() {
		$playing = false;
		dispatch(PB_STOP);
		
		this.$stop();
	}
	private function $stop(){ }
	/* Start media playback from the begining. */
	public function replay() {
		$playing = true;
		dispatch(PB_START);
		
		this.$replay();
	}
	private function $replay(){ }
	/* Seek to time value or percentage. */
	public function seek(to:Number, usePer:Boolean) { 
		if (usePer == undefined) usePer = true;
		this.$seek(Math.max(0, Math.min((usePer ? to * $totalTime : to), $totalTime - 1)));
	}
	private function $seek(to:Number) { }	
	
	// EVENTS CHECK
	private function checkEvents() {
		var i:Number = $events.length;
		while (--i >= 0) $events[i].call(this);
	}
	private function checkLoadProgress() {	}
	private function checkBufferStatus() {	}
	private function checkTimeProgress() {	}	
	
	// PROPERTIES
	// GET
	/* [READONLY] Media is ready. */
	public function get ready():Boolean {
		return $ready;
	}
	/* [READONLY] Media is playing. */
	public function get playing():Boolean {
		return $playing;
	}
	/* [READONLY] Media is buffering. */
	public function get buffering():Boolean {
		return $buffering;
	}
	/* [GET/SET] Media autoplay. */
	public function get autoPlay():Boolean {
		return $autoPlay;
	}
	/* [GET/SET] Media repeat playback. */
	public function get repeat():Boolean {
		return $repeat;
	}
	/* [GET/SET] Media sound mute. */
	public function get mute():Boolean {
		return $mute;
	}
	/* [GET/SET] Media sound volume. */
	public function get volume():Number {
		return $volume;
	}
	/* [GET/SET] Media url. */
	public function get media():String {
		return $media;
	}
	/* [READONLY] Media total time in seconds. */
	public function get totalTime():Number {
		return $totalTime;
	}
	/* [GET/SET] Media current playback time in seconds. */
	public function get currentTime():Number {
		return $currentTime;
	}
	/* [READONLY] Media total bytes. */
	public function get totalBytes():Number {
		return $totalBytes;
	}
	/* [READONLY] Media loaded bytes. */
	public function get loadedBytes():Number {
		return $loadedBytes;
	}
	/* [GET/SET] Media buffer time in seconds. */
	public function get bufferTime():Number {
		return $bufferTime;
	}
	/* [READONLY] Total time as formatted string. */
	public function get totalTimeStr():String {
		return $formatTime($totalTime);
	}
	/* [READONLY] Current time as formatted string. */
	public function get currentTimeStr():String {
		return $formatTime($currentTime);
	}
	
	// SET
	public function set autoPlay(bv:Boolean) {
		$autoPlay = bv;
	}
	public function set repeat(bv:Boolean) {
		$repeat = bv;
	}
	public function set mute(bv:Boolean) {
		$mute = bv;
		$mute ? SndOb.setVolume(0) : SndOb.setVolume($volume * 100);
	}
	public function set volume(nv:Number) {
		$volume 	= Math.max(0, Math.min(1, nv));
		this.mute 	= $mute;
	}
	public function set media(sv:String) {
		this.load(sv);
	}
	public function set currentTime(nv:Number) {
		seek(nv, false);
	}
	public function set bufferTime(nv:Number) {	}
	
	// FORMAT TIME
	private function $formatTime(t:Number) {
		t 						= Math.round(t);
		var hours:Number 		= Math.floor(t / 3600);
		var minutes:Number 		= Math.floor((t % 3600) / 60);
		var seconds:Number 		= Math.round((t % 3600) % 60);		
		var $hours:String 		= String(hours);
		var $minutes:String 	= String(minutes);
		var $seconds:String 	= String(seconds);		
		hours	< 10 ? $hours	= "0" + $hours 	 : null;
		minutes	< 10 ? $minutes	= "0" + $minutes : null;
		seconds < 10 ? $seconds = "0" + $seconds : null;		
		var $time:String 		= $minutes + ":" + $seconds;		
		hours > 0 ? $time 		= $hours + ":" + $time : null;
		
		return $time;
	}
	
	// delegate
	private function delegate(scope:Object, func:Function) {
		var f:Function = function ():Void {
			var o:Object = arguments.callee;
			o["func"].apply(o["scope"], o["args"].concat(arguments));
		};
		
		f["func"] 	= func;
		f["scope"] 	= scope;
		f["args"] 	= arguments.slice(2);
		
		return f;
	}
}
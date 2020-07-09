/* @last_update: 06/29/2015 (mm/dd/yyyy) */

import agung.UtilsAdjusted;

class agung.Mp3PlaybackLight{
	
	// playback control objects
	public var SndOb:Sound;
	private var SndMc:MovieClip;
	
	// events
	public var onInit:Function;
	public var onBuffering:Function;
	public var onBufferFull:Function;
	public var onPlaybackResume:Function;
	public var onPlaybackStop:Function;
	public var onPlaybackTimeUpdate:Function;
	public var onPlaybackComplete:Function;
	public var onPlaybackError:Function;
	public var onLoadProgress:Function;
	
	// vars
	private var $isPlaying:Boolean;
	private var $isReady:Boolean;
	private var $isBuffering:Boolean;
	private var $autoPlay:Boolean = true;
	private var $repeat:Boolean = false;
	private var $volume:Number = 75;
	private var $eCheck:Number;
	private var $bufferTime:Number = 3;
	private var $checkFuncs:Array;
	private var $loaded:Boolean;
	private var $muted:Boolean = false;
	
	// total / current time
	private var $totalTime:Number;
	private var $currentTime:Number;
	
	// total / loaded bytes
	private var $totalBytes:Number;
	private var $loadedBytes:Number;
	
	// constructor
	public function Mp3PlaybackLight() {
		var d:Number = _level0.getNextHighestDepth();
		SndMc = _level0.createEmptyMovieClip("$_mp3PlaybackSoundObjectTargetId"+d, d);
		SndOb = new Sound(SndMc);
		this.setVolume();
		
		SndOb.onLoad 		  = UtilsAdjusted.delegate(this, $onSoundLoad);
		SndOb.onSoundComplete = UtilsAdjusted.delegate(this, $onSoundComplete);
		
		_soundbuftime = $bufferTime;
	}
	
	// init
	private function $init() {
		$isPlaying 		= false;
		$isReady 		= false;
		$isBuffering	= false;
		$totalTime 		= 0;
		$currentTime 	= 0;
		$totalBytes 	= 0;
		$loadedBytes 	= 0;		
		$loaded 		= false;
		
		onPlaybackStop.call(this);
		onPlaybackTimeUpdate.call(this, $totalTime, $currentTime, formatTime($totalTime), formatTime($currentTime));
		onLoadProgress.call(this, $totalBytes, $loadedBytes);
		onBufferFull.call(this);
	}
	
	// reset everything
	public function reset() {
		SndOb.stop();
		clearInterval($eCheck);
		delete $checkFuncs;
		
		$init();
	}

	// load file
	public function load(url:String) {
		reset();
		
		_soundbuftime = $bufferTime;
		SndOb.loadSound(url, true);
		SndOb.stop();
		
		$checkFuncs = [$checkLoadProgress, $checkTimeProgress, $checkBufferStatus];
		$eCheck 	= setInterval(this, "$checkAll", 33);
	}
	
	// playback methods
	public function play() {
		SndOb.start($currentTime);
		$isPlaying = true;
		onPlaybackResume.call(this);
	}
	public function pause() {
		$isPlaying = false;
		SndOb.stop();
		onPlaybackStop.call(this);
	}
	public function stop() {
		SndOb.start(0);
		SndOb.stop();
		$checkTimeProgress();
		$isPlaying = false;
		onPlaybackStop.call(this);
	}
	public function rewind() {
		SndOb.start(0);
		$isPlaying = true;
		onPlaybackResume.call(this);
	}
	public function seek(to:Number, usePercentage:Boolean) {
		
		var $to:Number 	= usePercentage ? (to * $totalTime) : to;
		var $max:Number = SndOb.duration / 1000 - 1; // - ($loaded ? 0 : $bufferTime);
		($to > $max) ? ($to = $max) : null;
		
		SndOb.start($to);
		$isPlaying = true;
		onPlaybackResume.call(this);
	}
	
	// volume
	public function setVolume(p:Number) {
		p != undefined ? $volume = Math.round(p) : null;
		SndOb.setVolume($muted ? 0 : $volume);
	}
	public function getVolume() {
		return SndOb.getVolume()/100;
	}
	public function mute(b:Boolean) {
		$muted = (b == undefined) ? true : Boolean(b);
		this.setVolume();
	}
	
	// properties
	
	//// read-only
	public function isReady():Boolean {
		return $isReady;
	}
	public function get isPlaying() {
		return $isPlaying;
	}
	public function get isBuffering() {
		return $isBuffering;
	}
	public function get isMuted() {
		return $muted;
	}
	
	public function get totalTime() {
		return $totalTime;
	}
	public function get currentTime() {
		return $currentTime;
	}
	
	public function get totalBytes() {
		return $totalBytes;
	}
	public function get loadedBytes() {
		return $loadedBytes;
	}
	
	public function get soundObject():Sound {
		return SndOb;
	}
	
	//// get/set
	public function set autoPlay(b:Boolean) {
		$autoPlay = Boolean(b);
	}
	public function get autoPlay() {
		return $autoPlay;
	}
	
	public function set repeat(b:Boolean) {
		$repeat = Boolean(b);
	}
	public function get repeat() {
		return $repeat;
	}
	
	public function get bufferTime():Number {
		return $bufferTime;
	}
	public function set bufferTime(nbt:Number) {
		$bufferTime = nbt;
	}
	
	// events handling
	private function $onSoundLoad(s:Boolean) {
		if (!s) {
			onPlaybackError.call(this);		
		}		
	}
	
	private function $onSoundComplete() {
		$repeat ? this.rewind() : this.stop();
		onPlaybackComplete.call(this);
	}

	
	// periodically check time, buffering and loading
	private function $checkAll() {
		for (var i in $checkFuncs) {
			$checkFuncs[i].call(this);
		}
	}
	
	/// check loading
	private function $checkLoadProgress() {
		
		var tb:Number = SndOb.getBytesTotal();
		isNaN(tb) ? tb = $totalBytes : null;
		
		var lb:Number = SndOb.getBytesLoaded();		
		isNaN(lb) ? lb = $loadedBytes : null;
		
		if ($totalBytes != tb || $loadedBytes != lb) {
			$totalBytes  = tb;
			$loadedBytes = lb;
			
			onLoadProgress.call(this, $totalBytes, $loadedBytes);
		}
		
		// if fully loaded , remove load and buffering checking       
		if ($totalBytes == $loadedBytes && $totalBytes > 0) {
			$loaded 	= true;
			$checkFuncs = [$checkTimeProgress];
			
			$isBuffering ? ($isBuffering = false, onBufferFull.call(this)) : null;
		}
	}
	
	/// check buffer status ([?] kind of works)
	private function $checkBufferStatus() {		
		if (SndOb.position >= SndOb.duration - $bufferTime*1000) {
			!$isBuffering ? ($isBuffering = true, onBuffering.call(this)) : null;
		} else {
			$isBuffering ? ($isBuffering = false, onBufferFull.call(this)) : null;
		}
	}
	
	/// check time 
	private function $checkTimeProgress() {
		
		if (SndOb.duration >= ($bufferTime * 1000) && $totalTime > 0 && !$isReady) {
			$isReady = true;
			this.setVolume();
			$autoPlay ? this.rewind() : this.stop();
			onInit.call(this);
		}
		
		var ct:Number = SndOb.position/1000;
		(isNaN(ct) || !$isPlaying) ? ct = $currentTime : null;
		
		var tt:Number = $loaded ? (SndOb.duration / 1000) : ((SndOb.duration/1000)*($totalBytes/$loadedBytes));
		(isNaN(tt) || (!$loaded && Math.abs(tt - $totalTime) <= $bufferTime))  ? tt = $totalTime : null;
		
		if ($currentTime != ct || $totalTime != tt) {
			$currentTime = ct;
			$totalTime 	 = tt;
			
			$currentTime > $totalTime ? $totalTime = $currentTime : null;
			
			onPlaybackTimeUpdate.call(this, $totalTime, $currentTime, formatTime($totalTime), formatTime($currentTime));
		}
	}
	
	// time formatted string like (hh:mm:ss), hours only displayed if needed
	public function formatTime(t:Number) {
		var hours:Number 	= Math.floor(t/3600);
		var minutes:Number  = Math.floor((t %= 3600)/60);
		var seconds:Number  = Math.round(t % 60);
		
		var $hours:String   = String(hours);
		var $minutes:String = String(minutes);
		var $seconds:String = String(seconds);
		
		hours 	< 10 ? $hours 	= "0" + $hours 	 : null;
		minutes < 10 ? $minutes = "0" + $minutes : null;
		seconds < 10 ? $seconds = "0" + $seconds : null;
		
		var $time:String = $minutes + ":" + $seconds;
		
		hours > 0 ? $time = $hours + ":" + $time : null;
		
		return $time;
	}
}
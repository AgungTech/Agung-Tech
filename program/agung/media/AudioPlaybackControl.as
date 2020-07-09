/* @last_update: 06/29/2015 (mm/dd/yyyy) */

import agung.media.MediaPlaybackControl;

class agung.media.AudioPlaybackControl extends MediaPlaybackControl {
	/* Called when id3 info is available. */
	public static var ID3:String = "onId3Info";
	
	public function AudioPlaybackControl() {
		super();

		SndOb.onLoad 		  	= this.delegate(this, $onSoundLoad);
		SndOb.onSoundComplete 	= this.delegate(this, $onSoundComplete);
		SndOb.onID3				= this.delegate(this, $onSoundID3);
	}
	
	private function $onSoundID3() {
		dispatch(ID3);
	}
	/* Get id3 object info. */
	public function get id3tags():Object {
		return SndOb.id3;
	}
	
	private function $load(url:String) {
		SndOb.loadSound(url, true);
		SndOb.stop();
		
		$events 	= [checkBufferStatus, checkLoadProgress, checkTimeProgress];
		$eventsChk 	= setInterval(this, "checkEvents", 33);
	}
	private function $play() {
		SndOb.start($currentTime);
	}
	private function $pause() {
		SndOb.stop();
	}
	private function $stop() {
		SndOb.start(0);
		SndOb.stop();
	}
	private function $replay() {
		SndOb.start(0);
	}
	private function $seek(to:Number) {
		SndOb.start(to);
		if (!$playing) SndOb.stop();
	}
	
	private function $onSoundLoad(s:Boolean) {
		// Not really working :( !!!
		/*if (!s)	{
			dispatch(PB_ERROR);
			this.reset();
		}*/
	}
	
	public function set bufferTime(nv:Number) {
		$bufferTime 	= nv;
		_soundbuftime 	= $bufferTime;
	}
	
	private function $onSoundComplete() {
		$repeat ? this.replay() : this.stop();
		dispatch(PB_COMPLETE);
	}
	
	private function checkLoadProgress() {
		
		var tb:Number = SndOb.getBytesTotal() || $totalBytes;		
		var lb:Number = SndOb.getBytesLoaded() || $loadedBytes;		
		
		if ($totalBytes != tb || $loadedBytes != lb) {
			$totalBytes  = tb;
			$loadedBytes = lb;
			
			dispatch(LD_PROGRESS);
		}
		
		if ($totalBytes == $loadedBytes && $totalBytes > 0) {
			$loaded = true;
			$events = [checkTimeProgress];
			
			if ($buffering) {
				$buffering = false;
				dispatch(LD_BUFFER_FULL);
			}
		}
	}
	
	private function checkBufferStatus() {		
		if (SndOb.position >= SndOb.duration - $bufferTime * 1000) {
			if (!$buffering) {
				$buffering = true;
				dispatch(LD_BUFFERING);
			}
		} else {
			if ($buffering) {
				$buffering = false;
				dispatch(LD_BUFFER_FULL);
			}
		}
	}
	
	private function checkTimeProgress() {	
		if (SndOb.duration >= ($bufferTime * 1000) && $totalTime > 0 && !$ready) {
			$ready = true;
			$autoPlay ? this.replay() : this.stop();
			dispatch(PB_READY);
		}
		
		var ct:Number = SndOb.position / 1000;
		if (isNaN(ct)) ct = $currentTime;
		
		var tt:Number = $loaded ? (SndOb.duration / 1000) : ((SndOb.duration / 1000) * ($totalBytes / $loadedBytes));
		if (isNaN(tt) || (!$loaded && Math.abs(tt - $totalTime) <= $bufferTime)) tt = $totalTime;		
		
		if ($currentTime != ct || $totalTime != tt) {
			$currentTime = ct;
			$totalTime 	 = tt;
			
			if ($totalTime < $currentTime) $totalTime = $currentTime;
			
			dispatch(PB_TIME_UPDATE);
		}
	}
}
/* @last_update: 06/29/2015 (mm/dd/yyyy) */

import agung.media.MediaPlaybackControl;

class agung.media.VideoPlaybackControl extends MediaPlaybackControl {
	private var netStr:NetStream;
	private var netCon:NetConnection;
	private var vidOb:Video;
	
	private var w:Number;
	private var h:Number;
	
	private var $sizeCheck:Number;
	private var $isRTMP:Boolean 	= false;
	private var $streamer:String 	= null;
	
	public function VideoPlaybackControl(v:Video) {
		super();
		
		netCon = new NetConnection();
		vidOb  = v;
	}
	/* Reset video playback. */
	public function reset() {
		super.reset();		
		
		SndOb.stop();
		netStr.close();
		delete netStr;
		clearInterval($sizeCheck);
		$sizeCheck = undefined;
	}
	
	private function $load(url:String) {
		netCon.connect($streamer);		
		netStr = new NetStream(netCon);
		netStr.setBufferTime($bufferTime);
		netStr.onMetaData 	= this.delegate(this, $onMetaData);
		netStr.onStatus 	= this.delegate(this, $onStatus);
		
		vidOb.attachVideo(netStr);
		SndMc.attachAudio(netStr);
		
		netStr.play(url);		
	}
	private function $play() {
		netStr.pause(false);
	}
	private function $pause() {
		netStr.pause(true);
	}
	private function $stop() {
		netStr.seek(0);
		netStr.pause(true);
	}
	private function $replay() {
		netStr.seek(0);
		netStr.pause(false);
	}
	private function $seek(to:Number) {
		netStr.seek(to);
	}
	
	private function $onMetaData(o:Object) {
		delete netStr.onMetaData;
		
		w = h = 0;
		for (var p in o) {
			var val:Number = Number(o[p]);
			if(isNaN(val)) val = 0;
			
			switch (p) {
				case "width" :
					w = val;
					break;
				case "height" :
					h = val;
					break;
				case "duration" :
					$totalTime = val;
					break;
			}
		}
		
		if (w > 0 && h > 0) $initCall();
		else $checkSize();		
	}
	
	private function $checkSize() {
		if (vidOb.width > 0 && vidOb.height > 0) {
			clearInterval($sizeCheck);
			$sizeCheck = undefined;
			
			w = vidOb.width;
			h = vidOb.height;
			
			$initCall();
		} else if ($sizeCheck == undefined) {
			$sizeCheck = setInterval(this, "$checkSize", 33);
		}
	}
	private function $initCall() {
		vidOb._visible = true;
		$autoPlay ? this.replay() : this.stop();
		$ready = true;
		
		$events 	= [checkBufferStatus, checkLoadProgress, checkTimeProgress];
		$eventsChk 	= setInterval(this, "checkEvents", 33);
		
		dispatch(PB_READY);
	}
	// on status
	private function $onStatus(o:Object) {
		switch (o.code) {			
			case "NetStream.Play.Stop" :				
				$repeat ? this.replay() : this.stop();
				dispatch(PB_COMPLETE);
				break;
				
			case "NetStream.Play.StreamNotFound" :
				dispatch(PB_ERROR);
				this.reset();
				break;
				
			case "NetStream.Seek.InvalidTime" :
				seek(Number(o.details), false);
				break;
		}
	}
	
	private function checkLoadProgress() {
		var tb:Number = netStr.bytesTotal || ($isRTMP ? 1 : $totalBytes);
		var lb:Number = netStr.bytesLoaded || ($isRTMP ? 1 : $loadedBytes);		
		
		if ($totalBytes != tb || $loadedBytes != lb) {
			$totalBytes  = tb;
			$loadedBytes = lb;
			
			dispatch(LD_PROGRESS);
		}
		
		if ($totalBytes == $loadedBytes && $totalBytes > 0) {
			$events = [checkTimeProgress];
			if ($buffering) {
				$buffering = false;
				dispatch(LD_BUFFER_FULL);
			}
		}		
	}
	
	private function checkBufferStatus() {		
		if (netStr.bufferLength < netStr.bufferTime) {
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
		var ct:Number = netStr.time || $currentTime;
		
		if ($currentTime != ct) {
			$currentTime = ct;
			if ($currentTime > $totalTime) {
				$totalTime = $currentTime;
			}
			
			dispatch(PB_TIME_UPDATE);
		}
	}
	
	public function set bufferTime(nv:Number) {
		$bufferTime = nv;
		netStr.setBufferTime($bufferTime);
	}
	
	/* [GET/SET] Streamer for RTMP playback. */
	public function get streamer():String {
		return $streamer;
	}
	public function set streamer(str:String) {
		$streamer 	= str;
		$isRTMP 	= $streamer != null;
	}
	/* [READONLY] Media is RTMP. */
	public function get isRTMP():Boolean {
		return $isRTMP;
	}
}
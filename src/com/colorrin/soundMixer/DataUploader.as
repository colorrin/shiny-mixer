package com.colorrin.soundMixer{
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.display.Stage;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import com.sociodox.utils.Base64;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequestHeader;
	import flash.text.TextField;
	import flash.events.HTTPStatusEvent;
	
	public class DataUploader extends EventDispatcher{

		public static const URL_SOUND_TRACK:String = "http://www.unpuntorojo.com.ar/chamaco/mixer/uploadFile.php";

		private var _stage:Stage;
		private var _txtTarget:TextField;

		private var _accessToken:String;

		public function DataUploader() {
			// constructor code
		}
		
		public function init():void{
			var flashvars:Object = LoaderInfo(_stage.loaderInfo).parameters;
			_accessToken = flashvars["token"];
		}
		
		public function uploadSoundTrack(rawBytes:ByteArray):void{
			var urlPath:String = URL_SOUND_TRACK;
			if(_txtTarget){
				urlPath = _txtTarget.text;
			}
			
			var request:URLRequest = new URLRequest(urlPath);
			var requestVars:URLVariables = new URLVariables();
			requestVars["audioFile"] = Base64.encode(rawBytes);
			requestVars["accessToken"] = _accessToken;
			requestVars["privateAudio"] = "Y";
			request.data = requestVars;
			
			var header:URLRequestHeader = new URLRequestHeader( "enctype", "multipart/form-data" );
			request.requestHeaders.push(header);
			
			request.method = URLRequestMethod.POST;
			 
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onUploadComplete);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			urlLoader.load(request);
			
		}

		private function onUploadComplete(e:Event):void{
			var urlLoader:URLLoader = e.currentTarget as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onUploadComplete);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			trace("complete");
			
			dispatchEvent(e);
		}
		
		private function onIOError(e:IOErrorEvent):void{
			var urlLoader:URLLoader = e.currentTarget as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onUploadComplete);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			trace("error");
			trace(e.text);
			
			dispatchEvent(e);
		}
		
		private function onStatus(e:HTTPStatusEvent):void{
			trace("---STATUS---");
			trace(e.status);
			trace("---STATUS---");
		}
		
		public function set stage(value:Stage):void{
			_stage = value;
		}
		
		public function set txtTarget(value:TextField):void{
			_txtTarget = value;
		}
	}
	
}

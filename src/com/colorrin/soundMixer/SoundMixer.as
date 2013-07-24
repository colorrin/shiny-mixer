package com.colorrin.soundMixer {
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.audiofx.mp3.MP3FileReferenceLoader;
	import org.audiofx.mp3.MP3SoundEvent;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	import fr.kikko.lab.ShineMP3Encoder;
	import flash.events.ProgressEvent;
	import flash.events.ErrorEvent;
	import org.bytearray.micrecorder.encoder.WaveEncoder;
	import flash.display.Stage;
	import flash.events.IOErrorEvent;
	
	public class SoundMixer extends EventDispatcher{

		static const FILE_FILTER:FileFilter = new FileFilter("Sound File", "*.mp3");
		
		private var _stage:Stage;
		
		private var _mp3Encoder:ShineMP3Encoder ;
		
		private var _files:Vector.<FileReference>;
		private var _sounds:Vector.<Sound>;

		public function SoundMixer() {
			// constructor code
			_files = new Vector.<FileReference>();
			_sounds = new Vector.<Sound>();
		}

		public function browseFile():void{
			var fileReference = new FileReference();
			
			fileReference.addEventListener(Event.SELECT, onFileSelect);
			fileReference.addEventListener(Event.CANCEL, onFileCancel);
			
			fileReference.browse([FILE_FILTER]);
		}
		
		private function onFileSelect(e:Event):void{
			var fileReference:FileReference = e.currentTarget as FileReference;
			
			fileReference.removeEventListener(Event.SELECT, onFileSelect);
			fileReference.removeEventListener(Event.CANCEL, onFileCancel);
			
			_files.push(fileReference);
			trace(fileReference.name);
			var mp3loader:MP3FileReferenceLoader = new MP3FileReferenceLoader();
          	mp3loader.addEventListener(MP3SoundEvent.COMPLETE, onFileLoadComplete);
          	mp3loader.getSound(fileReference);
		}
		
		function onFileLoadComplete(evt:MP3SoundEvent) {
			var sound:Sound = evt.sound;
			
			_sounds.push(sound);
			
			var mp3loader:MP3FileReferenceLoader = evt.currentTarget as MP3FileReferenceLoader;
			mp3loader.removeEventListener(MP3SoundEvent.COMPLETE, onFileLoadComplete);
			
			dispatchEvent(new MP3SoundEvent(MP3SoundEvent.COMPLETE,evt.sound,evt.fileReference));
   		}
		
		public function playFile():void{
			var sound:Sound = _sounds[0];
			sound.play();
		}
		
		public function encode():void{
			var bytes:ByteArray = getFinalByteArray();
			
			var waveEncoder:WaveEncoder = new WaveEncoder();
			var waveByte:ByteArray = waveEncoder.encode(bytes);
			waveByte.position = 0;
			
			_mp3Encoder = new ShineMP3Encoder(waveByte);
			_mp3Encoder.addEventListener(Event.COMPLETE, mp3EncodeComplete);
			_mp3Encoder.addEventListener(ProgressEvent.PROGRESS, mp3EncodeProgress);
			_mp3Encoder.addEventListener(ErrorEvent.ERROR, mp3EncodeError);
			_mp3Encoder.start();
		}
		
		private function getFinalByteArray():ByteArray{
			var bytes:Vector.<ByteArray> = new Vector.<ByteArray>();

			for(var i:int = 0;i<_sounds.length;i++){
				var sound:Sound = _sounds[i];
				var byteArr:ByteArray = new ByteArray();
				sound.extract(byteArr, sound.length*44100, 0);
				byteArr.position = 0;
				bytes.push(byteArr);
			}
			
			var outputArray:ByteArray = new ByteArray();
			while(bytes.length>0){
				var currentSample:Number = 0;
				for(i=bytes.length-1;i>=0;i--){
					if(bytes[i].bytesAvailable > 0){
						currentSample += (bytes[i].readFloat() * (1/bytes.length));
					}else{
						bytes.splice(i,1);
					}
				}
				outputArray.writeFloat(currentSample);
			}
			return outputArray;
		}

		private function mp3EncodeComplete(e : Event) : void {
			trace("done!");
			
			var dataUploader:DataUploader = new DataUploader();
			dataUploader.stage = _stage;
			dataUploader.init();
			
			dataUploader.uploadSoundTrack(_mp3Encoder.mp3Data);
			
			dataUploader.addEventListener(Event.COMPLETE, onSendComplete);
			dataUploader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			//_mp3Encoder.saveAs("test.mp3");
			
			dispatchEvent(e);
		}
		
		private function onSendComplete(e:Event):void{
			var dataUploader:DataUploader = e.currentTarget as DataUploader;
			dataUploader.removeEventListener(Event.COMPLETE, onSendComplete);
			dataUploader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			dispatchEvent(e);
		}
		
		private function onIOError(e:IOErrorEvent):void{
			var dataUploader:DataUploader = e.currentTarget as DataUploader;
			dataUploader.removeEventListener(Event.COMPLETE, onSendComplete);
			dataUploader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			dispatchEvent(e);
		}
		
		private function mp3EncodeProgress(event : ProgressEvent) : void {
			trace(event.bytesLoaded + "%");
		}

		private function mp3EncodeError(event : ErrorEvent) : void {
			trace("[ERROR] : " + event.text);
		}
		
		private function onFileCancel(e:Event):void{
			var fileReference:FileReference = e.currentTarget as FileReference;
			
			fileReference.removeEventListener(Event.SELECT, onFileSelect);
			fileReference.removeEventListener(Event.CANCEL, onFileCancel);
		}
		
		public function set stage(value:Stage):void{
			_stage = value;
		}
	}
	
}

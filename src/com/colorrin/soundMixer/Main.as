package com.colorrin.soundMixer{
	import flash.display.MovieClip;
	import com.colorrin.ui.GeneralButton;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.FileReference;
	import com.colorrin.soundMixer.ui.SongRenderer;
	import com.colorrin.ui.GenericList;
	import org.audiofx.mp3.MP3SoundEvent;
	import flash.events.IOErrorEvent;
	import flash.text.TextField;
	
	public class Main extends MovieClip{

		private var _soundMixer:SoundMixer;

		private var _btnUpload:GeneralButton;
		private var _btnPlay:GeneralButton;
		private var _btnEncode:GeneralButton;
		
		private var _songList:GenericList;

		public function Main() {
			// constructor code
			init();
		}
		
		private function init():void{
			_soundMixer = new SoundMixer();
			_soundMixer.stage = this.stage;
			_soundMixer.txtTarget = getChildByName("txtTarget") as TextField;
			
			_soundMixer.addEventListener(MP3SoundEvent.COMPLETE, onFileLoadComplete);
			
			var clipSongContainer:MovieClip = getChildByName("songContainer") as MovieClip;
			_songList = new GenericList();
			_songList.container = clipSongContainer;
			_songList.rendererClass = SongRenderer;
			_songList.init();
			
			var clipBtnUpload:MovieClip = getChildByName("btnUpload") as MovieClip;
			_btnUpload = new GeneralButton(clipBtnUpload);
			_btnUpload.addEventListener(MouseEvent.CLICK, onUploadClick);
			
			var clipBtnEncode:MovieClip = getChildByName("btnEncode") as MovieClip;
			_btnEncode = new GeneralButton(clipBtnEncode);
			_btnEncode.addEventListener(MouseEvent.CLICK, onEncodeClick);
			
			var clipCntLoad:MovieClip = getChildByName("cntLoad") as MovieClip;
			clipCntLoad.visible = false;
		}
		
		private function onUploadClick(e:Event):void{
			_soundMixer.browseFile();
		}
		
		private function onFileLoadComplete(e:MP3SoundEvent):void{
			var _e:MP3SoundEvent = e as MP3SoundEvent;
			_songList.addItem(_e);
		}
		
		private function onEncodeClick(e:Event):void{
			_soundMixer.encode();
			
			var clipCntLoad:MovieClip = getChildByName("cntLoad") as MovieClip;
			clipCntLoad.txtMessage.text = "ENCODEANDO";
			clipCntLoad.visible = true;
			
			_soundMixer.addEventListener(Event.COMPLETE, onEncodeComplete);
		}
		
		private function onEncodeComplete(e:Event){
			_soundMixer.removeEventListener(Event.COMPLETE, onEncodeComplete);
			
			var clipCntLoad:MovieClip = getChildByName("cntLoad") as MovieClip;
			clipCntLoad.txtMessage.text = "ENVIANDO";
			
			_soundMixer.addEventListener(Event.COMPLETE, onSendComplete);
			_soundMixer.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		private function onSendComplete(e:Event){
			_soundMixer.removeEventListener(Event.COMPLETE, onSendComplete);
			_soundMixer.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			var clipCntLoad:MovieClip = getChildByName("cntLoad") as MovieClip;
			clipCntLoad.visible = false;
		}
		
		private function onIOError(e:Event){
			_soundMixer.removeEventListener(Event.COMPLETE, onSendComplete);
			_soundMixer.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			var clipCntLoad:MovieClip = getChildByName("cntLoad") as MovieClip;
			clipCntLoad.txtMessage.text = "ERROR";
		}
	}
	
}

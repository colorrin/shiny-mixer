package com.colorrin.soundMixer.ui{
	import com.colorrin.ui.IListRenderer;
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.display.DisplayObjectContainer;
	import org.audiofx.mp3.MP3SoundEvent;
	import flash.media.Sound;
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.display.MovieClip;
	import com.colorrin.ui.GeneralButton;
	import flash.events.MouseEvent;
	
	public class SongRenderer implements IListRenderer{

		private var _file:FileReference;
		private var _sound:Sound;
		
		private var _display:DisplayObjectContainer;
		private var _btnPlay:GeneralButton;
		
		private var _channel:SoundChannel;
		
		public function SongRenderer() {
			// constructor code
		}

		public function init():void{
			var type:Class = getDefinitionByName("songRenderer") as Class;
			_display = new type();
			
			var txtTitle:TextField = _display.getChildByName("txtTitle") as TextField;
			txtTitle.text = _file.name+"";
			
			var clipBtnPlay:MovieClip = _display.getChildByName("btnPlay") as MovieClip;
			_btnPlay = new GeneralButton(clipBtnPlay);
			_btnPlay.addEventListener(MouseEvent.CLICK, onPlayClick);
		}
		
		private function onPlayClick(e:Event):void{
			_btnPlay.removeEventListener(MouseEvent.CLICK, onPlayClick);
			_btnPlay.addEventListener(MouseEvent.CLICK, onStopClick);
			
			_channel = _sound.play();
		}
		
		private function onStopClick(e:Event):void{
			_btnPlay.addEventListener(MouseEvent.CLICK, onPlayClick);
			_btnPlay.removeEventListener(MouseEvent.CLICK, onStopClick);
			
			_channel.stop();
		}
		
		public function get height():Number{
			return _display.height;
		}
		
		public function get display():DisplayObject{
			return _display;
		}
		
		public function set data(value:Object):void{
			var evt:MP3SoundEvent = value as MP3SoundEvent;
			_file = evt.fileReference;
			_sound = evt.sound;
		}
		
		public function destroy():void{
			_file = null;
			_sound = null;
			_channel = null;
		}

	}
	
}

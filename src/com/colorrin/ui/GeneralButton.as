package com.colorrin.ui{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class GeneralButton extends EventDispatcher{

		private var _clip:MovieClip;

		private var _over:Function;
		private var _out:Function;

		public function GeneralButton (clip:MovieClip, over:Function = null, out:Function = null) {
			_clip = clip;
			
			_over = over;
			_out = out;
			
			_clip.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			_clip.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			_clip.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			_clip.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			_clip.stop();
		}
		
		private function onMouseOut(e:Event):void{
			if(_out != null){
				_out();
			}else{
				_clip.gotoAndStop("_up");
			}
		}
		
		private function onMouseOver(e:Event):void{
			if(_over != null){
				_over();
			}else{
				_clip.gotoAndStop("_down");
			}
		}
		
		private function onMouseClick(e:Event):void{
			this.dispatchEvent(e);
		}
		
		private function onRemovedFromStage(e:Event){
			_clip.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			_clip.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			_clip.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			_clip.removeEventListener(MouseEvent.ROLL_OUT, onMouseClick);
			
			_clip = null;
			
			_over = null;
			_out = null;
		}
		
	
	}
	
}

package com.colorrin.ui{
	import flash.display.DisplayObject;
	
	public interface IListRenderer{

		function set data(value:Object):void;
		
		function get height():Number;
		function get display():DisplayObject;
		
		function init():void;
		function destroy():void;

	}
	
}

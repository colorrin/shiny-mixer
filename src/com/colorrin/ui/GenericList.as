package com.colorrin.ui{
	import flash.display.DisplayObjectContainer;
	
	public class GenericList {

		private var _container:DisplayObjectContainer;
		private var _rendererClass:Class;

		private var _items:Vector.<IListRenderer>;

		public function GenericList() {
			// constructor code
		}
		
		public function init():void{
			_items = new Vector.<IListRenderer>();
		}
		
		public function addItem(data:Object):void{
			var yPos:Number = 0;
			for each(var element:IListRenderer in _items){
				yPos += element.height;
			}
			var item:IListRenderer = new _rendererClass() as IListRenderer;
			item.data = data;
			item.init();
			item.display.y = yPos;
			
			_container.addChild(item.display);
			
			_items.push(item);
		}
		
		public function set container(value:DisplayObjectContainer):void{
			_container = value;
		}
		
		public function set rendererClass(value:Class):void{
			_rendererClass = value;
		}

	}
	
}

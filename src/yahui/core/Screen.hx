package yahui.core;

import nme.events.Event;
import nme.Lib;
import yahui.skins.SkinManager;

class Screen {
	
	// getter and setter declarations
	public static var component(getComponent, null):Component;
	public static var width(getWidth, null):Float;
	public static var height(getHeight, null):Float;
	
	private function new() {
		
	}
	
	public static function init():Void {
		component = new Component();
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		component.width = stage.stageWidth;
		component.height = stage.stageHeight;
		component.backgroundCol = SkinManager.skin.getSkinPropInt("application.backgroundCol", 0xFFFFFF);
		Lib.current.addChild(component.sprite);
	}
	
	//************************************************************
	//                  IEventDispatcher
	//************************************************************
	public static function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		component.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}

	public static function dispatchEvent(event:Event):Bool {
		return component.dispatchEvent(event);
	}

	public static function hasEventListener(type:String):Bool {
		return component.hasEventListener(type);
	}

	public static function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false):Void {
		component.removeEventListener(type, listener, useCapture);
	}
	
	//************************************************************
	//                  GETTERS AND SETTERS
	//************************************************************
	public static function getComponent():Component {
		if (component == null) {
			init();
		}
		return component;
	}
	
	public static function getWidth():Float {
		if (component == null) {
			init();
		}
		return component.width;
	}
	
	public static function getHeight():Float {
		if (component == null) {
			init();
		}
		return component.height;
	}
}
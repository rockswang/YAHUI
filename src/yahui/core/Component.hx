package yahui.core;

import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.IEventDispatcher;
import yahui.skins.SkinManager;

class Component implements IEventDispatcher {

	// getter and setter declarations
	public var sprite(getSprite, null):Sprite;
	public var x(getX, setX):Float;
	public var y(getY, setY):Float;
	public var width(getWidth, setWidth):Float;
	public var height(getHeight, setHeight):Float;
	public var numChildren(getNumChildren, null):Int;
	public var backgroundCol:Int = -1;
	public var visible(default, setVisible):Bool;
	public var backgroundSkinId:String;
	
	public var ready(getReady, null):Bool = false;
	
	// holds all children that are components for later look up based on sprite
	private var childComponents:Array<Component>;
	
	// just to see how many display objects there are (useful for optimisation)
	public static var componentCount:Int = 0;
	
	// background skin (if available)
	private var backgroundSkin:DisplayObject;
	public var showBackgroundSkin:Bool = true;
	
	public function new() {
		componentCount++;
		//trace("" + componentCount + " component(s)");
		
		childComponents = new Array<Component>();
		sprite = new Sprite();
		
		addEventListener(Event.ADDED_TO_STAGE, onReady);
	}

	public function invalidateSize():Void {
		if (width > 0 && height > 0 && ready == true) {
			resize();
		}
	}
	
	//************************************************************
	//                  OVERRIDABLES
	//************************************************************
	private function createChildren():Void {
	}
	
	private function resize():Void {
		if (backgroundSkinId != null) {
			backgroundSkin = SkinManager.skin.getSkinAsset(backgroundSkinId, width, height);
			if (backgroundSkin != null) {
				addChild(backgroundSkin);
				backgroundSkin.width = width;
				backgroundSkin.height = height;
			}
		}
		
		if (backgroundCol > -1) {
			sprite.graphics.clear();
			sprite.graphics.beginFill(backgroundCol);
			sprite.graphics.lineStyle(0, backgroundCol);
			sprite.graphics.drawRect(0, 0, Std.int(width), Std.int(height));
			sprite.graphics.endFill();
		}
		
		if (backgroundSkin != null) {
			sendToBack(backgroundSkin);
		}
	}
	
	//************************************************************
	//                  EVENT HANDLERS
	//************************************************************
	private function onReady(event:Event) {
		removeEventListener(Event.ADDED_TO_STAGE, onReady);
		ready = true;
		createChildren();
		invalidateSize();
	}
	
	//************************************************************
	//                  GETTERS AND SETTERS
	//************************************************************
	public function getSprite():Sprite {
		return sprite;
	}
	
	public function getWidth():Float {
		return width;
	}
	
	public function getX():Float {
		return sprite.x;
	}
	
	public function setX(value:Float):Float {
		return sprite.x = value;
	}
	
	public function getY(): Float {
		return sprite.y;
	}

	public function setY(value:Float):Float {
		return sprite.y = value;
	}
	
	public function setWidth(value:Float):Float {
		width = value;
		invalidateSize();
		return value;
	}
	
	public function getHeight():Float {
		return height;
	}
	
	public function setHeight(value:Float):Float {
		height = value;
		invalidateSize();
		return value;
	}
	
	public function getReady():Bool {
		return ready;
	}
	
	public function setVisible(value:Bool):Bool {
		sprite.visible = value;
		return value;
	}
	//************************************************************
	//                  DISPLAY LIST OPERATIONS
	//************************************************************
	public function addChild(c:Dynamic):Dynamic {
		if (Std.is(c, Component)) {
			childComponents.push(c);
			c = untyped c.sprite;
		}
		sprite.addChild(c);
		return c;
	}
	
	public function contains(c:Dynamic):Bool {
		if (Std.is(c, Component)) {
			c = untyped c.sprite;
		}
		return sprite.contains(c);
	}

	public function removeChild(c:Dynamic):DisplayObject {
		if (Std.is(c, Component)) {
			// TODO: remove from childComponents
			c = untyped c.sprite;
		}
		return sprite.removeChild(c);
	}
	
	public function getChildAt(index:Int):DisplayObject {
		return sprite.getChildAt(index);
	}
	
	public function getNumChildren():Int {
		return sprite.numChildren;
	}
	
	public function swapChildren(child1:DisplayObject, child2:DisplayObject):Void {
		sprite.swapChildren(child1, child2);
	}
	
	public function bringToFront(c:Dynamic):Void {
		if (c != null) {
			if (Std.is(c, Component)) {
				c = untyped c.sprite;
			}
			if (sprite.contains(c)) {
				sprite.setChildIndex(c, numChildren - 1);
			}
		}
	}

	public function sendToBack(c:Dynamic):Void {
		if (c != null) {
			if (Std.is(c, Component)) {
				c = untyped c.sprite;
			}
			sprite.setChildIndex(c, 0);
		}
	}
	
	public function findChildFromSprite(s:DisplayObject):Component {
		var c:Component = null;
		if (sprite.contains(s)) {
			var t:Component = null;
			for (t in childComponents) {
				if (t.sprite == s) {
					c = t;
					break;
				}
			}
		}
		return c;
	}
	
	public function dispose():Void {
		// TODO: recusively remove and dispose of all children
	}
	
	//************************************************************
	//                  IEventDispatcher
	//************************************************************
	public function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		sprite.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}

	public function dispatchEvent(event:Event):Bool {
		return sprite.dispatchEvent(event);
	}

	public function hasEventListener(type:String):Bool {
		return sprite.hasEventListener(type);
	}

	public function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false):Void {
		sprite.removeEventListener(type, listener, useCapture);
	}

	public function willTrigger(type:String):Bool {
		return sprite.willTrigger(type);
	}
	
	//************************************************************
	//                  HELPERS
	//************************************************************
	private function drawBackground(col:Int = 0xBBBBBB, alpha:Float = 1):Void {
		sprite.graphics.clear();
		sprite.graphics.beginFill(col, alpha);
		sprite.graphics.lineStyle(0, col);
		sprite.graphics.drawRect(0, 0, Std.int(width), Std.int(height));
		sprite.graphics.endFill();
	}
	
	public function countChildren(recursive:Bool = false):Void {
		
	}
}
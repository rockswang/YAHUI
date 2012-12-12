package yahui.controls;
import nme.display.Bitmap;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.geom.Point;
import nme.geom.Rectangle;
import yahui.core.Component;
import yahui.core.Screen;
import yahui.skins.SkinHelper;
import yahui.skins.SkinManager;

class VScroll extends Component {
	private var backgroundSkin:DisplayObject;
	
	// getters/setters
	private var thumbMinSize:Float = 20;
	public var min(default, setMin):Float = 0;
	public var max(default, setMax):Float = 100;
	public var value(default, setValue):Float = 0;
	public var pageSize(default, setPageSize):Float = 0;
	
	// thumb skin items
	private var upThumbSkin:DisplayObject;
	private var overThumbSkin:DisplayObject;
	private var downThumbSkin:DisplayObject;

	// event target
	public var eventTarget:Sprite;
	
	// if the mouse button is down
	private var mouseDown:Bool = false;
	private var mouseDownOffset:Float; // the offset from the thumb ypos where the mouse event was detected
	
	private var padding:Rectangle;
	
	public function new() {
		super();
		
		width = SkinManager.skin.getSkinPropInt("vscroll.size.width", 20);
		height = 200;
		eventTarget = new Sprite();
		
		padding = new Rectangle();
		padding.left = 1;
		padding.top = 1;
		padding.right = 0;
		padding.bottom = 1;
	}
	
	//************************************************************
	//                  OVERRIDABLES
	//************************************************************
	private override function createChildren():Void {
		addEventListeners();
		addChild(eventTarget);
		resizeEventTarget();
	}
	
	private override function resize():Void {
		resizeEventTarget();
		if (backgroundSkin != null) {
			removeChild(backgroundSkin);
		}

		backgroundSkin = SkinManager.skin.getSkinAsset("vscroll.background", width, height);
		if (backgroundSkin != null) {
			backgroundSkin.width = width;
			backgroundSkin.height = height;
			addChild(backgroundSkin);
		}

		resizeThumb();
		repositionThumb();
		
		bringToFront(eventTarget); // make sure event target is top of the display list
		
	}

	//************************************************************
	//                  EVENT HANDLERS
	//************************************************************
	private function onMouseMove(event:MouseEvent):Void {
		if (mouseDown == true) {
			var ypos:Float = event.stageY - mouseDownOffset;
			if (ypos < 0) {
				ypos = 0;
			} else if (ypos > height - upThumbSkin.height) {
				ypos = height - upThumbSkin.height;
			}
			
			var usableHeight:Float = height;
			usableHeight -= upThumbSkin.height;
			var m:Int = Std.int(max - min);
			var newValue:Float = (ypos / usableHeight) * m;
			value = newValue;
		} else {
			if (mouseInThumb(event)) {
				showThumbState("over");
			} else {
				showThumbState("up");
			}
		}
	}
	
	private function onMouseOver(event:MouseEvent) {
		if (mouseDown == true) {
			showThumbState("down");
		}
	}

	private function onMouseOut(event:MouseEvent) {
		if (mouseDown == false) {
			showThumbState("up");
		}
	}
	
	private function onMouseDown(event:MouseEvent) {
		var ptStage:Point = new Point(event.stageX, event.stageY);
		
		if (mouseInThumb(event)) {
			Screen.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			Screen.addEventListener(MouseEvent.MOUSE_UP, onScreenMouseUp);
			mouseDownOffset = ptStage.y - upThumbSkin.y;
			mouseDown = true;
			showThumbState("down");
			
		}
	}

	private function onScreenMouseUp(event:MouseEvent) {
		Screen.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		Screen.removeEventListener(MouseEvent.MOUSE_UP, onScreenMouseUp);
		mouseDown = false;
		showThumbState("up");
	}
	
	private function onMouseUp(event:MouseEvent) {
		mouseDown = false;
		Screen.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		Screen.removeEventListener(MouseEvent.MOUSE_UP, onScreenMouseUp);
		if (mouseInThumb(event)) { // mouse in thumb
			showThumbState("over");
		} else {
			showThumbState("up");
		}
	}
	
	//************************************************************
	//                  GETTERS AND SETTERS
	//************************************************************
	public function setMin(value:Float):Float {
		min = value;
		return value;
	}
	
	public function setMax(value:Float):Float {
		max = value;
		return value;
	}
	
	public function setValue(newValue:Float):Float {
		value = newValue;
		repositionThumb();
		var changeEvent:Event = new Event(Event.CHANGE);
		#if !flash
		changeEvent.target = this;
		#end
		dispatchEvent(changeEvent);
		return newValue;
	}
	
	public function setPageSize(value:Float):Float {
		pageSize = value;
		resizeThumb();
		repositionThumb();
		return value;
	}
	
	//************************************************************
	//                  HELPERS
	//************************************************************
	private function mouseInThumb(event:MouseEvent) {
		var localPoint:Point = new Point(event.localX, event.localY);
		if (localPoint.y >= upThumbSkin.y && localPoint.y <= upThumbSkin.y + upThumbSkin.height) {
			return true;
		}
		return false;
	}
	
	private function showThumbState(state:String):Void {
		if (state == "up" && upThumbSkin != null) {
			if (upThumbSkin != null) {			upThumbSkin.visible = true;	}
			if (overThumbSkin != null) {		overThumbSkin.visible = false;	}
			if (downThumbSkin != null) {		downThumbSkin.visible = false;	}
		} else if (state == "over" && overThumbSkin != null) {
			if (upThumbSkin != null) {			upThumbSkin.visible = false;	}
			if (overThumbSkin != null) {		overThumbSkin.visible = true;	}
			if (downThumbSkin != null) {		downThumbSkin.visible = false;	}
		} else if (state == "down" && downThumbSkin != null) {
			if (upThumbSkin != null) {			upThumbSkin.visible = false;	}
			if (overThumbSkin != null) {		overThumbSkin.visible = false;	}
			if (downThumbSkin != null) {		downThumbSkin.visible = true;	}
		}
	}
	
	private function resizeThumb():Void {
		var m:Int = Std.int(max - min);
		var thumbHeight:Float = (pageSize / m) * height;
		var thumbWidth:Float = width;
		if (thumbHeight < thumbMinSize) {
			thumbHeight = thumbMinSize;
		}
		if (thumbHeight > height) {
			thumbHeight = height;
		}

		// thumb up skins
		if (upThumbSkin != null) {
			removeChild(upThumbSkin);
		}

		upThumbSkin = SkinManager.skin.getSkinAsset("vscroll.thumb.up", thumbWidth, Std.int(thumbHeight));
		if (upThumbSkin != null) {
			upThumbSkin.width = thumbWidth;
			upThumbSkin.height = thumbHeight;
			
			var upThumbGripper:DisplayObject = SkinManager.skin.getSkinAsset("vscroll.thumb.gripper.up", 9, 10);
			if (upThumbGripper != null) {
				var gripperX:Float = (thumbWidth / 2) - (upThumbGripper.width / 2);
				var gripperY:Float = (thumbHeight / 2) - (upThumbGripper.height / 2);
				var bmpThumb:Bitmap = cast(upThumbSkin, Bitmap), bmpGripper:Bitmap = cast(upThumbGripper, Bitmap);
				SkinHelper.drawStretchedBitmapToBitmap(bmpGripper, new Rectangle(gripperX, gripperY, upThumbGripper.width, upThumbGripper.height), bmpThumb);
				bmpGripper.bitmapData.dispose();
			}

			upThumbSkin.visible = false;
			addChild(upThumbSkin);
		}

		// thumb over skins
		if (overThumbSkin != null) {
			removeChild(overThumbSkin);
		}

		overThumbSkin = SkinManager.skin.getSkinAsset("vscroll.thumb.over", thumbWidth, Std.int(thumbHeight));
		if (overThumbSkin != null) {
			overThumbSkin.width = thumbWidth;
			overThumbSkin.height = thumbHeight;
			
			var overThumbGripper:DisplayObject = SkinManager.skin.getSkinAsset("vscroll.thumb.gripper.over", 9, 10);
			if (overThumbGripper != null) {
				var gripperX:Float = (thumbWidth / 2) - (overThumbGripper.width / 2);
				var gripperY:Float = (thumbHeight / 2) - (overThumbGripper.height / 2);
				var bmpThumb:Bitmap = cast(overThumbSkin, Bitmap), bmpGripper:Bitmap = cast(overThumbGripper, Bitmap);
				SkinHelper.drawStretchedBitmapToBitmap(bmpGripper, new Rectangle(gripperX, gripperY, overThumbGripper.width, overThumbGripper.height), bmpThumb);
				bmpGripper.bitmapData.dispose();
			}
			
			overThumbSkin.visible = false;
			addChild(overThumbSkin);
		}

		// thumb down skins
		if (downThumbSkin != null) {
			removeChild(downThumbSkin);
		}

		downThumbSkin = SkinManager.skin.getSkinAsset("vscroll.thumb.down", thumbWidth, Std.int(thumbHeight));
		if (downThumbSkin != null) {
			downThumbSkin.width = thumbWidth;
			downThumbSkin.height = thumbHeight;
			
			var downThumbGripper:DisplayObject = SkinManager.skin.getSkinAsset("vscroll.thumb.gripper.down", 9, 10);
			if (downThumbGripper != null) {
				var gripperX:Float = (thumbWidth / 2) - (downThumbGripper.width / 2);
				var gripperY:Float = (thumbHeight / 2) - (downThumbGripper.height / 2);
				var bmpThumb:Bitmap = cast(downThumbSkin, Bitmap), bmpGripper:Bitmap = cast(downThumbGripper, Bitmap);
				SkinHelper.drawStretchedBitmapToBitmap(bmpGripper, new Rectangle(gripperX, gripperY, downThumbGripper.width, downThumbGripper.height), bmpThumb);
				bmpGripper.bitmapData.dispose();
			}
			
			downThumbSkin.visible = false;
			addChild(downThumbSkin);
		}
		
		bringToFront(eventTarget);		
		showThumbState("up");
	}
	
	private function repositionThumb():Void {
		if (upThumbSkin != null) {
			var usableHeight:Float = height - (padding.top + padding.bottom);
			usableHeight -= upThumbSkin.height;
			var m:Int = Std.int(max - min);
			var thumbPos:Float = (value / m) * usableHeight;

			upThumbSkin.y = padding.top + Std.int(thumbPos);
			if (overThumbSkin != null) {
				overThumbSkin.y = padding.top + Std.int(thumbPos);
			}
			if (downThumbSkin != null) {
				downThumbSkin.y = padding.top + Std.int(thumbPos);
			}
		}
	}
	
	private function resizeEventTarget():Void {
		if (eventTarget != null) {
			eventTarget.alpha = .0;
			eventTarget.graphics.clear();
			eventTarget.graphics.beginFill(0xFF00FF);
			eventTarget.graphics.lineStyle(0);
			eventTarget.graphics.drawRect(0, 0, Std.int(width), Std.int(height));
			eventTarget.graphics.endFill();
		}
	}
	
	private function addEventListeners():Void {
		if (eventTarget != null) {
			eventTarget.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			eventTarget.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			eventTarget.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			eventTarget.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			#if !android
				eventTarget.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			#end
			/*
			eventTarget.addEventListener(MouseEvent.CLICK, onMouseClick);
			eventTarget.useHandCursor = true;
			eventTarget.buttonMode = true;
			*/
		}
	}
}
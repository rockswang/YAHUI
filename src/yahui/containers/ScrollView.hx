package yahui.containers;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.geom.Point;
import nme.geom.Rectangle;
import yahui.controls.VScroll;
import yahui.core.Component;
import yahui.core.Screen;
import yahui.skins.SkinManager;

class ScrollView extends Component {
	private var backgroundSkin:DisplayObject;
	private var content:Container;
	private var mask:Sprite;
	
	private var vscroll:VScroll;

	// event target
	public var eventTarget:Sprite;
	
	// where the mouse down was detected (used for delta values later)
	private var mouseDown:Bool = false;
	private var mouseEventPos:Point;
	
	// scroll positions
	private var scrollY:Float = 0;
	
	private var padding:Rectangle;
	
	public var autoHideScroll:Bool = false;
	
	public function new() {
		super();
		
		content = new VBox();
		content.spacing = 5;
		mask = new Sprite();
		eventTarget = new Sprite();
		autoHideScroll = SkinManager.skin.getSkinPropBool("scrollview.scrolls.autoHide", false);
		
		padding = new Rectangle();
		padding.left = 1;
		padding.top = 1;
		padding.right = 1;
		padding.bottom = 1;
	}
	
	//************************************************************
	//                  OVERRIDABLES
	//************************************************************
	private override function createChildren():Void {
		eventTarget.visible = false;
		super.addChild(eventTarget);
		super.addChild(content);
		
		mask.graphics.beginFill(0xFF00FF);
		mask.graphics.lineStyle(0);
		mask.graphics.drawRect(0, 0, width, height);
		mask.graphics.endFill();
		content.sprite.mask = mask;
		super.addChild(mask);
		
		setScrollRange();
		resizeEventTarget();
		addEventListeners();
	}
		
	private override function resize():Void {
		drawBackground(SkinManager.skin.getSkinPropInt("application.backgroundCol", 0xFFFFFF), .005); // TODO: something not right, "phone style" dragging doenst work with .0, something to do with getting mouse events
		resizeEventTarget();

		if (backgroundSkin != null) {
			super.removeChild(backgroundSkin);
		}
		
		backgroundSkin = SkinManager.skin.getSkinAsset("listview.background", width, height);
		if (backgroundSkin != null) {
			backgroundSkin.x = 0;
			backgroundSkin.y = 0;
			backgroundSkin.width = width;
			backgroundSkin.height = height;
			super.addChild(backgroundSkin);
		}
		
		content.x = padding.left;
		content.y = padding.top;
		content.width = width - (padding.left + padding.right);
		content.height = height - (padding.top + padding.bottom);
		
		mask.width = width;
		mask.height = height;
		mask.graphics.beginFill(0xFF00FF);
		mask.graphics.lineStyle(0);
		mask.graphics.drawRect(0, 0, width, height);
		content.sprite.mask = mask;
		mask.graphics.endFill();
		
		setScrollRange();
		
		sendToBack(backgroundSkin);
		sendToBack(eventTarget);	
		bringToFront(vscroll);
	}
	
	//************************************************************
	//                  SCROLL FUNCTIONS
	//************************************************************
	private function setScrollRange():Void {
		if (content.actualHeight > content.height) {
			if (vscroll == null) {
				vscroll = new VScroll();
				vscroll.x = width - vscroll.width - padding.right;
				vscroll.y = padding.top;
				vscroll.height = height - (padding.top + padding.bottom);
				vscroll.addEventListener(Event.CHANGE, onVScrollChange);
				if (autoHideScroll == true) {
					vscroll.visible = false;
				}
				super.addChild(vscroll);
			}
			
			//vscroll.visible = true;
			if (content.actualHeight != 0) {
				vscroll.max = content.actualHeight - content.height;
				vscroll.pageSize = (height / content.actualHeight) * vscroll.max;
			}
		}
	}
	
	//************************************************************
	//                  EVENT HANDLERS
	//************************************************************
	private function onVScrollChange(e:Event):Void {
		content.y = -vscroll.value;
		scrollY = vscroll.value;
	}

	private function onMouseDown(event:MouseEvent):Void {
		if (autoHideScroll == true && vscroll != null) {
			vscroll.visible = true;
		}
		eventTarget.visible = true;
		mouseEventPos = new Point(event.stageX, event.stageY);
		mouseDown = true;
		Screen.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		Screen.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}
	
	private function onMouseMove(event:MouseEvent):Void {
		if (mouseDown == true) {
			scrollY += mouseEventPos.y - event.stageY;
			if (scrollY < 0) {
				scrollY = 0;
			}
			var maxHeight:Float = content.actualHeight;
			if (scrollY > maxHeight - height) {
				scrollY = maxHeight - height;
			}
			
			vscroll.value = scrollY;
			content.y = -scrollY;
			
			mouseEventPos = new Point(event.stageX, event.stageY);
		}
	}
	
	private function onMouseUp(event:MouseEvent):Void {
		if (autoHideScroll == true && vscroll != null) {
			vscroll.visible = false;
		}
		eventTarget.visible = false;
		mouseDown = false;
		Screen.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		Screen.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}
	
	//************************************************************
	//                  SPECIAL OVERRIDES
	//************************************************************
	public override function addChild(c:Dynamic):Dynamic {
		var r:Dynamic = content.addChild(c);
		setScrollRange();
		return r;
	}

	public override function contains(c:Dynamic):Bool {
		return content.contains(c);
	}

	public override function removeChild(c:Dynamic):DisplayObject {
		var r:Dynamic = content.removeChild(c);
		setScrollRange();
		return r;
	}

	//************************************************************
	//                  HELPERS
	//************************************************************
	private function resizeEventTarget():Void {
		if (eventTarget != null) {
			var vscrollWidth:Float = 0;
			if (vscroll != null) {
				vscrollWidth = vscroll.width;
			}
			eventTarget.alpha = .0;
			eventTarget.graphics.clear();
			eventTarget.graphics.beginFill(0xFF00FF);
			eventTarget.graphics.lineStyle(0);
			eventTarget.graphics.drawRect(0, 0, Std.int(width - vscrollWidth), Std.int(height));
			eventTarget.graphics.endFill();
		}
	}
	
	private function addEventListeners():Void {
		if (eventTarget != null) {
			eventTarget.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		super.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}
}
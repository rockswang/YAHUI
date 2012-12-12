package yahui.controls;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.geom.Point;
import nme.geom.Rectangle;
import yahui.containers.Container;
import yahui.containers.HBox;
import yahui.core.Component;
import yahui.core.Screen;
import yahui.skins.Skin;
import yahui.skins.SkinManager;

class TabBar extends Component {
	
	// getter and setter declarations
	public var selectedIndex(default, setSelectedIndex):Int = 0;
	public var buttonWidth:Float = 120;
	public var buttonHeight:Float = 30;
	
	// holds tab buttons
	private var buttons:Array<Button>;
	
	// container for tabs
	private var tabContainer:Container;
	private var backgroundSkin:DisplayObject;

	// event target
	public var eventTarget:Sprite;
	
	// inner padding for improved skinning options
	public var padding:Rectangle;
	
	// where the mouse down was detected (used for delta values later)
	private var mouseDown:Bool = false;
	private var mouseEventPos:Point;
	
	// scroll positions
	public var scrollX:Float = 0;
	
	public function new() {
		super();
		
		tabContainer = new HBox();
		buttons = new Array<Button>();
		
		height = SkinManager.skin.getSkinPropInt("tabbar.size.height", 30);
		buttonWidth = SkinManager.skin.getSkinPropInt("tab.size.width", 120);
		buttonHeight = SkinManager.skin.getSkinPropInt("tab.size.height", 30);
		
		padding = new Rectangle();
		padding.left = SkinManager.skin.getSkinPropInt("tabbar.padding.left", 0);
		padding.right = SkinManager.skin.getSkinPropInt("tabbar.padding.right", 0);
		padding.top = SkinManager.skin.getSkinPropInt("tabbar.padding.top", 0);
		padding.bottom = SkinManager.skin.getSkinPropInt("tabbar.padding.bottom", 0);
		
		eventTarget = new Sprite();
	}
	
	//************************************************************
	//                  OVERRIDABLES
	//************************************************************
	private override function createChildren():Void {
		tabContainer.height = height;
		addChild(tabContainer);
		addEventListeners();
		eventTarget.visible = false;
		addChild(eventTarget);
	}
	
	private override function resize():Void {
		resizeEventTarget();
		//drawBackground();
		
		if (backgroundSkin != null) {
			removeChild(backgroundSkin);
		}

		backgroundSkin = SkinManager.skin.getSkinAsset("tabbar.background", width, height);
		if (backgroundSkin != null) {
			backgroundSkin.width = width;
			backgroundSkin.height = height;
			addChild(backgroundSkin);
		}
		
		tabContainer.x = padding.left - scrollX;
		tabContainer.y = padding.top;
		tabContainer.width = width;
		tabContainer.height = height;
		
		sendToBack(backgroundSkin);
		bringToFront(eventTarget);
	}

	//************************************************************
	//                  TAB OPERATIONS
	//************************************************************
	public function addTab(text:String, iconId:String = null):Button {
		var button:Button = new Button();
		
		button.toggle = true;
		button.upSkinId = "tab.unselected.up";
		button.overSkinId = "tab.unselected.over";
		button.downSkinId = "tab.selected.up";
		button.text = text;
		button.iconId = iconId;
		if (buttons.length == 0 && selectedIndex == 0)  {
			button.selected = true;
		}
		button.width = buttonWidth;
		button.height = buttonHeight;
		button.iconPosition = SkinManager.skin.getSkinProp("tab.icon.position", "left");
		button.iconSize =  SkinManager.skin.getSkinPropInt("tab.icon.size", 16);
		button.textCol =  SkinManager.skin.getSkinPropInt("tab.selected.text.col", 0x000000);
		button.fontSize =  SkinManager.skin.getSkinPropInt("tab.font.size", 14);
		button.addEventListener(MouseEvent.CLICK, onButtonClick);

		tabContainer.addChild(button);
		buttons.push(button);
		
		resizeButtons();
		
		return button;
	}

	//************************************************************
	//                  EVENT HANDLERS
	//************************************************************
	private function onButtonClick(event:MouseEvent):Void {
		var button:Dynamic;
		var n:Int = 0, newSelection:Int = selectedIndex;
		for (button in buttons) {
			var testTarget:Dynamic = button.eventTarget;
			if (testTarget != event.target) {
				button.selected = false;
			} else {
				button.selected = true;
				newSelection = n;
			}
			n++;
		}

		if (newSelection != selectedIndex) {
			selectedIndex = newSelection;
			var changeEvent:Event = new Event(Event.CHANGE);
			#if !flash
			changeEvent.target = this;
			#end
			dispatchEvent(changeEvent);
		}
	}
	
	private function onMouseDown(event:MouseEvent):Void {
		trace("tab bar on mouse down");
		mouseEventPos = new Point(event.stageX, event.stageY);
		mouseDown = true;
		Screen.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		Screen.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		//eventTarget.visible = true;
	}

	private function onMouseUp(event:MouseEvent):Void {
		trace("tab bar on mouse up");
		mouseDown = false;
		Screen.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		Screen.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		eventTarget.visible = false;
		selectedIndex = selectedIndex;
	}

	private function onMouseMove(event:MouseEvent):Void {
		trace("tab bar on mouse move");
		if (mouseDown == true) {
			scrollX += -(mouseEventPos.x - event.stageX);
			//if (Math.abs(scrollX) >= 3) {
				eventTarget.visible = true;
			//}
			//if (-scrollX < tabContainer.actualWidth) {
				//scrollX = 0;
			//}
			
			var maxWidth:Float = width; // content.actualHeight;
			/*
			if (scrollX > maxWidth - width) {
				scrollX = maxWidth - width;
			}
			*/
			
			//vscroll.value = scrollY;
			
			if (scrollX > padding.left) {
				scrollX = padding.left;
			}
			if (scrollX < -tabContainer.actualWidth + width) {
				scrollX = -tabContainer.actualWidth + width;
			}

			tabContainer.x = scrollX;
			
			mouseEventPos = new Point(event.stageX, event.stageY);
		}
	}
	
	//************************************************************
	//                  HELPERS
	//************************************************************
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
	
	private function resizeButtons():Void {
		
	}

	private function addEventListeners():Void {
		/*
		if (eventTarget != null) {
			eventTarget.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		*/
		super.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}
	//************************************************************
	//                  GETTERS AND SETTERS
	//************************************************************
	public function setSelectedIndex(value:Int):Int {
		var button:Dynamic;
		var n:Int = 0;
		for (button in buttons) {
			if (value != n) {
				button.selected = false;
			} else {
				button.selected = true;
			}
			n++;
		}
		
		selectedIndex = value;
		var changeEvent:Event = new Event(Event.CHANGE);
		#if !flash
		changeEvent.target = this;
		#end
		dispatchEvent(changeEvent);
		return value;
	}
}
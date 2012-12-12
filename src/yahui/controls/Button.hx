package yahui.controls;

import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.events.MouseEvent;
import nme.Lib;
import nme.media.Sound;
import yahui.core.Component;
import yahui.core.Screen;
import yahui.skins.SkinManager;

class Button extends Component {

	// getter and setter declarations
	public var upSkinId:String = "button.up";
	public var overSkinId:String = "button.over";
	public var downSkinId:String = "button.down";
	public var text:String = " ";
	public var iconId:String;
	public var clickSoundId:String = "button.click";
	
	// skin objects
	private var upSkin:DisplayObject;
	private var overSkin:DisplayObject;
	private var downSkin:DisplayObject;
	
	// event target
	public var eventTarget:Sprite;
	
	// for toggle buttons
	public var toggle:Bool = false;
	public var selected(default, setSelected):Bool = false;
	
	// button props
	public var textCol:Int = 0x000000;
	public var fontName:String = "_sans";
	public var fontSize:Int = 14;
	public var iconPosition:String = "left"; // farLeft, right, farRight, top, bottom
	public var iconSize:Int = 16;
	
	// if the mouse is in the control
	private var mouseIn:Bool = false;
	
	// label for text
	private var label:Label;
	
	// icon
	private var icon:DisplayObject;
	
	public function new() {
		super();
		
		width = SkinManager.skin.getSkinPropInt("button.size.width", 100);
		height = SkinManager.skin.getSkinPropInt("button.size.height", 30);
		fontSize = SkinManager.skin.getSkinPropInt("button.font.size", 14);
		textCol = SkinManager.skin.getSkinPropInt("button.text.col", 0x000000);
		eventTarget = new Sprite();
		
		label = new Label();
	}
	
	//************************************************************
	//                  OVERRIDABLES
	//************************************************************
	private override function createChildren():Void {
		label.textCol = textCol;
		label.fontName = fontName;
		label.fontSize = fontSize;
		label.textAlign = "center";
		label.text = text;
		addChild(label);
		
		if (iconId != null) {
			icon = SkinManager.skin.getSkinIcon(iconId, iconSize);
			addChild(icon);
		}
		
		addEventListeners();
		addChild(eventTarget);
	}
	
	private override function resize():Void {
		resizeEventTarget();
		
		// get resized up assets
		if (upSkin != null) {
			removeChild(upSkin);
		}

		upSkin = SkinManager.skin.getSkinAsset(upSkinId, width, height);
		if (upSkin != null) {
			upSkin.width = width;
			upSkin.height = height;
			upSkin.visible = false;
			addChild(upSkin);
		}
		
		// get resized over assets
		if (overSkin != null) {
			removeChild(overSkin);
		}

		overSkin = SkinManager.skin.getSkinAsset(overSkinId, width, height);
		if (overSkin != null) {
			overSkin.width = width;
			overSkin.height = height;
			overSkin.visible = false;
			addChild(overSkin);
		}

		// get resized down assets
		if (downSkin != null) {
			removeChild(downSkin);
		}

		downSkin = SkinManager.skin.getSkinAsset(downSkinId, width, height);
		if (downSkin != null) {
			downSkin.width = width;
			downSkin.height = height;
			downSkin.visible = false;
			addChild(downSkin);
		}

		var labelX = (width / 2) - (label.width / 2);
		var labelY = (height / 2) - (label.height / 2);
		var iconX = 0.0;
		var iconY = 0.0;
		if (icon != null) {
			if (label.text == " " || label.text.length == 0) { // TODO: strange performance problem on cpp if text is zero length, defaulted in label and button to a single space for now
				iconX = (width / 2) - (icon.width / 2);
				iconY = (height / 2) - (icon.height / 2);
			} else {
				if (iconPosition == "left") {
					iconX = labelX - icon.width - 2;
					iconY = (height / 2) - (icon.height / 2);
				} else if (iconPosition == "top") {
					var combHeight = label.height + icon.height;
					
					iconX = (width / 2) - (icon.width / 2);
					iconY = (height / 2) - (combHeight / 2);
					labelY += (icon.height / 2);
				}
			}
			
			icon.x = iconX;
			icon.y = iconY;
		}
		label.x = labelX;
		label.y = labelY;
		
		bringToFront(label); // make sure label is above skin images
		bringToFront(icon); // make sure icon is above skin images
		bringToFront(eventTarget); // make sure event target is top of the display list
		
		// display state
		if (toggle == true && selected == true) {
			showState("down");
		} else {
			showState("up");
		}
	}
	
	//************************************************************
	//                  EVENT HANDLERS
	//************************************************************
	private function onMouseOver(event:MouseEvent):Void {
		mouseIn = true;
		if (toggle == false || selected == false) {
			showState("over");
		}
	}
	
	private function onMouseOut(event:MouseEvent):Void {
		mouseIn = false;
		if (toggle == false || selected == false) {
			showState("up");
		}
	}
	
	private function onMouseDown(event:MouseEvent):Void {
		Screen.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		showState("down");
	}
	
	private function onMouseUp(event:MouseEvent):Void {
		Screen.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		showState("down");

		if (toggle == false) {
			#if android
				showState("up");
			#else
				if (mouseIn == true && overSkin != null) {
					showState("over");
				} else {
					showState("up");
				}
			#end
		}
	}
	
	private function onMouseClick(event:MouseEvent):Void {
		if (toggle == true) {
			selected = !selected;
			if (selected == true) {
				showState("down");
			} else {
				showState("up");
			}
		}

		var sound:Sound = SkinManager.skin.getSkinSound(clickSoundId);
		if (sound != null) {
			sound.play();
		}
	}
	
	//************************************************************
	//                  GETTERS AND SETTERS
	//************************************************************
	public function setSelected(value:Bool):Bool {
		if (toggle == true) {
			selected = value;
			if (value == true) {
				showState("down");
			} else {
				showState("up");
			}
		}
		return value;
	}
	
	//************************************************************
	//                  HELPERS
	//************************************************************
	private function showState(state:String):Void {
		if (state == "up" && upSkin != null) {
			if (upSkin != null) {		upSkin.visible = true;	}
			if (overSkin != null) {		overSkin.visible = false;	}
			if (downSkin != null) {		downSkin.visible = false;	}
		} else if (state == "over" && overSkin != null) {
			if (upSkin != null) {		upSkin.visible = false;	}
			if (overSkin != null) {		overSkin.visible = true;	}
			if (downSkin != null) {		downSkin.visible = false;	}
		} else if (state == "down" && downSkin != null) {
			if (upSkin != null) {		upSkin.visible = false;	}
			if (overSkin != null) {		overSkin.visible = false;	}
			if (downSkin != null) {		downSkin.visible = true;	}
		}
	}
	
	private function resizeEventTarget():Void {
		if (eventTarget != null) {
			eventTarget.alpha = 0;
			eventTarget.graphics.clear();
			eventTarget.graphics.beginFill(0xFF00FF);
			eventTarget.graphics.lineStyle(0);
			eventTarget.graphics.drawRect(0, 0, Std.int(width), Std.int(height));
			eventTarget.graphics.endFill();
		}
	}
	
	private function addEventListeners():Void {
		if (eventTarget != null) {
			eventTarget.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			eventTarget.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			eventTarget.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//eventTarget.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			eventTarget.addEventListener(MouseEvent.CLICK, onMouseClick);
			eventTarget.useHandCursor = true;
			eventTarget.buttonMode = true;
		}
	}
}
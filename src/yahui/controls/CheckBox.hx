package yahui.controls;

import yahui.core.Component;
import yahui.skins.SkinManager;

class CheckBox extends Component {
	public var checked(getChecked, setChecked):Bool;
	public var text:String = "Checkbox";
	public var checkWidth:Int = 12;
	public var checkHeight:Int = 12;
	
	private var button:Button;
	private var label:Label;
	
	// checkbox props
	public var textCol:Int = 0x000000;
	public var fontName:String = "_sans";
	public var fontSize:Int = 12;
	
	public function new() {
		super();
	
		textCol = SkinManager.skin.getSkinPropInt("checkbox.text.col", 0x000000);
		fontSize = SkinManager.skin.getSkinPropInt("checkbox.font.size", 12);
		checkWidth = SkinManager.skin.getSkinPropInt("checkbox.size.width", 12);
		checkHeight = SkinManager.skin.getSkinPropInt("checkbox.size.height", 12);
		
		button = new Button();
		button.upSkinId = "checkbox.unchecked.up";
		button.downSkinId = "checkbox.checked.up";
//		button.width = 13;// ;
//		button.height = 13;// 
		button.toggle = true;
		
		label = new Label();
		label.textCol = textCol;
		label.fontName = fontName;
		label.fontSize = fontSize;
		
		width = 120;
		height = button.height;
	}
	
	//************************************************************
	//                  OVERRIDABLES
	//************************************************************
	private override function createChildren():Void {
		addChild(button);
		
		label.textCol = textCol;
		label.fontName = fontName;
		label.fontSize = fontSize;
		label.text = text;
		addChild(label);
	}

	private override function resize():Void {
		//drawBackground();
		
		button.width = checkWidth;
		button.height = checkHeight;
		button.y = Std.int((height / 2) - (button.height / 2));
		
		label.x = button.width + 3;
		label.y = Std.int((height / 2) - (label.height / 2));
	}

	//************************************************************
	//                  GETTERS AND SETTERS
	//************************************************************
	public function getChecked():Bool {
		return button.selected;
	}
	
	public function setChecked(value:Bool):Bool {
		button.selected = value;
		return value;
	}
}
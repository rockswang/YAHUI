package yahui.controls;

import yahui.core.Component;

class CheckBox extends Component {
	public var text:String = "Checkbox";
	public var checkWidth:Int = 32;
	public var checkHeight:Int = 32;
	
	private var button:Button;
	private var label:Label;
	
	// checkbox props
	public var textCol:Int = 0xFFFFFF;
	public var fontName:String = "_sans";
	public var fontSize:Int = 16;
	
	public function new() {
		super();
	
		button = new Button();
		button.upSkinId = "checkbox.unchecked.up";
		button.downSkinId = "checkbox.checked.up";
		button.toggle = true;
		
		label = new Label();
		
		width = 120;
		height = 40;
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

}
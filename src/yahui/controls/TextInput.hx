package yahui.controls;

import nme.display.DisplayObject;
import nme.geom.Rectangle;
import nme.text.TextField;
import nme.text.TextFieldType;
import nme.text.TextFormat;
import yahui.core.Component;
import yahui.skins.SkinManager;

class TextInput extends Component {
	public var text(getText, setText):String = "";
	
	// skin objects
	private var normalSkin:DisplayObject;
	
	private var textControl:TextField;
	
	// text props
	public var textCol:Int = 0x000000;
	public var fontName:String = "_sans";
	public var fontSize:Int = 14;
	
	private var padding:Rectangle;
	
	public function new() {
		super();
		
		width = 229;
		height = 40;
		
		textControl = new TextField();
		padding = new Rectangle();
		padding.left = SkinManager.skin.getSkinPropInt("textinput.padding.left", 0);
		padding.top = SkinManager.skin.getSkinPropInt("textinput.padding.top", 0);
		padding.bottom = SkinManager.skin.getSkinPropInt("textinput.padding.bottom", 0);
		padding.right = SkinManager.skin.getSkinPropInt("textinput.padding.right", 0);
	}
	
	//************************************************************
	//                  OVERRIDABLES
	//************************************************************
	private override function createChildren():Void {
		var format:TextFormat = new TextFormat(fontName, fontSize, textCol);
		textControl.defaultTextFormat = format;

		textControl.selectable = true;
		textControl.type = TextFieldType.INPUT;
		#if flash
			textControl.embedFonts = false;
		#else
			textControl.embedFonts = true;
		#end
		addChild(textControl);
		textControl.text = text;
	}
	
	private override function resize():Void {
		//drawBackground();
		
		if (normalSkin != null) {
			removeChild(normalSkin);
		}
		
		normalSkin = SkinManager.skin.getSkinAsset("textinput.normal", width, height);
		if (normalSkin != null) {
			normalSkin.width = width;
			normalSkin.height = height;
			addChild(normalSkin);
		}
		
		textControl.width = width - (padding.left + padding.right);
		textControl.height = textControl.textHeight + 6;
		textControl.x = padding.left;
		textControl.y = Std.int(((height - padding.top - padding.bottom) / 2) - (textControl.height / 2));
		bringToFront(textControl);
	}
	
	//************************************************************
	//                  GETTERS AND SETTERS
	//************************************************************
	public function getText():String {
		return textControl.text;
	}
	
	public function setText(value:String) {
		textControl.text = value;
		return value;
	}
}
package yahui.controls;
import nme.text.TextField;
import nme.text.TextFormat;
import yahui.core.Component;

class Label extends Component {
	public var text:String = " ";
	
	private var textControl:TextField;
	
	// label props
	public var textCol:Int = 0x000000;
	public var fontName:String = "_sans";
	public var fontSize:Int = 24;
	public var textAlign:String = "left";
	
	public function new() {
		super();
		
		textControl = new TextField();

		width = -1;
		height = -1;
	}
	
	//************************************************************
	//                  OVERRIDABLES
	//************************************************************
	private override function createChildren():Void {
		var format:TextFormat = new TextFormat(fontName, fontSize, textCol);
		textControl.defaultTextFormat = format;
		//textControl.height = format.size + 6;
		textControl.selectable = false;
		textControl.mouseEnabled = false;
		#if flash
			textControl.embedFonts = false;
		#else
			textControl.embedFonts = true;
		#end
		addChild(textControl);
		textControl.text = text;
		textControl.width = textControl.textWidth + 6;
		textControl.height = textControl.textHeight + 6;
		if (width == -1) {
			width = textControl.width;
		}
		if (height == -1) {
			height = textControl.height;
		}
	}
	
	private override function resize():Void {
		//drawBackground();

		var ypos:Int = Std.int((height / 2) - (textControl.height / 2));
		var xpos:Int = 0;
		if (textAlign == "left") {
			xpos = 0;
		} else if (textAlign == "center") {
			xpos = Std.int(width / 2 - (textControl.width / 2));
		}
		
		textControl.x = xpos;
		textControl.y = ypos;
	}
}
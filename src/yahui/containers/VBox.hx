package yahui.containers;

import nme.display.DisplayObject;
import yahui.core.Component;

class VBox extends Container {
	public function new() {
		super();
		
		width = 1;
		height = 1;
	}
	
	//************************************************************
	//                  OVERRIDABLES
	//************************************************************
	private override function resize():Void {
		//drawBackground();

		var n:Int = 0;
		var ypos:Float = 0;
		for (n in 0...sprite.numChildren) {
			var s:DisplayObject = sprite.getChildAt(n);
			var c:Component = findChildFromSprite(s);
			if (c != null) {
				c.y = ypos;
				ypos += c.height + spacing;
			} else {
				s.y = ypos;
				ypos += s.height + spacing;
			}
		}
		
		actualHeight = ypos - spacing;
	}
}
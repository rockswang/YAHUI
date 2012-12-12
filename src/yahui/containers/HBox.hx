package yahui.containers;

import nme.display.DisplayObject;
import yahui.core.Component;

class HBox extends Container {
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
		var xpos:Float = 0;
		var acy:Float = 0;
		for (n in 0...sprite.numChildren) {
			var s:DisplayObject = sprite.getChildAt(n);
			var c:Component = findChildFromSprite(s);
			
			if (c != null) {
				c.x = xpos;
				xpos += c.width + spacing;
				if (c.height > acy) {
					acy = c.height;
				}
			} else {
				s.x = xpos;
				xpos += s.width + spacing;
				if (s.height > acy) {
					acy = s.height;
				}
			}
		}

		actualWidth = xpos - spacing;
		actualHeight = acy;
	}
}
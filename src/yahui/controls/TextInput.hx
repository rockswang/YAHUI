package yahui.controls;

import nme.display.DisplayObject;
import yahui.core.Component;
import yahui.skins.SkinManager;

class TextInput extends Component {
	// skin objects
	private var normalSkin:DisplayObject;
	
	public function new() {
		super();
		
		width = 229;
		height = 40;
	}
	
	//************************************************************
	//                  OVERRIDABLES
	//************************************************************
	private override function createChildren():Void {
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
	}
}
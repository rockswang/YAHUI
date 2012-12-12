package yahui.skins;

import nme.display.DisplayObject;
import nme.media.Sound;

class Skin {
	public function new() {
		
	}
	
	//************************************************************
	//                  OVERRIDABLES
	//************************************************************
	public function getSkinAsset(id:String, width:Float, height:Float):DisplayObject {
		return null;
	}

	public function getSkinProp(id:String, defaultValue:String = null):String {
		return defaultValue;
	}
	
	public function getSkinIcon(id:String, size:Int):DisplayObject {
		return null;
	}
	
	public function getSkinSound(id:String):Sound {
		return null;
	}
	//************************************************************
	//                  HELPERS
	//************************************************************
	public function getSkinPropInt(id:String, defaultValue:Int = 0):Int {
		var value:Int = defaultValue;
		var stringValue = getSkinProp(id, null);
		if (stringValue != null && stringValue.length > 0) {
			value = Std.parseInt(stringValue);
		}
		return value;
	}
	
	public function getSkinPropBool(id:String, defaultValue:Bool = false):Bool {
		var value:Bool = defaultValue;
		var stringValue = getSkinProp(id, null);
		if (stringValue != null && stringValue.length > 0) {
			stringValue = stringValue.toLowerCase();
			if (stringValue == "true" || stringValue == "1" || stringValue == "yes") {
				value = true;
			} else {
				value = false;
			}
		}
		return value;
	}
}
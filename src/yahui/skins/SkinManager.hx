package yahui.skins;

class SkinManager {
	public static var skin(getSkin, null):Skin;
	
	private function new() {
		
	}
	
	public static function loadSkinXML(xmlAssetPath:String):Void {
		var xmlSkin:XMLSkin = null;
		xmlSkin = new XMLSkin();
		xmlSkin.loadXML(xmlAssetPath);
		skin = xmlSkin;
	}
	
	//************************************************************
	//                  GETTERS AND SETTERS
	//************************************************************
	public static function getSkin():Skin {
		if (skin == null) {
			skin = new BasicSkin();
		}
		return skin;
	}
	
	
}
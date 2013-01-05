package yahui.controls;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.DisplayObject;
import yahui.core.Component;
import yahui.skins.SkinManager;

class Image extends Component {
	public var bitmapAssetPath(null, setBitmapAssetPath):String;
	public var iconId(null, setIconId):String;
	public var iconSize(default, setIconSize):Int = 32;
	
	private var bitmapData:BitmapData;
	private var bmp:Bitmap;
	private var icon:DisplayObject;
	
	public function new() {
		super();
	}
	
	//************************************************************
	//                  OVERRIDABLES
	//************************************************************
	private override function createChildren():Void {
	}

	private override function resize():Void {
		bmp.width = width;
		bmp.height = height;
	}

	//************************************************************
	//                  GETTERS AND SETTERS
	//************************************************************
	public function setBitmapAssetPath(value:String):String {
		bitmapData = Assets.getBitmapData(value);
		if (bmp != null && contains(bmp) == true) {
			removeChild(bmp);
			bmp = null;
		}
		if (icon != null && contains(icon) == true) {
			removeChild(icon);
			icon = null;
			iconId = null;
		}
		if (bitmapData != null) {
			bmp = new Bitmap(bitmapData);
			addChild(bmp);
		}
		return value;
	}
	
	public function setIconId(value:String):String {
		var skinIcon:DisplayObject = SkinManager.skin.getSkinIcon(value, iconSize);
		if (bmp != null && contains(bmp) == true) {
			removeChild(bmp);
			bmp = null;
		}
		if (icon != null && contains(icon) == true) {
			removeChild(icon);
			icon = null;
			iconId = null;
		}
		if (skinIcon != null) {
			icon = skinIcon;
			iconId = value;
			addChild(icon);
		}
		return value;
	}
	
	public function setIconSize(value:Int):Int {
		if (value != iconSize) {
			iconSize = value;
			if (iconId != null) {
				setIconId(iconId);
			}
		}
		return value;
	}
}
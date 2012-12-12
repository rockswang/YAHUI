package yahui.controls;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import yahui.core.Component;

class Image extends Component {
	public var bitmapAssetPath(null, setBitmapAssetPath):String;
	
	private var bitmapData:BitmapData;
	private var bmp:Bitmap;
	
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
		if (bitmapData != null) {
			if (bmp != null && contains(bmp) == true) {
				removeChild(bmp);
			}
			bmp = new Bitmap(bitmapData);
			addChild(bmp);
		}
		return value;
	}
}
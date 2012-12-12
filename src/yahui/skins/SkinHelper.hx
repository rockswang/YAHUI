package yahui.skins;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.geom.Matrix;
import nme.geom.Rectangle;

class SkinHelper {
	private function new() {
		
	}
	
	public static function drawCompoundBitmap(assetPaths:Hash<String>, targetRect:Rectangle = null, target:Bitmap = null):Bitmap {
		if (targetRect == null) {
			return target;
		}
		
		if (target == null) {
			var targetData:BitmapData = new BitmapData(Std.int(targetRect.width), Std.int(targetRect.height));
			target = new Bitmap(targetData);
		}

		// top row
		var tl:String = assetPaths.get("top.left");
		var tlSize:Rectangle = new Rectangle();
		if (tl != null) {
			tlSize = getBitmapSize(tl);
			drawStretchedBitmap(tl, new Rectangle(0, 0, tlSize.width, tlSize.height), target);
		}

		var tr:String = assetPaths.get("top.right");
		var trSize:Rectangle = new Rectangle();
		if (tr != null) {
			trSize = getBitmapSize(tr);
			drawStretchedBitmap(tr, new Rectangle(targetRect.width - trSize.width, 0, trSize.width, trSize.height), target);
		}

		var t:String = assetPaths.get("top");
		var tSize:Rectangle = new Rectangle();
		if (t != null) {
			tSize = getBitmapSize(t);
			drawStretchedBitmap(t, new Rectangle(tlSize.width, 0, targetRect.width - (tlSize.width + trSize.width), tSize.height), target);
		}
		
		// bottom row
		var bl:String = assetPaths.get("bottom.left");
		var blSize:Rectangle = new Rectangle();
		if (bl != null) {
			blSize = getBitmapSize(bl);
			drawStretchedBitmap(bl, new Rectangle(0, targetRect.height - blSize.height, blSize.width, blSize.height), target);
		}

		var br:String = assetPaths.get("bottom.right");
		var brSize:Rectangle = new Rectangle();
		if (br != null) {
			brSize = getBitmapSize(br);
			drawStretchedBitmap(br, new Rectangle(targetRect.width - brSize.width, targetRect.height - brSize.height, brSize.width, brSize.height), target);
		}

		var b:String = assetPaths.get("bottom");
		var bSize:Rectangle = new Rectangle();
		if (b != null) {
			bSize = getBitmapSize(b);
			drawStretchedBitmap(b, new Rectangle(blSize.width, targetRect.height - blSize.height, targetRect.width - (blSize.width + brSize.width), bSize.height), target);
		}
		
		// middle row
		var l:String = assetPaths.get("left");
		var lSize:Rectangle = new Rectangle();
		if (l != null) {
			lSize = getBitmapSize(l);
			drawStretchedBitmap(l, new Rectangle(0, tlSize.height, lSize.width, targetRect.height - (tlSize.height + blSize.height)), target);
		}
		
		var r:String = assetPaths.get("right");
		var rSize:Rectangle = new Rectangle();
		if (r != null) {
			rSize = getBitmapSize(l);
			drawStretchedBitmap(r, new Rectangle(targetRect.width - rSize.width, trSize.height, rSize.width, targetRect.height - (trSize.height + brSize.height)), target);
		}
		
		var m:String = assetPaths.get("middle");
		var mSize:Rectangle = new Rectangle();
		if (m != null) {
			mSize = getBitmapSize(l);
			drawStretchedBitmap(m, new Rectangle(lSize.width, tSize.height, targetRect.width - (lSize.width + rSize.width), targetRect.height - (tSize.height + bSize.height)), target);
		}
		
		return target;
	}
	
	public static function drawStretchedBitmap(assetPath:String, targetRect:Rectangle = null, target:Bitmap = null):Bitmap {
		var src:Bitmap = new Bitmap(Assets.getBitmapData(assetPath));
		return drawStretchedBitmapToBitmap(src, targetRect, target);
	}
	
	public static function drawStretchedBitmapToBitmap(src:Bitmap, targetRect:Rectangle = null, target:Bitmap = null):Bitmap {
		if (targetRect == null) {
			targetRect = new Rectangle(0, 0, src.width, src.height);
		}
		
		if (target == null) {
			var targetData:BitmapData = new BitmapData(Std.int(targetRect.width), Std.int(targetRect.height));
			target = new Bitmap(targetData);
		}
		
		var origin:Rectangle = new Rectangle(0, 0, src.width, src.height);
		var draw:Rectangle = targetRect;

		var mat:Matrix = new Matrix();
		mat.identity();
		mat.a = draw.width / origin.width;
		mat.d = draw.height / origin.height;
		mat.tx = draw.x - origin.x * mat.a;
		mat.ty = draw.y - origin.y * mat.d;
		
		target.bitmapData.draw(src.bitmapData, mat);
		
		return target;
	}
	
	public static function getBitmapSize(assetPath:String):Rectangle {
		var bmp:Bitmap = new Bitmap(Assets.getBitmapData(assetPath));
		var rc:Rectangle = new Rectangle(0, 0, bmp.width, bmp.height);
		return rc;
	}
}
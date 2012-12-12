package yahui.skins;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.media.Sound;

class BasicSkin extends Skin {
	public function new() {
		super();
	}
	
	//************************************************************
	//                  OVERRIDABLES
	//************************************************************
	public override function getSkinAsset(id:String, width:Float, height:Float):DisplayObject {
		var asset:DisplayObject = super.getSkinAsset(id, width, height);
		
		/*
		if (asset == null) {
			var sprite:Sprite = new Sprite();
			sprite.graphics.clear();
			sprite.graphics.beginFill(0xCCCCCC);
			sprite.graphics.lineStyle(1, 0x888888);
			sprite.graphics.drawRect(0, 0, Std.int(width), Std.int(height));
			sprite.graphics.endFill();
			asset = sprite;
		}
		*/
		
		return asset;
	}

	public override function getSkinProp(id:String, defaultValue:String = null):String {
		var prop:String = super.getSkinProp(id, defaultValue);
		return prop;
	}

	public override function getSkinIcon(id:String, size:Int):DisplayObject {
		var icon:DisplayObject = super.getSkinIcon(id, size);
		var path:String = null;
		
		if (id == "icons.home") {
			path = "icons/home_";
		} else if (id == "icons.addressBook") {
			path = "icons/address_book_";
		} else if (id == "icons.favs") {
			path = "icons/fav_";
		} else if (id == "icons.search") {
			path = "icons/search_";
		} else if (id == "icons.settings") {
			path = "icons/settings_";
		} else if (id == "icons.files.blank") {
			path = "icons/file_blank_";
		} else if (id == "icons.files.gif") {
			path = "icons/file_gif_";
		} else if (id == "icons.files.text") {
			path = "icons/file_text_";
		} else if (id == "icons.user") {
			path = "icons/user_";
		} else if (id == "icons.folders.open") {
			path = "icons/folder_open_";
		}
		
		if (path != null) {
			path = path + size + ".png";
			icon = new Bitmap(Assets.getBitmapData(path));
		} else {
			if (size != 16 && size != 32) {
				size = 16;
			}
			
			icon = new Bitmap(Assets.getBitmapData("icons/default_"  + size + ".png"));
		}
		
		return icon;
	}

	public override function getSkinSound(id:String):Sound {
		return null;
	}
}
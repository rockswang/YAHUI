package yahui.skins;
import nme.Assets;
import nme.display.DisplayObject;
import nme.geom.Rectangle;
import nme.media.Sound;

class XMLSkin extends BasicSkin {
	private var basePath:String;
	private var items:Hash<XMLSkinItem>;
	private var props:Hash<String>;
	private var sounds:Hash<String>;
	
	public function new() {
		super();
		
		items = new Hash<XMLSkinItem>();
		props = new Hash<String>();
		sounds = new Hash<String>();
	}

	//************************************************************
	//                  OVERRIDABLES
	//************************************************************
	public override function getSkinAsset(id:String, width:Float, height:Float):DisplayObject {
		var asset:DisplayObject = super.getSkinAsset(id, width, height);
		
		var item:XMLSkinItem = items.get(id);
		var part:XMLSkinItemPart = null;
		var fixedPath:String = null;
		if (item != null) {
			if (item.type == "image.compound") {
				var assetIds:Hash<String> = new Hash<String>();
				for (part in item.parts) {
					fixedPath = basePath + part.path;
					assetIds.set(part.id, fixedPath);
				}
				asset = SkinHelper.drawCompoundBitmap(assetIds, new Rectangle(0, 0, width, height));
			}
		}
		
		return asset;
	}

	public override function getSkinProp(id:String, defaultValue:String = null):String {
		var prop:String = super.getSkinProp(id, defaultValue);
		
		if (props.exists(id)) {
			prop = props.get(id);
		}
		
		return prop;
	}
	
	public override function getSkinIcon(id:String, size:Int):DisplayObject {
		var icon:DisplayObject = super.getSkinIcon(id, size);
		return icon;
	}
	
	public override function getSkinSound(id:String):Sound {
		var sound:Sound = super.getSkinSound(id);
		var soundPath:String = sounds.get(id);
		if (soundPath != null) {
			var fixedPath:String = basePath + soundPath;
			sound = Assets.getSound(fixedPath);
		}
		
		return sound;
	}
	//************************************************************
	//                  LOAD FROM XML TEXT
	//************************************************************
	public function loadXML(xmlAssetPath:String):Void {
		//trace(">> Loading skin xml from: " + xmlAssetPath);
		
		var n:Int = xmlAssetPath.lastIndexOf("/");
		basePath = xmlAssetPath.substr(0, n + 1);

		var xmlString:String = Assets.getText(xmlAssetPath);
		var xml:Xml = Xml.parse(xmlString).firstElement();
		var child:Xml;
		for (child in xml) {
			if (Std.string(child.nodeType) == "element") {
				if (child.nodeName == "item") {
					loadItem(child);
				} else if (child.nodeName == "prop") {
					var propId:String = child.get("id");
					var propValue:String = child.get("value");
					if (propId != null && propValue != null && propId.length > 0 && propValue.length > 0) {
						props.set(propId, propValue);
					}
				} else if (child.nodeName == "sound") {
					var soundId:String = child.get("id");
					var soundPath:String = child.get("path");
					if (soundId != null && soundPath != null && soundId.length > 0 && soundPath.length > 0) {
						sounds.set(soundId, soundPath);
					}
				}
			}
		}
	}
	
	private function loadItem(node:Xml):Void {
		var id:String = node.get("id");
		var child:Xml = node.firstElement();
		if (Std.string(child.nodeType) == "element") {
			if (child.nodeName == "image") {
				loadImageItem(id, child);
			}
		}
	}
	
	private function loadImageItem(id:String, node:Xml):Void {
		var path:String = node.get("path");
		var item:XMLSkinItem = null;
		var part:XMLSkinItemPart = null;
		var child:Xml;
		if (path != null && path.length > 0) {
			item = new XMLSkinItem();
			item.type = "image.basic";
			item.path = path;
		} else {
			item = new XMLSkinItem();
			item.type = "image.compound";
			item.parts = new Hash<XMLSkinItemPart>();
			for (child in node) {
				if (Std.string(child.nodeType) == "element") {
					if (child.nodeName == "part") {
						part = loadImagePart(child);
						item.parts.set(part.id, part);
					}
				}
			}
		}
		
		if (item != null) {
			items.set(id, item);
		}
	}
	
	private function loadImagePart(node:Xml):XMLSkinItemPart {
		var part:XMLSkinItemPart = new XMLSkinItemPart();
		
		var id:String = node.get("id");
		var path:String = node.get("path");
		
		part.id = id;
		part.path = path;
		
		return part;
	}
}

//************************************************************
//                  PRIVATE CLASSES
//************************************************************
private class XMLSkinItem {
	public var type:String;
	public var path:String;
	public var parts:Hash<XMLSkinItemPart>;

	public function new() {
		
	}
}

private class XMLSkinItemPart {
	public var id:String;
	public var path:String;
	
	public function new() {
		
	}
}
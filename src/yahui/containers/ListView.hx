package yahui.containers;

import nme.display.DisplayObject;
import yahui.controls.Label;
import yahui.core.Component;
import yahui.skins.SkinManager;

class ListView extends ScrollView {
	
	public function new() {
		super();
	}
	
	//************************************************************
	//                  OVERRIDABLES
	//************************************************************
	private override function createChildren():Void {
		super.createChildren();
	}
		
	private override function resize():Void {
		super.resize();
		
		//drawBackground();
	}
	
	//************************************************************
	//                  LIST FUNCTIONS
	//************************************************************
	public function addBasicItem(text:String, iconId:String = null):ListItem {
		var item:BasicListItem = new BasicListItem();
		
		item.width = width;
		item.text = text;
		item.iconId = iconId;
		
		addChild(item);
		
		return item;
	}
}

//************************************************************
//                  PRIVATE CLASSES
//************************************************************
private class ListItem extends Component {
	private var backgroundSkin:DisplayObject;
	
	public function new() {
		super();

		height = SkinManager.skin.getSkinPropInt("listview.item.height", 50);
		width = 100;
	}
	
	private override function createChildren():Void {
	}
	
	private override function resize():Void {
		if (backgroundSkin != null) {
			removeChild(backgroundSkin);
		}
		
		backgroundSkin = SkinManager.skin.getSkinAsset("listview.item.unselected", width, height);
		if (backgroundSkin != null) {
			backgroundSkin.width = width;
			backgroundSkin.height = height;
			addChild(backgroundSkin);
		}
		
		if (backgroundSkin != null) {
			sendToBack(backgroundSkin);
		}
		
	}
}

private class BasicListItem extends ListItem {
	public var text:String;
	public var fontSize:Int = 14;
	public var textCol:Int = 0x000000;
	public var iconId:String;
	public var iconSize:Int = 16;
	
	private var labelControl:Label;
	private var iconControl:DisplayObject;
	
	public function new() {
		super();
		labelControl = new Label();
		
		fontSize = SkinManager.skin.getSkinPropInt("listview.item.font.size", 14);
		textCol = SkinManager.skin.getSkinPropInt("listview.item.text.col", 0x000000);
		iconSize = SkinManager.skin.getSkinPropInt("listview.item.icon.size", 16);
	}
	
	private override function createChildren():Void {
		super.createChildren();
		
		labelControl.text = text;
		labelControl.fontSize = fontSize;
		labelControl.textCol = textCol;
		addChild(labelControl);
		
		if (iconId != null) {
			iconControl = SkinManager.skin.getSkinIcon(iconId, iconSize);
			if (iconControl != null) {
				addChild(iconControl);
			}
		}
	}
		
	private override function resize():Void {
		super.resize();
		//drawBackground(0xFF0000);
		
		var labelX:Float = 0;// (width / 2) - (label.width / 2);
		var labelY:Float = (height / 2) - (labelControl.height / 2);
		var iconX:Float = 0.0;
		var iconY:Float = 0.0;
		if (iconControl != null) {
			iconX = 0;
			iconY = (height / 2) - (iconControl.height / 2);
			iconControl.x = iconX;
			iconControl.y = iconY;
			labelX += iconControl.width + 3;
		}
		
		labelControl.x = labelX;
		labelControl.y = labelY;
	}
}
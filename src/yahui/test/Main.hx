package yahui.test;

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.geom.Rectangle;
import nme.Lib;
import yahui.containers.HBox;
import yahui.containers.VBox;
import yahui.controls.Button;
import yahui.controls.Label;
import yahui.controls.TabBar;
import yahui.core.Component;
import yahui.core.Screen;
import yahui.skins.SkinHelper;
import yahui.skins.SkinManager;

class Main extends Sprite {
	public static var WINDOWS_SKIN:String = "skins/windows/skin.xml";
	public static var ANDROID_SKIN:String = "skins/android/skin.xml";
	public static var IPHONE_SKIN:String = "skins/iphone/skin.xml";
	
	public static var currentSkin = ANDROID_SKIN;
	
	public function new() {
		super();
		#if iphone
			Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
			addEventListener(Event.ADDED_TO_STAGE, init);
		#end
	}

	public function init(e) {
		#if iphone
			Lib.current.stage.removeEventListener(Event.RESIZE, init);
		#else
			removeEventListener(Event.ADDED_TO_STAGE, init);
		#end
		// TODO: will cause mem leaks, nothing ever gets released/destroyed
		changeSkin(currentSkin);
	}
	
	private function changeSkin(skinPath:String):Void {
		currentSkin = skinPath;
		trace("changing skin: " + skinPath);
		SkinManager.loadSkinXML(skinPath);
		Screen.init();
		
		////////////// TEST STUFF
		
		var controlDemo:ControlDemo = new ControlDemo();
		controlDemo.y = 0;
		controlDemo.width = Screen.component.width;
		controlDemo.height = Screen.component.height;
		Screen.component.addChild(controlDemo);
		
		// TODO: if buttons arent last in the display list and a list is scrolled then events get lost
		/*
		var hbox:HBox = new HBox();
		hbox.x = 3;
		hbox.y = 3;
		hbox.spacing = 3;
		
		var button:Button = new Button();
		button.text = "Windows";
		button.toggle = true;
		button.selected = (currentSkin == WINDOWS_SKIN);
		button.addEventListener(MouseEvent.CLICK, function(e) {
			changeSkin(WINDOWS_SKIN);
		});
		hbox.addChild(button);

		var button:Button = new Button();
		button.text = "Android";
		button.toggle = true;
		button.selected = (currentSkin == ANDROID_SKIN);
		button.addEventListener(MouseEvent.CLICK, function(e) {
			changeSkin(ANDROID_SKIN);
		});
		hbox.addChild(button);

		var button:Button = new Button();
		button.text = "iPhone";
		button.toggle = true;
		button.selected = (currentSkin == IPHONE_SKIN);
		button.addEventListener(MouseEvent.CLICK, function(e) {
			changeSkin(IPHONE_SKIN);
		});
		hbox.addChild(button);
		
		Screen.component.addChild(hbox);
		*/
	}
	
	public static function setSkin(skin:String):Void {
		Main.currentSkin = skin;
		new Main().init(new Event(""));		
	}
	
	static public function main() {
		new Main().init(new Event(""));		
	}
	
}

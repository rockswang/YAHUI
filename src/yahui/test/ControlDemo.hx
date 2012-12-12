package yahui.test;
import nme.events.MouseEvent;
import nme.Lib;
import yahui.containers.Container;
import yahui.containers.HBox;
import yahui.containers.ListView;
import yahui.containers.ScrollView;
import yahui.containers.TabView;
import yahui.containers.VBox;
import yahui.controls.Button;
import yahui.controls.Image;
import yahui.controls.Label;
import yahui.controls.TabBar;
import yahui.controls.TextInput;
import yahui.controls.VScroll;
import yahui.core.Component;
import yahui.skins.SkinManager;

class ControlDemo extends Component {
	private var tabView:TabView;
	
	public function new() {
		super();
		
		tabView = new TabView();
	}
	
	public override function createChildren():Void {
		addChild(tabView);
		
		tabView.addPage("Basic", createPage_BASIC(), "icons.files.gif");
		tabView.addPage("List", createPage_LIST(), "icons.files.text");
		tabView.addPage("Scrolls", createPage_SCROLLS(), "icons.files.blank");
		for (n in 0...20) {
			tabView.addPage("Tab " + n, createPage("page " + n), "icons.files.blank");
		}
	}
	
	private function createPage(name:String):Container {
		var c:Container = new Container();
		var label:Label = new Label();
		label.text = name;
		c.addChild(label);
		return c;
	}
	
	public override function resize():Void {
		tabView.width = width;
		tabView.height = height;
	}

	private function createPage_LIST():Container {
		var c:Container = new HBox();
		c.spacing = 5;
		
		var scrollView:ListView = new ListView();
		scrollView.x = 0;
		scrollView.width = width - (SkinManager.skin.getSkinPropInt("tabview.padding.left", 0) + SkinManager.skin.getSkinPropInt("tabview.padding.right", 0));
		scrollView.height = height - SkinManager.skin.getSkinPropInt("tabbar.size.height", 0) - (SkinManager.skin.getSkinPropInt("tabview.padding.top", 0) + SkinManager.skin.getSkinPropInt("tabview.padding.bottom", 0) + SkinManager.skin.getSkinPropInt("button.size.height", 0) + 6);
		for (n in 0...20) {
			scrollView.addBasicItem("List item " + n, "icons.user");
			/*
			var button:Button = new Button();
			button.text = "Button " + n;
			scrollView.addChild(button);
			button.addEventListener(MouseEvent.CLICK, function(e) {
				trace("CLICK in button " + n);
			});
			*/
		}
		c.addChild(scrollView);
		
		return c;
	}
	
	private function createPage_SCROLLS():Container {
		var c:Container = new HBox();
		c.spacing = 5;
		
		var vscroll:VScroll = new VScroll();
		c.addChild(vscroll);

		var vscroll:VScroll = new VScroll();
		vscroll.value = 25;
		vscroll.width = 13;
		vscroll.pageSize = 50;
		c.addChild(vscroll);

		var vscroll:VScroll = new VScroll();
		vscroll.value = 66;
		vscroll.width = 50;
		c.addChild(vscroll);
		
		var scrollView:ScrollView = new ScrollView();
		scrollView.x = 500;
		scrollView.width = 150;
		scrollView.height = height - SkinManager.skin.getSkinPropInt("tabbar.size.height", 0) - (SkinManager.skin.getSkinPropInt("tabview.padding.top", 0) + SkinManager.skin.getSkinPropInt("tabview.padding.bottom", 0) + SkinManager.skin.getSkinPropInt("button.size.height", 0) + 6);
		for (n in 0...20) {
			var button:Button = new Button();
			button.text = "Button " + n;
			scrollView.addChild(button);
		}
		c.addChild(scrollView);
		
		return c;
	}
	
	
	private function createPage_BASIC():Container {
		var c:Container = new VBox();
		c.spacing = 5;
		
		{
			var hbox:HBox = new HBox();
			hbox.spacing = 5;
			
			var button:Button = new Button();
			button.text = "Exit";
			button.addEventListener(MouseEvent.CLICK, function (e) {
				Lib.exit();
			});
			hbox.addChild(button);

			var button:Button = new Button();
			button.text = "Icon";
			button.iconId = "icons.home";
			hbox.addChild(button);
			
			hbox.height = button.height;
			
			c.addChild(hbox);
		}
		
		{
			var textInput:TextInput = new TextInput();
			c.addChild(textInput);
		}
		
		{
			var hbox:HBox = new HBox();
			hbox.spacing = 5;
			
			var button:Button = new Button();
			button.text = "Toggle";
			button.toggle = true;
			hbox.addChild(button);

			var button:Button = new Button();
			button.text = "Toggle";
			button.toggle = true;
			button.iconId = "icons.search";
			hbox.addChild(button);
			
			hbox.height = button.height;
			
			c.addChild(hbox);
		}
		
		{
			var hbox:HBox = new HBox();
			hbox.spacing = 5;
			
			var button:Button = new Button();
			button.text = "";
			button.iconId = "icons.favs";
			hbox.addChild(button);

			var button:Button = new Button();
			button.text = "";
			button.iconId = "icons.favs";
			button.toggle = true;
			button.selected = true;
			button.width = button.height;
			hbox.addChild(button);
			
			hbox.height = button.height;
			
			c.addChild(hbox);
		}

		{
			var hbox:HBox = new HBox();
			hbox.spacing = 5;
			
			var button:Button = new Button();
			button.text = "Button";
			button.width = button.height = 64;
			hbox.addChild(button);

			var button:Button = new Button();
			button.text = "Icon";
			button.iconId = "icons.home";
			button.iconSize = 32;
			button.iconPosition = "top";
			button.width = button.height = 64;
			hbox.addChild(button);
			
			var button:Button = new Button();
			button.text = "Toggle";
			button.toggle = true;
			button.width = button.height = 64;
			hbox.addChild(button);

			hbox.height = button.height;
			
			c.addChild(hbox);
		}
		
		{
			var hbox:HBox = new HBox();
			hbox.spacing = 5;
			
			var button:Button = new Button();
			button.text = "Toggle";
			button.toggle = true;
			button.iconId = "icons.search";
			button.iconSize = 32;
			button.iconPosition = "top";
			button.width = button.height = 64;
			hbox.addChild(button);

			var button:Button = new Button();
			//button.text = " ";
			button.toggle = true;
			button.selected = true;
			button.iconId = "icons.favs";
			button.iconSize = 32;
			button.iconPosition = "top";
			button.width = button.height = 64;
			hbox.addChild(button);
	
			hbox.height = button.height;
			
			c.addChild(hbox);
		}

		{
			var hbox:HBox = new HBox();
			hbox.spacing = 5;
			
			var image:Image = new Image();
			image.width = image.height = 100;
			image.bitmapAssetPath = "img/slinky_small.jpg";
			hbox.addChild(image);

			hbox.height = image.height;
			
			c.addChild(hbox);
		}
		
		return c;
	}
}
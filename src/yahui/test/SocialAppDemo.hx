package yahui.test;
import yahui.containers.Container;
import yahui.containers.HBox;
import yahui.containers.ListView;
import yahui.containers.ScrollView;
import yahui.containers.TabView;
import yahui.containers.VBox;
import yahui.controls.Button;
import yahui.controls.CheckBox;
import yahui.controls.Image;
import yahui.controls.Label;
import yahui.controls.TextInput;
import yahui.core.Component;
import yahui.skins.SkinManager;

class SocialAppDemo extends Component {
	private var tabView:TabView;
	
	// contacts page controls
	private var contactsList:ListView;
	private var contactsSearchInput:TextInput;
	
	public function new() {
		super();
		
		tabView = new TabView();
	}
	
	public override function createChildren():Void {
		addChild(tabView);
		
		tabView.addPage("Home", createPageHome(), "icons.home");
		tabView.addPage("Chat", createPageChat(), "icons.folders.open");
		tabView.addPage("Contacts", createPageContacts(), "icons.user");
		tabView.addPage("Settings", createPageSettings(), "icons.settings");
	}
	
	public override function resize():Void {
		tabView.width = width;
		tabView.height = height;
	}
	
	private function createPageHome():Container {
		var c:Container = new ScrollView();
		c.showBackgroundSkin = false;
		c.spacing = 5;
		c.width = width - (SkinManager.skin.getSkinPropInt("tabview.padding.left", 0) + SkinManager.skin.getSkinPropInt("tabview.padding.right", 0));
		
		c.addChild(createBubble("4 contact requests"));
		
		var label:Label = new Label();
		label.text = "12 new items";
		c.addChild(label);

		c.addChild(createBubble("Ian Harrigan updated his status:", "Hmmm, why no scrollbar???", "icons.user"));
		c.addChild(createBubble("Kurt Jamal updated his status:", "Just got back from doing something!", "icons.user"));
		c.addChild(createBubble("Noemi Crowden updated her status:", "I Also just got back from doing something!", "icons.user"));
		c.addChild(createBubble("Ian Harrigan added a new photo:", "Little slinky!", "icons.user", "img/slinky_small.jpg"));
		c.addChild(createBubble("Neil Lawhon updated his status:", "Just decided to write something", "icons.user"));
		c.addChild(createBubble("Lonnie Brekke updated her status:", "Some other post", "icons.user"));
		c.addChild(createBubble("Clinton Venturi updated his status:", "Yet another post", "icons.user"));
		c.addChild(createBubble("Neil Lawhon updated his status:", "More information!", "icons.user"));
		c.addChild(createBubble("Neil Lawhon updated his status:", "More information!", "icons.user"));
		c.addChild(createBubble("Neil Lawhon updated his status:", "More information!", "icons.user"));
		c.addChild(createBubble("Neil Lawhon updated his status:", "More information!", "icons.user"));
		c.addChild(createBubble("Neil Lawhon updated his status:", "More information!", "icons.user"));
		
		return c;
	}
	
	private function createBubble(titleString:String, text:String = null, iconId:String = null, imagePath:String = null):Component {
		var bubble:Container = new Container();
		var cy:Float = 0;
		var xpos:Float = 4;
		
		if (iconId != null) {
			var icon:Image = new Image();
			icon.iconId = iconId;
			icon.x = xpos;
			icon.y = 4;
			bubble.addChild(icon);
			xpos += icon.iconSize;
		}
		
		//bubble.backgroundCol = 0xFF0000;
		bubble.backgroundSkinId = "container.background";
		bubble.width = width - (SkinManager.skin.getSkinPropInt("tabview.padding.left", 0) + SkinManager.skin.getSkinPropInt("tabview.padding.right", 0)) - 8;
		
		var title:Label = new Label();
		title.text = titleString;
		title.y = 4;
		title.x = xpos;
		cy = 14;
		bubble.addChild(title);
		
		if (text != null) {
			var textLabel:Label = new Label();
			textLabel.text = text;
			textLabel.y = cy + 6;
			textLabel.x = xpos;
			cy += 14;
			bubble.addChild(textLabel);
		}
		
		if (imagePath != null) {
			var image:Image = new Image();
			image.width = 165;
			image.height = 124;
			image.x = 4;
			image.y = cy + 10;
			image.bitmapAssetPath = imagePath;
			bubble.addChild(image);
			cy += image.height;
		}

		bubble.height = cy + 14;
		
		return bubble;
	}

	private function createPageChat():Container {
		var c:Container = new VBox();
		c.spacing = 5;
		
		var searchHBox:HBox = new HBox();
		searchHBox.spacing = 5;
		contactsSearchInput = new TextInput();
		contactsSearchInput.text = "Say something";
		searchHBox.addChild(contactsSearchInput);
		var contactsSearchButton:Button = new Button();
		contactsSearchButton.text = "Send";
		searchHBox.addChild(contactsSearchButton);
		searchHBox.height = Math.max(contactsSearchInput.height, contactsSearchButton.height);
		contactsSearchInput.width = width - (SkinManager.skin.getSkinPropInt("tabview.padding.left", 0) + SkinManager.skin.getSkinPropInt("tabview.padding.right", 0) + contactsSearchButton.width + searchHBox.spacing) - 4;
		
		var chatContent:ScrollView = new ScrollView();
		chatContent.x = 0;
		chatContent.width = width - (SkinManager.skin.getSkinPropInt("tabview.padding.left", 0) + SkinManager.skin.getSkinPropInt("tabview.padding.right", 0));
		chatContent.height = height - SkinManager.skin.getSkinPropInt("tabbar.size.height", 0) - (SkinManager.skin.getSkinPropInt("tabview.padding.top", 0) + SkinManager.skin.getSkinPropInt("tabview.padding.bottom", 0) + (c.spacing * 5)) - 25;
		chatContent.addChild(createBubble("Neil Lawhon says:", "Hello!", "icons.user"));
		chatContent.addChild(createBubble("Ian Harrigan says:", "Hello to you too!", "icons.user"));
		chatContent.addChild(createBubble("Neil Lawhon says:", "Some more chat text", "icons.user"));
		chatContent.addChild(createBubble("Neil Lawhon says:", "Yet more chat text", "icons.user"));
		chatContent.addChild(createBubble("Neil Lawhon says:", "And even more chat text", "icons.user"));
		chatContent.addChild(createBubble("Ian Harrigan says:", "That was some chat text!", "icons.user"));
		chatContent.addChild(createBubble("Neil Lawhon says:", "I know! ;)", "icons.user"));
		chatContent.addChild(createBubble("Ian Harrigan says:", "I wonder if this list will scroll correctly", "icons.user"));
		chatContent.addChild(createBubble("Neil Lawhon says:", "I hope so", "icons.user"));
		chatContent.addChild(createBubble("Ian Harrigan says:", "Me too!", "icons.user"));
		
		c.addChild(chatContent);
		c.addChild(searchHBox);
		
		return c;
	}
	
	private function createPageContacts():Container {
		var c:Container = new VBox();
		c.spacing = 5;
		
		var searchHBox:HBox = new HBox();
		searchHBox.spacing = 5;
		contactsSearchInput = new TextInput();
		contactsSearchInput.text = "Bob";
		searchHBox.addChild(contactsSearchInput);
		var contactsSearchButton:Button = new Button();
		contactsSearchButton.text = "Filter";
		searchHBox.addChild(contactsSearchButton);
		searchHBox.height = Math.max(contactsSearchInput.height, contactsSearchButton.height);
		contactsSearchInput.width = width - (SkinManager.skin.getSkinPropInt("tabview.padding.left", 0) + SkinManager.skin.getSkinPropInt("tabview.padding.right", 0) + contactsSearchButton.width + searchHBox.spacing) - 4;
		c.addChild(searchHBox);
		
		contactsList = new ListView();
		contactsList.x = 0;
		contactsList.width = width - (SkinManager.skin.getSkinPropInt("tabview.padding.left", 0) + SkinManager.skin.getSkinPropInt("tabview.padding.right", 0));
		contactsList.height = height - SkinManager.skin.getSkinPropInt("tabbar.size.height", 0) - (SkinManager.skin.getSkinPropInt("tabview.padding.top", 0) + SkinManager.skin.getSkinPropInt("tabview.padding.bottom", 0) + (c.spacing * 5));
		
		contactsList.addBasicItem("Louisa Iman", "icons.user");
		contactsList.addBasicItem("Alana Aikins", "icons.user");
		contactsList.addBasicItem("Lonnie Massengill", "icons.user");
		contactsList.addBasicItem("Javier Rank", "icons.user");
		contactsList.addBasicItem("Darcy Lanz", "icons.user");
		contactsList.addBasicItem("Tia Luiz", "icons.user");
		contactsList.addBasicItem("Kurt Jamal", "icons.user");
		contactsList.addBasicItem("Katy Doster", "icons.user");
		contactsList.addBasicItem("Allan Sok", "icons.user");
		contactsList.addBasicItem("Rae Platero", "icons.user");
		contactsList.addBasicItem("Gay Hardimon", "icons.user");
		contactsList.addBasicItem("Lonnie Brekke", "icons.user");
		contactsList.addBasicItem("Clayton Fothergill", "icons.user");
		contactsList.addBasicItem("Jessie Jacquemin", "icons.user");
		contactsList.addBasicItem("Lonnie Lakes", "icons.user");
		contactsList.addBasicItem("Clinton Venturi", "icons.user");
		contactsList.addBasicItem("Neil Lawhon", "icons.user");
		contactsList.addBasicItem("Noemi Crowden", "icons.user");
		contactsList.addBasicItem("Pearlie Caulkins", "icons.user");
		contactsList.addBasicItem("Jeanie Condron", "icons.user");
		c.addChild(contactsList);
		
		return c;
	}
	
	private function createPageSettings():Container {
		var c:Container = new VBox();
		c.spacing = 5;
		
		var label:Label = new Label();
		label.text = "Theme (doesnt work):";
		c.addChild(label);
		
		var hbox:HBox = new HBox();
		hbox.spacing = 5;
		
		var button:Button = new Button();
		button.text = "Android";
		hbox.addChild(button);
		var button:Button = new Button();
		button.text = "iPhone";
		hbox.addChild(button);
		var button:Button = new Button();
		button.text = "Windows";
		hbox.addChild(button);
		hbox.height = button.height;
		c.addChild(hbox);
		
		var fakeSetting:CheckBox = new CheckBox();
		fakeSetting.checked = true;
		fakeSetting.text = "Some fake setting";
		c.addChild(fakeSetting);
		
		var fakeSetting:CheckBox = new CheckBox();
		fakeSetting.text = "Another fake setting";
		c.addChild(fakeSetting);
		
		return c;
	}
}
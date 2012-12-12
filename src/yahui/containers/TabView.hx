package yahui.containers;
import nme.events.Event;
import nme.geom.Rectangle;
import yahui.controls.Button;
import yahui.controls.TabBar;
import yahui.skins.SkinManager;

class TabView extends Container {
	
	// tabbar cotnrols
	private var tabs:TabBar;
	
	// tab and page info
	private var pages:Array<Container>;
	private var currentPage:Container;
	
	// tab view page padding
	public var padding:Rectangle;
	
	public function new() {
		super();
		
		pages = new Array<Container>();
		tabs = new TabBar();

		padding = new Rectangle();
		padding.left = SkinManager.skin.getSkinPropInt("tabview.padding.left", 0);
		padding.right = SkinManager.skin.getSkinPropInt("tabview.padding.right", 0);
		padding.top = SkinManager.skin.getSkinPropInt("tabview.padding.top", 0);
		padding.bottom = SkinManager.skin.getSkinPropInt("tabview.padding.bottom", 0);
	}
	
	//************************************************************
	//                  OVERRIDABLES
	//************************************************************
	private override function createChildren():Void {
		tabs.addEventListener(Event.CHANGE, onTabChange);
		
		addChild(tabs);
	}
	
	private override function resize():Void {
		//drawBackground();
		
		tabs.width = width;
		//tabs.height = height;
		
		resizePages();
	}

	//************************************************************
	//                  PAGE OPERATIONS
	//************************************************************
	public function addPage(title:String, page:Container = null, iconId:String = null):Container {
		if (page == null) {
			page = new Container();
		}
		
		var button:Button = tabs.addTab(title, iconId);

		pages.push(page);
		page.visible = button.selected;
		if (button.selected == true) {
			currentPage = page;
		}
		addChild(page);
		
		return page;
	}

	//************************************************************
	//                  EVENT HANDLERS
	//************************************************************
	private function onTabChange(event:Event):Void {
		currentPage.visible = false;
		var page:Container = pages[tabs.selectedIndex];
		page.visible = true;
		currentPage = page;
	}

	//************************************************************
	//                  HELPERS
	//************************************************************
	private function resizePages():Void {
		var page:Container = null;
		for (page in pages) {
			page.x = padding.left;
			page.y = tabs.height + padding.top;
			page.width = width - (padding.left + padding.top);
			page.height = height - (tabs.height + padding.top + padding.bottom);
		}
		
		bringToFront(tabs);
	}
}

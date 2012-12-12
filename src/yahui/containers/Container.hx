package yahui.containers;

import yahui.core.Component;

class Container extends Component {
	
	// getter and setter declarations
	public var spacing(getSpacing, setSpacing):Int;
	public var actualWidth:Float = 0;
	public var actualHeight:Float = 0;
	
	public function new() {
		super();
	}
	
	//************************************************************
	//                  GETTERS AND SETTERS
	//************************************************************
	public function setSpacing(value:Int):Int {
		spacing = value;
		return value;
	}
	
	public function getSpacing():Int {
		return spacing;
	}
}
package hud;

import gameObjects.GlobalGameData;
import com.gEngine.display.Layer;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;

class KeyHud extends Entity {
	static var display:Sprite;
	static var hudLayer:Layer;
	static var picked = false;

	override public function new(layer:Layer) {
		super();
		hudLayer = layer;
		display = new Sprite("key");
		display.scaleX = display.scaleY = 2;
		display.y = 50;
		display.x = 120;
	}

	public static function pickedkey() {
		hudLayer.addChild(display);
	}

	public static function nextLevel() {
		display.removeFromParent();
	}
}

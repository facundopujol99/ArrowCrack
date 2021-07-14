package hud;

import gameObjects.GlobalGameData;
import com.gEngine.display.Layer;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;

class KeyHud extends Entity {
	static var display:Sprite;
	static var displaySword:Sprite;
	static var hudLayer:Layer;
	static var picked = false;

	override public function new(layer:Layer) {
		super();
		hudLayer = layer;
		display = new Sprite("key");
		display.scaleX = display.scaleY = 2;
		display.y = 50;
		display.x = 120;
		displaySword = new Sprite("sword");
		displaySword.scaleX = displaySword.scaleY = 1;
		displaySword.y = 50;
		displaySword.x = 180;
	}

	public static function pickedkey() {
		hudLayer.addChild(display);
	}

	public static function nextLevel() {
		display.removeFromParent();
		displaySword.removeFromParent();
	}

	public static function pickedSword() {
		hudLayer.addChild(displaySword);
	}

	public static function dropSword() {
		displaySword.removeFromParent();
	}
	
}

package gameObjects;

import com.soundLib.SoundManager.SM;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.gEngine.display.Layer;
import com.gEngine.display.Text;
import com.collision.platformer.ICollider;
import com.collision.platformer.CollisionBox;
import com.collision.platformer.CollisionEngine;
import com.framework.utils.Entity;

class Shop extends Entity {
	var collision:CollisionBox;
	var text:Text;
	var layer:Layer;

	override public function new(x:Float, y:Float, w:Float, h:Float, layer:Layer) {
		super();
		collision = new CollisionBox();
		collision.width = w;
		collision.height = h;
		collision.x = x;
		collision.y = y;
		collision.userData = this;

		text = new Text("AMATIC");
		text.x = x;
		text.y = y - 100;
		this.layer = layer;
		layer.addChild(text);
	}

	override function update(dt:Float) {
		super.update(dt);
		if (!CollisionEngine.overlap(GlobalGameData.archer.collision, collision, shopVsArcher)) {
			HideText();
		}
	}

	function shopVsArcher(archerCollider:ICollider, shopCollider:ICollider) {
		text.text = "Key to press and price \n 1 - Speed \n 2 - Fire Rate \n And for 3 \n 3 - Health";
		if (GlobalGameData.coins > 0) {
			if (Input.i.isKeyCodePressed(KeyCode.One)) {
				SM.playFx("coin_drop");
				GlobalGameData.speed += 20;
				GlobalGameData.coins--;
			}
			if (Input.i.isKeyCodePressed(KeyCode.Two)) {
				if (GlobalGameData.coins > 1) {
					SM.playFx("coin_drop");
					GlobalGameData.fireRate -= 6;
					GlobalGameData.coins-= 2;
				}
			}
			if (Input.i.isKeyCodePressed(KeyCode.Three)) {
				if (GlobalGameData.coins > 2) {
					SM.playFx("coin_drop");
					GlobalGameData.totalLife += 1;
					GlobalGameData.currentLife += 1;
					GlobalGameData.coins -= 3;
				}
			}
		} else {
			text.text = " Bring me some Coins!";
		}
	}

	function HideText() {
		text.text = "";
	}
}

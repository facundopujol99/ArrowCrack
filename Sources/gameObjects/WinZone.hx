package gameObjects;

import com.soundLib.SoundManager.SM;
import com.framework.utils.Input;
import kha.input.KeyCode;
import com.collision.platformer.CollisionEngine;
import com.collision.platformer.ICollider;
import com.gEngine.display.Layer;
import com.gEngine.display.Text;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;

class WinZone extends Entity {

    var collision:CollisionBox;
	var text:Text;
    
    override public function new(x:Float, y:Float, w:Float, h:Float, layer : Layer) {
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
		layer.addChild(text);
    }

	override function update(dt:Float) {
		super.update(dt);
		if (!CollisionEngine.overlap(GlobalGameData.archer.collision, collision, shopVsArcher)) {
			HideText();
		}
	}

	function shopVsArcher(archerCollider:ICollider, shopCollider:ICollider) {
		if (GlobalGameData.pickedKey) {
			text.text = "Space to end level";
			if (Input.i.isKeyCodePressed(KeyCode.Space)) {
				SM.playFx("door_open");
				GlobalGameData.level++;
			}
		}else{
            text.text = "Need Key";
        }
	}
	function HideText() {
		text.text = "";
	}

}
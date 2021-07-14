package gameObjects;

import com.gEngine.display.Layer;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;

class Key extends Entity {
	public var display:Sprite;
	public var collision:CollisionBox;

	private var layer:Layer;

	public function new(x:Float, y:Float, layer:Layer) {
		super();
		display = new Sprite("key");
		display.smooth = false;
		display.scaleX = display.scaleY = 1.5;
		this.layer = layer;
		layer.addChild(display);
		collision = new CollisionBox();
		collision.width = display.width();
		collision.height = display.height();
		collision.x = x;
		collision.y = y;

		collision.userData = this;
	}

	override function render() {
		super.render();
		display.x = collision.x;
		display.y = collision.y;
	}

	override function destroy() {
		super.destroy();
		this.collision.removeFromParent();
		this.display.removeFromParent();
	}
}

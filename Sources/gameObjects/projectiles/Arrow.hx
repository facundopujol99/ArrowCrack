package gameObjects.projectiles;

import com.soundLib.SoundManager.SM;
import com.collision.platformer.CollisionGroup;
import com.gEngine.display.Layer;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import kha.math.FastVector2;
import com.framework.utils.Entity;

class Arrow extends Entity {
	var dir:FastVector2;

	public var display:Sprite;
	public var collision:CollisionBox;
	public var SPEED:Float = 600;

	private var lifetime = 120;

	override public function new(x:Float, y:Float, dirX:Float, dirY:Float, collisionGroup:CollisionGroup, layer:Layer) {
		super();
		display = new Sprite("arrow");
		display.smooth = false;

		layer.addChild(display);
		collision = new CollisionBox();
		collision.width = display.width();
		collision.height = display.height();
		display.pivotX = display.width() * 0.5;
		display.pivotY = display.height() * 0.5;
		display.rotation = 1.5 + Math.atan2(dirY, dirX);
		collision.x = x;
		collision.y = y;
		collision.dragX = 0.9;
		collision.dragY = 0.9;
		collision.userData = this;
		collisionGroup.add(collision);

		dir = new FastVector2(dirX, dirY);

		display.scaleX = display.scaleY = 1.2;
	}

	override function update(dt:Float) {
		super.update(dt);
		collision.update(dt);
		if (lifetime <= 0) {
			this.destroy();
		}
		lifetime--;
		var finalVelocity = dir.normalized().mult(SPEED);
		collision.velocityX = finalVelocity.x;
		collision.velocityY = finalVelocity.y;
	}

	override function render() {
		super.render();
		display.x = collision.x;
		display.y = collision.y;
	}

	override function destroy() {
		super.destroy();
		SM.playFx("arrow_impact");
		this.collision.removeFromParent();
		this.display.removeFromParent();
	}
}

package gameObjects.enemies;

import gameObjects.projectiles.Ray;
import com.soundLib.SoundManager.SM;
import kha.math.Random;
import com.collision.platformer.CollisionGroup;
import kha.math.FastVector2;
import com.framework.utils.Input;
import com.gEngine.display.Layer;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;

class Spider extends Entity {
	public var display:Sprite;
	public var collision:CollisionBox;
	public var facingDir:FastVector2;
	public var SPEED:Float = 100;
	public var rayCollisions:CollisionGroup = new CollisionGroup();

	private var shot = 0;
	private var betweenShots = 5;

	private var initialYDir = 0;
	private var initialXDir = 0;

	private var posiblesMovesWith0 = [0, -1, 1];
	private var posiblesMoves = [-1, 1];

	public var following = false;

	private var layer:Layer;

	public function new(x:Float, y:Float, layer:Layer) {
		super();
		display = new Sprite("spider");
		display.scaleX = display.scaleY = 1.5;
		this.layer = layer;
		layer.addChild(display);
		collision = new CollisionBox();
		collision.width = display.width();
		collision.height = display.height();

		display.pivotX = display.width() * 0.5;
		display.pivotY = display.height() * 0.5;
		collision.x = x;
		collision.y = y;
		collision.dragX = 0.5;
		collision.dragY = 0.5;
		collision.userData = this;

		collision.maxVelocityX = 500;
		collision.maxVelocityY = 800;
		var initialXDir = Random.getIn(0, 2);
		initialXDir = posiblesMovesWith0[initialXDir];
		if (initialXDir == 0) {
			initialYDir = Random.getIn(0, 1);
			initialYDir = posiblesMoves[initialYDir];
		}
		facingDir = new FastVector2(initialXDir, initialYDir);
		GlobalGameData.spiderColliders.add(collision);
	}

	override function update(dt:Float) {
		super.update(dt);
		collision.update(dt);
		if (following) {
			var playerX = GlobalGameData.archer.collision.x;
			var playerY = GlobalGameData.archer.collision.y;
			facingDir.x = playerX - collision.x;
			facingDir.y = playerY - collision.y;
			facingDir.setFrom(facingDir.normalized());
			display.rotation = Math.PI * 1.5 + Math.atan2(facingDir.y, facingDir.x);
		}

		if (facingDir.length != 0) {
			var finalVelocity = facingDir.normalized().mult(SPEED);
			collision.velocityX = finalVelocity.x;
			collision.velocityY = finalVelocity.y;
		}
		if (shot >= betweenShots) {
			var ray = new Ray(collision.x, collision.y, facingDir.x, facingDir.y);
			addChild(ray);
			shot = 0;
		}
		shot++;
	}

	override function render() {
		super.render();
		display.timeline.frameRate = (1 / 6);
		var Vx = Math.abs(collision.velocityX);
		var Vy = Math.abs(collision.velocityY);
		if (collision.velocityX == 0 && collision.velocityY == 0) {
			display.timeline.playAnimation("idle");
		} else if (collision.velocityX > 0 && Vx > Vy) {
			display.timeline.playAnimation("walkRight");
		} else if (collision.velocityX < 0 && Vx > Vy) {
			display.timeline.playAnimation("walkLeft");
		} else if (collision.velocityY < 0 && Vx < Vy) {
			display.timeline.playAnimation("walkUp");
		} else if (collision.velocityY > 0 && Vx < Vy) {
			display.timeline.playAnimation("walkDown");
		}

		display.x = collision.x + display.width() * 0.5;
		display.y = collision.y + display.height() * 0.5;
	}

	inline function isShooting():Bool {
		return Input.i.isMouseDown();
	}

	override function destroy() {
		super.destroy();
		this.collision.removeFromParent();
		this.display.removeFromParent();
		this.die();
	}

	public function changeDirection() {
		if (!following) {
			if (facingDir.x > 0) {
				collision.x -= 10;
			}
			if (facingDir.x < 0) {
				collision.x += 10;
			}
			if (facingDir.y > 0) {
				collision.y -= 10;
			}
			if (facingDir.y > 0) {
				collision.y -= 10;
			}
			var xDir = Random.getIn(0, 2);
			xDir = posiblesMovesWith0[xDir];
			var yDir = 0;
			if (xDir == 0) {
				yDir = Random.getIn(0, 1);
				yDir = posiblesMoves[yDir];
			}
			if (facingDir.x == xDir && xDir != 0) {
				xDir = 0;
				yDir = Random.getIn(0, 1);
				yDir = posiblesMoves[yDir];
			}
			if (facingDir.y == yDir && yDir != 0) {
				yDir = 0;
				xDir = Random.getIn(0, 1);
				xDir = posiblesMoves[xDir];
			}
			facingDir = new FastVector2(xDir, yDir);
		}
	}

	public function startFollowing() {
		if (!following) {
			SM.playFx("squeak");
			following = true;
		}
	}
}

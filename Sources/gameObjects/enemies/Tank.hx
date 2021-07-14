package gameObjects.enemies;

import paths.Path;
import paths.PathWalker;
import com.collision.platformer.CollisionGroup;
import kha.math.FastVector2;
import com.gEngine.display.Layer;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;

class Tank extends Entity {
	public var display:Sprite;
	public var collision:CollisionBox;
	public var dir:FastVector2;
	public var SPEED:Float = 20;
	public var arrowCollisions:CollisionGroup = new CollisionGroup();

	private var isCharging:Bool = false;
	private var readyToShoot:Bool = true;
	private var chargeTime = 0;
	private var timeBetweenShots = 120;

	private var pathWalker:PathWalker;

	private var layer:Layer;

	public function new(path:Path, layer:Layer) {
		super();
		display = new Sprite("eightcannon");
		display.scaleX = display.scaleY = 1.5;
		this.layer = layer;
		layer.addChild(display);
		collision = new CollisionBox();
		collision.width = display.width();
		collision.height = display.height();

		display.pivotX = display.width() * 0.5;
		display.pivotY = display.height() * 0.5;
		display.offsetY = -display.height() * 0.5;
		display.offsetX = -display.width() * 0.5;
		
		collision.dragX = 0.5;
		collision.dragY = 0.5;
		collision.bounce = 1;
		collision.userData = this;
		GlobalGameData.tankColliders.add(collision);
		dir = new FastVector2(1, 0);
		pathWalker = new PathWalker(path, path.getLength()*0.01, PlayMode.Loop);
	}

	override function update(dt:Float) {
		super.update(dt);
		pathWalker.update(dt);

		collision.x = pathWalker.x;
		collision.y = pathWalker.y;
		chargeTime++;
		if (chargeTime >= timeBetweenShots) {
			shootBullets();
		}

		dir.x = collision.x - collision.lastX;
		dir.y = collision.y - collision.lastY;
		collision.update(dt);
	}

	override function render() {
		super.render();
		display.timeline.frameRate = (1 / 6);
		if (Math.abs(dir.x) >= Math.abs(dir.y)) {
			if (dir.x > 0) {
				display.timeline.playAnimation("walkX");
			} else {
				display.timeline.playAnimation("walkX");
			}
		} else {
			if (dir.y > 0) {
				display.timeline.playAnimation("walkY");
			} else {
				display.timeline.playAnimation("walkY");
			}
		}

		display.x = collision.x + display.width()*0.5;
		display.y = collision.y + display.height()*0.5;
	}

	override function destroy() {
		super.destroy();
		this.collision.removeFromParent();
		this.display.removeFromParent();
		this.die();
	}

	function shootBullets() {
		var dirBulletX = this.dir.x;
		var dirBulletY = this.dir.y;
		for (i in 1...9) {
			var xr = dirBulletX * Math.cos(45 * i) - dirBulletY * Math.sin(45 * i);
			var yr = dirBulletX * Math.sin(45 * i) + dirBulletY * Math.cos(45 * i);
			shootBullet(new FastVector2(xr, yr));
		}
	}

	function shootBullet(dirBullet:FastVector2) {
		var shot = new TankShot(collision.x + display.width()*0.5, collision.y  + display.height()*0.5, dirBullet.x, dirBullet.y, arrowCollisions, this.layer);
		if(this.parent != null){
			this.parent.addChild(shot);
		}
		chargeTime = 0;
	}

	override function die() {
		super.die();
	}
}

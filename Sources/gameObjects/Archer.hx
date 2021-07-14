package gameObjects;

import com.soundLib.SoundManager.SM;
import com.collision.platformer.CollisionGroup;
import kha.input.KeyCode;
import kha.math.FastVector2;
import com.framework.utils.Input;
import com.gEngine.display.Layer;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;

class Archer extends Entity {
	public var display:Sprite;
	public var collision:CollisionBox;
	public var facingDir:FastVector2;
	public var arrowCollisions:CollisionGroup = new CollisionGroup();

	private var isCharging:Bool = false;
	private var readyToShoot:Bool = true;
	private var chargeTime = 0;

	private var layer:Layer;

	public function new(x:Float, y:Float, layer:Layer) {
		super();
		display = new Sprite("archer");
		display.smooth = false;
		// display.scaleX = display.scaleY = 1.5;
		this.layer = layer;
		layer.addChild(display);
		collision = new CollisionBox();
		collision.width = display.width();
		collision.height = display.height();

		display.offsetY = -display.height() * 0.5;
		display.offsetX = -display.width() * 0.5;
		display.pivotX = display.width() * 0.5;
		display.pivotY = display.height() * 0.5;

		collision.x = x;
		collision.y = y;
		collision.dragX = 0.5;
		collision.dragY = 0.5;
		collision.bounce = 0;

		collision.userData = this;

		collision.maxVelocityX = 500;
		collision.maxVelocityY = 800;
		facingDir = new FastVector2(0, 0);
	}

	override function update(dt:Float) {
		super.update(dt);
		collision.update(dt);
		var mousePosition = GlobalGameData.camera.screenToWorld(Input.i.getMouseX(), Input.i.getMouseY());
		facingDir.x = mousePosition.x - collision.x;
		facingDir.y = mousePosition.y - collision.y;
		facingDir.setFrom(facingDir.normalized());
		display.rotation = Math.PI * 0.5 + Math.atan2(facingDir.y, facingDir.x);

		if (Input.i.isMouseDown()) {
			if (chargeTime <= GlobalGameData.fireRate) {
				chargeTime++;
			} else if (chargeTime >= GlobalGameData.fireRate && readyToShoot) {
				shootArrow();
			}
		}

		var dir:FastVector2 = new FastVector2();
		if (Input.i.isKeyCodeDown(KeyCode.W)) {
			dir.y += -1;
		}
		if (Input.i.isKeyCodeDown(KeyCode.S)) {
			dir.y += 1;
		}
		if (Input.i.isKeyCodeDown(KeyCode.D)) {
			dir.x += 1;
		}
		if (Input.i.isKeyCodeDown(KeyCode.A)) {
			dir.x += -1;
		}
		if (Input.i.isMouseReleased()) {
			chargeTime = 0;
			isCharging = false;
			readyToShoot = true;
		}

		if (dir.length != 0) {
			var finalVelocity = dir.normalized().mult(GlobalGameData.speed);
			collision.velocityX = finalVelocity.x;
			collision.velocityY = finalVelocity.y;
			
		}
	}

	override function render() {
		super.render();
		// var s = Math.abs(collision.velocityX / collision.maxVelocityX);
		// display.timeline.frameRate = (1 / 24) * s + (1 - s) * (1 / 10);
		if (collision.velocityX == 0 || chargeTime == 0) {
			display.timeline.playAnimation("idle");
		}
		if (Input.i.isMouseDown() && chargeTime <= GlobalGameData.fireRate * 0.3 && readyToShoot) {
			display.timeline.playAnimation("charge");
		}
		if (Input.i.isMouseDown() && chargeTime >= GlobalGameData.fireRate * 0.3 && readyToShoot) {
			display.timeline.playAnimation("charged");
		}

		display.x = collision.x + display.width()*0.5;
		display.y = collision.y + display.height()*0.5;
	}

	override function destroy() {
		super.destroy();
		this.collision.removeFromParent();
		this.display.removeFromParent();
	}

	function shootArrow()
	{
		SM.playFx("arrow_release");
		var arrow = new Arrow(collision.x, collision.y, facingDir.x, facingDir.y, arrowCollisions, this.layer);
		addChild(arrow);
		chargeTime = 0;
		readyToShoot = false;
	}
}

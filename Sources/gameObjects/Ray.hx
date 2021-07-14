package gameObjects;
import com.collision.platformer.CollisionBox;
import kha.math.FastVector2;
import com.framework.utils.Entity;

class Ray extends Entity {

    var dir: FastVector2;
	public var collision:CollisionBox;
    public var SPEED:Float = 1000;
    private var lifetime = 30; 

    override public function new(x: Float, y:Float, dirX : Float, dirY : Float) {
        super();
        collision = new CollisionBox();
        collision.width = 80;
        collision.height = 20;
		collision.x=x;
		collision.y=y;
		collision.dragX = 0.9;
		collision.dragY = 0.9;
		collision.userData = this;
        GlobalGameData.rayColliders.add(collision);

        dir = new FastVector2(dirX,dirY);
    }

    override function update(dt:Float) {
        super.update(dt);
        collision.update(dt);
        if(lifetime<=0){
            this.destroy();
        }
        lifetime--;
        var finalVelocity = dir.normalized().mult(SPEED);
		collision.velocityX = finalVelocity.x;
		collision.velocityY = finalVelocity.y;
    }

    override function destroy() {
        super.destroy();
        this.collision.removeFromParent();
        this.die();
    }
}
package gameObjects;

import hud.KeyHud;
import com.collision.platformer.CollisionGroup;
import com.gEngine.display.Camera;

class GlobalGameData {
	static public var archer:Archer;
	static public var key:Key;
	static public var shop:Shop;
	static public var camera:Camera;
	static public var shotsColliders:CollisionGroup = new CollisionGroup();
	static public var tankColliders:CollisionGroup = new CollisionGroup();
	static public var spiderColliders:CollisionGroup = new CollisionGroup();
	static public var rayColliders:CollisionGroup = new CollisionGroup();
	static public var totalLife = 3;
	static public var currentLife:Float = totalLife;
	static public var coins = 0;
	static public var speed:Float = 200;
	static public var fireRate:Float = 90;
	static public var level = 1;

	public static var pickedKey:Bool = false;
	public static var nearShop:Bool = false;

	public static var winZone:WinZone;

	static public function destroy() {
		archer = null;
		pickedKey = false;
	}

	static public function nextLevel() {
		shotsColliders.clear();
		tankColliders.clear();
		spiderColliders.clear();
		rayColliders.clear();
		archer = null;
		winZone = null;
		key = null;
		shop = null;
		camera = null;
		pickedKey = false;
		KeyHud.nextLevel();
	}
}

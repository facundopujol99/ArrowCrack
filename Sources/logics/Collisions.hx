package logics;
import com.soundLib.SoundManager.SM;
import com.gEngine.display.extra.TileMapDisplay;
import com.collision.platformer.Tilemap;
import gameObjects.GlobalGameData;
import com.collision.platformer.CollisionEngine;
import com.collision.platformer.ICollider;
import gameObjects.enemies.Spider;
import gameObjects.Archer;
import gameObjects.TankShot;
import gameObjects.enemies.Tank;
import gameObjects.Ray;
import gameObjects.Arrow;

class Collisions{
    public static var worldMap:Tilemap;
	public static var archerMap:TileMapDisplay;

    public static function setCollisions(aWorldMap : Tilemap, aArcherMap : TileMapDisplay) {
        worldMap = aWorldMap;
	    archerMap = aArcherMap;
    }

    public static function collisions() {
        CollisionEngine.collide(GlobalGameData.archer.collision, worldMap.collision);
		CollisionEngine.overlap(GlobalGameData.archer.arrowCollisions, worldMap.collision, arrowVsWall);
		CollisionEngine.collide(GlobalGameData.spiderColliders, worldMap.collision, spiderVsWall);
		CollisionEngine.overlap(GlobalGameData.shotsColliders, worldMap.collision, shotVsWall);
		CollisionEngine.overlap(GlobalGameData.tankColliders, GlobalGameData.archer.arrowCollisions, tankVsArrow);
		CollisionEngine.overlap(GlobalGameData.shotsColliders, GlobalGameData.archer.collision, shotVsArcher);
		CollisionEngine.overlap(GlobalGameData.tankColliders, GlobalGameData.archer.collision, tankVsArcher);
		CollisionEngine.overlap(GlobalGameData.rayColliders, GlobalGameData.archer.collision, rayVsArcher);
		CollisionEngine.overlap(GlobalGameData.rayColliders, worldMap.collision, rayVsWall);
		CollisionEngine.overlap(GlobalGameData.spiderColliders, GlobalGameData.archer.arrowCollisions, spiderVsArrow);
		CollisionEngine.overlap(GlobalGameData.key.collision, GlobalGameData.archer.collision, keyVsArcher);
    }

    static function arrowVsWall(wallCollider:ICollider, arrowCollider:ICollider) {

		var arrow:Arrow = cast arrowCollider.userData;
		arrow.destroy();
		arrow.die();
	}

	static function spiderVsWall(wallCollider:ICollider, spiderCollider:ICollider) {
		var spiderAux:Spider = cast spiderCollider.userData;
		spiderAux.changeDirection();
	}

	static function shotVsWall(wallCollider:ICollider, shotCollider:ICollider) {
		var shot:TankShot = cast shotCollider.userData;
		shot.destroy();
	}

	static function rayVsWall(wallCollider:ICollider, rayCollider:ICollider) {
		var ray : Ray = cast rayCollider.userData;
		ray.destroy();
	}

	static function tankVsArrow(tankCollider:ICollider, arrowCollider:ICollider) {

		var tank:Tank = cast tankCollider.userData;
		tank.destroy();
		tank.die();
		var arrow:Arrow = cast arrowCollider.userData;
		arrow.destroy();
		arrow.die();
		GlobalGameData.coins++;
	}

	static function spiderVsArrow(spiderCollider:ICollider, arrowCollider:ICollider) {
		
		var spiderOne:Spider = cast spiderCollider.userData;
		spiderOne.destroy();
		spiderOne.die();
		var arrow:Arrow = cast arrowCollider.userData;
		arrow.destroy();
		arrow.die();
		GlobalGameData.coins++;
	}

	static function tankVsArcher(tankCollider:ICollider, archerCollider:ICollider) {
		SM.playFx("human_hit");
		var archer:Archer = cast archerCollider.userData;
		if(GlobalGameData.currentLife>0){
			GlobalGameData.currentLife-=0.5;
		}
	}

	static function shotVsArcher(shotCollider:ICollider, archerCollider:ICollider) {
		SM.playFx("human_hit");
		var archer:Archer = cast archerCollider.userData;
		var shot:TankShot = cast shotCollider.userData;
		shot.destroy();
		shot.die();
		if(GlobalGameData.currentLife>0){
			GlobalGameData.currentLife-=0.5;
		}
	}

	static function rayVsArcher(rayCollider:ICollider, archerCollider:ICollider) {
		var archer:Archer = cast archerCollider.userData;
		var ray : Ray = cast rayCollider.userData;
		var spider : Spider = cast ray.parent;
		spider.startFollowing();
		ray.destroy();
		ray.die();
	}

	static function keyVsArcher(keyCollider:ICollider, archerCollider:ICollider) {
		GlobalGameData.pickedKey = true;
		GlobalGameData.key.destroy();
		GlobalGameData.key.die();
	}
}
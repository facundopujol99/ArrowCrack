package states;

import com.soundLib.SoundManager.SM;
import com.loading.basicResources.SoundLoader;
import com.gEngine.display.StaticLayer;
import com.gEngine.display.Sprite;
import logics.Collisions;
import gameObjects.enemies.Tank;
import format.tmx.Data.TmxTileLayer;
import gameObjects.Archer;
import gameObjects.WinZone;
import gameObjects.Shop;
import hud.KeyHud;
import gameObjects.Key;
import hud.Coin;
import com.loading.basicResources.FontLoader;
import hud.Life;
import com.loading.basicResources.ImageLoader;
import paths.Linear;
import paths.Complex;
import paths.Path;
import kha.math.FastVector2;
import gameObjects.GlobalGameData;
import gameObjects.enemies.Spider;
import com.gEngine.display.extra.TileMapDisplay;
import format.tmx.Data.TmxObject;
import com.loading.basicResources.TilesheetLoader;
import com.loading.basicResources.SpriteSheetLoader;
import com.gEngine.display.Layer;
import com.loading.basicResources.DataLoader;
import com.collision.platformer.Tilemap;
import com.loading.basicResources.JoinAtlas;
import com.loading.Resources;
import com.framework.utils.State;

class GameState extends State {
	var simulationLayer:Layer;
	var overLayer:StaticLayer;
	var worldMap:Tilemap;
	var archerMap:TileMapDisplay;
	var levelArray = ["level1_tmx","level2_tmx","level3_tmx"];
	var currentLevel = GlobalGameData.level;
	public static var startingX : Float = 0;
	public static var startingY : Float = 0;

	override function load(resources:Resources) {
		super.load(resources);

		resources.add(new DataLoader("level1_tmx"));
		resources.add(new DataLoader("level2_tmx"));
		resources.add(new DataLoader("level3_tmx"));
		resources.add(new SoundLoader("dungeon_amb", false));
		resources.add(new SoundLoader("arrow_impact"));
		resources.add(new SoundLoader("male_groan"));
		resources.add(new SoundLoader("human_hit"));
		resources.add(new SoundLoader("arrow_release"));
		resources.add(new SoundLoader("coin_drop"));
		resources.add(new SoundLoader("squeak"));
		resources.add(new SoundLoader("key_pick_up"));
		resources.add(new SoundLoader("door_open"));
		var atlas = new JoinAtlas(2048, 2048);
		atlas.add(new FontLoader("SEASRN",48));
		atlas.add(new FontLoader("AMATIC",25));
		atlas.add(new TilesheetLoader("tiles", 16, 16, 0));
		atlas.add(new SpriteSheetLoader("archer", 32, 32, 0, [
			new Sequence("idle", [0]),
			new Sequence("charge", [1, 2, 3]),
			new Sequence("charged", [3]),
		]));
		atlas.add(new SpriteSheetLoader("spider", 32, 32, 0, [
			new Sequence("idle", [0]),
			new Sequence("walkUp", [4, 4]),
			new Sequence("walkDown", [2, 3]),
			new Sequence("walkRight", [6, 7]),
			new Sequence("walkLeft", [8, 9]),
		]));
		atlas.add(new SpriteSheetLoader("eightcannon", 32, 32, 0, [
			new Sequence("idle", [0]),
			new Sequence("walkY", [0, 1]),
			new Sequence("walkX", [2, 3])
		]));
		atlas.add(new SpriteSheetLoader("arrow", 32, 32, 0, [new Sequence("idle", [0])]));
		atlas.add(new SpriteSheetLoader("tankshot", 7, 16, 0, [new Sequence("idle", [0])]));
		atlas.add(new ImageLoader("fullheart"));
		atlas.add(new ImageLoader("halfheart"));
		atlas.add(new ImageLoader("emptyheart"));
		atlas.add(new ImageLoader("coin"));
		atlas.add(new ImageLoader("key"));
		resources.add(atlas);
	}

	override function init() {
		super.init();
		stageColor(0.5, 0.5, 0.5);
		simulationLayer = new Layer();
		stage.addChild(simulationLayer);
		
		worldMap = new Tilemap(levelArray[GlobalGameData.level - 1]);
		worldMap.init(parseTileLayers, parseMapObjects);
		stage.defaultCamera().scale = 1.5;
		stage.defaultCamera()
			.limits(-stage.defaultCamera().width * 0.5,
				-stage.defaultCamera().height * 0.5, worldMap.widthIntTiles * 16
				+ stage.defaultCamera().width,
				worldMap.heightInTiles * 16
				+ stage.defaultCamera().height);
		GlobalGameData.camera = stage.defaultCamera();
		overLayer = new StaticLayer();
		var coin = new Coin(overLayer);
		addChild(coin);
		var keyHud = new KeyHud(overLayer);
		addChild(keyHud);
		var life = new Life(overLayer);
		addChild(life);
		stage.addChild(overLayer);
		Collisions.setCollisions(worldMap,archerMap);
		SM.playMusic("dungeon_amb");
	}

	override function update(dt:Float) {
		super.update(dt);
		stage.defaultCamera().setTarget(GlobalGameData.archer.collision.x, GlobalGameData.archer.collision.y);


		Collisions.collisions();

		if(currentLevel != GlobalGameData.level){
			GlobalGameData.nextLevel();
			changeState(new GameState());
		}
	}

	function parseMapObjects(layerTilemap:Tilemap, object:TmxObject) {
		if (compareName(object, "playerPosition")) {
			if (GlobalGameData.archer == null) {
				startingX = object.x;
				startingY = object.y;
				var archer = new Archer(object.x, object.y, simulationLayer);
				GlobalGameData.archer = archer;
				addChild(archer);
			}
		}
		if (compareName(object, "keyPosition")) {
			if (GlobalGameData.key == null) {
				GlobalGameData.key = new Key(object.x, object.y, simulationLayer);
				addChild(GlobalGameData.key);
			}
		}
		if (compareName(object, "spiderPosition")) {
				var spider = new Spider(object.x, object.y, simulationLayer);
				addChild(spider);
		}
		if (compareType(object, "path")) {
			var properties = object.properties;
			var points:Array<FastVector2> = cast object.objectType.getParameters()[0];

			var levelPathPoints:Array<Path> = new Array();
			for (point in points) {
				point.x += object.x;
				point.y += object.y;
			}
			for (i in 0...(points.length - 1)) {
				levelPathPoints.push(new Linear(points[i], points[i + 1]));
			}

			var path = new Complex(levelPathPoints);
			var tank = new Tank(path, simulationLayer);
			addChild(tank);
		}
		if(compareName(object,"shop")){
			if(GlobalGameData.shop==null){
				GlobalGameData.shop = new Shop(object.x, object.y,object.width,object.height,simulationLayer);
				addChild(GlobalGameData.shop);
			}
		}
		if(compareName(object,"winZone")){
			if(GlobalGameData.winZone==null){
				GlobalGameData.winZone = new WinZone(object.x, object.y,object.width,object.height,simulationLayer);
				addChild(GlobalGameData.winZone);
			}
		}
	}

	inline function compareName(object:TmxObject, name:String) {
		return object.name.toLowerCase() == name.toLowerCase();
	}

	inline function compareType(object:TmxObject, type:String) {
		return object.type.toLowerCase() == type.toLowerCase();
	}

	function parseTileLayers(layerTilemap:Tilemap, tileLayer:TmxTileLayer) {
		if (!tileLayer.properties.exists("noCollision")) {
			layerTilemap.createCollisions(tileLayer);
		}
		simulationLayer.addChild(layerTilemap.createDisplay(tileLayer, new Sprite("tiles")));
		archerMap = layerTilemap.createDisplay((tileLayer), new Sprite("tiles"));
		simulationLayer.addChild(archerMap);
	}

	public static function ArcherDeath() {
		GlobalGameData.currentLife = GlobalGameData.totalLife;
		GlobalGameData.coins = 0;
		GlobalGameData.archer.collision.x = startingX;
		GlobalGameData.archer.collision.y = startingY;
	}
}

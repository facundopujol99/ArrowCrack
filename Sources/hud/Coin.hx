package hud;

import com.gEngine.display.Text;
import gameObjects.GlobalGameData;
import com.gEngine.display.Layer;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;

class Coin extends Entity {

    var display : Sprite;
    var coins = GlobalGameData.coins;
    var coinsText: Text;
    var hudLayer : Layer;

    override public function new(layer : Layer) {
        super();
        hudLayer = layer;
        var coinSprite = new Sprite("coin");
        coinSprite.scaleX = coinSprite.scaleY = 2;
        coinSprite.y = 50;
        coinSprite.x = 5;
        coinsText = new Text("SEASRN");
        coinsText.y = 42;
        coinsText.x = 50;
        hudLayer.addChild(coinSprite);
        hudLayer.addChild(coinsText);
        RenderCoins();
    }

    override function update(dt:Float) {
        if(coins != GlobalGameData.coins){
            coins = GlobalGameData.coins;
            RenderCoins();
        }
    }

    function RenderCoins(){
        coinsText.text = coins + "";
    }
}
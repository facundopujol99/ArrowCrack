package hud;

import gameObjects.GlobalGameData;
import com.gEngine.display.Layer;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;

class Life extends Entity {

    public var displays = [];
    var totalLife = GlobalGameData.totalLife;
    var currentLife = GlobalGameData.currentLife;
    var hudLayer : Layer;

    override public function new(layer : Layer) {
        super();
        hudLayer = layer;
        AddHearts();
    }

    override function update(dt:Float) {
        if(totalLife != GlobalGameData.totalLife || currentLife != GlobalGameData.currentLife){
            totalLife = GlobalGameData.totalLife;
            currentLife = GlobalGameData.currentLife;
            AddHearts();
        }
    }
    
	function AddHearts() {
        for (h in displays){
            hudLayer.remove(h);
            displays.remove(h);
        }
        var x = 500;
        var y = 50;
        var cl = Math.floor(currentLife);
        var hasHalf = currentLife % 1 == 0.5;
        for(i in 0...cl){
            var fh = new Sprite('fullheart');
            fh.scaleX = fh.scaleY = 2;
            fh.x = x - 25*i;
            fh.y = y;
            displays.push(fh);
            hudLayer.addChild(fh);
        }
        if(hasHalf){
            var hh = new Sprite('halfheart');
            hh.scaleX = hh.scaleY = 2;
            hh.x = x - 25*(cl);
            hh.y = y;
            displays.push(hh);
            hudLayer.addChild(hh);
        }
        var emptyLife = Math.floor(totalLife-currentLife);
        for(j in 0...emptyLife){
            var eh = new Sprite('emptyheart');
            eh.scaleX = eh.scaleY = 2;
            eh.x = x - 25*(j+cl+1);
            eh.y = y;
            displays.push(eh);
            hudLayer.addChild(eh);
        }
    }
}
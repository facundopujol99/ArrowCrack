package paths;
import kha.math.FastVector2;

class Bezier implements Path {
    
    var start:FastVector2;
    var C1:FastVector2;
    var C2:FastVector2;
    var end:FastVector2;

    var temp=new FastVector2();

    public function new(start:FastVector2,C1:FastVector2,C2:FastVector2,end:FastVector2) {
        this.start=start;
        this.C1=C1;
        this.C2=C2;
        this.end=end;
    }


	public function getPos(s:Float):FastVector2 {
		var T1 = new FastVector2(LERP(start.x,C1.x,s),LERP(start.y,C1.y,s));
        var T2 = new FastVector2(LERP(C1.x,C2.x,s),LERP(C1.y,C2.y,s));
        var T3 = new FastVector2(LERP(C2.x,end.x,s),LERP(C2.y,end.y,s));

        var T4 = new FastVector2(LERP(T1.x,T2.x,s),LERP(T1.y,T2.y,s));
        var T5 = new FastVector2(LERP(T2.x,T3.x,s),LERP(T2.y,T3.y,s));

        var T6 = new FastVector2(LERP(T4.x,T5.x,s),LERP(T4.y,T5.y,s));

        temp.setFrom(T6);
        return temp;
	}

	public function getLength():Float {
		return (C1.sub(start).length+C2.sub(C1).length+end.sub(C2).length+end.sub(start).length)*0.5;
	}

    private inline function LERP(start:Float,end:Float,s:Float):Float{
        return start + (end-start) * s;
    }
}
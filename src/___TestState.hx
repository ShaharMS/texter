package;
import texter.flixel.FlxInputTextRTL;
import flixel.FlxState;
class ___TestState extends FlxState {

    override function create() {
        super.create();
        var t = new FlxInputTextRTL(0, 10, 600, "", 40);
        t.font = "assets/V.ttf";
        add(t);
    }
}
package;
import texter.flixel.FlxInputTextRTL;
import texter.general.Char;
import texter.flixel.FlxTextButton;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;
class ___TestState extends FlxState {
	var t:FlxInputTextRTL;
    override function create() {
        super.create();
        t = new FlxInputTextRTL(10, 10, 600, "", 30);
        t.font = "assets/V.ttf";
        add(t);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }
}
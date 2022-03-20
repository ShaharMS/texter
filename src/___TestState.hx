package;
import texter.flixel.FlxTextButton;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;
class ___TestState extends FlxState {
	var t:FlxTextButton;
    override function create() {
        super.create();
        t = new FlxTextButton(0, 10, 40, "", 8, () -> trace("clicked!"), () -> trace("enter!") );
        t.label.font = "assets/V.ttf";
        add(t);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }
}
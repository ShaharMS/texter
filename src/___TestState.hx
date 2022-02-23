package;
import texter.flixel.FlxTextButton;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import texter.flixel.FlxInputTextRTL;
import flixel.FlxState;
class ___TestState extends FlxState {

    override function create() {
        super.create();
        var t = new FlxTextButton(0, 10, 600, "", 40, () -> trace("clicked!"), () -> trace("enter!") );
        t.label.font = "assets/V.ttf";
        add(t);
    }
}
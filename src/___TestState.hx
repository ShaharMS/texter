package;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import texter.flixel.FlxInputTextRTL;
import flixel.FlxState;

class ___TestState extends FlxState {
    
    public override function create() {
        super.create();
        add(new FlxSprite().makeGraphic(800, 800, FlxColor.BLUE));
        add(new FlxInputTextRTL(0,300, 700, "", 30));
    }
}
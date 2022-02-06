package;

import texter.flixel.FlxInputTextRTL;
import flixel.FlxState;

class ___TestState extends FlxState {
    
    public override function create() {
        super.create();
        add(new FlxInputTextRTL(0,0, 700, "", 30));
    }
}
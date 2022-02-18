package;

import flixel.util.FlxTimer;
import openfl.Lib;
import flixel.text.FlxText;
import flixel.FlxG;
import openfl.text.TextField;
import haxe.Timer;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import texter.flixel.FlxInputTextRTL;
import flixel.FlxState;
using texter.flixel._internal.WordWrapper;
import texter.flixel._internal.FlxInputText;

class ___TestState extends FlxState {
    var t:FlxInputTextRTL;
    public override function create() {
        super.create();
		add(new FlxSprite().makeGraphic(1000, 1000, 0x0000FFFF));
        t = new FlxInputTextRTL(0, 100, 800, "", 50);
        t.font = "assets/VarelaRound-Regular.ttf";
        add(t);
		new FlxTimer().start(1, (ti) -> trace(WordWrapper.wrapVisual(t, true)), 0);

    }

    public override function update(elapsed:Float) {
        super.update(elapsed);
    }

    
    
}
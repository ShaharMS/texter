package;

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

    public override function create() {
        super.create();
		add(new FlxSprite().makeGraphic(1000, 1000, 0x0000FFFF));
        add(new FlxInputTextRTL(0, 100, 800, "", 50));
    }

    public override function update(elapsed:Float) {
        super.update(elapsed);
    }

    
    
}
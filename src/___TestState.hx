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
        t = new FlxInputTextRTL(0,0, 800, "text", 50);
        t.font = "assets/VarelaRound-Regular.ttf";
		t.color = 0x000000FF;
        t.backgroundColor = 0xFFFFFFFF;
        add(t);
    }

    public override function update(elapsed:Float) {
        super.update(elapsed);
    }

    
    
}
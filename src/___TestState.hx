package;

import openfl.Lib;
import flixel.text.FlxText;
import flixel.FlxG;
import openfl.text.TextField;
import js.Browser;
import haxe.Timer;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import texter.flixel.FlxInputTextRTL;
import flixel.FlxState;
using texter.flixel._internal.WordWrapper;
import texter.flixel._internal.FlxInputText;

class ___TestState extends FlxState {
    
	var s:FlxText;
    public override function create() {
        super.create();
		
        add(new FlxSprite().makeGraphic(800, 800, FlxColor.BLUE));
		s = new FlxText(0, 300, 400, "",20);
        s.color = FlxColor.BLACK;
        s.wordWrap = true;
        add(s);

        Browser.document.onkeypress = (text) -> {
            s.text += text;
            trace(text);
        };
    }

    public override function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.keys.justPressed.ENTER) s.text += "\n";
    }
}
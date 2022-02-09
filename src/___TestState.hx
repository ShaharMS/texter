package;

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
    
	var s:FlxInputText;
    public override function create() {
        super.create();
		
        add(new FlxSprite().makeGraphic(800, 800, FlxColor.BLUE));
		s = new FlxInputText(0, 300, 300, "", 30);
        s.wordWrap = true;
        add(s);
    }

    public override function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.keys.justPressed.ENTER) Browser.alert(WordWrapper.wrapVisual(s));
    }
}
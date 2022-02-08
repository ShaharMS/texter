package;

import openfl.text.TextField;
import js.Browser;
import haxe.Timer;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import texter.flixel.FlxInputTextRTL;
import flixel.FlxState;
using texter.flixel._internal.WordWrapper;


class ___TestState extends FlxState {
    
    public override function create() {
        super.create();
		var s = new FlxInputTextRTL(0, 300, 700, "", 30);
        add(new FlxSprite().makeGraphic(800, 800, FlxColor.BLUE));
        add(s);
       
		new Timer(2000).run = () ->
		{
			WordWrapper.wrapVisual(s);
		};
    }
}
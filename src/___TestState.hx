package;

import openfl.text.TextFormat;
import openfl.text.TextField;
import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;
import openfl.events.KeyboardEvent;
import texter.flixel.FlxInputTextRTL;
import texter.flixel._internal.FlxInputText;
import texter.general.Char;
import texter.general.markdown.Markdown;
import texter.general.markdown.MarkdownEffect;

class ___TestState extends FlxState
{
	override function create()
	{
		super.create();
		
		//add(new FlxInputTextRTL(10, 10, 400, "FlxInputTextRTL", 40));
		//add(new FlxInputText(10, 110, 400, "FlxInputText", 40));
	}

	function callback(text:String, effects:Array<MarkdownEffect>)
	{
		trace(text);
		for (e in effects) {
			trace(e);
		}
	}

	var markdownStressTest:String = "
	# This is a header1
	## This is a sub-header
	### This is a sub-sub-header
	#### This is a sub-sub-sub-header
	##### This is a sub-sub-sub-sub-header
	###### This is a sub-sub-sub-sub-sub-header
	####### shouldnt work
	##also this
	---

	*start*
	***hello* World**

	This Test is a ***stress `test`***.

	- it has
	   - nesting
	   - of

	1. many
	2. types

	contains some math: $y = ax + b$

	```
	and codeblocks
	```


";

}
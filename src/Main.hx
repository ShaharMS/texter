package;

import texter.general.markdown.Markdown;
import openfl.text.TextFormat;
import openfl.text.TextField;
import flixel.FlxGame;
import flixel.FlxG;
import openfl.display.Sprite;
using StringTools;

class Main extends Sprite {

    public function new() {
        super();
		var tf = new TextField();
		tf.width = 800;
		tf.height = 800;
		tf.text = markdownStressTest.replace("\r", "").replace("\t", "");
        tf.x = tf.y = 0;
		tf.defaultTextFormat = new TextFormat("assets/V.ttf", 16, 0x000000, false, false, false, "", "", "left");
		tf.background = true;
		tf.backgroundColor = 0xDDDDDD;
		tf.border = true;
		tf.borderColor = 0x0000FF;
		tf.selectable = true;
		tf.type = INPUT;
		tf.wordWrap = true;
		tf.multiline = true;
		tf = Markdown.generateTextFieldVisuals(tf, true);
		addChild(tf);
        
    }
	var markdownStressTest:String = "
	# This is a header1
	## This is a sub-header
	### This is a sub-sub-header
	#### h4
	##### h5
	###### h6
	####### h7
	##wont work

	hello its your friend!

	- nested
	  - lists
	   - letsgo
	- sus
	1. many
	2. types

	**crash *test***
	contains some math: $y = ax + b$


	```
	var tf = Markdown.generateTextFieldVisuals(tf, false)
	```


";
}
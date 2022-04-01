package;

import texter.general.markdown.MarkdownVisualizer;
import haxe.Timer;
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
		tf.width = 700;
		tf.height = 700;
		tf.text = "";
        tf.x = tf.y = 50;
		tf.defaultTextFormat = new TextFormat("assets/V.ttf", 16, 0x000000, false, false, false, "", "", "left");
		tf.background = true;
		tf.backgroundColor = 0xDDDDDD;
		tf.border = true;
		tf.borderColor = 0x0000FF;
		tf.selectable = true;
		tf.type = INPUT;
		tf.wordWrap = true;
		tf.multiline = true;
		addChild(tf);

		var s = new TextField();
		s.width = 700;
		s.height = 700;
		s.text = "";
		s.x = 800;
		s.y = 50;
		s.defaultTextFormat = new TextFormat("assets/V.ttf", 16, 0x000000, false, false, false, "", "", "left");
		s.background = true;
		s.backgroundColor = 0xDDDDDD;
		s.border = true;
		s.borderColor = 0x0000FF;
		s.selectable = true;
		s.wordWrap = true;
		s.multiline = true;
		addChild(s);
		new Timer(25).run = () -> {
			s.text = tf.text;
			MarkdownVisualizer.generateTextFieldVisuals(s);
		};
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
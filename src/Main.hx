package;

import texter.openfl.TextFieldRTL;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.FlxState;
import texter.flixel.FlxInputTextRTL;
import flixel.text.FlxText;
import openfl.events.Event;
import texter.general.TextTools;
import texter.general.markdown.MarkdownBlocks;
import openfl.Lib;
import openfl.display.FPS;
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
		md();
		//tfrtl();
	}


	function md() {
		var tf = new TextFieldRTL();
		tf.width = 700;
		tf.height = 700;
		tf.text = "";
		tf.x = tf.y = 50;
		tf.defaultTextFormat = new TextFormat("assets/V.ttf", 16, 0x000000, false, false, false, "", "", "left");
		tf.border = true;
		tf.borderColor = 0x0000FF;
		tf.selectable = true;
		tf.type = INPUT;
		tf.wordWrap = true;
		tf.multiline = true;
		addChild(tf);
		var s = new TextFieldRTL();
		s.width = 700;
		s.height = 700;
		s.text = "";
		s.x = 800;
		s.y = 50;
		s.defaultTextFormat = new TextFormat("assets/V.ttf", 16, 0x000000, false, false, false, "", "", "left");
		s.border = true;
		s.borderColor = 0x0000FF;
		s.selectable = true;
		s.wordWrap = true;
		s.multiline = true;
		s.defaultTextFormat = tf.defaultTextFormat = MarkdownVisualizer.markdownTextFormat;
		addChild(s);
		tf.addEventListener(Event.CHANGE, (e) ->
		{
			s.text = tf.text;
			s.dispatchEvent(new Event(Event.CHANGE));
			Markdown.visualizeMarkdown(s);
		});
	}

	function tfrtl() {
		var tf = new TextFieldRTL();
		tf.width = tf.height = 400;
		tf.text = "";
		tf.defaultTextFormat = new TextFormat("assets/V.ttf", 16, 0x000000, false, false, false, "", "", "left");
		tf.border = true;
		tf.borderColor = 0x0000FF;
		tf.selectable = true;
		tf.type = INPUT;
		tf.wordWrap = true;
		tf.multiline = true;

		addChild(tf);
	}
}
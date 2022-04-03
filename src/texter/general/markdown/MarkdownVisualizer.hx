package texter.general.markdown;

import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectShader;
import flixel.text.FlxText;
import openfl.display.Bitmap;

using texter.general.TextTools;

/**
 * The `MarkdownVisualizer` class is a containing all framework-specific markdown visualization methods.
 * 
 * For now, visualization is only supported for these frameworks:
 * 
 *  - OpenFL (via `TextField`)
 * 
 * If you'd like for more frameworks to be added you can do a couple of things:
 * 
 * 1. Take an existing visualization method and make it work for your framework. If it works as intended, contact me and i'll add it.
 * 2. If you cant make existing solutions work well, add a new visualization method. again - if it works as intended, contact me and i'll add it.
 * 3. contact me and ask me to make a visualization method. this one will take the longest since ill need to download and learn how to make things with that framework.
 * 
 * contact info: 
 * - ShaharMS#8195 (discord)
 * - https://github.com/ShaharMS/texter (this haxelib's repo to make pull requests)
 */
class MarkdownVisualizer
{

	public static var visualizer(default, null):MarkdownVisualizer = new MarkdownVisualizer();

	#if openfl
	/**
	 * When visualizing a given Markdown string, this `TextFormat` will be used.
	 */
	public var markdownTextFormat(default,
		never):openfl.text.TextFormat = new openfl.text.TextFormat(null, 20, 0x000000, false, false, false, "", "", "left");

	/**
		Generates the default visual theme from the markdown interpreter's information.

		examples (with/without static extension):

		var visuals = new TextField();
		visuals.text = "# hey everyone\n this is *so cool*"
		MarkdownVisualizer.generateTextFieldVisuals(visuals);
		//OR
		visuals.generateTextFieldVisuals();

	**/
	overload extern inline public function generateVisuals(field:openfl.text.TextField):openfl.text.TextField
	{
		field.setTextFormat(markdownTextFormat);
		//if (field.mask == null) field.mask = new Bitmap(new BitmapData(Std.int(field.width), Std.int(field.height), true, 0xFFFFFFFF));
		//@:privateAccess field.mask.__graphics.clear();
		Markdown.interpret(field.text, (markdownText, effects) ->
		{
			field.text = markdownText;
			for (e in effects)
			{
				switch e
				{
					case Bold(start, end): field.setTextFormat(new openfl.text.TextFormat(null, null, null, true, null), start, end);
					case Italic(start, end): field.setTextFormat(new openfl.text.TextFormat(null, null, null, null, true), start, end);
					case Code(start, end): field.setTextFormat(new openfl.text.TextFormat("_typewriter", 22), start, end);
					case Math(start, end): field.setTextFormat(new openfl.text.TextFormat("assets/includedFontsMD/math.ttf"), start, end);
					case ParagraphGap(start, end): continue; // default behaviour
					case CodeBlock(language, start, end): {
							field.setTextFormat(new openfl.text.TextFormat("_typewriter", 22, markdownTextFormat.color, null, null, null, null, null, null, markdownTextFormat.size, markdownTextFormat.size), start, end);
							var coloring:Array<{color:Int, start:Int, end:Int}> = Markdown.codeBlocks.blockSyntaxMap[language](field.text.substring(start, end));
							for (i in coloring) {
								field.setTextFormat(new openfl.text.TextFormat("_typewriter", null, i.color), start + i.start, start + i.end + 1);
							}
						}
					case Link(link, start,
						end): field.setTextFormat(new openfl.text.TextFormat(null, null, 0x008080, null, null, true, link, "_blank"), start, end);
					case Emoji(type, start, end): continue; // default behaviour
					case Heading(level, start, end): field.setTextFormat(new openfl.text.TextFormat(null, 60 - Std.int(level * 10), null, true), start, end);
					case UnorderedListItem(nestingLevel, start, end): field.setTextFormat(new openfl.text.TextFormat(null, 20, null, true), start + nestingLevel, start + nestingLevel + 1);			
					case OrderedListItem(number, nestingLevel, start, end): continue;
					case HorizontalRule(type, start, end): {
							var bounds = field.getCharBoundaries(start + 1);
							bounds.y = bounds.y + bounds.height / 2;
							var lW = field.width - 2 - field.defaultTextFormat.rightMargin, x = field.x + field.defaultTextFormat.leftMargin + 2;
						}
					case StrikeThrough(start, end): continue;
					case Image(altText, imageSource, start, end): continue;
					default: continue;
				}
			}
		});
		return field;
	}
	#end

	#if flixel
	/**
		Generates the default visual theme from the markdown interpreter's information.

		examples (with/without static extension):

		```haxe
		var t = new FlxText();
		t.text = "# hey everyone\n this is *so cool*"
		var visuals = MarkdownVisualizer.generateTextFieldVisuals(t);
		//OR
		var visuals = t.generateTextFieldVisuals();
		```

	**/
	public overload extern inline function generateVisuals(field:FlxText)
	{
		throw "generateVisuals not yet implemented for Flixel";
	}
	#end

	private function new() {
		
	}
}

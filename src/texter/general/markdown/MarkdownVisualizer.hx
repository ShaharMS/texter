package texter.general.markdown;

import flash.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
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
 * ### How To Implement
 * 
 * If you want to make markdown visualization work for your framework, its actually pretty easy.
 * The interpreter already sends all of the data and even does some nice modifictaions, so its as easy as can be:
 * 
 * **First, make a function, containing `Markdown.interpret` that recives a text field and retruns it**  
 * **Dont forget to reset the text's "styling" each time to avoid artifacts!**
 * ****
 * ```haxe
 * 	function displayMarkdown(textField:Text):Text {
 * 		textField.textStyle = defaultTextStyle;
 * 		Markdown.interpret(textField.text, function(markdownText:String, effects:Array<MarkdownEffect>) {
 * 			
 * 		});
 * 		return textField;
 * 	}
 * ```
 * 
 * **Second, in the body of the anonymus function, you implement this *giant*
 *  switch-case to handle all of the effects you want to handle, as well as make your text "markdown-artifact-free":**
 * ```haxe
 * 	function displayMarkdown(textField:Text):Text {
 * 		textField.textStyle = defaultTextStyle;
 * 		Markdown.interpret(textField.text, function(markdownText:String, effects:Array<MarkdownEffect>) {
 * 			field.text = markdownText;
			for (e in effects)
			{
				switch e
				{
					case Emoji(type, start, end): 
					case Bold(start, end): 
					case Italic(start, end): 
					case Code(start, end): 
					case Math(start, end): 
					case Link(link, start, end): 
					case Heading(level, start, end): 
					case UnorderedListItem(nestingLevel, start, end): 
					case OrderedListItem(number, nestingLevel, start, end): 
					case HorizontalRule(type, start, end): 
					case CodeBlock(language, start, end): 
					case StrikeThrough(start, end): 
					case Image(altText, imageSource, start, end): 
					case ParagraphGap(start, end):

					default: continue;
				}
			}
		});
		return field;
 * 	}
 * ```
 * 
 * **And FInally, you can add your desired effect in the switch-case:**
 * ```haxe
 * case Bold: textField.setBold(start, end);
 * case Italic: textField.setItalic(start, end);
 * case Math: textField.setFont("path/to/mathFont.ttf", start, end); //ETC.
 * ```
 * 
 * ### For a working example you can look at this file's source code.
 * 
 * 
 * contact info (for submitting a visualization method): 
 * - ShaharMS#8195 (discord)
 * - https://github.com/ShaharMS/texter (this haxelib's repo to make pull requests)
 */
class MarkdownVisualizer
{
	#if openfl
	/**
	 * When visualizing a given Markdown string, this `TextFormat` will be used.
	 */
	public static var markdownTextFormat(default, never):openfl.text.TextFormat = new openfl.text.TextFormat("_sans", 18, 0x000000, false, false, false, "", "", "left");

	/**
		Generates the default visual theme from the markdown interpreter's information.

		examples (with/without static extension):
		```haxe
		var visuals = new TextField();
		visuals.text = "# hey everyone\n this is *so cool*"
		MarkdownVisualizer.generateTextFieldVisuals(visuals);
		//OR
		visuals.generateVisuals();
		```

	**/
	public static overload extern inline function generateVisuals(field:openfl.text.TextField):openfl.text.TextField
	{
		field.defaultTextFormat = markdownTextFormat;
		field.mask = new Bitmap(new BitmapData(Std.int(field.width), Std.int(field.height), true, 0x00000000));
		Markdown.interpret(field.text, (markdownText, effects) ->
		{
			field.text = markdownText;
			for (e in effects)
			{
				switch e
				{
					case Emoji(type, start, end): 
					case Bold(start, end): field.setTextFormat(new openfl.text.TextFormat(null, null, null, true, null), start, end);
					case Italic(start, end): field.setTextFormat(new openfl.text.TextFormat(null, null, null, null, true), start, end);
					case Code(start, end): field.setTextFormat(new openfl.text.TextFormat("_typewriter", markdownTextFormat.size + 2), start, end);
					case Math(start, end): field.setTextFormat(new openfl.text.TextFormat("_serif"), start, end);
					case Link(link, start, end): field.setTextFormat(new openfl.text.TextFormat(null, null, 0x008080, null, null, true, link, ""), start, end);
					case Heading(level, start, end): field.setTextFormat(new openfl.text.TextFormat(null, markdownTextFormat.size * 3 - Std.int(level * 10), null, true), start, end);
					case UnorderedListItem(nestingLevel, start, end): field.setTextFormat(new openfl.text.TextFormat(null, markdownTextFormat.size, null, true), start + nestingLevel, start + nestingLevel + 1);			
					case OrderedListItem(number, nestingLevel, start, end): continue;
					case HorizontalRule(type, start, end): {
						var bounds = field.getCharBoundaries(start + 1);
						bounds.y = bounds.y + bounds.height / 2;
						var lW = field.width - 2 - field.defaultTextFormat.rightMargin, x = field.x + field.defaultTextFormat.leftMargin + 2;
					}
					case CodeBlock(language, start, end): {
						field.setTextFormat(new openfl.text.TextFormat("_typewriter", markdownTextFormat.size + 2, markdownTextFormat.color, null, null, null, null, null, null, markdownTextFormat.size, markdownTextFormat.size), start, end);
						try {
							var coloring:Array<{color:Int, start:Int, end:Int}> = Markdown.syntaxBlocks.blockSyntaxMap[language](field.text.substring(start, end));
							for (i in coloring) {
								field.setTextFormat(new openfl.text.TextFormat("_typewriter", null, i.color), start + i.start, start + i.end);
							}
						}  catch(e) trace(e);		
					}
					case StrikeThrough(start, end): continue;
					case Image(altText, imageSource, start, end): continue;
					case ParagraphGap(start, end): continue; // default behaviour

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
	public static overload extern inline function generateVisuals(field:flixel.text.FlxText)
	{
		throw "visualizer.generateVisuals not yet implemented for Flixel";
	}
	#end
}

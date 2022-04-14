package texter.general.markdown;

using texter.general.TextTools;

#if openfl
import openfl.text.TextFormat;
import openfl.text.TextField;
import texter.openfl.TextFieldRTL;
#end

/**
	* The `MarkdownVisualizer` class is a containing all framework-specific markdown visualization methods.
	* 
	* For now, visualization is only supported for these frameworks:
	* 
	*  - OpenFL (via `TextField`, `TextFieldRTL`)
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
	* switch-case to handle all of the effects you want to handle, as well as make your text "markdown-artifact-free".**
	*  - **start** contains the starting index of the effect.
	*  - **end** contains the ending index of the effect, but not included!
	*  - **any extra argument** this is for effects that require extra information to be rendered correctly - language for codeblocks, level for headings...
	* 
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
	* **And Finally, you can add your desired effect in each of the cases.**
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
	/**
	 * `visualConfig` is a "dictionary" containing all of the configuration options for the visualizer.
	 * **NOTE** - because its a cross-framework field, and not every framework supports the same options,
	 * You cant exect everything to work in every framework.
	 */
	public static var visualConfig:VisualConfig = @:privateAccess new VisualConfig();

	#if openfl
	/**
	 * When visualizing a given Markdown string, this `TextFormat` will be used.
	 * You can modify the `TextFormat` to change the style of the text via `visualConfig`;
	 */
	public static var markdownTextFormat(get, never):openfl.text.TextFormat;

	@:noCompletion static function get_markdownTextFormat():TextFormat
	{
		return new openfl.text.TextFormat(visualConfig.font, visualConfig.size, visualConfig.color, false, false, false, "", "", visualConfig.alignment,
			visualConfig.leftMargin, visualConfig.rightMargin, visualConfig.indent, visualConfig.leading);
	}

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
		Markdown.interpret(field.text, (markdownText, effects) ->
		{
			field.text = markdownText;
			for (e in effects)
			{
				switch e
				{
					case Emoji(type, start, end):
					case Alignment(alignment, start, end): field.setTextFormat(new openfl.text.TextFormat( null, null, null, null, null, null, null, null, alignment), start, end);
					case Indent(level, start, end): field.setTextFormat(new openfl.text.TextFormat(null, null, null, null, null, null, null, null, null, null, null, level * markdownTextFormat.size), start, end);
					case Bold(start, end): field.setTextFormat(new openfl.text.TextFormat(null, null, null, true, null), start, end);
					case Italic(start, end): field.setTextFormat(new openfl.text.TextFormat(null, null, null, null, true), start, end);
					case Code(start, end): field.setTextFormat(new openfl.text.TextFormat("_typewriter", field.getTextFormat(start, end).size + 2), start, end);
					case Math(start, end): field.setTextFormat(new openfl.text.TextFormat("_serif"), start, end);
					case Link(link, start, end): field.setTextFormat(new openfl.text.TextFormat(null, null, 0x008080, null, null, true, link, ""), start, end);
					case Heading(level, start, end): field.setTextFormat(new openfl.text.TextFormat(null, markdownTextFormat.size * 3 - Std.int(level * 10), null, true), start, end);
					case UnorderedListItem(nestingLevel, start, end): field.setTextFormat(new openfl.text.TextFormat(null, markdownTextFormat.size, null, true), start + nestingLevel, start + nestingLevel + 1);
					case OrderedListItem(number, nestingLevel, start, end): continue;
					case HorizontalRule(type, start, end): continue;
					case CodeBlock(language, start, end): {
						field.setTextFormat(new openfl.text.TextFormat("_typewriter", markdownTextFormat.size + 2, markdownTextFormat.color, null, null,
							null, null, null, null, field.getTextFormat(start, end).leftMargin + markdownTextFormat.size, markdownTextFormat.size),
							start, end);
						try
						{
							var coloring:Array<{color:Int, start:Int, end:Int}> = Markdown.syntaxBlocks.blockSyntaxMap[language](field.text.substring(start,
								end));
							for (i in coloring)
							{
								field.setTextFormat(new openfl.text.TextFormat("_typewriter", null, i.color), start + i.start, start + i.end);
							}
						}
						catch (e)
							trace(e);
					}
					case TabCodeBlock(start, end): {
						field.setTextFormat(new openfl.text.TextFormat("_typewriter", markdownTextFormat.size + 2, markdownTextFormat.color, null, null,
							null, null, null, null, field.getTextFormat(start, end).leftMargin + markdownTextFormat.size, markdownTextFormat.size),
							start, end);
						try
						{
							var coloring:Array<{color:Int, start:Int, end:Int}> = Markdown.syntaxBlocks.blockSyntaxMap["default"](field.text.substring(start,
								end));
							for (i in coloring)
							{
								field.setTextFormat(new openfl.text.TextFormat("_typewriter", null, i.color), start + i.start, start + i.end);
							}
						}
						catch (e)
							trace(e);
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

	public static overload extern inline function generateVisuals(field:TextFieldRTL):TextFieldRTL
	{
		field.defaultTextFormat = markdownTextFormat;
		field.overlay.graphics.clear();
		field.underlay.graphics.clear();
		field.background = false;
		field.underlay.graphics.beginFill(field.backgroundColor);
		field.underlay.graphics.drawRect(0, 0, field.width, field.height + field.textHeight);
		field.underlay.graphics.endFill();
		Markdown.interpret(field.text, (markdownText, effects) ->
		{
			field.text = markdownText;
			for (e in effects)
			{
				switch e
				{
					case Alignment(alignment, start, end): field.setTextFormat(new openfl.text.TextFormat( null, null, null, null, null, null, null, null, alignment), start, end);
					case Indent(level, start, end): field.setTextFormat(new openfl.text.TextFormat(null, null, null, null, null, null, null, null, null, null, null, level * markdownTextFormat.size), start, end);
					case Bold(start, end): field.setTextFormat(new openfl.text.TextFormat(null, null, null, true, null), start, end);
					case Italic(start, end): field.setTextFormat(new openfl.text.TextFormat(null, null, null, null, true), start, end);
					case Math(start, end): field.setTextFormat(new openfl.text.TextFormat("_serif"), start, end);
					case Link(link, start, end): field.setTextFormat(new openfl.text.TextFormat(null, null, 0x008080, null, null, true, link, ""), start, end);
					case Heading(level, start, end): field.setTextFormat(new openfl.text.TextFormat(null, markdownTextFormat.size * 3 - Std.int(level * 10), null, true), start, end);
					case UnorderedListItem(nestingLevel, start, end): field.setTextFormat(new openfl.text.TextFormat(null, markdownTextFormat.size, null, true), start + nestingLevel, start + nestingLevel + 1);
					case OrderedListItem(number, nestingLevel, start, end): continue;
					case Code(start, end): {
						field.setTextFormat(new openfl.text.TextFormat("_typewriter", field.getTextFormat(start, end).size + 2), start, end);
						var g = field.underlay.graphics;
						g.lineStyle(visualConfig.borderSize, visualConfig.borderColor, 1, false, NORMAL);
						g.beginFill(visualConfig.codeblockBackgroundColor, 0.5);
						var bounds = field.getCharBoundaries(start),
							bounds2 = field.textField.getCharBoundaries(end - 1);
						g.drawRoundRect(bounds.x, bounds.y, bounds2.x + bounds2.width - bounds.x, bounds2.height, 5, 5);
						g.endFill();
					}
					case HorizontalRule(type, start, end): {
						var bounds = field.getCharBoundaries(start + 1);
						bounds.y = bounds.y + bounds.height / 2 + field.getTextFormat(start, start + 1).size / 8;
						var lW = field.width - 8 - field.getTextFormat(start, start + 1).rightMargin - field.getTextFormat(start, start + 1).leftMargin,
							x = 4 + field.getTextFormat(start + 1, start + 2).leftMargin;
						// draw the HR according to the text's dimensions
						var g = field.overlay.graphics;
						g.lineStyle(4, 0x000000, 1, false, NORMAL);
						g.moveTo(x, bounds.y);
						g.lineTo(x + lW, bounds.y);
					}
					case CodeBlock(language, start, end): {
						field.setTextFormat(new openfl.text.TextFormat("_typewriter", markdownTextFormat.size + 2, markdownTextFormat.color, null, null,
							null, null, null, null, field.getTextFormat(start, end).leftMargin + markdownTextFormat.size, markdownTextFormat.size),
							start, end);
						// preparing the background
						var g = field.underlay.graphics;
						g.lineStyle(visualConfig.borderSize, visualConfig.borderColor, 1, false, NORMAL);
						g.beginFill(visualConfig.codeblockBackgroundColor, 0.5);
						var bounds = field.getCharBoundaries(start + 3 + language.length +
							1); // +3 for the ```, +1 for the \n and +langLength for the language
						var bounds2 = field.getCharBoundaries(end - 3 - 2); // -3 for the ```, -2 for the \n and because end is not icluded
						g.drawRoundRect(bounds.x - 2, bounds.y, field.width - bounds.x * 2 - 4 + 2, bounds2.y - bounds.y + bounds2.height, 5, 5);
						g.endFill();
						try
						{
							var coloring:Array<{color:Int, start:Int, end:Int}> = Markdown.syntaxBlocks.blockSyntaxMap[language](field.text.substring(start,
								end));
							for (i in coloring)
							{
								field.setTextFormat(new openfl.text.TextFormat("_typewriter", null, i.color), start + i.start, start + i.end);
							}
						}
						catch (e)
							trace(e);
					}
					case TabCodeBlock(start, end): {
						field.setTextFormat(new openfl.text.TextFormat("_typewriter", markdownTextFormat.size + 2, markdownTextFormat.color, null, null,
							null, null, null, null, field.getTextFormat(start, end).leftMargin + markdownTextFormat.size, markdownTextFormat.size),
							start, end);
						// preparing the background
						var g = field.underlay.graphics;
						g.lineStyle(visualConfig.borderSize, visualConfig.borderColor, 1, false, NORMAL);
						g.beginFill(visualConfig.codeblockBackgroundColor, 0.5);
						var bounds = field.getCharBoundaries(start + 4); // + 4 for the spaces
						var bounds2 = field.getCharBoundaries(end - 1); // -1 because end is not included
						bounds.y = bounds.y + bounds.height / 8 - 2;
						bounds2.y = bounds2.y + bounds2.height / 8 + 2;
						g.drawRoundRect(bounds.x - 2, bounds.y, field.width - bounds.x * 2 - 4 + 2, bounds2.y - bounds.y + bounds2.height, 5, 5);
						g.endFill();
						try
						{
							var coloring:Array<{color:Int, start:Int, end:Int}> = Markdown.syntaxBlocks.blockSyntaxMap["default"](field.text.substring(start,
								end));
							for (i in coloring)
							{
								field.setTextFormat(new openfl.text.TextFormat("_typewriter", null, i.color), start + i.start, start + i.end);
							}
						}
						catch (e)
							trace(e);
					}
					case StrikeThrough(start, end): {
						var bounds = field.getCharBoundaries(start + 1);
						bounds.y = bounds.y + bounds.height / 2 + field.getTextFormat(start + 1, start + 2).size / 16;
						var bounds2 = field.getCharBoundaries(end - 1);
						bounds2.y = bounds2.y + bounds2.height / 2;
						var g = field.overlay.graphics;
						g.lineStyle(field.getTextFormat(start + 1, start + 2).size / 8, 0x000000, 1, false, NORMAL, SQUARE);
						g.moveTo(bounds.x, bounds.y);
						g.lineTo(bounds2.x + bounds2.width, bounds.y);
					}
					case Image(altText, imageSource, start, end): continue;
					case ParagraphGap(start, end): continue; // default behaviour
					case Emoji(type, start, end): continue; // default behaviour

					default: continue;
				}
			}
		});
		return field;
	}
	#end
}

private class VisualConfig
{
	@:noCompletion private function new()
		return;

	public var size:Int = 18;
	public var color:Int = 0x000000;
	public var font:String = "_sans";
	public var leftMargin:Int = 0;
	public var rightMargin:Int = 0;
	public var indent:Int = 0;
	public var leading:Int;
	public var blockIndent:Int = 18;
	public var alignment:String = "left";
	public var border:Bool = true;
	public var borderColor:Int = 0x000000;
	public var borderSize:Int = 1;
	public var background:Bool = false;
	public var backgroundColor:Int = 0xEEEEEE;
	public var codeblockBackgroundColor:Int = 0xCCCCCC;

	/**
	 * Set all the properties of the default visual configuration at once.
	 * to skip values, set them to `null`.
	 * @param size the size of the text
	 * @param color the color of the text
	 * @param font specify the font of the text, use the path to your font: `path/to/font.ttf`
	 * @param leftMargin the left margin of the text (how far will the text be away from the left border, in pixels)
	 * @param rightMargin the right margin of the text (how far will the text be away from the right border, in pixels)
	 * @param indent the indent of the text (how far will the text be away from the left margin, in pixels)
	 * @param leading the spacing between lines, in pixels
	 * @param blockIndent the right & left margin used when displaying a code block
	 *  characters the contain the symbols; the first character is the symbol for the
	 *  first-level bullet point, the second character is the symbol for the second-level bullet point.
	 * @param alignment the alignment of the text, can be `left`, `right`, `center` or `justify`
	 * @param border whether to draw a border around the text
	 * @param borderColor the color of the border
	 * @param borderSize the size of the border (the thickness of the border, in pixels)
	 * @param background whether to draw a background behind the text
	 * @param backgroundColor the color of the background
	 * @param codeblockBackgroundColor the color of the background behind code blocks
	 */
	public function setAll(?size:Int, ?color:Int, ?font:String, ?leftMargin:Int, ?rightMargin:Int, ?indent:Int, ?leading:Int, ?blockIndent:Int,
			?alignment:String, ?border:Bool, ?borderColor:Int, ?borderSize:Int, ?background:Bool, ?backgroundColor:Int,
			?codeblockBackgroundColor:Int):VisualConfig
	{
		this.size = size != null ? size : this.size;
		this.color = color != null ? color : this.color;
		this.font = font != null ? font : this.font;
		this.leftMargin = leftMargin != null ? leftMargin : this.leftMargin;
		this.rightMargin = rightMargin != null ? rightMargin : this.rightMargin;
		this.indent = indent != null ? indent : this.indent;
		this.leading = leading != null ? leading : this.leading;
		this.blockIndent = blockIndent != null ? blockIndent : this.blockIndent;
		this.alignment = alignment != null ? alignment : this.alignment;
		this.border = border != null ? border : this.border;
		this.borderColor = borderColor != null ? borderColor : this.borderColor;
		this.borderSize = borderSize != null ? borderSize : this.borderSize;
		this.background = background != null ? background : this.background;
		this.backgroundColor = backgroundColor != null ? backgroundColor : this.backgroundColor;
		this.codeblockBackgroundColor = codeblockBackgroundColor != null ? codeblockBackgroundColor : this.codeblockBackgroundColor;
		return this;
	}
}

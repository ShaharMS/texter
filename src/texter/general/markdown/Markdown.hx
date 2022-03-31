package texter.general.markdown;

import texter.general.markdown.MarkdownEffect;
import texter.general.markdown.ModifiedMarkdownPatterns;

using StringTools;
using texter.general.text.TextTools;

/**
 * The `Markdown` class provides tools to handle markdown texts in a **cross-framework** fashion.
 * 
 * **In its base resides the `interpret()` function.**
 * 
 * Everything in this class is based around the interpreter. everything from the markdown rules, to the patterns & visualization methods.
 * The interpreter uses a pre-parser & lots of `regex`s (Regular Expresions) to parse the markdown text. after parsing, 
 * it returns the text witout all of the "ugly" markdown syntax, and an array of the effects that are needed to be appied, with `startIndex` and `endIndex`.
 * You don't have to utilize all of the information the interpreter gives you - it doesnt enforce anything - it just guves you the data you need to start working
 * 
 * `interpret()` is mostly used internally to get information about the markdown text for visualization methods, 
 * but you can also use it yourself to make your own markdown styling
 * 
 */
class Markdown
{
	/**
	 * The `modifiedPatterns` field contains all of the modified patterns that are used to parse markdown text.   
	 */
	static var modifiedPatterns(default, never):ModifiedMarkdownPatterns = @:privateAccess new ModifiedMarkdownPatterns();

	static var markdownRules(default, null):Array<EReg> = [
		modifiedPatterns.titleEReg, // Done.
		modifiedPatterns.codeblockEReg, // Done.
		modifiedPatterns.italicEReg, // Done.
		modifiedPatterns.mathEReg, // Done.
		modifiedPatterns.codeEReg, // Done.
		modifiedPatterns.boldEReg, // Done.
		modifiedPatterns.parSepEReg, // Done.
		modifiedPatterns.linkEReg, // Done.
		modifiedPatterns.listItemEReg, // Done.
		modifiedPatterns.hRuleEReg, // Done.
		modifiedPatterns.emojiEReg // Done. 
	];

	/**
	 * Mostly for internal use, but can also be useful for creating your own
	 * Markdown styling.
	 * 
	 * This function takes in a string formatted in Markdown, and each time it encounteres
	 * a Markdown "special effect" (headings, charts, points, etc.), it pushes
	 * a style corresponding to the found effect. 
	 * 
	 * for some effects, it also includes a built-in visual effect:
	 *  - Unordered Lists
	 *  - Emojis
	 *  - tables (coming soon)
	 * 
	 * after finding the effects, it calls:
	 * 
	 * ### onComplete:
	 * 
	 * The `onComplete()` will get called after the text has been processed:
	 *  - **First Argument - The Actual Text**: to keep the text clean, after proccessing the text, a markdown-
	 * free version of the text is returned (altho some marks do remain, such as the list items and hrules)
	 *  - **Second Argument - The Effects** - this array contains lots of ADTs (algebric data types). Those
	 * contain the actual data - most of them contain the start & end index of the effect, and some contain more
	 * data (things like list numbers, indentation...)
	 * 
	 * ### Things to notice:
	 *  - The markdown text contains zero-width spaces (\u200B) in the text in order to keep track of effect positions.
	 *  - The effect's range is from startIndex up to, but not including endIndex.
	 *  - certine effects will already be rendered by the interpreter, so no need to mess with those.
	 *  - The interpreter doesnt support everything markdown has to offer (yet). supported markups:  
	 * 	  - **Headings**: #, ##, ###, ####, #####, ######, #######
	 * 	  - **Lists**: -, *, +, 1.
	 * 	  - **CodeBlocks**: ``````
	 * 	  - **Inline Code**: ``
	 * 	  - **Italics**: _, *
	 * 	  - **Bolds**: **, __
	 * 	  - **StrikeThrough**: ~~~~ 
	 * 	  - **Links**: `[ ]( )`
	 * 	  - **Math**: $$
	 * 	  - **Emojis**: :emojiNameHere:
	 * 	  - **HRules**: ---, ***, ___, ===
	 * 	  - **Paragraph Gaps** (two or more newlines)
	 * 
	 * @param markdownText Just a plain string with markdown formatting. If you want to make sure 
	 * the formatting is correct, just write the markdown text in a `.md` file and do `File.getContent("path/to/file.md")`
	 */
	public static function interpret(markdownText:String, onComplete:(String, Array<MarkdownEffect>) -> Void)
	{
		var lineTexts = StringTools.replace(markdownText, "\r", "");
		
		// fix for nested bold
		lineTexts = lineTexts.replace("\t", "").replace("__", "**");
		// fixes interpreter faults & matches the markdown rules.
		lineTexts = lineTexts
			.replace("\n___\n", "\n———\n")
			.replace("\n---\n", "\n———\n")
			.replace("\n===\n", "\n———\n")
			.replace("\n***\n", "\n———\n")
			.replace("\n\n", "\r\r");

		var effects:Array<MarkdownEffect> = [];
		for (rule in markdownRules)
		{
			while (rule.match(lineTexts))
			{
				if (rule == modifiedPatterns.italicEReg || rule == modifiedPatterns.mathEReg || rule == modifiedPatterns.codeEReg || rule == modifiedPatterns.astItalicEReg)
				{
					lineTexts = rule.replace(lineTexts, "​$1​");
					var info = rule.matchedPos();
					effects.push(
						if (rule == modifiedPatterns.mathEReg) 
					Math(info.pos, info.pos + info.len) else 
					if (rule == modifiedPatterns.codeEReg) 
						Code(info.pos, info.pos + info.len) else
					Italic(info.pos, info.pos + info.len)); 
				}
				else if (rule == modifiedPatterns.boldEReg || rule == modifiedPatterns.strikeThroughEReg)
				{
					lineTexts = rule.replace(lineTexts, "​​$1​​");
					var info = rule.matchedPos();
					effects.push(
						if (rule == modifiedPatterns.boldEReg) 
							Bold(info.pos, info.pos + info.len) else
						StrikeThrough(info.pos, info.pos + info.len));
				}
				else if (rule == modifiedPatterns.parSepEReg || rule == modifiedPatterns.hRuleEReg)
				{
					lineTexts = rule.replace(lineTexts, if (rule == modifiedPatterns.parSepEReg) "\n\n" else "\r$1\r");
					var info = rule.matchedPos();
					effects.push(if (rule == modifiedPatterns.parSepEReg) ParagraphGap(info.pos,
						info.pos + info.len - 1) else HorizontalRule("—", info.pos, info.pos + info.len));
				}
				else if (rule == modifiedPatterns.linkEReg)
				{
					var linkLength = "";
					while (linkLength.length < rule.matched(2).length)
						linkLength += "​";
					lineTexts = rule.replace(lineTexts, "​$1​​​" + linkLength);
					var info = rule.matchedPos();
					effects.push(Link(rule.matched(1), info.pos, info.pos + info.len));
				}
				else if (rule == modifiedPatterns.listItemEReg)
				{
					if (!~/[0-9]/g.match(rule.matched(1)))
						lineTexts = rule.replace(lineTexts, "$1• $3")
					else
						lineTexts = rule.replace(lineTexts, "$1$2. $3");
					var info = rule.matchedPos();
					effects.push(if (!~/[0-9]/g.match(rule.matched(1))) UnorderedListItem(rule.matched(1).length, info.pos,
						info.pos + info.len - 1) else
						OrderedListItem(Std.parseInt(rule.matched(2)), rule.matched(1).length, info.pos, info.pos + info.len - 1));
				}
				else if (rule == modifiedPatterns.titleEReg)
				{
					lineTexts = rule.replace(lineTexts, rule.matched(1).replace("#", "​") + "$2");
					var info = rule.matchedPos();
					effects.push(Heading(rule.matched(1).length, info.pos, info.pos + info.len));
				}
				else if (rule == modifiedPatterns.codeblockEReg)
				{
					var langLength = "";
					while (langLength.length < rule.matched(1).length)
						langLength += "​";
					lineTexts = rule.replace(lineTexts, langLength + "​​​\r$2​​​");
					var info = rule.matchedPos();
					effects.push(CodeBlock(rule.matched(1), info.pos, info.pos + info.len));
				}
				else if (rule == modifiedPatterns.emojiEReg)
				{
					var info = rule.matchedPos();
					effects.push(Emoji(rule.matched(1), info.pos, info.pos + info.len));
				} 
			}
		}
		while (modifiedPatterns.astItalicEReg.match(lineTexts)) 
		{
			lineTexts = modifiedPatterns.astItalicEReg.replace(lineTexts, "​$1​");
			var info = modifiedPatterns.astItalicEReg.matchedPos();
			effects.push(Italic(info.pos, info.pos + info.len));
		}
		onComplete(lineTexts.replace("\r", "\n"), effects);
	}

	#if openfl
	/**
	 * Generates the default visual theme from the markdown interpreter's information.
	 * 
	 * This method **is** cross-framework, but is yet to have support for all of those frameworks.
	 * currently supported frameworks:
	 *  - OpenFL
	 *  - HaxeFlixel
	 * 
	 * For the **textField** parameter, provide a text of your framework's main text type: 
	 * - for **OpenFL** its **TextField**, 
	 * - for **HaxeFlixel** its **FlxText**...
	 * 
	 * The **apply** parameter is a boolean that determines whether the theme should be applied to the actual textField or a shallow copy of it
	 * 
	 * ### Expectations:
	 *  - The markdown text should be a string inside the field `text`.
	 *  - The textField's font should be able to support *italic* and **bold**'
	 * 
	 * example:
	 * 
	 *  	var visuals:TextClass = Markdown.generateTextClassVisuals(yourText);
	 */
	public static function generateTextFieldVisuals(textField:openfl.text.TextField, apply:Bool = false):openfl.text.TextField {
		//now we get to the fun part
		var field:openfl.text.TextField = if (!apply) createShallowCopyTF(textField) else textField;
		interpret(field.text, (markdownText, effects) ->
		{
			field.text = markdownText;
			for (e in effects)
			{
				switch e
				{
					case Bold(start, end): field.setTextFormat(new openfl.text.TextFormat(null, null, null, true), start, end);
					case Italic(start, end): field.setTextFormat(new openfl.text.TextFormat(null, null, null, null, true), start, end);
					case Code(start, end): field.setTextFormat(new openfl.text.TextFormat("_typewriter"), start, end);
					case Math(start, end): field.setTextFormat(new openfl.text.TextFormat("assets/includedFontsMD/math.ttf"), start, end);
					case ParagraphGap(start, end): continue; //default behaviour
					case CodeBlock(language, start, end): field.setTextFormat(new openfl.text.TextFormat("_typewriter"), start, end);
					case Link(link, start, end): field.setTextFormat(new openfl.text.TextFormat(null, null, 0x008080, null, null, true, link, "_blank"), start, end);
					case Emoji(type, start, end): continue; //default behaviour
					case Heading(level, start, end): field.setTextFormat(new openfl.text.TextFormat(null, field.defaultTextFormat.size + Std.int(6 / level * 2), null, true), start, end);
					case UnorderedListItem(nestingLevel, start, end): continue; //default behaviour
					case OrderedListItem(number, nestingLevel, start, end): continue; //default behaviour
					case HorizontalRule(type, start, end): {
						var bounds = field.getCharBoundaries(start), lW = field.getLineMetrics(field.getLineIndexOfChar(start)).width;
					}
					case StrikeThrough(start, end): continue;
					case Image(altText, imageSource, start, end): continue;
					default: continue;
				}
			}
		});
		return field;
	}
	static function createShallowCopyTF(t:openfl.text.TextField):openfl.text.TextField {
		var f = new openfl.text.TextField();
		f.text = t.text;
		f.defaultTextFormat = t.defaultTextFormat;
		f.embedFonts = t.embedFonts;
		f.antiAliasType = t.antiAliasType;
		f.autoSize = t.autoSize;
		f.background = t.background;
		f.backgroundColor = t.backgroundColor;
		f.border = t.border;
		f.borderColor = t.borderColor;
		f.displayAsPassword = t.displayAsPassword;
		f.gridFitType = t.gridFitType;
		f.htmlText = t.htmlText;
		f.maxChars = t.maxChars;
		f.multiline = t.multiline;
		f.restrict = t.restrict;
		f.selectable = t.selectable;
		f.sharpness = t.sharpness;
		f.textColor = t.textColor;
		f.type = t.type;
		f.wordWrap = t.wordWrap;
		return f;
	}
	#end
}


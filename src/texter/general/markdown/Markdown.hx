package texter.general.markdown;

import texter.general.markdown.MarkdownEffect;
import texter.general.markdown.MarkdownPatterns;
import texter.general.markdown.MarkdownBlocks;
import texter.general.markdown.MarkdownVisualizer;
import texter.general.Emoji;

using StringTools;
using texter.general.TextTools;

/**
 * The `Markdown` class provides tools to handle markdown texts in a **cross-framework** fashion.
 * 
 * **In its base resides the `interpret()` function.**
 * 
 * Everything in this class is based around the interpreter. everything from the markdown rules, 
 * to the patterns & visualization methods. The interpreter uses a pre-parser & lots of `regex`s
 * (Regular Expresions) to parse the markdown text. after parsing, it returns the text witout all
 * of the "ugly" markdown syntax, and an array of the effects that are needed to be appied, with 
 * `startIndex` and `endIndex`. You don't have to utilize all of the information the interpreter
 * gives you - it doesnt enforce anything - it just gives you the data you need to start working
 * 
 * `interpret()` is mostly used internally to get information about the markdown text for visualization methods, 
 * but you can also use it yourself to make your own markdown styling
 * 
 */
class Markdown
{

	/**
	 * The `patterns` field contains all of the patterns used to parse markdown text.   
	 * 
	 * If you want to access them individually, you can do it using this field
	 */
	public static var patterns(default, never) = MarkdownPatterns;

	/**
	 * `syntaxBlocks` is a field representing a class that contains many syntax coloring
	 * methods for codeblocks.
	 */
	public static var syntaxBlocks(default, null) = MarkdownBlocks;

	/**
	 * If you want to modify certain visual aspects of the markdown text, you can 
	 * gain access to those via the `visualizer` field.
	 */
	public static var visualizer(default, null) = MarkdownVisualizer;

	static var markdownRules(default, null):Array<EReg> = [
		patterns.indentEReg, // Done.
		patterns.hRuledTitleEReg, // Done.
		patterns.titleEReg, // Done.
		patterns.codeblockEReg, // Done.
		patterns.emojiEReg, // Done.
		patterns.boldEReg, // Done.
		patterns.astBoldEReg, // Done.
		patterns.strikeThroughEReg, // Done.
		patterns.italicEReg, // Done.
		patterns.astItalicEReg, // Done.
		patterns.mathEReg, // Done.
		patterns.codeEReg, // Done.
		patterns.parSepEReg, // Done.
		patterns.linkEReg, // Done.
		patterns.listItemEReg, // Done.
		patterns.hRuleEReg // Done.
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
	 *  - Tables (coming soon)
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
	 * 	  - **Lists (also nested)**: -, *, +, 1., 2.
	 * 	  - **CodeBlocks**: ``````
	 * 	  - **Inline Code**: ``
	 * 	  - **Italics**: _, *
	 * 	  - **Bolds**: **, __
	 * 	  - **StrikeThrough**: ~~~~
	 * 	  - **Links**: `[]()`
	 * 	  - **Math**: $$
	 * 	  - **Emojis**: :emojiNameHere:
	 * 	  - **HRules**: ---, ***, ___, ===, +++
	 * 	  - **HRuledHeadings**: H1 - title\n===,+++,***, H2 - title\n---,___
	 * 	  - **Paragraph Gaps** (two or more newlines)
	 * 
	 * @param markdownText Just a plain string with markdown formatting. If you want to make sure 
	 * the formatting is correct, just write the markdown text in a `.md` file and do `File.getContent("path/to/file.md")`
	 */
	public static function interpret(markdownText:String, onComplete:(String, Array<MarkdownEffect>) -> Void)
	{
		var lineTexts = StringTools.replace(markdownText, "\r", "") + "\n";
		// fixes interpreter faults & matches the markdown rules.
		var effects:Array<MarkdownEffect> = [];
		for (rule in markdownRules)
		{
			if (rule == patterns.parSepEReg)
				continue;
			while (rule.match(lineTexts))
			{
				if (rule == patterns.indentEReg) {
					lineTexts = rule.replace(lineTexts, "​".multiply(rule.matched(1).length));
					var info = rule.matchedPos();
					effects.push(Indent(rule.matched(1).length, info.pos, info.pos + info.len));
				}
				if (rule == patterns.italicEReg || rule == patterns.mathEReg || rule == patterns.codeEReg || rule == patterns.astItalicEReg)
				{
					lineTexts = rule.replace(lineTexts, "​$1​");
					var info = rule.matchedPos();
					effects.push(if (rule == patterns.mathEReg) Math(info.pos,
						info.pos + info.len) else if (rule == patterns.codeEReg) Code(info.pos, info.pos + info.len) else
						Italic(info.pos, info.pos + info.len));
				}
				else if (rule == patterns.boldEReg || rule == patterns.strikeThroughEReg || rule == patterns.astBoldEReg)
				{
					lineTexts = rule.replace(lineTexts, "​​$1​​");
					var info = rule.matchedPos();
					effects.push(if (rule == patterns.boldEReg || rule == patterns.astBoldEReg) Bold(info.pos,
						info.pos + info.len) else StrikeThrough(info.pos, info.pos + info.len));
				}
				else if (rule == patterns.hRuleEReg)
				{
					lineTexts = rule.replace(lineTexts, if (rule == patterns.parSepEReg) "\n\n" else "—".multiply(rule.matched(1).length));
					var info = rule.matchedPos();
					effects.push(HorizontalRule(rule.matched(1).charAt(0), info.pos, info.pos + info.len));
				}
				else if (rule == patterns.hRuledTitleEReg)
				{
					lineTexts = rule.replace(lineTexts, rule.matched(1) + "\n" + "—".multiply(rule.matched(2).length));
					var info = rule.matchedPos();
					var type = rule.matched(2).charAt(0);
					if (rule.matched(1).charAt(0) == "#")
						continue; // this is inteded to be a regular heading
					effects.push(Heading(if (type == "*" || type == "+" || type == "=") 1 else 2, if (info.pos == 0) info.pos else info.pos - 1,
						info.pos + rule.matched(1).length));
					effects.push(HorizontalRule(type, info.pos + rule.matched(1).length + 1, info.pos + info.len + 1));
				}
				else if (rule == patterns.linkEReg)
				{
					var linkLength = "​".multiply(rule.matched(1).length);
					lineTexts = rule.replace(lineTexts, "​$2​​​" + linkLength);
					var info = rule.matchedPos();
					effects.push(Link(rule.matched(1), info.pos, info.pos + info.len));
				}
				else if (rule == patterns.listItemEReg)
				{
					if (!rule.matched(2).contains("."))
					{
						var n = rule.matched(1).length;
						var info = rule.matchedPos();
						var start = info.pos - 2;
						if (start < 0)
						{
							lineTexts = rule.replace(lineTexts, "$1• $3");
							effects.push(UnorderedListItem(n, info.pos, info.pos + info.len - 1));
							continue;
						}
						while (lineTexts.charAt(start--) != "\n" && start != 0) {} // now, start contains the previous line's start
						if (start != 0)
							start += 2;
						var prevLine = lineTexts.substring(start, info.pos);
						if (prevLine.trim().charAt(0) == "•" || prevLine.trim().charAt(0) == "◦")
						{
							var len = 0;
							while (prevLine.charAt(len) != "•" && prevLine.charAt(len) != "◦")
								len++;
							if (n < len)
							{
								lineTexts = rule.replace(lineTexts, "$1• $3");
							}
							else if (len == n)
							{
								if (prevLine.trim().charAt(0) == "•")
								{
									lineTexts = rule.replace(lineTexts, "$1• $3");
								}
								else
								{
									lineTexts = rule.replace(lineTexts, "$1◦ $3");
								}
							}
							else
							{
								lineTexts = rule.replace(lineTexts, "$1◦ $3");
							}
							effects.push(UnorderedListItem(n, info.pos, info.pos + info.len - 1));
							continue;
						}
						lineTexts = rule.replace(lineTexts, "$1• $3");
						effects.push(UnorderedListItem(n, info.pos, info.pos + info.len - 1));
					}
					else
					{
						lineTexts = rule.replace(lineTexts, rule.matched(1) + rule.matched(2).replace(".", "") + "․ $3");
						var info = rule.matchedPos();
						effects.push(OrderedListItem(Std.parseInt(rule.matched(2)), rule.matched(1).length, info.pos, info.pos + info.len - 1));
					}
				}
				else if (rule == patterns.titleEReg)
				{
					lineTexts = rule.replace(lineTexts, rule.matched(1).replace("#", "​") + "$2");
					var info = rule.matchedPos();
					effects.push(Heading(rule.matched(1).length, info.pos, info.pos + info.len));
				}
				else if (rule == patterns.codeblockEReg)
				{
					var langLength = "";
					while (langLength.length < rule.matched(1).length)
						langLength += "​";
					lineTexts = rule.replace(lineTexts, langLength + "​​​\r$2​​​");
					var info = rule.matchedPos();
					effects.push(CodeBlock(rule.matched(1), info.pos, info.pos + info.len));
				}
				else if (rule == patterns.emojiEReg) 
				{
					var emoji = '​${texter.general.Emoji.emojiFromString[rule.matched(1)]}${"​".multiply(rule.matched(1).length - 2)}';
					if (emoji.contains("undefined")) emoji = rule.matched(1).replace(":", "​");
					lineTexts = rule.replace(lineTexts, emoji);
					var info = rule.matchedPos();
					effects.push(Emoji(emoji, info.pos, info.pos + info.len));
				}
			}
		}
		onComplete(lineTexts.replace("\r", "\n"), effects);
	}

	#if openfl
	/**
		Generates the default visual theme from the markdown interpreter's information.

		If you want to edit the default visual theme, you can go to 
		`Markdown.visualizer.markdownTextFormat`/`MarkdownVisualizer.markdownTextFormat` and change things there.

		examples (with/without static extension):
		```haxe
		var visuals = new TextField();
		visuals.text = "# hey everyone\n this is *so cool*"
		Markdown.visualizeMarkdown(visuals);
		//OR
		visuals.visualizeMarkdown();
		```

	**/
	public static overload extern inline function visualizeMarkdown(textField:openfl.text.TextField):openfl.text.TextField {
		return visualizer.generateVisuals(textField);
	}
	#end
}

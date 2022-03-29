package texter.general.markdown;

import texter.general.markdown.MarkdownEffects;
import texter.general.markdown.MarkdownPatterns;

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
class Markdown {

	public static var patterns(default, never):MarkdownPatterns = @:privateAccess new MarkdownPatterns();
    public static var emojiMaps:Map<String, String> = [

    ];
    static var isParagraphStart(get, default):Bool = false;
	static function get_isParagraphStart():Bool return isParagraphStart = !isParagraphStart;

	static var current:String;

    /**
     * Those rules are the ones used by the interpreter to determine where to place each markdown element:
     */
    public static var markdownRules(default, null):Array<EReg> = [
        patterns.titleEReg, // Done.
        patterns.codeblockEReg, // Done.
		patterns.italicEReg, // Done.
		patterns.mathEReg, // Done.
		patterns.codeEReg, // Done.
		patterns.boldEReg, // Done.
	    patterns.parSepEReg, // Done.
	    patterns.linkEReg, // Done.
	    patterns.listItemEReg, // Done.
        patterns.hRuleEReg, // Done.
        patterns.emojiEReg // Done.
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
     * data (things like list numbers, indentation...) **NOTICE -** the texts starts at startIndex, but not including endIndex.
     * 
     * @param markdownText Just a plain string with markdown formatting. If you want to make sure 
     * the formatting is correct, just write the markdown text in a `.md` file and do `File.getContent("path/to/file.md")`
     */
    public static function interpret(markdownText:String, onComplete:(String, Array<MarkdownEffects>) -> Void) {
        var lineTexts = StringTools.replace(markdownText, "\r", "");
        //fix for nested bold
        while (lineTexts.contains("__")) lineTexts = lineTexts.replacefirst( "__", "**");
        //fixes interpreter faults & matches the markdown rules.
		lineTexts = lineTexts.replace("\n\n", "\r\r").replace("\n___", "\n―――").replace("\n---", "\n―――").replace("*", "_");
        ~/( *[0-9]+\.)/g.replace(lineTexts, "$1>");

        current = lineTexts;

        var effects:Array<MarkdownEffects> = [];
        for (rule in markdownRules) {
			while (rule.match(current)) {

                if (rule == patterns.italicEReg|| rule == patterns.mathEReg || rule == patterns.codeEReg)
                {
					current = rule.replace(current, "$1");
                    var info = rule.matchedPos();
                    effects.push(
                        if (rule == patterns.italicEReg) 
                            Italic(info.pos, info.pos + info.len - 2) else
                        if (rule == patterns.codeEReg) 
                            Code(info.pos, info.pos + info.len - 2) else
                        Math(info.pos, info.pos + info.len - 2)
                    );
                } 
                else if (rule == patterns.boldEReg) 
                {
					current = rule.replace(current, "$1");
                    var info = rule.matchedPos();
                    effects.push(Bold(info.pos, info.pos + info.len - 4));
                } 
                else if (rule == patterns.parSepEReg || rule == patterns.hRuleEReg)
                {
					current = rule.replace(current, if (rule == patterns.parSepEReg) "\n\n" else "\r$1\r");
                    var info = rule.matchedPos();
                    effects.push(
                        if (rule == patterns.parSepEReg)
                            ParagraphGap(info.pos, info.pos + info.len - 1) else 
                        HorizontalRule("―", info.pos, info.pos + info.len - 1));
                } 
                else if (rule == patterns.linkEReg) 
                {
                    current = rule.replace(current, "$1");
                    var info = rule.matchedPos();
                    effects.push(Link(rule.matched(1), info.pos, info.pos + info.len - 4 - rule.matched(2).length));
                } 
                else if (rule == patterns.listItemEReg) 
                {
					if (!~/[0-9]/g.match(rule.matched(1))) current = rule.replace(current, "$1· $3") else current = rule.replace(current, "$1$2. $3");
                    var info = rule.matchedPos();
					effects.push(
                        if (!~/[0-9]/g.match(rule.matched(1)))
                            UnorderedListItem(rule.matched(1).length,  info.pos, info.pos + info.len - 1) else
					    OrderedListItem(Std.parseInt(rule.matched(2)), rule.matched(1).length, info.pos, info.pos + info.len - 1));
                } 
                else if (rule == patterns.titleEReg) 
                {
                    current = rule.replace(current, "$2");
                    var info = rule.matchedPos();
                    effects.push(Heading(rule.matched(1).length, info.pos, info.pos + info.len - rule.matched(1).length - 2));
                } 
                else if (rule == patterns.codeblockEReg) 
                {
                    current = rule.replace(current, "$2");
                    var info = rule.matchedPos();
                    effects.push(CodeBlock(rule.matched(1), info.pos, info.pos + info.len - 6 - rule.matched(1).length));
                } 
                else if (rule == patterns.emojiEReg) 
                {
                    var info = rule.matchedPos();
                    effects.push(Emoji(rule.matched(1), info.pos, info.pos + info.len - 2));
                }
            }
        }
        onComplete(current.replace("\r", "\n"), effects);
    }
}
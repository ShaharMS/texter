package texter.general.markdown;

import texter.general.markdown.MarkdownEffects;
import texter.general.markdown.MarkdownPatterns;

using StringTools;

class Markdown {

	public static var patterns(default, never):MarkdownPatterns = @:privateAccess new MarkdownPatterns();
    static var isParagraphStart(get, default):Bool = false;
	static function get_isParagraphStart():Bool return isParagraphStart = !isParagraphStart;

	static var current:String;

    /**
     * Those rules are the ones used by the interpreter to determine where to place each markdown element:
     */
    public static var markdownRules(default, null):Array<EReg> = [
        //patterns.titleEReg, <- DISABLED - causes a crash in the interpreter
        patterns.codeblockEReg,
		patterns.boldEReg, // Done.
		patterns.italicEReg, // Done.
		patterns.mathEReg, // Done.
		patterns.codeEReg, // Done.
	    patterns.parSepEReg,
	    patterns.linkEReg,
	    patterns.listItemEReg,
	    patterns.imageEReg,
        patterns.hRuleEReg,
    ];

    /**
     * Mostly for internal use, but can also be useful for creating your own
     * Markdown styling.
     * 
     * This function takes in a string formatted in Markdown, and each time it encounteres
     * a Markdown "special effect" (headings, charts, points, etc.), it pushes
     * a style corresponding to the found effect. after finding the effects, it calls:
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
        var lineTexts = StringTools.replace(markdownText, "\r", ""); //gets each line of text, wordwrapped text shouldnt be worried about
        var b = true;
        //fix for nested bold
        while (lineTexts.contains("**")) {
            if (b) {lineTexts = replacefirst(lineTexts, "**", "[<"); b = !b;}
            else   {lineTexts = replacefirst(lineTexts, "**", ">]"); b = !b;}
        }
		if (lineTexts.lastIndexOf("[<") > lineTexts.lastIndexOf(">]")) {
            lineTexts = replaceLast(lineTexts, "[<", "**");
        }
        //fixes interpreter faults
        lineTexts = lineTexts.replace("\n\n", "\r\r").replace("=", "_").replace("-", "_");
        current = lineTexts;
        trace(current);
        var effects:Array<MarkdownEffects> = [];
        for (rule in markdownRules) {
			while (rule.match(current)) {
                if (rule == patterns.italicEReg|| rule == patterns.mathEReg || rule == patterns.codeEReg) {
					current = rule.replace(current, "$1");
                    var info = rule.matchedPos();
                    effects.push(
                        if (rule == patterns.italicEReg) 
                            Italic(info.pos, info.pos + info.len - 2) else
                        if (rule == patterns.codeEReg) 
                            Code(info.pos, info.pos + info.len - 2) else
                        Math(info.pos, info.pos + info.len - 2)
                    );
                } else if (rule == patterns.boldEReg) {
					current = rule.replace(current, "$1");
                    var info = rule.matchedPos();
                    effects.push(Bold(info.pos, info.pos + info.len - 4));
                } else if (rule == patterns.parSepEReg || rule == patterns.hRuleEReg) {
					current = rule.replace(current, if (rule == patterns.parSepEReg) "\n\n" else "==");
                    var info = rule.matchedPos();
                    effects.push(
                        if (rule == patterns.parSepEReg)
                            ParagraphGap(info.pos, info.pos + info.len - 1) else 
                        HorizontalRule("=", info.pos, info.pos + info.len - 1));
                } else if (rule == patterns.linkEReg) {
                    current = rule.replace(current, "$1");
                    var info = rule.matchedPos();
                    effects.push(Link(rule.matched(1), info.pos, info.pos + info.len - 4 - rule.matched(2).length));
                } else if (rule == patterns.listItemEReg) {
                    
                }
            }
        }
        onComplete(current, effects);
    }

    static function replaceLast(string:String, replace:String, by:String):String {
        var place = string.lastIndexOf(replace);
        var result = string.substring(0, place) + by + string.substring(place + replace.length);
        return result;
    }

    static function replacefirst(string:String, replace:String, by:String):String {
        var place = string.indexOf(replace);
        var result = string.substring(0, place) + by + string.substring(place + replace.length);
        return result;
    }
}
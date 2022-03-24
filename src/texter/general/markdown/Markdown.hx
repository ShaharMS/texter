package texter.general.markdown;
#if (flixel && !openfl_development)
import flixel.FlxSprite;
#elseif openfl
import openfl.display.DisplayObject;
import openfl.text.TextField;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
#end

import texter.general.markdown.MarkdownEffects;
import texter.general.markdown.MarkdownRule;
import texter.general.markdown.MarkdownPatterns;

class Markdown {

	public static var patterns:MarkdownPatterns;
    static var isParagraphStart(get, default):Bool = false;
	static function get_isParagraphStart():Bool return isParagraphStart = !isParagraphStart;

    static var cblockStart(get, default):Bool = false;
    static function get_cblockStart():Bool return cblockStart = !cblockStart;

	static var currentLine:String;
    public static var markdownRules(default, null):Array<MarkdownRule> = [
        { rule: patterns.titleEReg, 	effect: Heading(matcher(patterns.titleEReg, currentLine, 1).length, matcher(patterns.titleEReg, currentLine, 2))}, /* Headings */
		{ rule: patterns.hRuleEReg, 	effect: HorizontalRule(matcher(patterns.hRuleEReg, currentLine, 1).charAt(0), matcher(patterns.hRuleEReg, currentLine, 1))}, /* Horizontal Rule */
		{ rule: patterns.boldEReg,  	effect: Bold(matcher(patterns.boldEReg, currentLine, 1))}, /* Bold */
		{ rule: patterns.italicEReg, 	effect: Italic((matcher(patterns.italicEReg, currentLine, 1)))}, /* Italic */
		{ rule: patterns.mathEReg, 		effect: Math(matcher(patterns.mathEReg, currentLine, 1))}, /* Math */
		{ rule: patterns.parSepEReg,	effect: Paragraph(isParagraphStart)}, /* Paragraph */
		{ rule: patterns.linkEReg, 		effect: Link(matcher(patterns.linkEReg, currentLine, 2), matcher(patterns.linkEReg ,currentLine, 1))}, /* HyperLink */
        { rule: patterns.codeEReg, 		effect: Code(matcher(patterns.codeEReg, currentLine, 1))}, /* Code */
        { rule: patterns.codeblockEReg,	effect: CodeBlock(matcher(patterns.codeblockEReg, currentLine, 2), cblockStart)}, /* Code Block */
		{ rule: patterns.listItemEReg, 	effect: UnorderedListItem(matcher(patterns.listItemEReg, currentLine, 1).length)}, /* List Item (+) */
		{ rule: patterns.imageEReg, 	effect: Image(matcher(patterns.imageEReg, currentLine, 1), matcher(patterns.imageEReg, currentLine, 2), matcher(patterns.imageEReg, currentLine , 1))}, /* Image */
    ];

    public static function generateVisuals(text:TextField, markdownStyle:Dynamic) {
        
    }

    /**
     * Mostly for internal use, but can also be useful for creating your own
     * Markdown styling.
     * 
     * This function takes in a string formatted in Markdown, and each time it encounteres
     * a Markdown "special effect" (headings, charts, points, etc.), it triggers a callback
     * for the style corresponding to the found effect.
     * 
     * @param markdownText Just a plain string with markdown formatting. If you want to make sure 
     * the formatting is correct, just write the markdown text in a `.md` file and do `File.getContent("path/to/file.md")`
     * @param callback This function will get called each time a new effect is detected: 
     * - `startIndex` will contain the point in the string to start applying effects
     * - `endIndex` will contain the point in the string to stop applying effects
     * - `effect` is the actual special effect, defined by `MarkdownEffects`
     */
    public static function interpret(markdownText:String, callback:(startIndex:Int, endIndex:Int, effect:MarkdownEffects) -> Void) {
        final lineTexts = StringTools.replace(markdownText, "\r", "").split("\n"); //gets each line of text, wordwrapped text shouldnt be worried about
        var lengthOffset = 0, index = -1, skipNextLine = false; // add to it each time we finish scanning a line
        for (line in lineTexts) {
            currentLine = line;
			index++;
            for (rule in markdownRules) {
				
            }
        }
    }

	static function matcher(e:EReg, s:String, item:Int):String
	{
		e.match(s);
		return e.matched(item);
	}
}
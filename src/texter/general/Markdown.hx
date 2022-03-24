package texter.general;
#if (flixel && !openfl_development)
import flixel.FlxSprite;
#elseif openfl
import openfl.display.DisplayObject;
import openfl.text.TextField;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
#end
typedef MDRule = {
    rule:EReg,
    effect:MarkdownEffects
}
class Markdown {

	/**
	    When used on a string of text with `lineEReg.match(string)`, 
        it will report everything that gives info about a markdown link:

        - `lineEReg.matched(1)` will give you the text from the link. this text should be displayed
        - `lineEReg.matched(2)` will give you the actual hyperlink. this text should be internal
	**/
	public static var linkEReg:EReg = ~/\[([^\]]+)\]\(([^)]+)\)/g;
	public static var codeEReg:EReg = ~/`(\s?[^\n,]+\s?)`/g;
	public static var codeblockEReg:EReg = ~/```(.{1,})\n(.{1,}\n{1,})```/g;
	public static var imageEReg:EReg = ~/!\[([^\]]+)\]\(([^)]+)\s"([^")]+)"\)/g;

    static var isParagraphStart(get, default):Bool = false;
	static function get_isParagraphStart():Bool return isParagraphStart = !isParagraphStart;

    static var cblockStart(get, default):Bool = false;
    static function get_cblockStart():Bool return cblockStart = !cblockStart;

	static var currentLine:String;
    public static final markdownRules:Array<MDRule> = [
        //headers
        { rule: ~/#{6}\s?([^\n]+)/g, effect: Heading(1)}, /* Heading 1 */
		{ rule: ~/#{5}\s?([^\n]+)/g, effect: Heading(2)}, /* Heading 2 */
		{ rule: ~/#{4}\s?([^\n]+)/g, effect: Heading(3)}, /* Heading 3 */
		{ rule: ~/#{3}\s?([^\n]+)/g, effect: Heading(4)}, /* Heading 4 */
		{ rule: ~/#{2}\s?([^\n]+)/g, effect: Heading(5)}, /* Heading 5 */
		{ rule: ~/#{1}\s?([^\n]+)/g, effect: Heading(6)}, /* Heading 6 */

        //horizontal rules
        { rule: ~/-{1,}|={1,}/g, effect: HORIZONTALRULE},

        //bold & italic
		{ rule: ~/\*\*\s?([^\n]+)\*\*/g, effect: BOLD}, /* Bold */
		{ rule: ~/\*\s?([^\n]+)\*/g, effect: ITALIC}, /* Italic */
		{ rule: ~/__([^_]+)__/g, effect: BOLD}, /* Bold (_) */
		{ rule: ~/_([^_`]+)_/g, effect: ITALIC}, /* Italic (_) */

        //paragraphs
		{ rule: ~/([^\n]+\n?)/g, effect: Paragraph(isParagraphStart)}, /* Paragraph */

        //links
		{ rule: linkEReg, effect: Link(matcher(linkEReg, currentLine, 2), matcher(linkEReg ,currentLine, 1))}, /* HyperLink */

        //code/codeblocks
        { rule: codeEReg, effect: CODE}, /* Code */
        { rule: codeblockEReg, effect: CodeBlock(matcher(codeblockEReg, currentLine, 2), cblockStart)}, /* Code Block */
    
        //List Items
        { rule: ~/([^\n]+)(\+)([^\n]+)/g, effect: UNORDEREDLISTITEM}, /* List Item (+) */
		{ rule: ~/([^\n]+)(\*)([^\n]+)/g, effect: UNORDEREDLISTITEM}, /* List Item (*) */
		{ rule: ~/([^\n]+)(\-)([^\n]+)/g, effect: UNORDEREDLISTITEM}, /* List Item (-) */
    
        //Image
		{ rule: imageEReg, effect: Image(matcher(imageEReg, currentLine, 1), matcher(imageEReg, currentLine, 2), matcher(imageEReg, currentLine , 1))}, /* Image */
    ];
    
    #if (flixel && !openfl_development)
    public static function generateVisuals(text:flixel.text.FlxText, markdownStyle:MarkdownStyle) {
        
    }
    #elseif openfl
    public static function generateVisuals(textField:openfl.text.TextField, markdownStyle:MarkdownStyle) {
        
    }
    #end

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
            for (i in markdownRules) {

            }
        }
    }

	static function matcher(e:EReg, s:String, item:Int):String
	{
		e.match(s);
		return e.matched(item);
	}
}

class MarkdownStyle {
    /**
     * Heading size when you do
     * 
     * `# text`
     */
    public var heading1Size:Int = 90;
	/**
	 * Heading size when you do
	 * 
	 * `## text`
	 */
    public var heading2Size:Int = 70;
	/**
	 * Heading size when you do
	 * 
	 * `### text`
	 */
	public var heading3Size:Int = 50;
	/**
	 * Heading size when you do
	 * 
	 * `#### text`
	 */
	public var heading4Size:Int = 30;
	/**
	 * Heading size when you do
	 * 
	 * `###### text`
	 */
	public var heading5Size:Int = 20;
	/**
	 * Heading size when you do
	 * 
	 * `####### text`
	 */
	public var heading6Size:Int = 15;
    /**
     * The height of the line seperator when you skip a line like this:
     * ```txt
     * line1
     * 
     * line3
     * ```
     * (line2 is skipped)
     */
    public var paragraphSeperatorHeight:Int = 20;

    /**
     * The thickness of this table:
     * 
     * | c1 |  c2|  c3|
     * | -- | -- | -- |
     * |row1|text|text|
     * |row2|text|text|
     * 
     * when you do this:
     * ```txt
     * |col1|col2|col3|
     * | -- | -- | -- |
     * |row1|    |    |
     * |row2|    |    |
     * ```
     */
    public var chartThickness:Int = 1;

    /**
     * The graphic displayed when you do a markdown point:
     *  - <- point
     * 
     * like this:
     * ```md
     *  - this is a point
     * ```
     * defaults to a round circle.
     */
	public var pointGraphic:#if (flixel && !openfl_development) FlxSprite #else DisplayObject #end;
}

enum MarkdownEffects {
    BOLD;
    ITALIC;
    UNDERLINE;
    STRIKETHROUGH;
    BLOCKQUOTE;
    CODE;
    TABBED;
    LINEBREAK;
    HORIZONTALRULE;
    UNORDEREDLISTITEM;
	NESTEDUNORDEREDLISTITEM;
    TABLEHEADING;
	TABLEROW;
    Paragraph(start:Bool);
    TableAlign(left:Bool, right:Bool, center:Bool);
    OrderedListItem(number:Int);
	NestedOrderedListItem(number:Int);
    CodeBlock(language:String, start:Bool);
    Link(link:String, text:String);
    Image(altText:String, imageSource:String, title:String);
    Emoji(type:String);
    Heading(level:Int);
    Highlight(text:String);

}

/*

	public static function interpret(markdownText:String, callback:(startIndex:Int, endIndex:Int, effect:MarkdownEffects) -> Void) {
		final lineTexts = markdownText.split("\n"); //gets each line of text, wordwrapped text shouldnt be worried about
		var lengthOffset = 0, index = -1, skipNextLine = false; // add to it each time we finish scanning a line
		for (line in lineTexts) {
			currentLine = line;
			index++;
			if (index > 0) lengthOffset += lineTexts[index - 1].length;
			if (skipNextLine) {
				skipNextLine = false;
				continue;
			}

			//------
			//TITLES
			//------
			if (line.charAt(0) == "#") { //easy peasy lemon squeezy, there can only be a title here
				var headingLevel = 1;
				while (line.charAt(headingLevel) == "#") headingLevel++;
				if (headingLevel <= 6) { //Bingo! title
					callback(headingLevel + lengthOffset, line.length - 1 + lengthOffset, Heading(headingLevel));
					continue;
				}
			}
			else if (lineTexts[index + 1] != null && lineTexts[index + 1].charAt(0) == "-") { //A title can also form with some text and a hyphen below it
				var broken = false;
				for (i in 0...lineTexts[index + 1].length) {
					if (lineTexts[index + 1].charAt(i) != "-") {broken = true; break;}
				}
				if (!broken) {callback(0  + lengthOffset, line.length - 1  + lengthOffset, Heading(3)); skipNextLine = true;}
			}
			else if (lineTexts[index + 1] != null && lineTexts[index + 1].charAt(0) == "=") { //Or an equals sign
				var broken = false;
				for (i in 0...lineTexts[index + 1].length) {
					if (lineTexts[index + 1].charAt(i) != "=") {broken = true; break;}
				}
				if (!broken) {callback(0 + lengthOffset, line.length - 1 + lengthOffset, Heading(1)); skipNextLine = true;}
			}
			//--------------
			//SIMPLE EFFECTS
			//--------------

		}
	}
*/
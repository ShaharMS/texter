package texter.general;

class MarkDownVisuals {
    
    #if (flixel)
    function generateVisuals(text:flixel.text.FlxText, markdownStyle:MarkdownStyle) {
        
    }
    #elseif (openfl)
    function generateVisuals(text:openfl.text.TextField, markdownStyle:MarkdownStyle) {
        
    }
    #end
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
     * The thickness of this chart:
     * 
     * | c1 |  c2|  c3|
     * | -- | -- | -- |
     * |row1|text|text|
     * |row2|text|text|
     * 
     * when you do this:
     * ```md
     * |col1|col2|col3|
     * | -- | -- | -- |
     * |row1|    |    |
     * |row2|    |    |
     * ```
     */
    public var chartThickness:Int = 1;

    /**
     * The graphic displayed when you do a markdown point:
     *  - point
     * 
     * like this:
     * ```md
     *  - this is a point
     * ```
     * defaults to a round circle.
     */
    public var pointGraphic:#if flixel flixel.FlxSprite #else openfl.display.DisplayObject #end;
}
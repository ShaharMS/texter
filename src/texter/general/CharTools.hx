package texter.general;

/**
 * `CharTools` is a class that gives you tools
 * to work with `Char`s and `String`s.
 */
class CharTools
{
	/**
			 	An `EReg` of all arabic & hebrew letters. It'll check if a `String` 
		contains 1 or more chars from a RTL (right-to-left) language.

		usage:
		```haxe
			CharTools.rtlLetters.match(yourRtlLetterOrString)
		```
	**/
	public static var rtlLetters(default,
		null):EReg = ~/ش|س|ز|ر|ذ|د|خ|ح|ج|ث|ت|ب|ا|ء|ي|و|ه|ن|م|ل|ك|ق|ف|غ|ع|ظ|ط|ض|ص|ى|ئ|ؤ|ة|إ|أ|ٱ|آ|ז|ס|ב|ה|נ|מ|צ|ת|ץ|ש|ד|ג|כ|ע|י|ח|ל|ך|ף|ק|ר|א|ט|ו|ן|ם|פ/gi;

	/**
		An `EReg` of all numbers (0-9).

		usage: 
		```haxe
			CharTools.numericChars.match(yourNumberAsAString)
		```
	**/
	public static var numericChars(default, null):EReg = ~/[0-9]/g;

	/**
		An `Array<String>` of all **common** general text marks.
		
		contains common math & grammer related characters

		usage:
		```haxe
		CharTools.generalMarks.contains(yourTextWithGeneralMarks)
		```
	**/
	public static var generalMarks(default, null):Array<String> = [
		'!', '"', '#', '$', '%', '&', "'", '(', ')', '*', '+', ',', '-', '.', '/', ':', ';', '<', '=', '>', '?', '@', '[', '\\', ']', '^', '_', '`', '{', '|',
		'}', '~', '^'
	];

	/**
	 * The `newline` char used to add an enter to a string of text
	 */
	public static var NEWLINE(default, never):String = "\n";

	/**
	 * The `tab` char used to add a wide space - tab - to a string of text
	 */
	public static var TAB(default, never):String = "\t";

	/**
	 * The `Right to Left Mark` Char.
	 * 
	 * - Code:  `"U+200F"`
	 * - Invisible: `true`
	 * 
	 * when inserted before a letter, it will set the base direction
	 * of that letter to RTL (right-to-left). useful to make words from
	 * RTL languages appear correctly
	 */
	public static var RLM(default, never):String = "‏";

	/**
	 * The `Left to Right Isolate` Char.
	 * 
	 * - Code: `"U+2066"`
	 * - HTML Markup: `dir = ltr`
	 * - Invisible: `true`
	 * 
	 * sets the base text direction to LTR (left-to-right) and
	 * also isolates embedded content from the rest of the text.
	 * 
	 */
	public static var LRI(default, never):String = "⁦";

	/**
	 * The `Right to Left Isolate` Char.
	 * 
	 * - Code: `"U+2067"`
	 * - HTML Markup: `dir = rtl`
	 * - Invisible: `true`
	 * 
	 * sets the base text direction to RTL (right-to-left) and
	 * also isolates embedded content from the rest of the text.
	 */
	public static var RLI(default, never):String = "⁧";

	/**
	 * The `First Strong Isolate` Char.
	 * 
	 * - Code: `"U+2068"`
	 * - HTML Markup: `dir = auto`
	 * - Invisible: `true`
	 * 
	 * sets the base text direction according to the first strongly
	 * typed directional char
	 */
	public static var FSI(default, never):String = "⁨";

	/**
	 * The `Left to Right Embedding` Char.
	 * 
	 * - Code: `"U+202A"`
	 * - HTML Markup: `dir = ltr`
	 * - Invisible: `true`
	 * 
	 * sets base text direction to LTR (left-to-right) but allows 
	 * embedded text to interact & be effcted from surrounding text.
	 */
	public static var LRE(default, never):String = "‪";

	/**
	 * The `Right to Left Embedding` Char.
	 * 
	 * - Code: `"U+202B"`
	 * - HTML Markup: `dir = rtl`
	 * - Invisible: `true`
	 * 
	 * sets base text direction to RTL (right-to-left) but allows 
	 * embedded text to interact & be effcted from surrounding text.
	 */
	public static var RLE(default, never):String = "‫";

	/**
	 * The `Left to Right Override` Char.
	 * 
	 * - Code: `"U+202D"`
	 * - HTML Markup: `<bdo dir = "ltr">`
	 * 
	 * overrides the bidirectional algorithm to display characters in
	 * memory order, progressing from left to right
	 */
	public static var LRO(default, never):String = "‭";

	/**
	 * The `Right to Left Override` Char.
	 * 
	 * - Code: `"U+202E"`
	 * - HTML Markup: `<bdo dir = "rtl">`
	 * - Invisible: `true`
	 * 
	 * overrides the bidirectional algorithm to display characters in
	 * RTL order (progressing from right to left)
	 */
	public static var RLO(default, never):String = "‮";

	/**
	 * The `Pop Directional Fromat` Char.
	 * 
	 * - Code: `"U+202C"`
	 * - HTML Markup: `</bdo>`, `end tag`
	 * - Invisible: `true`
	 * 
	 * Used to end the directional formatting for `RLE`, `LRE`, `RLO`
	 * and `LRO`
	 */
	public static var PDF(default, never):String = "‬";

	/**
	 * The `Pop Directional Isolate` Char.
	 * 
	 * - Code: `"U+2069"`
	 * - HTML Markup: `end tag`
	 * - Invisible: `true`
	 * 
	 * Used to end the directional formatting for `RLI`
	 * and `LRI`
	 */
	public static var PDI(default, never):String = "⁩";

	/**
	 * Converts any string to an array of letters in `String` format.
	 * @param string the string to process
	 * @return An array of letters & symbols
	 */
	public static function toCharArray(string:String):Array<String>
	{
		return [for (i in 0...string.length) string.charAt(i)];
	}

	public static function fromCharArray(charArray:Array<String>):String
	{
		return charArray.join("");
	}
}

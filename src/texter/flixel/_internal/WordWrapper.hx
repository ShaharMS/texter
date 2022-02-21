package texter.flixel._internal;

using texter.flixel._internal.WordWrapper;

typedef WordWithIndex = {
    public var word:String;
    public var int1:Int;
    public var int2:Int;
};

@:access(texter.flixel.FlxInputTextRTL)
@:access(texter.flixel._internal.FlxInputText)
@:access(openfl.text.TextField)
class WordWrapper {
    
    public static var splitOnChars:Array<String> = [" ", "-", "\t", "\n", "\r"];

    /**
     * Takes in a `FlxInputTextRTL` instance, gets its text and tries to wrap it **correctly**.
     * this algorithm just flips the lins of text to get the correct lineup. the unmodified text should
     * be stored inside `textInputRtl.internalString`
     * @param textInput an instance of FlxInputTextRTL
     */
    public static function wrapRTL(textField:#if flixel FlxInputText #elseif openfl TextField #else Any #end):String {

		var modifiedText:String = "";
		for (i in 0...textField.textField.numLines) {
			var line = textField.textField.getLineText(i);
            if (line == null) continue;
			modifiedText = modifiedText.insertSubstring(line, 0);

        }
        textField.text = modifiedText;
        textField.text = textField.text;
		return modifiedText;
        
    }

    public static function indexOfAny(string:String, splitOnStrings:Array<String>, ?startIndex:Int = 0):Int {
		for (i in startIndex...string.length)
		{
			if (splitOnChars.indexOf(string.charAt(i)) > -1)
			{
				return i;
			}
		}
		return -1;
    }

    public static inline function containsWhiteSpace(string:String):Bool {
		return if (StringTools.trim(string).length != string.length) false else true;
    }

	public static function insertSubstring(Original:String, Insert:String, Index:Int):String
	{
		if (Index != Original.length)
		{
			Original = Original.substring(0, Index) + (Insert) + (Original.substring(Index));
		}
		else
		{
			Original = Original + (Insert);
		}
		return Original;
	}
}
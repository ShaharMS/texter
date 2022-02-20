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
     * Takes in a `FlxInputTextRTL` instance, gets its text and tries to wrap it.
     * @param textInput an instance of FlxInputTextRTL
     * @return the same text, but with the `"\n"` (newline) char where a line needs to be broken
     */
    public static function wrapRTL(textInput:#if flixel FlxInputText #elseif openfl TextField #else Any #end):String {
        //trying to split the string into words
        var pureTextCopy = textInput.text;
		var wordArray:Array<WordWithIndex> = [], lastCheck = 0;
        for (i in 0...textInput.text.length) {
			if (textInput.text.charAt(i) == " " || i == textInput.text.length - 1) {
                var word = textInput.text.substring(lastCheck, i + 1);
                wordArray.push({word: word ,int1: lastCheck, int2: i + 1});
                lastCheck = i + 1;
            }
        }
        //wordArray is now consisting of: [WORD + SPACE, WORD + SPACE,...]
		var modifiedText:String = textInput.text, lastLineCheckedHeight:Null<Float> = 0.0, linesLengths:Array<Int> = [], lastLine:String = "";
		var lineSeperator = "ㅤ";
        for (i in 0...textInput.text.length) {
            if (textInput.getCharBoundaries(i).y == lastLineCheckedHeight || textInput.text.charAt(i) == " ") continue;
            modifiedText = modifiedText.substring(0, i) + lineSeperator + modifiedText.substring(i, textInput.text.length - 1);
        }
		return modifiedText;
        
    }

    public static function warpByWords(text:String, length:Int):String {
        return "";
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
}
package texter.flixel._internal;

import openfl.utils.ByteArray;
import lime.app.Future;
using texter.flixel._internal.WordWrapper;

typedef DualInt = {
    public var int1:Int;
    public var int2:Int;
};

function formatDualInt(dual:DualInt):String {
    return '${dual.int1}, ${dual.int2}';
}

class WordWrapper {
    
    public static var splitOnChars:Array<String> = [" ", "-", "\t", "\n"];

    /**
     * Takes in a `FlxInputTextRTL` instance, gets its text and tries to wrap it.
     * @param textInput an instance of FlxInputTextRTL
     * @return the same text, but with the `"\n"` (newline) char where a line needs to be broken
     */
    public static function wrapRTL(textInput:#if flixel FlxInputText #elseif openfl TextField #else Any #end):String {
        //trying to split the string into words
		var wordArray:Array<String> = [];
        var indexArray:Array<DualInt> = [];
        var lastCheck = 0;
        for (i in 0...textInput.text.length) {
			if (textInput.text.charAt(i) == " " || i == textInput.text.length - 1) {
                var word = textInput.text.substring(lastCheck, i + 1);
                indexArray.push({int1: lastCheck, int2: i + 1});
                wordArray.push(word);
                lastCheck = i + 1;
            }
        }
        //wordArray is now consisting of: WORD + SPACE, WORD + SPACE
		var textWithNewLines:String = "";
        var checkingChar = textInput.text.length - 1;
        while (checkingChar >= 0) {
            for (i in indexArray[checkingChar].int1...indexArray[checkingChar].int2) {
                @:privateAccess {
                    if (textInput.getCharBoundaries(i).x < (textInput.x + 2)) {
                        for (escapeChar in indexArray[checkingChar].int1...textInput.text.length) {
                        }
                    }
                }
            }
        }

		return textWithNewLines;         
        
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
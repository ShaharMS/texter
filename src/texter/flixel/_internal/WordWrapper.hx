package texter.flixel._internal;

using texter.flixel._internal.WordWrapper;
typedef DualInt = {
    public var int1:Int;
    public var int2:Int;
};

function formatDualInt(dual:DualInt):String {
    return '${dual.int1}, ${dual.int2}';
}

class WordWrapper {
    
    public static var splitOnChars:Array<String> = [" ", "-", "\t"];

    public static function wrapVisual(textInput:FlxInputText):String {
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
       
        var bounderySum:Float = 0;
        var currentWord:Float = 0;
        for (i in 0...wordArray.length) {
            for (char in indexArray[i].int1...indexArray[i].int2 + 1) {
				currentWord += @:privateAccess textInput.getCharBoundaries(char).width;
            }
			bounderySum += currentWord;
            trace('length of word "${wordArray[i]}" is: ${currentWord}');
			if (bounderySum > textInput.width) {
                textWithNewLines += "\n";
                bounderySum = currentWord;
            }
			textWithNewLines += wordArray[i];
            currentWord = 0;
        }
        trace(textWithNewLines);
		return textWithNewLines;         
        
        

        return "";
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
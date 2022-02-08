package texter.flixel._internal;

using texter.flixel._internal.WordWrapper;
typedef DualInt = {
    public var int1:Int;
    public var int2:Int;
};
class WordWrapper {
    
    public static var splitOnChars:Array<String> = [" ", "-", "\t"];

    public static function wrapVisual(textInput:FlxInputText):String {
        //trying to split the string into words
		var wordArray:Array<String> = [];
        var indexArray:Array<DualInt> = [];
        var lastCheck = 0;
        for (i in 0...textInput.text.length) {
			if (textInput.text.charAt(i) == " ") {
                var word = textInput.text.substring(lastCheck, i + 1);
                indexArray.push({int1: lastCheck, int2: i + 1});
                wordArray.push(word);
                lastCheck = i + 1;
            }
        }
        //wordArray is now consisting of: WORD + SPACE, WORD + SPACE
        
        @:privateAccess {
            for (index in indexArray) {
                var bounderySum:Float = 0;
                for (char in index.int1...index.int2 + 1) {
                    bounderySum += textInput.getCharBoundaries(char).width;
                }
            }
        }

        return "";
    }

    public static function warpByWords(text:String, length:Int):String {
        var words:Array<String> = explodeString(text, splitOnChars);
        trace(words);
        var currentLineLength = 0;
        var stringBuffer = new StringBuf();
        for (word in words) {
            if (currentLineLength + word.length > length) {

                if (currentLineLength > 0) {
					stringBuffer.add("\n");
					currentLineLength = 0;
                }    
                
				while (word.length > length)
				{
					stringBuffer.add(word.substring(0, length - 1) + "-");
					word = word.substring(length - 1);
					stringBuffer.add("\n");
				}

				word = StringTools.ltrim(word);
            }
            stringBuffer.add(word);
            currentLineLength += word.length;  
        }

        return stringBuffer.toString();
    }

    public static function explodeString(text:String, splitOnChars:Array<String>):Array<String> {
        var parts = new Array<String>();
        var startIndex = 0;
        while (true) {
            trace("iteration");
            var index = text.indexOfAny(splitOnChars, startIndex);
            if (index == -1) {
                parts.push(text.substring(startIndex));
                break;
            }

            var word = text.substring(startIndex, index - startIndex);
            var nextChar = text.substring(index, text.length).charAt(0);

            if (nextChar.containsWhiteSpace()) {
				parts.push(word);
				parts.push(nextChar);
            } else {
				parts.push(word + nextChar);
            }

			startIndex += index + 1;
        }
		return parts;
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
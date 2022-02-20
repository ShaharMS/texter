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
    public static function wrapRTL(textInput:#if flixel FlxInputText #elseif openfl TextField #else Any #end):String {

		var modifiedText:String = textInput.text, lastLineCheckedHeight:Null<Float> = 2.0, lineSeperators:Array<Int> = [], i = textInput.text.length - 1;
        while (i >= 0) {
			if (i == textInput.text.length - 1) {
				lastLineCheckedHeight = textInput.getCharBoundaries(i).y;
                i--;
                continue;
            }
            if (textInput.getCharBoundaries(i).y  == lastLineCheckedHeight || textInput.text.charAt(i) == " ") {
                i--;
				continue;
            }
            lineSeperators.push(i);
            lastLineCheckedHeight = textInput.getCharBoundaries(i).y;
            i--;
        }
        if (lineSeperators.length == 0) return modifiedText;
        var lastSep = 0, textCorrection:Array<String> = [];
        for (sep in lineSeperators) {
            textCorrection.push(modifiedText.substring(lastSep, sep + 1));
            lastSep = sep + 1;
        }
        textCorrection.reverse();
        modifiedText = textCorrection.join(" ");
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
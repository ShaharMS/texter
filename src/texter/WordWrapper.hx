package texter;

import haxe.PosInfos;
import lime.utils.Log;
import openfl.geom.Rectangle;
import flixel.util.typeLimit.OneOfThree;
import flixel.text.FlxText;
import texter.flixel.FlxInputTextRTL;
import openfl.text.TextField;
import haxe.extern.EitherType;
using texter.WordWrapper;

/**
 * This class supplies wordWrapping utilities in various ways.
 * 
 * it also includes some general purpose methods.
 */
class WordWrapper {
    
    /**
     * Wordwraps a **single** line of text. calculates only one line for perfrmence reasons.
     * @param text the line of text, you can get it with `textField.getLineText(textField.getLineOndexOfChar(caretIndex))`
     * @param lineWidth the width of the line for calculating where to put the `"\n"`
     * @param getCharBoundaries a function to calculate the boundaries of the characters
     * @param mode whether to wrap that line RTL or LTR.
     * @return the wrapped line of text
     */
    public static function wordWrap(text:String, lineWidth:Float, getCharBoundaries:Int -> Rectangle, mode:String):String {

        var letters = StringTools.replace(text, CharTools.RLO, "").toCharArray();
        if (letters.contains("\n")) return text;
		var wordsWidth = 0.0;
        if (mode.toLowerCase() == "rtl" ) {
            var i = text.length - 1;
            while (i >= 0) {
                wordsWidth += getCharBoundaries(i).width;
				trace(letters.fromCharArray());
                if (wordsWidth >= lineWidth) {
                    letters.insert(i + 2, "\n");
					var cutText = letters.fromCharArray().split("\n"), par1, par2;
                    //the short part is the wordwrapped part:
                    if (cutText[0].length > cutText[1].length) {
						par1 = cutText[0];
                        par2 = cutText[1];
                        return par1 + "\n" + par2;
                    } else {
						par2 = cutText[0];
						par1 = cutText[1];
						return par1 + "\n" + par2;
                    }
                }
                i--;
            }
        } else {
            for (i in 0...text.length) {
				wordsWidth += getCharBoundaries(i).width;
				if (wordsWidth >= lineWidth)
				{
					letters.insert(i, "\n");
					return letters.fromCharArray();
				}
            }
        }
        return text;
    }

    /**
     * Converts any string to an array of letters in `String` format.
     * @param string the string to process
     * @return An array of letters & symbols
     */
    public static function toCharArray(string:String):Array<String> {
        return [for (i in 0...string.length) string.charAt(i)];
    }

    public static function fromCharArray(charArray:Array<String>):String {
        return charArray.join("");
    }

	function indexOfAny(s:String, characters:Array<String>)
	{
		for (i in 0...s.length)
		{
			if (characters.indexOf(s.charAt(i)) > -1)
			{
				return i;
			}
		}
		return -1;
	}
}
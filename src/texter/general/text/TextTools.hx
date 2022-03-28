package texter.general.text;

/**
 * `TextTools` is a class containing static methods for manipulating text.
 * 
 * you can use it by doing
 * 
 *      using texter.general.text.TextTools;
 * 
 * and enjoy not having to write more text manipulation functions!
 */
class TextTools {
	public static function replaceLast(string:String, replace:String, by:String):String
	{
		var place = string.lastIndexOf(replace);
		var result = string.substring(0, place) + by + string.substring(place + replace.length);
		return result;
	}

	public static function replacefirst(string:String, replace:String, by:String):String
	{
		var place = string.indexOf(replace);
		var result = string.substring(0, place) + by + string.substring(place + replace.length);
		return result;
	}
}
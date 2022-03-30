package texter.general.text;

import haxe.extern.EitherType;
import haxe.ds.Either;

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

	public static function filter(text:String, filter:Dynamic):String {
		if (filter is EReg) {
			var pattern:EReg = cast filter;
			text = pattern.replace(text, "");
			return text;
		}
		var patternType:String = cast filter;
		if (replacefirst(text, "/", "") != patternType) { //someone decided to be quirky and pass an EReg as a string
			return filter(text, new EReg(patternType, "g"));
		}
		switch patternType.toLowerCase() {
			case "alpha":
				return filter(text, new EReg("[^a-zA-Z]", "g"));
			case "alphanumeric": //alphanumeric is the same as alpha, but with numbers
				return filter(text, new EReg("[^a-zA-Z0-9]", "g"));
			case "numeric": //numeric is the same as alpha, but with numbers
				return filter(text, new EReg("[^0-9]", "g")); 
		}
		return text;
		
	}
}

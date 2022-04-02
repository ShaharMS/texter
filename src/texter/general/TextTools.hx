package texter.general;

/**
 * `TextTools` is a class containing static methods for manipulating text.
 * 
 * you can use it by doing
 * 
 *      using texter.general.TextTools;
 * 
 * and enjoy not having to write more text manipulation functions!
 */
class TextTools {

	/**
	 * replaces the last occurrence of `replace` in `string` with `by`
	 * @param string the string to replace in
	 * @param replace the string to replace
	 * @param by the replacement string
	 * @return the string with the last occurrence of `replace` replaced by `by`
	 */
	public static function replaceLast(string:String, replace:String, by:String):String
	{
		var place = string.lastIndexOf(replace);
		var result = string.substring(0, place) + by + string.substring(place + replace.length);
		return result;
	}

	/**
	 * replaces the first occurrence of `replace` in `string` with `by`
	 * @param string the string to replace in
	 * @param replace the string to replace
	 * @param by the replacement string
	 * @return the string with the first occurrence of `replace` replaced by `by`
	 */
	public static function replacefirst(string:String, replace:String, by:String):String
	{
		var place = string.indexOf(replace);
		var result = string.substring(0, place) + by + string.substring(place + replace.length);
		return result;
	}

	/**
	 * filters a string according to the contents of `filter`:
	 * 
	 * - if `filter` is a string, it can be use as one of 2 things
	 * 	- if the string contains a regex filter it will re-call the function with the string passed as an EReg
	 * 	- if the string does not contain the filter it can be one of 3 3 things:
	 * 		- if the string is empty, nothing will be filtered
	 * 		- if the string is "alpha", it will filter out all non-alphabetic characters
	 * 		- if the string is "numeric", it will filter out all non-numeric characters
	 * 		- if the string is "alphanumeric", it will filter out all non-alphanumeric characters
	 * 
	 * - if `filter` is an EReg, it will be used to filter the string
	 * @param text the text to filter
	 * @param filter the actual filter; can be a string or an EReg
	 * @return the filtered string
	 */
	public static function filter(text:String, filter:Dynamic):String {
		if (filter is EReg) {
			var pattern:EReg = cast filter;
			text = pattern.replace(text, "");
			return text;
		}
		var patternType:String = cast filter;
		if (replacefirst(text, "/", "") != patternType) { //someone decided to be quirky and pass an EReg as a string
			var regexDetector:EReg = ~/^~?\/(.*)\/(.*)$/s;
			regexDetector.match(patternType);
			return filter(text, new EReg(regexDetector.matched(1), regexDetector.matched(2)));
		}
		switch patternType.toLowerCase() {
			case "alpha":
				return filter(text, new EReg("[^a-zA-Z]", "g"));
			case "alphanumeric":
				return filter(text, new EReg("[^a-zA-Z0-9]", "g"));
			case "numeric":
				return filter(text, new EReg("[^0-9]", "g")); 
		}
		return text;
		
	}

	/**
	 * Multiplies `string` by `times`.
	 * 
	 * When multiplied by a number equal/less than 0, it returns an empty string.
	 * 
	 * example:
	 * ```haxe
	 * var foo = "foo";
	 * var bar = TextTools.multiply(foo, 3);
	 * trace(bar); // foofoofoo
	 * bar = TextTools.multiply(foo, 0);
	 * trace(bar); // ""
	 * ```
	 * 
	 * @param string 
	 * @param by 
	 * @return String
	 */
	public static function multiply(string:String, times:Int):String {
		var stringcopy = string;
		if (times <= 0) return "";
		while (times-- > 0) {
			string += stringcopy;
		}
		return string;
	}

	/**
	 * Finds all instances of a `part` in `string` and returns them as an array of start indexes.
	 * 
	 * If `string` doesn't contain `part`, an empty array is returned.
	 * @param string the string to search in
	 * @return an array of start indexes
	 */
	public static function findAll(string:String, part:String):Array<Int> {
		var result:Array<Int> = [];
		var index = string.indexOf(part);
		while (index != -1) {
			result.push(index);
			string = replacefirst(string, part, "");
			index = string.indexOf(part);
		}
		return result;
		
	}
}

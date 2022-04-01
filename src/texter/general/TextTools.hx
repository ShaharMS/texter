package texter.general;

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
			case "alphanumeric":
				return filter(text, new EReg("[^a-zA-Z0-9]", "g"));
			case "numeric":
				return filter(text, new EReg("[^0-9]", "g")); 
		}
		return text;
		
	}

	public static function multiply(string:String, by:Int):String {
		var stringcopy = string;
		while (by-- > 0) {
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
		if (index == -1) return result;
		result.push(index);
		string = replacefirst(string, part, "");
		return [];
	}
}

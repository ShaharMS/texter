package;

/**
 * `TextTools` is a class containing static methods for manipulating text.
 * 
 * you can use it by doing
 * 
 *      using TextTools;
 * 
 * and enjoy not having to write more text manipulation functions ever again :D
 */
class TextTools
{
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
	 * splits `string` on the first occurrence of `delimiter` and returns the array of the two parts
	 * @param string the string to split
	 * @param delimiter the string to split on
	 * @return the array of the two parts
	 */
	public static function splitOnFirst(string:String, delimiter:String):Array<String>
	{
		var place = string.indexOf(delimiter);
		var result = new Array<String>();
		result.push(string.substring(0, place));
		result.push(string.substring(place + delimiter.length));
		return result;
	}

	/**
	 * splits `string` on the last occurrence of `delimiter` and returns the array of the two parts
	 * @param string the string to split
	 * @param delimiter the string to split on
	 * @return the array of the two parts
	 */
	 public static function splitOnLast(string:String, delimiter:String):Array<String>
		{
			var place = string.lastIndexOf(delimiter);
			var result = new Array<String>();
			result.push(string.substring(0, place));
			result.push(string.substring(place + delimiter.length));
			return result;
		}

	/**
	 * Splits a text into paragraphs, determined by HTML/Markdown markup (double newline or <p></p>)
	 * @param text the text to split
	 * @return an array containing the paragraphs
	 */
	public static inline function splitOnParagraph(text:String):Array<String>
	{
		return ~/<p>|<\/p>|\n\n|\r\n\r\n/g.split(text);
	}

	/**
	 * filters a string according to the contents of `filter`:
	 * 
	 * - if `filter` is a string, it can be use as one of 2 things
	 * 
	 * 	 - if the string contains a regex filter it will re-call the function with the string passed as an EReg
	 * 	 - if the string does not contain the filter it can be one of 3 3 things:
	 * 
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
	public static function filter(text:String, filter:Dynamic):String
	{
		if (filter is EReg)
		{
			var pattern:EReg = cast filter;
			text = pattern.replace(text, "");
			return text;
		}
		var patternType:String = cast filter;
		if (replacefirst(text, "/", "") != patternType)
		{ // someone decided to be quirky and pass an EReg as a string
			var regexDetector:EReg = ~/^~?\/(.*)\/(.*)$/s;
			regexDetector.match(patternType);
			return filter(text, new EReg(regexDetector.matched(1), regexDetector.matched(2)));
		}
		switch patternType.toLowerCase()
		{
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
	 * Returns an array containing the start & end indexes of all occurences of `sub`.
	 * the reported indxes are from `startIndex`, up to but not including `endIndex`.
	 * @param string The string containing the `sub`
	 * @param sub The `sub` itself
	 * @return An Array f all indexes
	 */
	public static function indexesOf(string:String, sub:String):Array<{startIndex:Int, endIndex:Int}>
	{
		var indexArray:Array<{startIndex:Int, endIndex:Int}> = [];
		var removedLength = 0, index = string.indexOf(sub);
		while (index != -1)
		{
			indexArray.push({startIndex: index + removedLength, endIndex: index + sub.length + removedLength - 1});
			removedLength += sub.length;
			string = string.substring(0, index) + string.substring(index + sub.length, string.length);
			index = string.indexOf(sub);
		}
		return indexArray;
	}

	/**
	 * repoort all occurences of the elements inside `sub` in `string`
	 * @param string the string to search in
	 * @param subs an array of substrings to search for
	 * @return an array of all positions of the substrings, from startIndex, up to but not including endIndex
	 */
	public static function indexesFromArray(string:String, subs:Array<String>):Array<{startIndex:Int, endIndex:Int}>
	{
		var indexArray:Array<{startIndex:Int, endIndex:Int}> = [],
			orgString = string;
		for (sub in subs)
		{
			var removedLength = 0, index = string.indexOf(sub);
			while (index != -1)
			{
				indexArray.push({startIndex: index + removedLength, endIndex: index + sub.length + removedLength});
				removedLength += sub.length;
				string = string.substring(0, index) + string.substring(index + sub.length, string.length);
				index = string.indexOf(sub);
			}
			string = orgString;
		}
		return indexArray;
	}

	/**
	 * reports all occurences of the findings of `ereg` in `string`.
	 * NOTICE: avoid using eregs with the global flag, as they will only report the first substring found.
	 * @param string the string to search in
	 * @param ereg the EReg to use as the searching engine
	 * @return an array of all positions of the substrings, from startIndex, up to but not including endIndex
	 */
	public static function indexesFromEReg(string:String, ereg:EReg):Array<{startIndex:Int, endIndex:Int}>
	{
		var indexArray:Array<{startIndex:Int, endIndex:Int}> = [];
		while (ereg.match(string))
		{
			var info = ereg.matchedPos();
			string = ereg.replace(string, multiply("⨔", info.len));
			indexArray.push({startIndex: info.pos, endIndex: info.pos + info.len});
		}

		return indexArray;
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
	 * bar = foo.multiply(0);
	 * trace(bar); // ""
	 * ```
	 * 
	 * @param string the string to multiply
	 * @param by the number of times to multiply
	 * @return the multiplied string
	 */
	public static function multiply(string:String, times:Int):String
	{
		var stringcopy = string;
		if (times <= 0)
			return "";
		while (--times > 0)
		{
			string += stringcopy;
		}
		return string;
	}

	/**
	 * Subtracts a part of a string from another string.  
	 * Itll try to find the last occurence of `by` in `string`, and remove it.
	 * 
	 * @param string the string to subtract from
	 * @param by the string to subtract
	 */
	public static inline function subtract(string:String, by:String)
	{
		return replaceLast(string, by, "");
	}

	/**
	 * Creates a lorem ipsum text the following modifiers.
	 * 
	 * @param paragraphs the amount of paragraphs to generate
	 * @param length **Optional** - the total length of the text.
	 */
	public static inline function loremIpsum(?paragraphs:Int = 1, ?length:Int)
	{
		var loremArray = splitOnParagraph(StringTools.replace(loremIpsumText, "\t", ""));
		var loremText = loremArray.join("\n\n");
		if (paragraphs > loremArray.length)
		{
			var multiplier = Math.ceil(paragraphs / loremArray.length);
			loremText = multiply(loremIpsumText, multiplier);
			loremArray = splitOnParagraph(loremText);
		}
		while (loremArray.length > paragraphs)
			loremArray.pop();
		return loremArray.join("\n\n");
	}

	/**
	 * Sorts an array of strings by the string's length, whith the shortest strings first.
	 * @param array an array of strings to be sorted
	 * @return the sorted array
	 */
	public static function sortByLength(array:Array<String>):Array<String>
	{
		array.sort(function(a:String, b:String):Int
		{
			return a.length - b.length;
		});
		return array;
	}

	/**
	 * Sorts an array of floats by the float's value, whith the lowest values first.
	 * @param array an array of floats to be sorted
	 * @return the sorted array
	 */
	@:deprecated public static function sortByValue(array:Array<Float>):Array<Float>
	{
		array.sort(function(a:Float, b:Float):Int
		{
			return Std.int(a - b);
		});
		return array;
	}

	/**
	 * 
	 * Sorts an array of ints by the float's value, whith the lowest values first.
	 * @param array an array of ints to be sorted
	 * @return the sorted array
	 */
	@:deprecated public static function sortByIntValue(array:Array<Int>):Array<Int>
	{
		array.sort(function(a:Int, b:Int):Int
		{
			return a - b;
		});
		return array;
	}

	/**
	 * Gets the 0-based line index of the char in position `index`
	 * @param string the string to search in
	 * @param index The character's position within the string
	 * @return The 0-based line index of the char in position `index`
	 */
	public static function getLineIndexOfChar(string:String, index:Int):Int
	{
		var lines = string.split("\n");
		var lineIndex = 0;
		for (i in 0...lines.length)
		{
			if (index < lines[i].length)
			{
				lineIndex = i;
				break;
			}
			index -= lines[i].length;
		}
		return lineIndex;
	}

    /**
     * Searches for occurrences of `sub` in `string`, and returns the number of occurrences.
     * @param string the string to search in
     * @param sub the substring to search for
     * @return The amount of times `sub` was found in `string`
     */
	public static function countOccurrencesOf(string:String, sub:String):Int
    {
        var count = 0;
        while (contains(string, sub))
        {
            count++;
            string = replacefirst(string, sub, "");
        }
        return count;
    }

    public static function contains(string:String, contains:String):Bool
    {
        return string.indexOf(contains) != -1;
    }

	public static function remove(string:String, remove:String):String
	{
		return StringTools.replace(string, remove, "");
	}

	public static function replace(string:String, replace:String, with:String):String
	{
		return StringTools.replace(string, replace, with);
	}

	public static function reverse(string:String) {
		var arr = string.split("");
		arr.reverse();
		return arr.join("");
	}

	public static var loremIpsumText(default, never):String = "
		Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque finibus condimentum magna, eget porttitor libero aliquam non. Praesent commodo, augue nec hendrerit tincidunt, urna felis lobortis mi, non cursus libero tellus quis tellus. Vivamus ornare convallis tristique. Integer nec ornare libero. Phasellus feugiat facilisis faucibus. Vivamus porta id neque id placerat. Proin convallis vel felis et pharetra. Quisque magna justo, ullamcorper quis scelerisque eu, tincidunt vitae lectus. Nunc sed turpis justo. Aliquam porttitor, purus sit amet faucibus bibendum, ligula elit molestie purus, eu volutpat turpis sapien ac tellus. Fusce mauris arcu, volutpat ut aliquam ut, ultrices id ante. Morbi quis consectetur turpis. Integer semper lacinia urna id laoreet.

		Ut mollis eget eros eu tempor. Phasellus nulla velit, sollicitudin eget massa a, tristique rutrum turpis. Vestibulum in dolor at elit pellentesque finibus. Nulla pharetra felis a varius molestie. Nam magna lectus, eleifend ac sagittis id, ornare id nibh. Praesent congue est non iaculis consectetur. Nullam dictum augue sit amet dignissim fringilla. Aenean semper justo velit. Sed nec lectus facilisis, sodales diam eget, imperdiet nunc. Quisque elementum nulla non orci interdum pharetra id quis arcu. Phasellus eu nunc lectus. Nam tellus tortor, pellentesque eget faucibus eu, laoreet quis odio. Pellentesque posuere in enim a blandit.

		Duis dignissim neque et ex iaculis, ac consequat diam gravida. In mi ex, blandit eget velit non, euismod feugiat arcu. Nulla nec fermentum neque, eget elementum mauris. Vivamus urna ligula, faucibus at facilisis sed, commodo sit amet urna. Sed porttitor feugiat purus ac tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aliquam sollicitudin lacinia turpis quis placerat. Donec eget velit nibh. Duis vehicula orci lectus, eget rutrum arcu tincidunt et. Vestibulum ut pharetra lectus. Quisque lacinia nunc rhoncus neque venenatis consequat. Nulla rutrum ultricies sapien, sed semper lectus accumsan nec. Phasellus commodo faucibus lacinia. Donec auctor condimentum ligula. Sed quis viverra mauris.

		Quisque maximus justo dui, eget pretium lorem accumsan ac. Praesent eleifend faucibus orci et varius. Ut et molestie turpis, eu porta neque. Quisque vehicula, libero in tincidunt facilisis, purus eros pulvinar leo, sit amet eleifend justo ligula tempor lectus. Donec ac tortor sed ipsum tincidunt pulvinar id nec eros. In luctus purus cursus est dictum, ac sollicitudin turpis maximus. Maecenas a nisl velit. Nulla gravida lectus vel ultricies gravida. Proin vel bibendum magna. Donec aliquam ultricies quam, quis tempor nunc pharetra ut.

		Pellentesque sit amet dui est. Aliquam erat volutpat. Integer vitae ullamcorper est, ut eleifend augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque congue velit felis, vitae elementum nulla faucibus id. Donec lectus nibh, commodo eget nunc id, feugiat sagittis massa. In hac habitasse platea dictumst. Pellentesque volutpat molestie ultrices.
	";
}

enum TextDirection
{
	RTL;
	LTR;
	UNDETERMINED;
}
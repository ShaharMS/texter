package texter.general.markdown;

using StringTools;
using texter.general.TextTools;

class MarkdownPatterns
{	
	public static var hRuledTitleEReg(default, null):EReg = ~/([^\n]+)\n^(-{3,}|\+{3,}|_{3,}|\*{3,}|={3,})$/m;
	public static var linkEReg(default, null):EReg = ~/\[([^\]]+)\]\(([^)]+)\)/m;
	public static var codeEReg(default, null):EReg = ~/`([^`\n]+)`/;
	public static var codeblockEReg(default, null):EReg = ~/```([^\n]*)\n*([^`]+)```/m;
	public static var imageEReg(default, null):EReg = ~/!\[([^\]]+)\]\(([^)]+)\s"([^")]+)"\)/m;
	public static var listItemEReg(default, null):EReg = ~/^( *)([0-9]+\.|[+\-*]) ([^\n]*)/m;
	public static var unorderedListItemEReg(default, null):EReg = ~/^( *)([+\-*]) ([^\n]*)/m;
	public static var titleEReg(default, null):EReg = ~/^(#{1,6}) ([^\n]+)/m;
	public static var hRuleEReg(default, null):EReg = ~/^(-{3,}|\+{3,}|_{3,}|\*{3,}|={3,})$/m;
	public static var astBoldEReg(default, null):EReg = ~/\*\*([^\n]+)\*\*/m;
	public static var boldEReg(default, null):EReg = ~/__([^_\n]+)__/m;
	public static var strikeThroughEReg(default, null):EReg = ~/~~([^\n]+)~~/m;
	public static var italicEReg(default, null):EReg = ~/_([^\n]+)_/m;
	public static var astItalicEReg(default, null):EReg = ~/\*([^\n]+)\*/m;
	public static var mathEReg(default, null):EReg = ~/\$([^\$]+)\$/m;
	public static var parSepEReg(default, null):EReg = ~/\n\n/gm;
	public static var emojiEReg(default, null):EReg = ~/:([^:]+):/m;

	/**
	 * Because tables are slow to parse with regex, this function is used to parse & style tables.
	 * @param markdownText the text containing a table
	 */
	public static function parseTable(markdownText:String):String
	{
		// first - filter any line that doesnt start with a |
		var lines = markdownText.split("\n");
		for (line in lines)
			if (line.charAt(0) != "|")
				lines.remove(line);
		var textArray:Array<String> = [];
		// second - split the lines into cells
		for (i in 0...lines.length)
		{
			textArray.push(lines[i]);
			var indexes = lines[i].indexesOf("|");
		}

		return markdownText;
	}
}

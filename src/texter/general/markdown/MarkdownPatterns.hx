package texter.general.markdown;

using StringTools;
using texter.general.TextTools;

class MarkdownPatterns
{
	public static var patterns(default, null):MarkdownPatterns = new MarkdownPatterns();
	
	public var hRuledTitleEReg(default, null):EReg = ~/([^\n]+)\n^(-{3,}|\+{3,}|_{3,}|\*{3,}|={3,})$/m;
	public var linkEReg(default, null):EReg = ~/\[([^\]]+)\]\(([^)]+)\)/m;
	public var codeEReg(default, null):EReg = ~/`([^`\n]+)`/;
	public var codeblockEReg(default, null):EReg = ~/```([^\n]*)\n*([^`]+)```/m;
	public var imageEReg(default, null):EReg = ~/!\[([^\]]+)\]\(([^)]+)\s"([^")]+)"\)/m;
	public var listItemEReg(default, null):EReg = ~/^( *)([0-9]+\.|[+\-*]) ([^\n]*)/m;
	public var unorderedListItemEReg(default, null):EReg = ~/^( *)([+\-*]) ([^\n]*)/m;
	public var titleEReg(default, null):EReg = ~/^(#{1,6}) ([^\n]+)/m;
	public var hRuleEReg(default, null):EReg = ~/^(-{3,}|\+{3,}|_{3,}|\*{3,}|={3,})$/m;
	public var astBoldEReg(default, null):EReg = ~/\*\*([^\n]+)\*\*/m;
	public var boldEReg(default, null):EReg = ~/__([^_\n]+)__/m;
	public var strikeThroughEReg(default, null):EReg = ~/~~([^\n]+)~~/m;
	public var italicEReg(default, null):EReg = ~/_([^\n]+)_/m;
	public var astItalicEReg(default, null):EReg = ~/\*([^\n]+)\*/m;
	public var mathEReg(default, null):EReg = ~/\$([^\$]+)\$/m;
	public var parSepEReg(default, null):EReg = ~/\n\n/gm;
	public var emojiEReg(default, null):EReg = ~/:([^:]+):/m;

	private function new() {}

	/**
	 * Because tables are slow to parse with regex, this function is used to parse & style tables.
	 * @param markdownText the text containing a table
	 */
	public function parseTable(markdownText:String):String
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

package texter.general.markdown;

class MarkdownPatterns
{
	public static var hRuledTitleEReg(default, null):EReg = ~/([^\n]+)\n^(-{3,}|\+{3,}|_{3,}|\*{3,}|={3,})$/m;
	public static var linkEReg(default, null):EReg = ~/\[([^\]]+)\]\(([^)]+)\)/m;
	public static var codeEReg(default, null):EReg = ~/`([^`\n]+?)`/;
	public static var codeblockEReg(default, null):EReg = ~/```([^\n]*)\n(..+?)```/s;
	public static var tildeCodeblockEReg(default, null):EReg = ~/~~~([^\n]*)\n*(..+?)~~~/s;
	public static var tabCodeblockEReg(default, null):EReg = ~/ {4}(.+)/m;
	public static var imageEReg(default, null):EReg = ~/!\[([^\]]+)\]\(([^)]+)\s"([^")]+)"\)/m;
	public static var listItemEReg(default, null):EReg = ~/^( *)([0-9]+\.|[+\-*]) ([^\n]*)/m;
	public static var unorderedListItemEReg(default, null):EReg = ~/^( *)([+\-*]) ([^\n]*)/m;
	public static var titleEReg(default, null):EReg = ~/^(#{1,6}) ([^\n]+)/m;
	public static var hRuleEReg(default, null):EReg = ~/^(-{3,}|\+{3,}|_{3,}|\*{3,}|={3,})$/m;
	public static var astBoldEReg(default, null):EReg = ~/\*\*([^\n]+)\*\*/m;
	public static var boldEReg(default, null):EReg = ~/__([^\n]+)__/m;
	public static var strikeThroughEReg(default, null):EReg = ~/~~([^~{2}]+?)~~/m;
	public static var italicEReg(default, null):EReg = ~/_([^\n]+)_/m;
	public static var astItalicEReg(default, null):EReg = ~/\*([^\n]+)\*/m;
	public static var mathEReg(default, null):EReg = ~/\$([^\$]+?)\$/m;
	public static var parSepEReg(default, null):EReg = ~/\n\n/m;
	public static var emojiEReg(default, null):EReg = ~/(:[^: ]+:)/m;
	public static var indentEReg(default, null):EReg = ~/^(>+)(.+)/m;
	public static var doubleSpaceNewlineEReg(default, null):EReg = ~/  $/m;
	public static var backslashNewlineEReg(default, null):EReg = ~/\\$/m;
	public static var alignmentEReg(default, null):EReg = ~/^<align="(left|right|center|justify)">([^\r]+?)<\/align>/m;
}

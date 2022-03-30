package texter.general.markdown;

class MarkdownPatterns {
	/**
		When used on a string of text with `lineEReg.match(string)`, 
		it will report everything that gives info about a markdown link:

		- `lineEReg.matched(1)` will give you the text from the link. this text should be displayed
		- `lineEReg.matched(2)` will give you the actual hyperlink. this text should be internal
	**/
	public var linkEReg(default, null):EReg = ~/\[([^\]]+)\]\(([^)]+)\)/m;

	/**
		When used on a string of text with `codeEReg.match(string)`, 
		it will report everything that gives info about a markdown single-line codeblock:
	**/
	public var codeEReg(default, null):EReg = ~/`([^`\n]+)`/;

	/**
		When used on a string of text with `codeblockEReg.match(string)`, 
		it will report everything that gives info about a markdown multi-line code block:

		- `codeblockEReg.matched(1)` will give you the language of the code block, it detects this text: ```**haxe** <- this.
		- `codeblockEReg.matched(2)` is it the start of the codeblock or the end? true for start, false for end.
	**/
	public var codeblockEReg(default, null):EReg = ~/```(.*)\n*([^`]+)```/m;

	/**
		When used on a string of text with `imageEReg.match(string)`, 
		it will report everything that gives info about an image:

		- `imageEReg.matched(1)` will give you the alt text of the image.
		- `imageEReg.matched(2)` will give you the actual source of the image.
		- `imageEReg.matched(3)` will give you the title of the image.
	**/
	public var imageEReg(default, null):EReg = ~/!\[([^\]]+)\]\(([^)]+)\s"([^")]+)"\)/m;

	/**
		When used on a string of text with `listItemEReg.match(string)`, 
		it will report everything that gives info about an image:

		- `listItemEReg.matched(1)` will give you the nesting level of the list item.
		- `listItemEReg.matched(2)` the sign used to determine the list item's texture. can be one of those: **`(*, -, +)`** 
		- `listItemEReg.matched(3)` gives you the text inside of the list item
	**/
	public var listItemEReg(default, null):EReg = ~/^( *)(\d+>|[+\-*]) (.*)/m;

	/**
		When used on a string of text with `titleEReg.match(string)`, 
		it will report everything that gives info about a title:

		- `titleEReg.matched(1)` will give you the size of the heading, between 1 and 6
		- `titleEReg.matched(2)` the actual text used in the title.
	**/
	public var titleEReg(default, null):EReg = ~/^(#+) (.+)/m;

	/**
		(hRule stands for horizontal rule)

		When used on a string of text with `hRuleEReg.match(string)`, 
		it will report everything that gives info about a title:

		- `hRuleEReg.matched(1)` the actual text forming this horizontal rule.
	**/
	public var hRuleEReg(default, null):EReg = ~/\n(—{3,})\n/m;

	public var boldEReg(default, null):EReg = ~/\[<([^>]+)>\]/m;
	public var italicEReg(default, null):EReg = ~/_([^_]+)_/m;
	public var mathEReg(default, null):EReg = ~/\$([^\$]+)\$/m;
	public var parSepEReg(default, null):EReg = ~/\r\r/m;
	public var emojiEReg(default, null):EReg = ~/:(.+):/m;
	private function new() {}
}
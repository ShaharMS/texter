package texter.general.markdown;

enum MarkdownEffect
{
	Bold(start:Int, end:Int);
	Italic(start:Int, end:Int);
	ItalicBold(start:Int, end:Int);
	Underline(start:Int, end:Int);
	StrikeThrough(start:Int, end:Int);
	Code(start:Int, end:Int);
	Math(start:Int, end:Int);
	HorizontalRule(type:String, start:Int, end:Int);
	ParagraphGap(start:Int, end:Int);
	CodeBlock(language:String, start:Int, end:Int);
	Link(link:String, start:Int, end:Int);
	Image(altText:String, imageSource:String, start:Int, end:Int);
	Emoji(type:String, start:Int, end:Int);
	Heading(level:Int, start:Int, end:Int);
	UnorderedListItem(nestingLevel:Int, start:Int, end:Int);
	OrderedListItem(number:Int, nestingLevel:Int, start:Int, end:Int);
}

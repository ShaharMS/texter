package texter.general.markdown;

enum MarkdownEffects
{
	Bold(start:Int, end:Int);
	Italic(start:Int, end:Int);
	ItalicBold(start:Int, end:Int);
	Underline(start:Int, end:Int);
	StrikeThrough(start:Int, end:Int);
	Code(start:Int, end:Int);
	Math(start:Int, end:Int);
	LINEBREAK;
	HorizontalRule(type:String, start:Int, end:Int);
	Paragraph(start:Bool);
	CodeBlock(language:String, start:Int, end:Int);
	Link(link:String, start:Int, end:Int);
	Image(altText:String, imageSource:String, start:Int, end:Int);
	Emoji(type:String);
	Heading(level:Int, start:Int, end:Int);
	UnorderedListItem(nestingLevel:Int);
	RegularText(start:Int, end:Int);
}

typedef MarkdownEffectRange = {
    start:Int,
    end:Int,
    effect:String
};
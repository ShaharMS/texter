package texter.general.markdown;

enum MarkdownEffects
{
	Bold(text:String);
	Italic(text:String);
	Underline(text:String);
	StrikeThrough(text:String);
	Code(text:String);
	Math(text:String);
	LINEBREAK;
	HorizontalRule(type:String, text:String);
	Paragraph(start:Bool);
	CodeBlock(language:String, start:Bool);
	CodeBlockText(text:String);
	Link(link:String, text:String);
	Image(altText:String, imageSource:String, title:String);
	Emoji(type:String);
	Heading(level:Int, text:String);
	UnorderedListItem(nestingLevel:Int);
	RegularText(text:String);
}

typedef MarkdownEffectRange = {
    start:Int,
    end:Int,
    effect:String
};
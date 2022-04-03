package texter.general.markdown;

using texter.general.TextTools;

class MarkdownBlocks {

	public var blockSyntaxMap(default, null):Map<String, String -> Array<{color:Int, start:Int, end:Int}>>;

	private function new() {
		blockSyntaxMap = [
			"json" => parseJSON
		];
	}


	public dynamic function parseJSON(text:String):Array<{color:Int, start:Int, end:Int}>
	{
		var interp:Array<{color:Int, start:Int, end:Int}> = [];
		var indexOfTrue = text.indexesOf("true"),
			indexOfFalse = text.indexesOf("false"),
			indexOfNull = text.indexesOf("null");

		var indexOfLCB = text.indexesOf("{"), 
			indexOfRCB = text.indexesOf("}");

		var indexOfStringEnd = text.indexesOf('",'),
			indexOfEnd = text.indexesOf('"\n'),
			indexOfKeyEnd = text.indexesOf('":');

		var indexOfNumbers = text.indexesFromArray(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]);

		for (a in [indexOfFalse, indexOfTrue, indexOfNull])
		{
			for (i in a)
			{
				interp.push({color: 0x002366, start: i.startIndex, end: i.endIndex});
			}
		}

		for (i in indexOfNumbers)
		{
			interp.push({color: 0x90EE90, start: i.startIndex, end: i.endIndex});
		}

		for (i in indexOfKeyEnd)
		{
			var colorSetup:{?color:Int, ?start:Int, ?end:Int} = {};
			colorSetup.start = i.startIndex - 1;
			colorSetup.end = i.endIndex - 1;
			colorSetup.color = 0x00FFFF;
			while (text.charAt(colorSetup.start) != '"' && colorSetup.start > 0)
			{
				colorSetup.start--;
			}
			interp.push(colorSetup);
		}

		for (a in [indexOfStringEnd, indexOfEnd])
		{
			for (i in a)
			{
				var colorSetup:{?color:Int, ?start:Int, ?end:Int} = {};
				colorSetup.start = i.startIndex - 1;
				colorSetup.end = i.endIndex - 1;
				colorSetup.color = 0xFF7F50;
				while (text.charAt(colorSetup.start) != '"' && colorSetup.start > 0)
				{
					colorSetup.start--;
				}
				interp.push(colorSetup);
			}
		}

		for (a in [indexOfRCB, indexOfLCB])
		{
			for (i in a)
			{
				interp.push({color: 0xDB7093, start: i.startIndex, end: i.endIndex});
			}
		}
		return interp;
	}
	public dynamic function parseHaxe(text:String):Array<{color:Int, start:Int, end:Int}> return [];
    public dynamic function parseCSharp(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public dynamic function parseCPP(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public dynamic function parseC(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public dynamic function parseFlash(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public dynamic function parseXML(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public dynamic function parseJava(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public dynamic function parseKotlin(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public dynamic function parseGo(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public dynamic function parseHTML(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public dynamic function parseCSS(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public dynamic function parseJavaScript(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public dynamic function parseTypeScript(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public dynamic function parseLua(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public dynamic function parseDart(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public dynamic function parsePython(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public dynamic function parsePHP(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public dynamic function parseRuby(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public dynamic function parseSQL(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public dynamic function parseRust(text:String):Array<{color:Int, start:Int, end:Int}> return [];    
	public dynamic function parsePerl(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public dynamic function parseOCaml(text:String):Array<{color:Int, start:Int, end:Int}> return [];

}
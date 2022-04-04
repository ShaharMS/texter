package texter.general.markdown;

using texter.general.TextTools;

class MarkdownBlocks {

	public static var blockSyntaxMap(default, null):Map<String, String -> Array<{color:Int, start:Int, end:Int}>> = [
			"json" => parseJSON,
			"haxe" => parseHaxe,
			"c" => parseC,
			"cpp" => parseCPP,
			"csharp" => parseCSharp,
			"java" => parseJava,
			"js" => parseJS,
			"php" => parsePHP,
			"python" => parsePython,
			"ruby" => parseRuby,
			"sql" => parseSQL,
			"xml" => parseXML,
			"yaml" => parseYAML,
			"html" => parseHTML,
			"css" => parseCSS,
			"ocaml" => parseOCaml,
			"ts" => parseTS,
			"go" => parseGo,
			"kotlin" => parseKotlin,
			"rust" => parseRust,
			"scala" => parseScala,
			"swift" => parseSwift,
			"typescript" => parseTS,
			"lua" => parseLua,
			"haskell" => parseHaskell,
			"erlang" => parseErlang,
			"elixir" => parseElixir,
			"elm" => parseElm,
			"clojure" => parseClojure,
			"crystal" => parseCrystal,
			"dart" => parseDart,
			"golang" => parseGo,
			"assembly" => parseAssembly,
			"vb" => parseVB,
			"basic" => parseBasic,
			"vhdl" => parseVHDL,
			"wasm" => parseWASM,
			"solidity" => parseSolidity,	
		];

	
	public static dynamic function parseJSON(text:String):Array<{color:Int, start:Int, end:Int}>
	{
		var interp:Array<{color:Int, start:Int, end:Int}> = [];
		var indexOfBool = text.indexesFromArray(["true", "false", "null"]),
			indexOfCB = text.indexesFromArray(["{", "}"]), 
			indexOfEnd = text.indexesFromArray(['"\n', '",']),
			indexOfKeyEnd = text.indexesOf('":'),
			indexOfNumbers = text.indexesFromArray(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]);

		for (i in indexOfBool) 		interp.push({color: 0x4169E1, start: i.startIndex, end: i.endIndex});
		for (i in indexOfNumbers) 	interp.push({color: 0x90EE90, start: i.startIndex, end: i.endIndex});
		for (i in indexOfCB) 		interp.push({color: 0xDB7093, start: i.startIndex, end: i.endIndex}); 

		for (i in indexOfKeyEnd)
		{
			var colorSetup:{color:Int, start:Int, end:Int} = {start: i.startIndex - 1, end: i.endIndex - 1, color: 0x00BBFF};
			while (text.charAt(colorSetup.start) != '"' && colorSetup.start > 0) colorSetup.start--;
			interp.push(colorSetup);
		}
			
		for (i in indexOfEnd)
		{
			var colorSetup:{color:Int, start:Int, end:Int} = {start: i.startIndex - 1, end: i.endIndex - 1, color: 0xFF7F50};
			while (text.charAt(colorSetup.start) != '"' && colorSetup.start > 0) colorSetup.start--;
			interp.push(colorSetup);
		}
		

		return interp;
	}
	public static dynamic function parseHaxe	(text:String):Array<{color:Int, start:Int, end:Int}> 
	{
		var interp:Array<{color:Int, start:Int, end:Int}> = [];
		var indexOfBlue = text.indexesFromArray(["true", "false", "null", "public", "static", "dynamic", "extern", "inline", "override", "abstract", "final", "var", "function", "package", "enum", "typedef", "in", "is", "trace", "new", "this", "super", "extends", "implements", "interface"]),
			indexOfPurle = text.indexesFromArray([ "if", "else", "for", "while", "do", "switch", "case", "default", "break", "continue", "try", "catch", "throw", "import"]), 
			indexOfFunction = text.indexesFromEReg(~//),
			indexOfKeyEnd = text.indexesOf('":'),
			indexOfNumbers = text.indexesFromArray(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]);

		return interp;
	}
    public static dynamic function parseCSharp	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseCPP		(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseC		(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseFlash	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseXML		(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseJava	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseKotlin	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseGo		(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseHTML	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseCSS		(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseJS		(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseTS		(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseLua		(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseDart	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parsePython	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parsePHP		(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseRuby	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseSQL		(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseRust	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parsePerl	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseOCaml	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseYAML	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseHaskell	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseCrystal	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseClojure	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseScala	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseSwift	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseElixir	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseErlang	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseElm		(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseAssembly(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseVB		(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseBasic	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseVHDL	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseWASM	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseSolidity(text:String):Array<{color:Int, start:Int, end:Int}> return [];
}
package texter.general.markdown;

using texter.general.TextTools;

/**
   The `MarkdownBlocks` class is a collection of static methods that can be used to get
   syntax highlighting for Markdown code-blocks.
   
   You might notice this class is a bit different from the other `Markdown` classes, as its 
   methods are fully editable. This is because i cant just make syntax highlighters for every single language,
   but you can help with some that i dont knw and you are :) 
   
   ### How to implement a syntax parser.
   **For this example, Ill use Haxe:**
   
   Lets say you wanted to give haxe syntax highlighting,
   but you discover its not supported and the text remains in a single color. how do you fix that?
   
   first, make sure the language exists on the class. you can look at the file/try autocompletion for that
   
   second, you make a syntax parser of your own. i recommand working with this template:
   ```haxe
    using texter.general.TextTools;
   
    function parseLanguage(text) {
     	var interp:Array<{color:Int, start:Int, end:Int}> = [];
		var indexOfKeyColor1 = text.indexesFromEReg(~/(?: |\n|^)(keywords|that|need|to|be|colored|blue)/m),
		indexOfKeyColor2 = text.indexesFromArray([ "You", "can", "also", "add", "words", "with", "an", "array"]), 
		indexOfFunctionName = text.indexesFromEReg(~/([a-zA-Z_]+)\(/m), //detects function syntax, camal/snake/Title case
		indexOfClassName = text.indexesFromEReg(~/(?:\(| |\n|^)[A-Z]+[a-z]+/m), // detects Title Case
		indexOfString = text.indexesFromEReg(~/"[^"]*"|'[^']*'/), // detects "" and ''
		indexOfNumbers = text.indexesFromArray(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]),
		indexOfComment = text.indexesFromEReg(~/\/\/[^\n]*|\/\*[^]*?\*\//m); // detects //

		//add the indexes to the interp array
		for (i in indexOfFunctionName) 	interp.push({color: customColor1, start: i.startIndex, end: i.endIndex - 1}); //dont coint the last (
		for (i in indexOfKeyColor1) 	interp.push({color: customColor2, start: i.startIndex + 1, end: i.endIndex}); //dont count the first char, its not related.
		for (i in indexOfClassName) 	interp.push({color: customColor3, start: i.startIndex, end: i.endIndex});
		for (i in indexOfKeyColor2) 	interp.push({color: customColor4, start: i.startIndex + 1, end: i.endIndex}); //dont count the first char, its not related.
		for (i in indexOfString) 		interp.push({color: customColor5, start: i.startIndex, end: i.endIndex});
		for (i in indexOfNumbers) 		interp.push({color: customColor6, start: i.startIndex, end: i.endIndex});
		for (i in indexOfComments) 		interp.push({color: customColor7, start: i.startIndex, end: i.endIndex});
		for (i in indexOfConditionals) 	interp.push({color: customColor8, start: i.startIndex, end: i.endIndex});
		return interp;
    }
   ```
   What do i do here:

- Im getting all of the special syntax - functions, classes, keywords, strings, numbers, comments, etc.
- I differentiate between the different types of syntax, so i can color them differently.
- I add the indexes to the `interp` array, each one with a unique start & end index.
- I return the `interp` array.

After that, i just assign this function to the correct language, in our case its haxe:

	
	MarkdownBlocks.parseHaxe = parseLanguage;
   	
   **/
class MarkdownBlocks {

	public static var blockSyntaxMap(default, null):Map<String, String -> Array<{color:Int, start:Int, end:Int}>> = [
			"json" => parseJSON,
			"haxe" => parseHaxe,
			"hx" => parseHaxe,
			"c" => parseC,
			"cpp" => parseCPP,
			"csharp" => parseCSharp,
			"cs" => parseCSharp,
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
	public static dynamic function parseHaxe(text:String):Array<{color:Int, start:Int, end:Int}> 
	{
		var interp:Array<{color:Int, start:Int, end:Int}> = [];
		var indexOfBlue = text.indexesFromEReg(~/(?:\(| |\n|^)(overload|true|false|null|public|static|dynamic|extern|inline|override|abstract|final|var|function|package|enum|typedef|in|is|trace|new|this|class|super|extends|implements|interface|->)/m),
			indexOfPurple = text.indexesFromArray([ "if", "else", "for", "while", "do", "switch", "case", "default", "break", "continue", "try", "catch", "throw", "import"]), 
			indexOfFunctionName = text.indexesFromEReg(~/([a-zA-Z_]+)\(/m),
			indexOfClassName = text.indexesFromEReg(~/(?::|\(| |\n|^)[A-Z]+[a-z]+/m),
			indexOfString = text.indexesFromEReg(~/"[^"]*"|'[^']*'/),
			indexOfNumbers = text.indexesFromArray(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]),
			indexOfComments = text.indexesFromEReg(~/\/\/.*/m),
			indexOfConditionals = text.indexesFromEReg(~/#(?:if|end|elseif) [^\n]*/m);

		for (i in indexOfFunctionName) 	interp.push({color: 0xFF8700, start: i.startIndex, end: i.endIndex - 1});
		for (i in indexOfBlue) 			interp.push({color: 0x4169E1, start: i.startIndex + 1, end: i.endIndex});
		for (i in indexOfClassName) 	interp.push({color: 0x42B473, start: i.startIndex + 1, end: i.endIndex});
		for (i in indexOfPurple) 		interp.push({color: 0xDC52BF, start: i.startIndex, end: i.endIndex});
		for (i in indexOfString) 		interp.push({color: 0xFF7F50, start: i.startIndex, end: i.endIndex});
		for (i in indexOfNumbers) 		interp.push({color: 0x62D493, start: i.startIndex, end: i.endIndex});
		for (i in indexOfComments) 		interp.push({color: 0x556B2F, start: i.startIndex, end: i.endIndex});
		for (i in indexOfConditionals) 	interp.push({color: 0x888888, start: i.startIndex, end: i.endIndex});
		return interp;
	}
    public static dynamic function parseCSharp(text:String):Array<{color:Int, start:Int, end:Int}> 
	{
		var interp:Array<{color:Int, start:Int, end:Int}> = [];
		trace("tryParse");
		var indexOfBlue = text.indexesFromEReg(~/(?:\(| |\n|^)(virtual|true|false|null|public|static|as|base|bool|byte|abstract|char|var|checked|class|enum|const|in|is|decimal|new|this|delegate|super|double|extern|float|int|inerface|internal|long|namespace|object|override|private|protected|readonly|short|sizeof|string|struct|typeof|uint|ulong|ushort|using|void|volatile|dynamic|where|yield|to|partial)/m),
			indexOfPurple = text.indexesFromEReg(~/(?:\(| |\n|^)(foreach|if|else|for|while|do|switch|case|default|break|continue|try|catch|throw|return)/m),
			indexOfFunctionName = text.indexesFromEReg(~/([a-zA-Z_]+)\(/m),
			indexOfClassName = text.indexesFromEReg(~/(?:\(| |\n|^)[A-Z]+[a-z]+/m),
			indexOfString = text.indexesFromEReg(~/"[^"]*"|'[^']*'/),
			indexOfNumbers = text.indexesFromArray(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]),
			indexOfComments = text.indexesFromEReg(~/\/\/.*/m);
		trace("endParse");

		for (i in indexOfBlue) 			interp.push({color: 0x4169E1, start: i.startIndex + 1, end: i.endIndex});
		for (i in indexOfClassName) 	interp.push({color: 0x42B473, start: i.startIndex + 1, end: i.endIndex});
		for (i in indexOfFunctionName) 	interp.push({color: 0xFF8700, start: i.startIndex, end: i.endIndex - 1});
		for (i in indexOfPurple) 		interp.push({color: 0xDC52BF, start: i.startIndex + 1, end: i.endIndex});
		for (i in indexOfString) 		interp.push({color: 0xFF7F50, start: i.startIndex, end: i.endIndex});
		for (i in indexOfNumbers) 		interp.push({color: 0x62D493, start: i.startIndex, end: i.endIndex});
		for (i in indexOfComments) 		interp.push({color: 0x556B2F, start: i.startIndex, end: i.endIndex});
		return interp;
	}
	public static dynamic function parseC(text:String):Array<{color:Int, start:Int, end:Int}> 
	{
		var interp:Array<{color:Int, start:Int, end:Int}> = [];
		var indexOfBlue = text.indexesFromEReg(~/(?:\(| |\n|^)(auto|char|const|double|enum|extern|float|goto|inline|int|long|register|restrict|short|signed|sizeof|static|struct|typedef|union|unsigned|void|volatile)/m),
			indexOfPurple = text.indexesFromEReg(~/(?:\(| |\n|^)(break|case|continue|default|do|else|for|if|return|switch|while)/m),
			indexOfFunctionName = text.indexesFromEReg(~/(?:\(| |\n|^)([a-zA-Z_]+)\(/m),
			indexOfString = text.indexesFromEReg(~/"[^"]*"|'[^']*'/),
			indexOfNumbers = text.indexesFromArray(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]),
			indexOfComments = text.indexesFromEReg(~/\/\/.*/m),
			indexOfPink = text.indexesFromEReg(~/^#[^\n]*/m);

		for (i in indexOfBlue) 			interp.push({color: 0x4169E1, start: i.startIndex + 1, end: i.endIndex});
		for (i in indexOfFunctionName) 	interp.push({color: 0xFF8700, start: i.startIndex + 1, end: i.endIndex - 1});
		for (i in indexOfPurple) 		interp.push({color: 0xDC52BF, start: i.startIndex + 1, end: i.endIndex});
		for (i in indexOfString) 		interp.push({color: 0xFF7F50, start: i.startIndex, end: i.endIndex});
		for (i in indexOfNumbers) 		interp.push({color: 0x62D493, start: i.startIndex, end: i.endIndex});
		for (i in indexOfComments) 		interp.push({color: 0x556B2F, start: i.startIndex, end: i.endIndex});
		for (i in indexOfPink) 			interp.push({color: 0xFF00FF, start: i.startIndex, end: i.endIndex});
		return interp;
	}
	public static dynamic function parseR		(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseCPP		(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseFlash	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseXML		(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseXAML	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseJava	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseKotlin	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseGo		(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseHTML	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseCSS		(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseSCSS	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
	public static dynamic function parseVue		(text:String):Array<{color:Int, start:Int, end:Int}> return [];
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
	public static dynamic function parseLisp	(text:String):Array<{color:Int, start:Int, end:Int}> return [];
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
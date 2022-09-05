package;

import texter.general.math.MathLexer;
import haxe.Timer;
import texter.general.bidi.Bidi;
using TextTools;
class Main {
	static function main() {
		#if false
		var timer = haxe.Timer.stamp();
		var processed = Bidi.process("
- שלום עולם
שלום לכם זה RTL וזה LTR
my name is שחר and היום אני בן 16
- hello world");
		trace(processed);
		trace(Bidi.unbidify(processed));
		trace('Processing Time: ${Timer.stamp() - timer}');
		#else
		//var eq = "f(x) = 5x + (444x)/(30542315) + 61x";
		//trace(MathLexer.condenseAttributes(MathLexer.getMathAttributes(eq)));
		//trace(MathLexer.extractTextFromAttributes(MathLexer.condenseAttributes(MathLexer.getMathAttributes(eq))));
		var e = "(4x + 5) * 3x + (2x + 5) * (2x + 5)/(4x + 6)";
		trace(
			MathLexer.reorderAttributes(
				MathLexer.getMathAttributes(e)
			).join("\n")
		);
		trace(
			MathLexer.splitBlocks(
				MathLexer.getMathAttributes(
					"12345x + 3490"
				)
			)
		);
		#end
	}
}
package;

import texter.general.bidi.Bidi;
using TextTools;
class Main {
	static function main() {
		var decostructed = Bidi.getTextAttributes("
- שלום עולם
my name is שחר and היום אני בן 16
- hello world");
		trace(Bidi.stringityAttributes(decostructed).remove("\r"));
		var processed = Bidi.process("
- שלום עולם
my name is שחר and היום אני בן 16
- hello world");
		trace(processed);
		var a = Bidi.process(Bidi.process("
- שלום עולם
my name is שחר and היום אני בן 16
- hello world"));
		trace(a);
		trace("
- שלום עולם
my name is שחר and היום אני בן 16
- hello world");
	}
}
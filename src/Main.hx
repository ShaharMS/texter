package;

import haxe.Timer;
import texter.general.bidi.Bidi;
using TextTools;
class Main {
	static function main() {
		#if interp
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

		#end
	}
}
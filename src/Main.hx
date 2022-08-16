package;

import texter.general.bidi.Bidi;

class Main {
	static function main() {
		var decostructed = Bidi.getTextAttributes("שלום עולם Hello World\nשמי הוא שחר\n - hello");
		trace(decostructed); //[Bidified,LineDirection(RTL),Rtl(שלום עולם ),Ltr(Hello World),LineEnd,Bidified]
	}
}
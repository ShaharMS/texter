package texter.bidi.algorithm;

import texter.bidi.Statics.CharStructure;
import lime.text.UTF8String;
import texter.bidi.database.UnicodeData;
import texter.bidi.Statics;
import texter.bidi.Statics.*;
import texter.bidi.database.UnicodeData;

class Paragraph {
  	public static function preprocessText(text:UTF8String) {
    	var ls:Array<CharStructure> = [];

    	for(i in 0...text.length) {
      		var char = text.substring(i, 1);
      		var charStructure = Statics.getCharStructure();
			charStructure.char = char;
			charStructure.bidiType = UnicodeData.bidirectional(char);
			ls.push(charStructure);
    	}

    	return ls;
  	}

  	public static function getParagraphLevel(chars:Array<CharStructure>) {
    	for (char in chars) {
			switch (char.bidiType) {
        		case "AL", "R": return 1;
        		case "L": return 0;
      		}
    	}

    	return 0;
  	}
}
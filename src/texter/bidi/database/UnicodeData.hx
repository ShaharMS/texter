package texter.bidi.database;

import lime.text.UTF8String;
import texter.bidi.database.UnicodeDB;

class UnicodeData {

    public static inline var SHIFT = 7;

    public static function bidirectional(char:UTF8String) {
        var code = char.charCodeAt(0), index = 0;

    	if (code < 0x110000) {
      		var firstShift = code >> SHIFT;
      		index = UnicodeDB.index1[firstShift];
      		var n = code & ((2 * SHIFT) - 1);
      		var secondShift = (index << SHIFT) + n;
     		index = UnicodeDB.index2[secondShift];
    	}

    	var record = UnicodeDB.databaseRecords[index];
    	var bidi = record[DatabaseRecord.bidirectional];
		var name = UnicodeDB.bidirectionalNames[bidi];

    	return name;
  	}

  	public static function mirrored(char:UTF8String) {
    	var code = char.charCodeAt(0), index = 0;
    	if (code < 0x110000) {
    	  	index = UnicodeDB.index1[code >> SHIFT];
    	  	var leftShift = index << SHIFT;
    	  	var added = code & (1<<SHIFT - 1);
    	  	var i = leftShift + added;
    	  	index = UnicodeDB.index2[i];
    	}

    	return UnicodeDB.databaseRecords[index][DatabaseRecord.mirrored];
  	}

}

enum abstract DatabaseRecord(Int) from Int to Int {
  	var bidirectional = 2;
 	var mirrored = 3;
}
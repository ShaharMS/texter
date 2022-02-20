package texter.bidi.algorithm;

import texter.bidi.database.UnicodeData;
import texter.bidi.algorithm.ReorderResolved.ReverseIterator;
import texter.bidi.algorithm.Explicit.Stack;
import texter.bidi.database.BidiBrackets;
import texter.bidi.Statics;

class ResolveNeutral {

  	static function sortAscending(a:Array<Dynamic>, b:Array<Dynamic>) {
    	if (a[0] < b[0]) return -1;
    	return 1;
  	}

  static function identifyBracketPairs(sequence:IsolatingRunSequenceStructure, data:DataStructure) {
    	var stack:Stack = [], pair_indexes:Array<Array<Dynamic>> = [];

    	for (ch in sequence.chars) {

      	if (BidiBrackets.brackets.exists(ch.char)) {
        	var entry = BidiBrackets.brackets[ch.char];
        	var bracket_type = entry[1];
        	var text_position = data.chars.indexOf(ch);

        	if (bracket_type == "o") {
        	  	if (stack.length <= 63) {
        	  	  	stack.push([entry[0], text_position]);
        	  	} else break;
        	} else if (bracket_type == "c") {
          		var element_index = stack.length - 1;
          
          		while (element_index > 0 && entry[0] != stack[element_index][0]) {
            		element_index -= 1;
          		}
        
          		var element = stack[element_index];
          		if (element != null && element[0] == entry[0]) {
            		pair_indexes.push([element[1], text_position]);
            		stack.pop();
          		}
        	}
      	}
    }

    pair_indexes.sort(sortAscending);

    return pair_indexes;
  }

  static function N0(sequence:IsolatingRunSequenceStructure, data:DataStructure) {
    var bracket_pairs = identifyBracketPairs(sequence, data);

    for (bracket_pair in bracket_pairs) {
      var strong_type = null;

      var chars = data.chars.slice(bracket_pair[0], bracket_pair[1]);

      for (ch in chars) {
        var bidiType = ch.bidiType;

        switch (bidiType) {
          case 'EN', 'AN':
            bidiType = "R";
        }

        if (bidiType == sequence.embedding_direction) {
          data.chars[bracket_pair[0]].bidiType = sequence.embedding_direction;
          data.chars[bracket_pair[1]].bidiType = sequence.embedding_direction;
          strong_type = null;
          break;
        } else if (bidiType == "L" || bidiType == "R") {
          strong_type = bidiType;
        }
      }

      if (strong_type != null) {
        var found_preceding_strong_type = false;

        for (i in new ReverseIterator(bracket_pair[0], -1)) {
          var ch = data.chars[i];

          var bidiType = ch.bidiType;
        
          switch (bidiType) {
            case 'EN', 'AN':
              bidiType = "R";
          }

          if (bidiType == strong_type) {
            data.chars[bracket_pair[0]].bidiType = strong_type;
            data.chars[bracket_pair[1]].bidiType = strong_type;
            found_preceding_strong_type = true;
            break;
          }

          if (!found_preceding_strong_type) {
            data.chars[bracket_pair[0]].bidiType = sequence.embedding_direction;
            data.chars[bracket_pair[1]].bidiType = sequence.embedding_direction;
          }
        }
      }

      chars = data.chars.slice(bracket_pair[0] + 1, bracket_pair[1]);
      for (ch in chars) {
        var original_type = UnicodeData.bidirectional(ch.char);
        if (original_type != "NSM") {
          break;
        }

        ch.bidiType = data.chars[bracket_pair[0]].bidiType;
      }
    }
  }

  static function N1(sequence:IsolatingRunSequenceStructure) {
    var strong_type = null;
    var NI_sequence = [];
    var is_in_sequence = false;

    for (ch in sequence.chars) {
      switch (ch.bidiType) {
        case "B", "S", "WS", "ON", "FSI", "LRI", "RLI", "PDI":
          is_in_sequence = true;
          NI_sequence.push(ch);
        case _:
          var new_type = null;
          switch (ch.bidiType) {
            case 'R', 'EN', 'AN':
              new_type = "R";
            case "L":
              new_type = "L";
          }

          if (new_type != null) {
            if (is_in_sequence && strong_type == new_type) {
              for (_ch in NI_sequence) {
                _ch.bidiType = strong_type;
              }
            }
            NI_sequence = [];
            is_in_sequence = false;
            strong_type = new_type;
          }
      }
    }
  }

  static function N2(sequence:IsolatingRunSequenceStructure) {
    for (ch in sequence.chars) {
      switch(ch.bidiType) {
        case "B", "S", "WS", "ON", "FSI", "LRI", "RLI", "PDI":
          ch.bidiType = sequence.embedding_direction;
      }
    }
  }

  public static function resolve_neutral_and_isolate_formatting_types(data:DataStructure) {
    for (sequence in data.isolatingRunSequences) {
      N0(sequence, data);
      N1(sequence);
      N2(sequence);
    }
  }

}
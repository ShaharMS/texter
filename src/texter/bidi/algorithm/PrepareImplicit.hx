package texter.bidi.algorithm;

import texter.bidi.Statics;

class PrepareImplicit {

    inline static function compareLevels(x, y) {
      	return Math.max(x, y) % 2 == 0 ? "L" : "R";
    }

  	public static function getIsolatingRunSequences(data:DataStructure) {
    	var isolating_run_sequences = [];

    	if (data.chars.length == 0) return isolating_run_sequences;

    	var prev_level = data.chars[0].level, start = 0, end = 0, PDI_scopes_counter = 0;
    	for (ch in data.chars) {
      		var bt = ch.bidiType;
      		if (bt == "FSI" || bt == "LRI" || bt == "RLI") {
        		PDI_scopes_counter += 1;
      		}
      		if(bt ==  "PDI" && PDI_scopes_counter > 0) {
        		PDI_scopes_counter -= 1;
      		}

      		end = data.chars.indexOf(ch);

      		if (prev_level != ch.level || end >= data.chars.length  - 1) {
        		if (PDI_scopes_counter > isolating_run_sequences.length - 1) {
          			isolating_run_sequences.push(Statics.getIsolatingRunSequenceStructure());
        		}
        	var sequence = isolating_run_sequences[PDI_scopes_counter];

        	if (end >= data.chars.length - 1) {
          		end = data.chars.length - 1;
        	}

        	sequence.embedding_level = prev_level;
        	sequence.embedding_direction = prev_level % 2 == 0 ? "L" : "R";
        	var chars = data.chars.slice(start, end);
        	sequence.chars = sequence.chars.concat(chars);

        	start = end;
      	}

      	prev_level = ch.level;
    }

    for (sequence in isolating_run_sequences) {
      if(sequence.chars.length == 0) {
        continue;
      }
      var first_index = data.chars.indexOf(sequence.chars[0]);
      var first_level = data.chars[first_index].level;
      var preceding_level = first_index == 0 ? data.level : data.chars[first_index - 1].level;

      sequence.sosType = compareLevels(first_level, preceding_level);

      var last_index = data.chars.indexOf(sequence.chars[sequence.chars.length - 1]);
      var last_level = data.chars[last_index].level;
      var following_level = last_index == 0 ? data.level : data.chars[last_index - 1].level;

      sequence.eosType = compareLevels(last_level, following_level);      
    }

    return isolating_run_sequences;

  }

  public static function preparations_for_implicit_processing(data:DataStructure) {
    var chars_copy = data.chars.concat([]);

    for (ch in chars_copy) {
      switch (ch.bidiType) {
        case 'RLE', 'LRE', 'RLO', 'LRO', 'PDF', 'BN':
          data.chars.remove(ch);
      }
    }

    data.isolatingRunSequences = getIsolatingRunSequences(data);
  }
}
package texter.bidi.algorithm;

import texter.bidi.Statics.CharStructure;
import texter.bidi.Statics.DirectionalIsolate;
import texter.bidi.Statics.DataStructure;
import texter.bidi.Statics.DirectionalOverride;

class CounterStructure {
  public var overflowIsolate:Int = 0;
  public var overflowEmbedding:Int = 0;
  public var validIsolate:Int = 0;

  public function new() {}
}

typedef Stack = Array<Array<Any>>;

class Explicit {

  	static inline var max_depth = Statics.max_depth;

  	public static inline function getCountersStructrue():CounterStructure {
    	return new CounterStructure();
  	}

  	public static inline function leastOddGreater(x:Int) {
  	  	return x + 1 + (x % 2);
  	}

  	public static inline function leastEvenGreater(x:Int) {
  	  	return x + 1 + ((x + 1) % 2);
  	}

  	static function X1(data:DataStructure):Array<Any> {
  	  	var stack:Stack = [];
  	  	var counters = getCountersStructrue();

  	  	var d:Array<Any> = [data.level, DirectionalOverride.Neutral, DirectionalIsolate.False];
  	  	stack.push(d);

  	  	return [stack, counters];
  	}

	static function X2(charStructure:CharStructure, stack:Stack, counters:CounterStructure) {
		if (charStructure.bidiType != "RLE") {
  	    	return;
  	  	}

  	  	var new_level_odd = leastOddGreater(stack[stack.length - 1][0]);
  	  	if (counters.overflowEmbedding == 0 && counters.overflowIsolate == 0 && new_level_odd < max_depth) {
  	    	stack.push([new_level_odd, DirectionalOverride.Neutral, DirectionalIsolate.False]);
  	  	} else if (counters.overflowIsolate == 0) {
  	      	counters.overflowEmbedding += 1;
  	    }
  	}

	static function X3(charStructure:CharStructure, stack:Stack, counters:CounterStructure) {
		if (charStructure.bidiType != "RLE") {
  	    	return;
  	  	}

  	  	var new_level_even = leastEvenGreater(stack[stack.length - 1][0]);
  	  	if (counters.overflowEmbedding == 0 && counters.overflowIsolate == 0 && new_level_even < max_depth - 1) {
  	    	stack.push([new_level_even, DirectionalOverride.Neutral, DirectionalIsolate.False]);
  	  	} else if (counters.overflowIsolate == 0) {
  	      counters.overflowEmbedding += 1;
  	    }
  	}

	static function X4(charStructure:CharStructure, stack:Stack, counters:CounterStructure) {
		if (charStructure.bidiType != "RLO") {
  	    	return;
  	  	}

  	  	var new_level_odd = leastOddGreater(stack[stack.length - 1][0]);
  	  	if (counters.overflowEmbedding == 0 && counters.overflowIsolate == 0 && new_level_odd < max_depth) {
  	    	stack.push([new_level_odd, DirectionalOverride.RTL, DirectionalIsolate.False]);
  	  	} else if (counters.overflowIsolate == 0) { 	    
  	      	counters.overflowEmbedding += 1;
  	    }
  	}

	static function X5(charStructure:CharStructure, stack:Stack, counters:CounterStructure) {
		if (charStructure.bidiType != "LRO") {
  	    	return;
  	  	} 

  	  	var new_level_even = leastEvenGreater(stack[stack.length - 1][0]);
  	  	if (counters.overflowEmbedding == 0 && counters.overflowIsolate == 0 && new_level_even < max_depth - 1) {
  	    	stack.push([new_level_even, DirectionalOverride.LTR, DirectionalIsolate.False]);
  	  	} else if (counters.overflowIsolate == 0) {
  	      counters.overflowEmbedding += 1;
  	    }
  	}

  	static function X5a(charStructure:CharStructure, stack:Stack, counters:CounterStructure) {
		if (charStructure.bidiType != "RLI") {
  	  	  	return;
  	  	} 

		charStructure.level = stack[stack.length - 1][0];
  	  	var directional_override = stack[stack.length - 1][1];

  	  	if (directional_override == DirectionalOverride.LTR) {
			charStructure.bidiType = "L";
  	  	} else if (directional_override == DirectionalOverride.RTL) {
			charStructure.bidiType = "R";
  	  	}

  	  	var new_level_odd = leastOddGreater(stack[stack.length - 1][0]);
  	  	if (counters.overflowEmbedding == 0 && counters.overflowIsolate == 0 && new_level_odd < max_depth) {
  	  	  counters.validIsolate += 1;
  	  	  stack.push([new_level_odd, DirectionalOverride.Neutral, DirectionalIsolate.True]);
  	  	} else {
  	  	  counters.overflowIsolate += 1;
  	  	}

  	}

	static function X5b(charStructure:CharStructure, stack:Stack, counters:CounterStructure) {
		if (charStructure.bidiType != "LRI") {
  	    	return;
  	  	} 

		charStructure.level = stack[stack.length - 1][0];
  	  	var directional_override = stack[stack.length - 1][1];

  	  	if (directional_override == DirectionalOverride.LTR) {
			charStructure.bidiType = "L";
  	  	} else if (directional_override == DirectionalOverride.RTL) {
			charStructure.bidiType = "R";
  	  	}

  	  	var new_level_even = leastEvenGreater(stack[stack.length - 1][0]);
  	  	if (counters.overflowEmbedding == 0 && counters.overflowIsolate == 0 && new_level_even < max_depth) {
  	    	counters.validIsolate += 1;
  	    	stack.push([new_level_even, DirectionalOverride.Neutral, DirectionalIsolate.True]);
  	  	} else {
  	    	counters.overflowIsolate += 1;
  	  	}
  	}

	static function X5c(data:DataStructure, charStructure:CharStructure, stack:Stack, counters:CounterStructure) {
		if (charStructure.bidiType != "FSI") {
  	    	return;
  	  	}

		var start = data.chars.indexOf(charStructure), end = 0, PDIScopesCounter = 0;

  	  	for (i in start...data.chars.length) {
  	    	var x = data.chars[i];
  	    	switch(x.bidiType) {
  	      		case "FSI", "LRI", "RLI": PDIScopesCounter += 1;
  	      		case "PDI": {
					if (PDIScopesCounter == 0) {
  	          			end = i;
  	          			break;
  	        		} else {
						PDIScopesCounter -= 1;
  	        		}
				}
					
  	    	}
  	  	}

  	  	if (end == 0) {
  	    	end = data.chars.length - 1;
  	  	}

  	  	if (Paragraph.getParagraphLevel(data.chars.slice(start, end)) == 1) {
			charStructure.bidiType = "RLI";
			X5a(charStructure, stack, counters);
  	  	} else {
			charStructure.bidiType = "LRI";
			X5b(charStructure, stack, counters);
  	  	}
  	}

	static function X6(charStructure:CharStructure, stack:Stack) {
		switch (charStructure.bidiType) {
  	    	case "B", "BN", "RLE", "LRE", "RLO", "LRO", "PDF", "RLI", "LRI", "FSI", "PDI": return;
  	  	}

		charStructure.level = stack[stack.length - 1][0];
  	  	var directional_override = stack[stack.length - 1][1];

  	  	if (directional_override == DirectionalOverride.RTL) {
			charStructure.bidiType = "R";    
  	  	} else if (directional_override == DirectionalOverride.LTR) {
			charStructure.bidiType = "L";   
  	  	}
  	}

	static function X6a(charStructure:CharStructure, stack:Stack, counters:CounterStructure) {
		if (charStructure.bidiType != "PDI") return;

  	  	if (counters.overflowIsolate > 0) {
  	    	counters.overflowIsolate -= 1;
  	  	} else if (counters.validIsolate > 0) {
  	    	counters.overflowEmbedding = 0;
  	    	while(stack[stack.length - 1][2] == DirectionalIsolate.False) {
  	      		stack.pop();
  	    	}

  	    	stack.pop();
  	    	counters.validIsolate -= 1;
  	  	}

  	  	var last_status = stack[stack.length - 1];
		charStructure.level = last_status[0];
  	  	if (last_status[1] == DirectionalOverride.LTR) {
			charStructure.bidiType = "L";
  	  	} else if (last_status[1] == DirectionalOverride.RTL) {
			charStructure.bidiType = "R";
  	  	}
  	}

	static function X7(charStructure:CharStructure, stack:Stack, counters:CounterStructure) {
		if (charStructure.bidiType != "PDF") return;

  	  	if (counters.overflowIsolate > 0) {
		
  	  	} else if (counters.overflowEmbedding > 0) {
  	    	counters.overflowEmbedding -= 1;
  	  	} else if (stack[stack.length - 1][2] == DirectionalIsolate.False && stack.length > 2) {
  	    	stack.pop();
  	  	}
  	}

  	public static function explicitLevelsAndDirections(data:DataStructure) {
  	  	var tmp = X1(data), stack = (tmp[0]:Stack), counters = (tmp[1]:CounterStructure);

  	  	for (char in data.chars) {
  	    	X2(char, stack, counters);
  	    	X3(char, stack, counters);
  	    	X4(char, stack, counters);
  	    	X5(char, stack, counters);
  	    	X5a(char, stack, counters);
  	    	X5b(char, stack, counters);
  	    	X5c(data, char, stack, counters);
  	    	X6(char, stack);
  	    	X6a(char, stack, counters);
  	    	X7(char, stack, counters);

  	    	if (char.bidiType == "B") {
  	    	  	char.bidiType = data.level;
				
  	    	  	tmp = X1(data);
  	    	  	stack = (tmp[0]:Stack);
  	    	  	counters = (tmp[1]:CounterStructure);
  	    	}
  	  	}
  	}

}
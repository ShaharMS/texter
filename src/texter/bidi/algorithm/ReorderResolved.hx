package texter.bidi.algorithm;

import texter.bidi.Statics;
import texter.bidi.Statics.*;
import texter.bidi.database.UnicodeData;
import texter.bidi.database.BidiBrackets;

class ReorderResolved {

  	static function L1(data:DataStructure) {
    	var resetable_chars = [];

    	for (ch in data.chars) {
      		var original_type = UnicodeData.bidirectional(ch.char);

      		switch (original_type) {
        		case 'WS', 'FSI', 'LRI', 'RLI', 'PDI': resetable_chars.push(ch);
        		case 'B', 'S': {
					ch.level = data.level;
					for (ch2 in resetable_chars)
					{
						ch2.level = data.level;
					}
					resetable_chars = [];
				}
				default: resetable_chars = [];
			}
      	}

    	for (ch2 in resetable_chars) {
      		ch2.level = data.level;
    	}
  	}

  	static function L2(data:DataStructure) {
   	 	var highest_level = 0, lowest_odd_level = Math.POSITIVE_INFINITY;

    	for (ch in data.chars) {
      		if (ch.level > highest_level) {
        		highest_level = ch.level;
      		}
      		if (ch.level < lowest_odd_level && (ch.level % 2) == 1) {
        		lowest_odd_level = ch.level;
      		}
    	}

    	if (lowest_odd_level == Math.POSITIVE_INFINITY) {
    	  // no rtl text, do nothing
    	  return;
    	}

    	for (i in new ReverseIterator(highest_level, Std.int(lowest_odd_level) - 1)) {
      var sequences = [[]], sequence_index = 0;
      
      for (ch in data.chars) {
        if (ch.level >= i) {
          sequences[sequence_index].push(ch);
        } else if (sequences[sequence_index].length > 0) {
          sequences.push([]);
          sequence_index += 1;
        }
      }

      for (sequence_chars in sequences) {
        if(sequence_chars.length == 0) {
          continue;
        }
        var first_char = sequence_chars[0];
        var index = data.chars.indexOf(first_char);
        var chars = [];

        for (j in 0...index) {
          chars.push(data.chars[j]);
        }
        for (j in new ReverseIterator(index + sequence_chars.length - 1, index - 1)) {
          chars.push(data.chars[j]);
        }
        for (j in (index + sequence_chars.length)...data.chars.length) {
          chars.push(data.chars[j]);
        }

        data.chars = chars;

      }

    }
  }

  static function L3(data:DataStructure) {
    var non_spacing_chars = [];
    for (ch in data.chars) {
      var original_type = UnicodeData.bidirectional(ch.char);
      if (original_type == "NSM") {
        non_spacing_chars.push(ch);
      } else if (original_type == "R") {
        non_spacing_chars.push(ch);

        var first_char = non_spacing_chars[0];
        var index = data.chars.indexOf(first_char);
        var chars = [];

        for (j in 0...index) {
          chars.push(data.chars[j]);
        }
        for (j in new ReverseIterator(index + non_spacing_chars.length - 1, index - 1)) {
          chars.push(data.chars[j]);
        }
        for (j in (index + non_spacing_chars.length)...(data.chars.length)) {
          chars.push(data.chars[j]);
        }

        for (j in index...(index + non_spacing_chars.length)) {
          // SHOULDN'T BE chars?????
          data.chars.splice(j, 1);
        }

        data.chars = chars;

        non_spacing_chars = [];
      } else {
        non_spacing_chars = [];
      }
    }
  }

  static function L4(data:DataStructure) {
    for (ch in data.chars) {
      if (ch.level % 2 == 1 && BidiBrackets.mirrored.exists(ch.char)) {
        ch.char = BidiBrackets.mirrored.get(ch.char);
      }
    }
  }

  public static function reorder_resolved_levels(data:DynamicAccess) {
    L1(data);
    L2(data);
    L3(data);
    L4(data);
  }

}

class ReverseIterator
{
	var end:Int;
	var i:Int;

	public inline function new(start:Int, end:Int)
	{
		this.i = start;
		this.end = end;
	}

	public inline function hasNext()return i > end;
	public inline function next() return i--;
}

abstract DynamicAccess(Dynamic) from Dynamic to Dynamic
{
	public inline function new()
		this = {};

	public inline function get<T>(key:String, ?def:T):Null<T>
	{
		var r = Reflect.field(this, key);
		return r == null ? def : r;
	}

	@:arrayAccess
	inline function get_arrayaccess(key:String):Null<Dynamic>
	{
		return get(key);
	}

	@:arrayAccess
	public inline function set<T>(key:String, value:T):T
	{
		Reflect.setField(this, key, value);
		return value;
	}

	public inline function exists(key:String):Bool
		return Reflect.hasField(this, key);

	public inline function remove(key:String):Bool
		return Reflect.deleteField(this, key);

	public inline function keys():Array<String>
		return Reflect.fields(this);
}
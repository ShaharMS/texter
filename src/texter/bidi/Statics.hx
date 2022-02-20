package texter.bidi;

import lime.text.UTF8String;

enum abstract DirectionalOverride(Int) from Int to Int {
    var Neutral = 0;
    var RTL = 1;
    var LTR = 2;
}

enum abstract DirectionalIsolate(Int) from Int to Int {
    var True = 1;
    var False = 0;
}

class Statics {

 	public static inline var max_depth = 125;

  	public static inline function getIsolatingRunSequenceStructure():IsolatingRunSequenceStructure {
    	return new IsolatingRunSequenceStructure();
  	}

  	public static inline function getCharStructure():CharStructure {
    	return new CharStructure();
  	}

  	public static inline function getDataStructure():DataStructure {
    	return new DataStructure();
  	}

}

class IsolatingRunSequenceStructure {
  	public var chars:Array<CharStructure> = [];
  	public var sosType:UTF8String = null;
  	public var eosType:UTF8String = null;
  	public var embedding_level:Int = 0;
  	public var embedding_direction:UTF8String = "";

  	public function new() {}
}

class CharStructure {
  	public var char:UTF8String = "";
  	public var bidiType:UTF8String = null;
  	public var level:Dynamic = null;

  	public var charcode(get, never):Int;

  	inline function get_charcode() {
  	  return char.charCodeAt(0);
  	}

  	public function new() {}
}

class DataStructure {
  	public var level:Dynamic = null;
  	public var chars:Array<CharStructure> = [];
  	public var isolatingRunSequences:Array<IsolatingRunSequenceStructure> = [];

  	public function new() {}
}

package texter.bidi.algorithm;

import texter.bidi.algorithm.ReorderResolved.ReverseIterator;
import lime.text.UTF8String;
import texter.bidi.Statics;

class ResolveWeak {
  
  static function W1(data:DataStructure, sequence:IsolatingRunSequenceStructure, ch:CharStructure, char_index:Int) {
    if (ch.bidiType != "NSM") {
      return;
    }

    if (ch == sequence.chars[0]) {
      ch.bidiType = sequence.sosType;
    } else {
      var prev_char = data.chars[char_index - 1];
      switch(prev_char.bidiType) {
        case 'PDI', 'LRI', 'RLI', 'FSI':
          ch.bidiType = "ON";
        default:
          ch.bidiType = prev_char.bidiType;
      }
    }
  }

  static function W2(ch:CharStructure, last_strong_type:UTF8String) {
    if (ch.bidiType != "EN") {
      return;
    }

    if (last_strong_type == "AL") {
      ch.bidiType = "AN";
    }
  }

  static function W3(ch:CharStructure) {
    if (ch.bidiType == "AL") {
      ch.bidiType = "R";
    }
  }

  static function W4(data:DataStructure, ch:CharStructure, char_index:Int) {
    if (char_index > 0 && char_index < data.chars.length - 1) {
      if (ch.bidiType == "ES") {
        var prev_char = data.chars[char_index - 1];
        var following_char = data.chars[char_index + 1];

        if (prev_char.bidiType == "EN" && following_char.bidiType == "EN") {
          ch.bidiType = "EN";
        }
      }

      if (ch.bidiType == "CS") {
        var prev_char = data.chars[char_index - 1];
        var following_char = data.chars[char_index + 1];

        if ((prev_char.bidiType == "EN" || prev_char.bidiType == "AN")
          && (following_char.bidiType == "EN" || following_char.bidiType == "AN")) {
          ch.bidiType = prev_char.bidiType;
        }
      }
    }
  }

  static function W5(data:DataStructure, ch:CharStructure, char_index:Int) {
    if(ch.bidiType != "EN") {
      return;
    }

    for (i in char_index...data.chars.length) {
      var _ch = data.chars[i];
      if (_ch.bidiType != "ET") {
        break;
      }
      _ch.bidiType = "EN";
    }

    for(i in new ReverseIterator(char_index, -1)) {
      var _ch = data.chars[i];
      if (_ch.bidiType != "ET") {
        break;
      }
      _ch.bidiType = "EN";
    }
  }

  static function W6(ch:CharStructure) {
    switch(ch.bidiType) {
      case 'ET', 'ES', 'CS':
        ch.bidiType = "ON";
    }
  }

  static function W7(ch:CharStructure, last_strong_type:UTF8String) {
    if (ch.bidiType == "EN" && last_strong_type == "L") {
      ch.bidiType = "L";
    }
  }

  public static function resolve_weak_types(data:DataStructure) {
    for (sequence in data.isolatingRunSequences) {
      var last_strong_type = null;
      for (ch in sequence.chars) {
        var char_index = data.chars.indexOf(ch);

        switch (ch.bidiType) {
          case 'AL', 'R', 'L':
            last_strong_type = ch.bidiType;
        }

        W1(data, sequence, ch, char_index);
        W2(ch, last_strong_type);
        W3(ch);
        W4(data, ch, char_index);
        W5(data, ch, char_index);
        W6(ch);
        W7(ch, last_strong_type);

      }
    }
  }

}
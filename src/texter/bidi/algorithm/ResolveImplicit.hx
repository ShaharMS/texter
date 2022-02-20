package texter.bidi.algorithm;

import texter.bidi.Statics;
import texter.bidi.Statics.*;

class ResolveImplicit {
  	static function I1(ch:CharStructure) {
    	if (ch.level % 2 == 0) {
      		switch (ch.bidiType) {
        		case "R": ch.level += 1;
        		case 'AN', 'EN':ch.level += 2;
      		}
    	}
  	}

  	static function I2(ch:CharStructure) {
  	  	if (ch.level % 2 == 1) {
  	  	  	switch (ch.bidiType) {
  	  	  	  case 'L', 'AN', 'EN': ch.level += 1;
  	  	  	}
  	  	}	
  	}

  	public static function resolveImplicitLevels(data:DataStructure) {
    	for (ch in data.chars) {
      		I1(ch);
      		I2(ch);
    	}
  	}
}
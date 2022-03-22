package texter.general;

import texter.general.CharTools.*;

/**
 * An abstract that loosely represents a `char`.
 * 
 * The reason i say "loosely" is because its not actually
 * a real `char`, but an abstraction over `String` to
 * help you manipulate/get information about characters
 */
abstract Char(String) {
    
    var charCode(get, set):Null<Int>;
    @:noCompletion inline function get_charCode() return toInt();
    @:noCompletion inline function set_charCode(i:Null<Int>):Null<Int> {
		this = charFromValue[i].toString();
        return charFromValue[i];
    }

    var character(get, set):String;
    @:noCompletion inline function get_character() return toString();
    @:noCompletion inline function set_character(string:String) return this = string;

    public function new(?string:String, ?int:Int) {
        if (string != null && string.length != 0) {
            this = string.charAt(0);
            return;
        } else if (int != null) {
            this = charFromValue[int];
        }
        this = "";
    }

    @:from public static function fromInt(int:Int):Char 
    {
        return "n";
    }

	@:from public static function fromString(string:String):Char
	{
		return new Char(string);
	}

    @:to public function toString():String {
        return this;
    }

    @:to public function toInt():Int {
        return charToValue[this];
    }
}
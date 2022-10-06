package texter.general;

import texter.general.CharTools.*;

/**
 * An abstract that loosely represents a `char`.
 * 
 * The reason i say "loosely" is because its not actually
 * a real `char`, but an abstraction over `String` to
 * help you manipulate/get information about characters
 * 
 * When used with `CharTools`, it provides some great tooling to work with characters & string
 */
abstract Char(String)
{
	/**
	 * Every single character has a code that associates with it.
	 * 
	 * The `charCode` property is the code corresponding to this `Char`.
	 * 
	 * Changing this value will also change the char.
	 */
	public var charCode(get, set):Null<Int>;

	@:noCompletion inline function get_charCode()
		return toInt();

	@:noCompletion inline function set_charCode(i:Null<Int>):Null<Int>
	{
		this = charFromValue[i].toString();
		return charFromValue[i];
	}

	/**
	 * A `String` representation of this `Char`.
	 * 
	 * `Char`s are at their core just a fancy, one-character `String`,
	 * so you should be able to use the actual char to represent a string too.
	 */
	public var character(get, set):String;

	@:noCompletion inline function get_character()
		return toString();

	@:noCompletion inline function set_character(string:String)
		return this = string;

	/**
	 * Creates a new `Char`, from either a `String`, or
	 * an `Int`. If you supply both values, the char
	 * will use the `String` property
	 * 
	 * **Notice** - Creating a `Char` with an `Int` might be slow
	 * 
	 * Usage:
	 * 
	 * ```haxe
	 * var char = new Char("n");
	 * //or maybe
	 * var char2 = new Char(110);
	 * ```
	 * 
	 * **Notice** - you can also just do:
	 * ```haxe
	 * var char = "n";
	 * var char2 = 110;
	 * ```
	 */
	public function new(?string:String, ?int:Int)
	{
		if (string != null && string.length != 0)
		{
			this = string.charAt(0);
			return;
		}
		else if (int != null)
		{
			this = charFromValue[int];
			return;
		}
		this = "";
	}

	@:from public static inline function fromInt(int:Int):Char
	{
		return charFromValue[int];
	}

	@:from public static inline function fromString(string:String):Char
	{
		return new Char(string);
	}

	@:to public inline function toString():String
	{
		return this;
	}

	@:to public inline function toInt():Int
	{
		return charToValue[this];
	}
}

package texter.flixel;

import openfl.display.BitmapData;
import openfl.text.TextFieldType;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.addons.effects.chainable.FlxOutlineEffect;

/**
 * A text class that has some extra fancy visual settings to it.
 * 
 * uses FlxInputTextRTL under the hood to support both RTL and LTR input.
 * 
 * INCOMPLETE - waiting for FlxInputTextRTL
 */
class FlxSuperText extends FlxSpriteGroup {

	public function new(x:Float, y:Float, length:Int, size:Int)
	{
		super(x, y);
	}

	override function draw()
	{
		super.draw();
	}
}
package msf.extras;

import openfl.display.BitmapData;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxMatrix;
import openfl.text.TextFieldType;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import openfl.geom.ColorTransform;
import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.util.FlxSpriteUtil;
import flixel.addons.effects.chainable.FlxOutlineEffect;
import msf.extras.FlxTextButton;
import msf.extras.FlxInputTextRTL;
/**
 * A text class that has some extra fancy visual settings to it.
 * 
 * uses FlxTextFeildRTL under the hood to support both RTL and LTR input.
 */
class FlxSuperText extends FlxSpriteGroup {

	var internalTextFeild:TextField;
	var resizeOutline:FlxOutlineEffect;
	var frontSprite:FlxSprite;
	var bmp:BitmapData;

	public function new(x:Float, y:Float, length:Int, size:Int)
	{
		super(x, y);
		internalTextFeild = new TextField();
		internalTextFeild.x = x;
		internalTextFeild.y = y;
		internalTextFeild.defaultTextFormat = new TextFormat(null, size, 0xFFFFFF);
		internalTextFeild.type = TextFieldType.INPUT;
		internalTextFeild.background = true;
        internalTextFeild.width = length;
		internalTextFeild.backgroundColor = 0x000000;
		frontSprite = new FlxSprite();
		frontSprite.width = length;
		frontSprite.height = internalTextFeild.height;
		add(frontSprite);

		bmp = new BitmapData(Std.int(internalTextFeild.width), Std.int(internalTextFeild.height), false, 0x000000);
	}

	override function draw()
	{
		super.draw();
		bmp.draw(internalTextFeild);
		frontSprite.loadGraphic(bmp);

	}
}
package texter.flixel;
#if (flixel && false)
import flixel.group.FlxSpriteGroup;


/**
 * A text class that has some extra fancy visual settings to it.
 * 
 * uses FlxInputTextRTL under the hood to support both RTL and LTR input.
 * 
 * INCOMPLETE - waiting for FlxInputTextRTL's RTL WordWrap
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
#end
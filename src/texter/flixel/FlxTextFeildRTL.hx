package msf.extras;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import lime.ui.KeyCode;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import openfl.text._internal.TextLayout;
import openfl.ui.Keyboard;

/**
 * Extends TextFeild to support flixel & RTL. displays over all other objects
 */
class FlxTextFeildRTL extends TextField implements IFlxDestroyable
{
	var format = new openfl.text.TextFormat(null, 60, 0xFFFFFF);

	/**
	 * The sprite you should add to states/FlxGroups.
	 */
	public var textFieldSprite(default, null):FlxSprite;

	var textLayout:TextLayout;

	var bmp:BitmapData;

	var isRTL(default, null):Bool;

	public function new(Width:Int = 500)
	{
		super();
		defaultTextFormat = format;
		selectable = true;
		type = INPUT;
		width = Width;
		textLayout = new TextLayout();
		textLayout.direction = RIGHT_TO_LEFT;
		textLayout.script = HEBREW;
		textLayout.language = "he";
		Reflect.setField(Reflect.field(this, "__textEngine"), "__textLayout", textLayout);

		bmp = new BitmapData(Std.int(width), Std.int(height), false, 0x000000);
		addEventListener(Event.CHANGE, redrawText);
		addEventListener(KeyboardEvent.KEY_DOWN, fixText);

		textFieldSprite = new FlxSprite();
		textFieldSprite.width = width;
		textFieldSprite.height = height;

		textFieldSprite.loadGraphic(bmp, false, 0, 0, true);
	}

	function redrawText(event:Event)
	{
		trace("redraw");
		bmp.fillRect(bmp.rect, 0x0000);
		bmp.draw(this);
		textFieldSprite.loadGraphic(bmp);
	}

	function fixText(event:KeyboardEvent)
	{
		if (event.shiftKey && event.altKey)
			isRTL = !isRTL;
		if (isRTL) {
			textLayout.direction = RIGHT_TO_LEFT;
			textLayout.script = HEBREW;
			textLayout.language = "he";
			Reflect.setField(Reflect.field(this, "__textEngine"), "__textLayout", textLayout);
		}
		else {
			textLayout.direction = LEFT_TO_RIGHT;
			textLayout.script = TextScript.COMMON;
			textLayout.language = "en";
			Reflect.setField(Reflect.field(this, "__textEngine"), "__textLayout", textLayout);
		}
		/*var letter = String.fromCharCode(event.charCode);
		if (letter == " ")
		{
			if (isRTL)
			{
				text = insertSubstring(text, letter, caretIndex);
			}
			else
			{
				text = insertSubstring(text, letter, caretIndex);
				@:privateAccess this.__caretIndex++;
			}
		} */
	}

	public function addToState():FlxTextFeildRTL
	{
		FlxG.addChildBelowMouse(this);
		return this;
	}

	public function kill()
	{
		visible = false;
	}

	public function revive()
	{
		visible = true;
	}

	public function destroy()
	{
		FlxG.removeChild(this);
	}

	function insertSubstring(Original:String, Insert:String, Index:Int):String
	{
		if (Index != Original.length)
		{
			Original = Original.substring(0, Index) + (Insert) + (Original.substring(Index));
		}
		else
		{
			Original = Original + (Insert);
		}
		return Original;
	}
}

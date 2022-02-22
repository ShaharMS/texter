package texter.flixel;
import flixel.group.FlxSpriteGroup;
#if flixel
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * A text that calls a function when clicked
 * Behaves like a regular `FlxText`, but
 * with extra button functions.
 * 
 * INCOMPLETE - works but lacks features
 */
class FlxTextButton extends FlxSpriteGroup {

    /**
        The type of the label:
        
        - `LabelType.INPUT` - the button will be able to recieve text input and the `enter` button will trigger its callback.
        - `LabelType.REGULAR` - the button will behave like a bormal button, with mouse clicks being the trigger for the
        `onClick()` function and `onEnter()` being disabled.
    **/
    public var labelType(get, set):LabelType;

    /**
        An Instance of FlxInputTextRTL, will handle the
        text visulas & input.
    **/
    public var label(default, null):FlxInputTextRTL;

    /**
        The current state of the button:
        
        | State | Situation |
        | --- | --- |
        | `FlxButton.NORMAL` | when the button isn't overlapped by the mouse/touchpoint |
        | `FlxButton.HIGHLIGHT` | when the mouse overlaps the button, but isn't pressed |
        | `FlxButton.PRESSED` | when the mouse/touchpoint not only overlap the button, but are also pressed |
    **/
    public var status(get, null):Int;

    /**
      The button's callback for when the user presses it
    **/
    public var onClick:Void -> Void;

    /**
        #### For INPUT mode only
        The button's callback for when the user presses enter while the text is focused
    **/
    public var onEnter:Void -> Void;

    
    public function new(x:Float = 0, y:Float = 0, text:String = "", size:Int = 8, ?OnClick:Void -> Void = null, ?OnEnter:Void -> Void = null) {
        super(x,y);
        if (OnClick == null) 
            onClick == () -> return; 
        else 
            onClick = OnClick;

		if (OnEnter == null)
			onEnter == () -> return;
		else
			onEnter = OnEnter;
        label.color = color;
        label.size = size;
        label.text = text;
        
    }

	function get_labelType():LabelType {
		throw new haxe.exceptions.NotImplementedException();
	}

	function set_labelType(value:LabelType):LabelType {
		throw new haxe.exceptions.NotImplementedException();
	}

	function get_status():Int {
		throw new haxe.exceptions.NotImplementedException();
	}
}

enum LabelType
{
	INPUT;
	REGULAR;
}
#end


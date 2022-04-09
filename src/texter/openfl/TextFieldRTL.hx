package texter.openfl;
import openfl.display.Shape;
import openfl.utils.ByteArray;
import openfl.events.Event;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
#if openfl
import openfl.display.Sprite;
import openfl.Lib;
import openfl.text.TextFieldType;
import texter.general.TextTools.TextDirection;
import openfl.text.TextFormat;
import openfl.desktop.Clipboard;
import texter.general.CharTools;
import openfl.events.FocusEvent;
import openfl.text.TextFieldAutoSize;
import openfl.geom.Rectangle;
import openfl.ui.MouseCursor;
import openfl.ui.Mouse;
import openfl.events.MouseEvent;
import lime.ui.KeyModifier;
import lime.ui.KeyCode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.text.TextField;

/**
 * `TextFieldRTL` is an "extention" of `TextField` that adds support for multiple things:
 *  - right-to-left text
 *  - built-in markdown visualization
 *  - built in syntax highlighter
 * 
 * It also adds some convenience methods & fields for working with the object, that `TextField` doesn't have:
 * 
 *  - alignment
 *  - upperMask
 *  - useMarkdown
 *  - markdownDisplay
 *  - editable `caretIndex`
 *  - hasFocus
 *  - insertSubstring()
 *  - getCaretIndexAtPoint()
 *  - getCaretIndexOfMouse()
 * 
 * And more.
 */
class TextFieldRTL extends Sprite {
    
    public var textField:TextField;

    /**
		Whether or not the text is aligned according to the first typed character:

		 - if the character is from a RTL language - `alignment` will be set to `RIGHT`.
		 - if the character is from any other language - `alignment` will be set to `LEFT`.
		 - if the character is not from any specific language - `alignment` will be set to `UNDETERMINED`.
		
		
		
		 **`autoAlign` does not default to a certine direction when set to `false`**. it will
		use the last direction it remembers when this `TextFieldRTL` was created/when `autoAlign` was still true;
	**/
	public var autoAlign(default, set):Bool = true;

	/**
		Specifies the direction of the starting character inside this text input.

		the text direction will only be set according to `openingDirection` if `autoAlign` is set to true.

		`openingDirection` is decided after the first strongly typed character is typed. a table to help:

		| Character Group | Type | Direction |
		|	  :---:	     | :---:|  :---:  |
		| punctuation marks (see `CharTools.generalMarks`) | softly typed | UNDETERMINED |
		| LTR languages (English, Spanish, French, German...) | strongly typed | LTR |
		| RTL languages (Arabic, Hebrew, Sorani, Urdu...) | strongly typed | RTL |
	**/
	public var openingDirection(default, null):TextDirection = UNDETERMINED;

    /**
     * This `Sprite` is a mask that exists above the actual text. You can 
	 * draw on it, add `DisplayObject`s to it, etc.
     */
    public var upperMask:Sprite;

	/**
	 * This `Sprite` is a mask that exists below the actual text. You can 
	 * draw on it, add `DisplayObject`s to it, etc.
	 * 
	 * **NOTICE** - setting the `background` property to `true` will hide the lower mask.
	 */
	public var lowerMask:Sprite;


    /**
     * Whether or not to use the markdown display when this `TextFieldRTL` loses focus.
	 * 
	 * If set to true, this TextField will be hidden by the `markdownDisplay`,
	 * which contains the visuals.
	 * 
	 * some things to notice:
	 *  - The `markdownDisplay`'s properties
     */
    public var useMarkdown(default, set):Bool;

    public var markdownDisplay(default, null):TextFieldRTL;

    public var caretIndex(default, set):Int = 0;

    public var text(get, set):String;

    public var autoSize(get, set):TextFieldAutoSize;
    
    public var alignment(get, set):TextFieldAutoSize;

    public var textColor(get, set):Int;

    public var backgroundColor(get, set):Int;

    public var background(get, set):Bool;

    public var wordWrap(get, set):Bool;

    public var multiline(get, set):Bool;

    public var hasFocus(get, set):Bool;

    public var defaultTextFormat(get, set):TextFormat;

    public var type(get, set):TextFieldType;

    public var border(get, set):Bool;

    public var borderColor(get, set):Int;

    public var selectable(get, set):Bool;

    var caret:Bitmap;
	var currentlyRTL:Bool = false;
	var currentlyNumbers:Bool;
	var caretTimer = new Timer(500);
	var selectionShape:Shape;
	var hasMoved = false;
	var startSelect = -1;
	var selectedRange:Array<Int> = [-1, -1];

    public function new() {
        super();

		lowerMask = new Sprite();
		lowerMask.addChild(new Bitmap(new BitmapData(Std.int(width), Std.int(height), true, 0x00000000)));
		addChild(lowerMask);

        textField = new TextField();
		addChild(textField);

		selectionShape = new Shape();
		addChild(selectionShape);

		background = false;
		backgroundColor = 0x00000000;
        upperMask = new Sprite();
		upperMask.addChild(new Bitmap(new BitmapData(Std.int(width), Std.int(height), true, 0x00000000)));
        caret = new Bitmap(new BitmapData(1, 1, false, 0x000000));
		caret.height = textField.defaultTextFormat.size;
		caret.x = caret.y = 2;
		caret.visible = false;
		caretTimer.addEventListener(TimerEvent.TIMER, caretBlink);

        addChild(upperMask);
        addChild(caret);
        Lib.application.window.onTextInput.add(regularKeysDown);
        Lib.application.window.onKeyDown.add(specialKeysDown);

		textField.addEventListener(FocusEvent.FOCUS_IN, (e) -> stage.focus = this);
		upperMask.addEventListener(FocusEvent.FOCUS_IN, (e) -> stage.focus = this);
        addEventListener(MouseEvent.MOUSE_DOWN, onFocusIn);
        addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
        addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    }

	function caretBlink(e:TimerEvent) {
		caret.visible = !caret.visible;
	}

	function onMouseMove(e:MouseEvent) {
		if (!e.buttonDown) {
			startSelect = -1;
			hasMoved = false;
			setSelection(-1, -1);
			return;
		}
		else if (hasMoved) {
			var lastBound = getCaretIndexOfMouse();
			setSelection(startSelect, lastBound);
		} else {
			startSelect = getCaretIndexOfMouse();
			hasMoved = true;
		}

	}

    function onFocusOut(e:FocusEvent) {
        hasFocus = false;
        if (!useMarkdown) return;
    }

	function onFocusIn(e:MouseEvent) {
		trace("focus");
        stage.window.textInputEnabled = true;
        if (type != INPUT) return;
        hasFocus = true;
        caretIndex = getCaretIndexOfMouse();
    }

	function onMouseOver(e:MouseEvent) {
        Mouse.cursor = MouseCursor.IBEAM;
    }

	function onMouseOut(e:MouseEvent)
	{
		Mouse.cursor = MouseCursor.AUTO;
	}

	function onMouseWheel(e:MouseEvent) {
		final del = Std.int(e.delta / 6);
		textField.scrollV += del;
	}

    public function getCaretIndexAtPoint(x:Float, y:Float):Int {
        if (text.length > 0)
		{
			for (i in 0...text.length)
			{
				var r = getCharBoundaries(i);
				if ((x >= r.x && x <= r.right && y >= r.y && y <= r.bottom)) // <----------------- CHANGE HERE
				{
					return i;
				}
				
			}
			//the mouse might have been pressed between the lines
			var i = 0;
			while (i < text.length) {
				var r = getCharBoundaries(i), line = textField.getLineIndexOfChar(i + 1);
				if (r == null) return 0;
				if (y >= r.y && y <= r.bottom) {
					if (i == 0) i--;
					if (i != -1 && !StringTools.contains(text, "\n")) i -= 2;
					if (i + 1 + StringTools.replace(textField.getLineText(line), "\n", "").length == text.length - 1) i++;
					return i + 1 + StringTools.replace(textField.getLineText(line), "\n", "").length;
				}
				i++;
			}
			return text.length;
		}
		// place caret at leftmost position
		return 0;
    }

    public function getCaretIndexOfMouse():Int {
        return getCaretIndexAtPoint(mouseX, mouseY);
    }

	public function getCharBoundaries(charIndex:Int):Rectangle
	{
		if (textField.getCharBoundaries(charIndex) != null) return textField.getCharBoundaries(charIndex);

		if (charIndex <= 0) return new Rectangle(2, 2, 0, textField.defaultTextFormat.size);

		var charBoundaries:Rectangle = new Rectangle();


		if (text.charAt(charIndex) == "\n")
		{
			var diff = 1; // this is going to be used when a user presses enter twice to display the caret at the correct height
			while (text.charAt(charIndex - 1) == "\n")
			{
				charIndex--;
				diff++;
			}
			// if this is a spacebar, we cant use textField.getCharBoundaries() since itll return null
			charBoundaries = getCharBoundaries(charIndex - 1);
			charBoundaries.y += diff * charBoundaries.height;
			if (alignment == RIGHT)
				charBoundaries.x = x + width - 2
			else if (alignment == CENTER)
                charBoundaries.x = x + width / 2
            else
				charBoundaries.x = 2;
			charBoundaries.width = 0;
		}
		else if (text.charAt(charIndex) == " ")
		{
			// we know that it doesnt matter how many spacebars are pressed,
			// the first one after a char/at the start of the text
			// is always defined and has the correct boundaries
			var widthDiff = 0, originalIndex = charIndex;
			while (text.charAt(charIndex - 1) == " " && charIndex != 0)
			{
				charIndex--;
				widthDiff++;
			}
			charBoundaries = textField.getCharBoundaries(charIndex);
			// removing this makes pressing between word-wrapped lines crash
			if (charBoundaries == null)
				charBoundaries = textField.getCharBoundaries(charIndex - 1);
			charBoundaries.x += widthDiff * charBoundaries.width
				- (width - 4) * (textField.getLineIndexOfChar(originalIndex) - textField.getLineIndexOfChar(charIndex));
			// guessing line height differences when lots of spacebars are pressed and are being wordwrapped
			charBoundaries.y = textField.getLineIndexOfChar(originalIndex) * charBoundaries.height;
		}
		return charBoundaries;
	}

    public function insertSubstring(insert:String, index:Int):TextFieldRTL
	{
		if (insert == "") {
			if (selectedRange != [-1, -1]) {
				text = text.substring(0, selectedRange[0]) + text.substring(selectedRange[1] + 1);
				caretIndex = selectedRange[1];
				selectedRange = [-1, -1];
			} else {
				text = text.substring(0, caretIndex) + text.substring(caretIndex + 1);
			}
			return this;
		}

		if (selectedRange != [-1, -1]) text = text.substring(0, selectedRange[0]) + insert + text.substring(selectedRange[1] + 1)
		else text = text.substring(0, index) + insert + text.substring(index);
		selectedRange = [-1, -1];
        return this;
	}

	function specialKeysDown(key:KeyCode, modifier:KeyModifier)
	{
		// if the user didnt intend to edit the text, dont do anything
		if (!hasFocus)
			return;
		// handle copy-paste
		if (modifier.ctrlKey)
		{
			if (key == KeyCode.V)
			{
				// paste text
				var clipboardText = Clipboard.generalClipboard.getData(TEXT_FORMAT);
				if (clipboardText == null)
					return;
				if (currentlyRTL)
				{
					insertSubstring(clipboardText, caretIndex);
				}
				else
				{
					insertSubstring(clipboardText, caretIndex);
					caretIndex += clipboardText.length;
					if (caretIndex > text.length)
						caretIndex = text.length;
				}
			}
		}
		// those keys break the caret and place it in caretIndex -1
		if (modifier.altKey || modifier.shiftKey || modifier.ctrlKey || modifier.metaKey)
			return;

		// fix the caret if its broken
		if (caretIndex < 0)
			caretIndex = 0;

		if (key == KeyCode.RIGHT && caretIndex < text.length)
			caretIndex++;
		if (key == KeyCode.LEFT && caretIndex > 0)
			caretIndex--;
		if (key == KeyCode.DOWN)
		{
			// here we get the line the caret is on, the amount of letters in it and where is the caret relative to it
			var currentLine = textField.getLineIndexOfChar(caretIndex),
				letterLineIndex = caretIndex - textField.getLineOffset(currentLine);
			// here we get stats about the next line and where to put the caret
			if (letterLineIndex > textField.getLineLength(currentLine + 1))
				letterLineIndex = textField.getLineLength(currentLine + 1);
			caretIndex = textField.getLineOffset(currentLine + 1) + letterLineIndex;
		}
		if (key == KeyCode.UP)
		{
			// here we get the line the caret is on, the amount of letters in it and where is the caret relative to it
			var currentLine = textField.getLineIndexOfChar(caretIndex),
				letterLineIndex = caretIndex - textField.getLineOffset(currentLine);
			// here we get stats about the next line and where to put the caret
			if (letterLineIndex > textField.getLineLength(currentLine - 1))
				letterLineIndex = textField.getLineLength(currentLine - 1);
			caretIndex = textField.getLineOffset(currentLine - 1) + letterLineIndex;
		}
		else if (key == KeyCode.BACKSPACE)
		{
			if (caretIndex > 0)
			{
				#if !js
				if (CharTools.rtlLetters.match(text.charAt(caretIndex + 1)) || CharTools.rtlLetters.match(text.charAt(caretIndex)))
				{
					insertSubstring("", caretIndex);
				}
				else
				{
					caretIndex--;
					insertSubstring("", caretIndex);
				}
				#else
				caretIndex--;
				insertSubstring("", caretIndex);
				#end

			}
		}
		else if (key == KeyCode.DELETE)
		{
			#if !js
			if (text.length > 0 && caretIndex < text.length)
			{
				if (CharTools.rtlLetters.match(text.charAt(caretIndex + 1)) || CharTools.rtlLetters.match(text.charAt(caretIndex)))
				{
					insertSubstring("", caretIndex - 1);
					caretIndex--;
				}
				else
				{
					insertSubstring("", caretIndex);
				}
			}
			#else
			insertSubstring("", caretIndex);
			#end
		}
		else if (key == 13)
		{
			caretIndex++;
			if (!currentlyRTL)
			{
				insertSubstring("\n", caretIndex);
			}
			else
			{
				var insertionIndex = 0;
				insertionIndex = caretIndex;
				// starts a search for the last RTL char and places the "\n" there
				// if the string ends and theres still no last RTl char, "\n" will be insterted at length.
				while (CharTools.rtlLetters.match(text.charAt(insertionIndex))
					|| text.charAt(insertionIndex) == " "
					&& insertionIndex != text.length)
					insertionIndex++;
				insertSubstring("\n", insertionIndex);
				caretIndex = insertionIndex + 1;
			}
		}
		else if (key == KeyCode.END)
		{
			caretIndex = text.length;
		}
		else if (key == KeyCode.HOME)
		{
			caretIndex = 0;
		}
	}

	function regularKeysDown(letter:String)
	{
		// if the user didnt intend to edit the text, dont do anything
		if (!hasFocus)
			return;
		// if the caret is broken for some reason, fix it
		if (caretIndex < 0)
			caretIndex = 0;
		// set up the letter - remove null chars, add rtl mark to letters from RTL languages
		var t:String = "", hasConverted:Bool = false, addedSpace:Bool = false;
		#if !js
		if (letter != null)
		{
			// logic for general RTL letters, spacebar, punctuation mark
			if (CharTools.rtlLetters.match(letter)
				|| (currentlyRTL && letter == " ")
				|| (CharTools.generalMarks.contains(letter) && currentlyRTL))
			{
				currentlyNumbers = false;
				t = CharTools.RLO + letter;
				currentlyRTL = true;
				if (openingDirection == UNDETERMINED || text == "")
				{
					if (autoAlign)
						alignment = RIGHT;
					openingDirection = RTL;
				}
			}
			// logic for when the user converted from RTL to LTR
			else if (currentlyRTL)
			{
				t = letter;
				currentlyRTL = false;
				hasConverted = true;

				// after conversion, the caret needs to move itself to he end of the RTL text.
				// the last spacebar also needs to be moved
				if (text.charAt(caretIndex) == " ")
				{
					t = CharTools.PDF + " " + letter;
					text = text.substring(0, caretIndex) + text.substring(caretIndex, text.length);
					addedSpace = true;
				}
				caretIndex++;

				while (CharTools.rtlLetters.match(text.charAt(caretIndex)) || text.charAt(caretIndex) == " " && caretIndex != text.length)
					caretIndex++;
			}
			// logic for everything else - LTR letters, special chars...
			else
			{
				t = letter;
				if (openingDirection == UNDETERMINED || text == "")
				{
					if (autoAlign)
						alignment = LEFT;
					if (CharTools.generalMarks.contains(t))
						openingDirection = UNDETERMINED
					else
						openingDirection = LTR;
				}
			}
		}
		else
			"";
		#else
		t = letter;
		#end
		if (t.length > 0)
		{
			insertSubstring(t, caretIndex);
			caretIndex++;
			if (hasConverted) caretIndex++;
			if (addedSpace) caretIndex++;
		}
	}

    //----------------------------------
    // TextField Compatibility
    //----------------------------------

    public function replaceSelectedText(value:String):Void
    {
        textField.replaceSelectedText(value);
    }

    public function replaceText(beginIndex:Int, endIndex:Int, newText:String):Void
    {
        textField.replaceText(beginIndex, endIndex, newText);
    }

    public function getLineIndexOfChar(charIndex:Int):Int
    {
        return textField.getLineIndexOfChar(charIndex);
    }

    public function getLineLength(lineIndex:Int):Int
    {
        return textField.getLineLength(lineIndex);
    }

    public function getLineText(lineIndex:Int):String
    {
        return textField.getLineText(lineIndex);
    }

    public function getParagraphLength(charIndex:Int):Int
    {
        return textField.getParagraphLength(charIndex);
    }

    public function getTextFormat(beginIndex:Int, endIndex:Int):TextFormat
    {
        return textField.getTextFormat(beginIndex, endIndex);
    }

    public function setTextFormat(format:TextFormat ,beginIndex:Int, endIndex:Int)
    {
        return textField.setTextFormat(format ,beginIndex, endIndex);
    }

    public function getCharIndexAtPoint(x:Int, y:Int):Int
    {
        return getCaretIndexAtPoint(x, y);
    }

    public function getLineIndexAtPoint(x:Int, y:Int):Int
    {
        return textField.getLineIndexAtPoint(x, y);
    }

    public function getLineOffset(lineIndex:Int):Int
    {
        return textField.getLineOffset(lineIndex);
    }

	public function setSelection(beginIndex:Int, endIndex:Int):Void
	{
		if (beginIndex > endIndex)
		{
			var temp:Int = beginIndex;
			beginIndex = endIndex;
			endIndex = temp;
		}
		trace("start: " + beginIndex + " end: " + endIndex);
		selectedRange = [beginIndex, endIndex];
	}
	//---------------
	// getters & setters (boilerplate)
	// Now i get why TextField is 3500~ lines of code
	//---------------

	function get_background():Bool
	{
		return textField.background;
	}

	function set_background(background:Bool):Bool
	{
		return textField.background = background;
	}

	function get_backgroundColor():Int
	{
		return textField.backgroundColor;
	}

	function set_backgroundColor(backgroundColor:Int):Int
	{
		return textField.backgroundColor = backgroundColor;
	}

	function get_textColor():Int
	{
		return textField.textColor;
	}

	function set_textColor(textColor:Int):Int
	{
		return textField.textColor = textColor;
	}

	function set_useMarkdown(value:Bool):Bool
	{
		throw new haxe.exceptions.NotImplementedException();
	}

	function set_caretIndex(index:Int):Int
	{
		caretIndex = index;
		caretTimer.stop();
		caret.visible = true;
		caretTimer.start();

		// If caret is too far to the right something is wrong
		if (caretIndex > text.length)
		{
			caretIndex = text.length;
		}
		
		var bounds = getCharBoundaries(index - 1 != 0 ? index - 1 : 0);
		caret.height = bounds.height;
		caret.x = if (CharTools.rtlLetters.match(text.charAt(index))) bounds.x else bounds.x + bounds.width;
		caret.y = bounds.y;

		if (caret.x < 0) caret.x = 2;
		if (caret.y < 0) caret.y = 2;
		if (caret.x > width) caret.x = width - 2;
		if (caret.y > height) caret.y = height - 2;

		return index;
	}

	function get_alignment():TextFieldAutoSize
	{
		return this.textField.autoSize;
	}

	function set_alignment(alignment:TextFieldAutoSize):TextFieldAutoSize
	{
		return this.textField.autoSize = alignment;
	}

	function get_autoSize():TextFieldAutoSize
	{
		return this.textField.autoSize;
	}

	function set_autoSize(autoSize:TextFieldAutoSize):TextFieldAutoSize
	{
		return this.textField.autoSize = autoSize;
	}

	function get_text():String
	{
		return textField.text;
	}

	function set_text(text:String):String
	{
		return textField.text = text;
	}

	function get_hasFocus():Bool
	{
		return stage.focus == this ? true : false;
	}

	function set_hasFocus(value:Bool):Bool
	{
		if (value)
		{
			stage.focus = this;
			caret.visible = true;
			caretTimer.start();
			return value;
		}
		caret.visible = false;
		caretTimer.stop();
		return false;
	}

	function get_multiline():Bool
	{
		return this.textField.multiline;
	}

	function set_multiline(multiline:Bool):Bool
	{
		return this.textField.multiline = multiline;
	}

	function get_wordWrap():Bool
	{
		return this.textField.wordWrap;
	}

	function set_wordWrap(wordWrap:Bool):Bool
	{
		return this.textField.wordWrap = wordWrap;
	}

	function get_defaultTextFormat():TextFormat
	{
		return this.textField.defaultTextFormat;
	}

	function set_defaultTextFormat(defaultTextFormat:TextFormat):TextFormat
	{
		return this.textField.defaultTextFormat = defaultTextFormat;
	}

	function set_autoAlign(value:Bool):Bool
	{
		if (!value)
			return value;
		if (!CharTools.rtlLetters.match(text.charAt(0)))
		{
			alignment = LEFT;
		}
		else
		{
			alignment = RIGHT;
		}
		return value;
	}

	function get_borderColor():Int
	{
		return this.textField.borderColor;
	}

	function set_borderColor(borderColor:Int):Int
	{
		return this.textField.borderColor = borderColor;
	}

	function get_border():Bool
	{
		return this.textField.border;
	}

	function set_border(border:Bool):Bool
	{
		return this.textField.border = border;
	}

	function get_type():TextFieldType
	{
		return this.textField.type;
	}

	function set_type(type:TextFieldType):TextFieldType
	{
		return this.textField.type = type;
	}

	function get_selectable():Bool
	{
		return this.textField.selectable;
	}

	function set_selectable(selectable:Bool):Bool
	{
		return this.textField.selectable = selectable;
	}

	//----------------------------
	// overriden getters & setters
	//----------------------------

	override function set_width(value:Float):Float
	{
		upperMask.removeChildAt(0);
		upperMask.addChildAt(new Bitmap(new BitmapData(Std.int(value), Std.int(height), true, 0x00000000)), 0);
		lowerMask.removeChildAt(0);
		lowerMask.addChildAt(new Bitmap(new BitmapData(Std.int(value), Std.int(height), true, 0x00000000)), 0);

		return textField.width = value;
	}

	override function set_height(value:Float):Float
	{
		return textField.height = value;
	}

	
}

#end
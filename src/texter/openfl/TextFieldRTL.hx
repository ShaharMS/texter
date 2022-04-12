package texter.openfl;
import texter.general.markdown.Markdown;
import texter.general.markdown.MarkdownVisualizer;
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
import openfl.text.TextLineMetrics;
import openfl.display.Shape;
import openfl.utils.ByteArray;
import openfl.events.Event;
import openfl.events.TimerEvent;
import openfl.utils.Timer;

#if actuate
import motion.Actuate;
import motion.easing.Quad;
#end

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
     * Similar to `TextField`s caretIndex, but its editable.
	 * 
	 * The caret is the blinking cursor that appears when you're typing. 
	 * its always before the character you're typing.
	 * 
	 * For example (`⸽` is the caret): **`index - 0`**
	 * 
	 * empty text field:
	 * ```
	 * ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
	 * ▏⸽                   ▎
	 * ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔
	 * ```
	 * 
	 * caret at the end of the text field: **`index - text.length`**
	 * ```
	 * ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
	 * ▏hey there friend⸽   ▎
	 * ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔
	 * ```
	 * 
	 * caret at index 1 (after the first character at index `0`): **`index - 1`**
	 * ```
	 * ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
	 * ▏h⸽ey there friend   ▎
	 * ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔
	 * ```
	 */
    public var caretIndex(default, set):Int = 0;

	/**
	 * The text that is currently being edited/displayed.
	 */
    public var text(get, set):String;

    /**
     * Similar to the `alignment` property of `TextFieldRTL`, and only exists for compatibility with `TextField`.
	 * The reason for adding the `alignment` property in the first place is to make it easier to use `TextFieldRTL` objects.
     */
    public var autoSize(get, set):TextFieldAutoSize;
    
    /**
		Controls automatic sizing and alignment of this `TextFieldRTL`.
		| mode | description |
		| --- | --- |
		| `TextFieldAutoSize.NONE` | no automatic sizing or alignment |
		| `TextFieldAutoSize.LEFT` | the text is treated as left-justified text, meaning that the left margin of the text field remains fixed and any resizing of a single line of the text field is on the right margin. If the text includes a line break(for example, `"\n"` or `"\r"`), the bottom is also resized to fit the next line of text. If `wordWrap` is also set to `true`, only the bottom of the text field is resized and the right side remains fixed. |
		| `TextFieldAutoSize.RIGHT` | the text is treated as right-justified text, meaning that the right margin of the text field remains fixed and any resizing of a single line of the text field is on the left margin. If the text includes a line break(for example, `"\n" or "\r")`, the bottom is also resized to fit the next line of text. If `wordWrap` is also set to `true`, only the bottom of the text field is resized and the left side remains fixed.
		| `TextFieldAutoSize.CENTER` | the text is treated as center-justified text, meaning that any resizing of a single line of the text field is equally distributed to both the right and left margins. If the text includes a line break(for example, `"\n"` or `"\r"`), the bottom is also resized to fit the next line of text. If `wordWrap` is also set to `true`, only the bottom of the text field is resized and the left and right sides remain fixed.|
     **/
    public var alignment(get, set):TextFieldAutoSize;

    /**
     * The default font color that will be used to draw the text.
     */
    public var textColor(get, set):Int;

    /**
     * The default background color that will be used to draw the text.
	 * 
	 * **Note** - when using the `lowerMask` property, you might want to set the `background` property
	 * to false. this also means the color applied here wont do anything. If you want to color the `lowerMask`'s
	 * background, you can do this:
	 * ```haxe
	 * lowerMask.graphics.beginFill(yourColor);
	 * lowerMask.graphics.drawRect(0, 0, textField.width, textField.textHeight);
	 * lowerMask.graphics.endFill();
	 * ```
	 */
    public var backgroundColor(get, set):Int;

    /**
     * Whether or not this `TextFieldRTL` has a background.
	 * 
	 * **Note** - when using the `lowerMask` property, you might want to set this property to false to avoid hiding the `lowerMask`.
     */
    public var background(get, set):Bool;

    public var wordWrap(get, set):Bool;

    public var multiline(get, set):Bool;

    public var hasFocus(get, set):Bool;

    public var defaultTextFormat(get, set):TextFormat;

    public var type(get, set):TextFieldType;

    public var border(get, set):Bool;

    public var borderColor(get, set):Int;

    public var selectable(default, set):Bool;

	public var embedFonts(get, set):Bool;

	public var textWidth(get, null):Float;

	public var textHeight(get, null):Float;

	public var maxChars(get, set):Int;

	public var maxScrollH(get, never):Int;

	public var maxScrollV(get, never):Int;

	public var scrollH(get, set):Int;

	public var scrollV(get, set):Int;

	public var length(get, null):Int;

	public var htmlText(get, set):openfl.text._internal.UTF8String;

	public var markdownText(default, set):String;

    var caret:Bitmap;
	var currentlyRTL:Bool = false;
	var currentlyNumbers:Bool;
	var caretTimer = new Timer(500);
	var selectionShape:Shape;
	var hasMoved = false;
	var startSelect = -1;
	var selectedRange:Array<Int> = [-1, -1];
	var maskRect:Shape = new Shape();

    public function new() {
        super();
		//dont activate getter/setter
		Reflect.setField(this, "useMarkdown", false);

        textField = new TextField();
		textField.type = TextFieldType.DYNAMIC;
		textField.selectable = false;

		lowerMask = new Sprite();
		addChild(lowerMask);
		addChild(textField);

		selectionShape = new Shape();
		addChild(selectionShape);

		background = true;
		backgroundColor = 0xEEEEEE;

        upperMask = new Sprite();
        caret = new Bitmap(new BitmapData(1, 1, false, 0x000000));
		caret.height = textField.defaultTextFormat.size;
		caret.x = caret.y = 2;
		caret.visible = false;
		caretTimer.addEventListener(TimerEvent.TIMER, caretBlink);

        addChild(upperMask);
        addChild(caret);
        Lib.application.window.onTextInput.add(regularKeysDown);
        Lib.application.window.onKeyDown.add(specialKeysDown);

		upperMask.scrollRect = new Rectangle(0, 0, textField.width, textField.height);
		lowerMask.scrollRect = new Rectangle(0, 0, textField.width, textField.height);
		selectionShape.scrollRect = new Rectangle(0, 0, textField.width, textField.height);

		textField.addEventListener(FocusEvent.FOCUS_IN, (e) -> stage.focus = this);
		addEventListener(Event.EXIT_FRAME, onMouseWheel);
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
			hasMoved = false;
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
		if (stage == null) return;
        hasFocus = false;
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

	function onMouseWheel(e:Event) {
		var yVal = getCharBoundaries(0);
		
		for (o in [upperMask, lowerMask, selectionShape]) {
			o.y = yVal.y;	
		}
	}

    public function getCaretIndexAtPoint(x:Float, y:Float):Int {
        if (text.length > 0)
		{
			for (i in 0...text.length)
			{
				var r = getCharBoundaries(i);
				//take scrolling into account
				if ((x >= r.x && x <= r.right && y >= r.y && y <= r.bottom)) return i;			
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
					return i + (if (scrollV == 1) 1 else 0) + StringTools.replace(textField.getLineText(line), "\n", "").length;
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
		if (textField.getCharBoundaries(charIndex) != null) {
			final bounds = textField.getCharBoundaries(charIndex);
			bounds.y -= bounds.height * (scrollV - 1);
			return bounds;
		}

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
			charBoundaries.y -= charBoundaries.height * (scrollV - 1);
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
			if (charBoundaries == null) charBoundaries = textField.getCharBoundaries(charIndex - 1);
			charBoundaries.x += widthDiff * charBoundaries.width - (width - 4) * (textField.getLineIndexOfChar(originalIndex) - textField.getLineIndexOfChar(charIndex));
			// guessing line height differences when lots of spacebars are pressed and are being wordwrapped
			charBoundaries.y = textField.getLineIndexOfChar(originalIndex) * charBoundaries.height;
			charBoundaries.y -= charBoundaries.height * (scrollV - 1);
		}
		return charBoundaries;
	}

    public function insertSubstring(insert:String, index:Int):TextFieldRTL
	{
		Lib.application.window.textInputEnabled = true; // patches loss of text input after copy/past/cut
		selectionShape.graphics.clear();
		if (insert == "bsp" || insert == "del") {
			if (selectedRange[0] != -1) {
				text = text.substring(0, selectedRange[0]) + text.substring(selectedRange[1] + 1);
				caretIndex = if (insert == "bsp") selectedRange[0] + 1 else selectedRange[0];
				setSelection(-1, -1);
			} else {
				text = text.substring(0, index) + text.substring(index + 1);
			}
			dispatchEvent(new Event(Event.CHANGE));
			return this;
		}

		if (selectedRange[0] != -1) {
			text = text.substring(0, selectedRange[0]) + insert + text.substring(selectedRange[1] + 1);
			caretIndex = selectedRange[0];
		}
		else text = text.substring(0, index) + insert + text.substring(index);
		dispatchEvent(new Event(Event.CHANGE));
		setSelection(-1, -1);
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
				trace("Paste");
				// paste text
				var clipboardText = Clipboard.generalClipboard.getData(TEXT_FORMAT);
				if (clipboardText == null)
					return;
				if (currentlyRTL)
				{
					insertSubstring(clipboardText, caretIndex);
					trace("Paste: " + clipboardText);
				}
				else
				{
					insertSubstring(clipboardText, caretIndex);
					caretIndex += clipboardText.length;
					if (caretIndex > text.length)
						caretIndex = text.length;
				}
			}
			if (key == KeyCode.C && selectedRange[0] != -1) {
				// copy text
				var clipboardText = text.substring(selectedRange[0], selectedRange[1] + 1);
				Clipboard.generalClipboard.setData(TEXT_FORMAT, clipboardText);
			}
			if (key == KeyCode.X && selectedRange[0] != -1) {
				// cut text
				var clipboardText = text.substring(selectedRange[0], selectedRange[1] + 1);
				Clipboard.generalClipboard.setData(TEXT_FORMAT, clipboardText);
				insertSubstring("del", selectedRange[0]);
			}
			if (key == KeyCode.A) {
				// select all
				setSelection(0, text.length - 1);
			}
			if (key == KeyCode.L) { //select the current line of text
				var lineIndex = getLineIndexOfChar(caretIndex);
				var lineStart = getLineOffset(lineIndex);
				setSelection(lineStart, lineStart + getLineLength(lineIndex) - 1);
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
					insertSubstring("bsp", caretIndex);
				}
				else
				{
					insertSubstring("bsp", caretIndex - 1);
					caretIndex--;
				}
				#else
				insertSubstring("bsp", caretIndex - 1);
				if (caretIndex != text.length) caretIndex--;
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
					insertSubstring("sel", caretIndex - 1);
					caretIndex--;
				}
				else
				{
					insertSubstring("del", caretIndex);
				}
			}
			#else
			insertSubstring("del", caretIndex);
			#end
		}
		else if (key == 13)
		{
			#if !js
			if (!currentlyRTL)
			{
				insertSubstring("\n", caretIndex);
				caretIndex++;
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
				caretIndex++;
			}
			#else
			insertSubstring("\n", caretIndex);
			caretIndex++;
			#end
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
			caretIndex += t.length;
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

	public function getLineMetrics(lineIndex:Int):TextLineMetrics
	{
		return textField.getLineMetrics(lineIndex);
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
        return textField.setTextFormat(format, beginIndex, endIndex);
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
		if (beginIndex != -1)
		{
			if (beginIndex > endIndex)
			{
				var temp:Int = beginIndex;
				beginIndex = endIndex;
				endIndex = temp;
			}
			if (beginIndex == endIndex) {
				selectionShape.graphics.clear();
				final bounds = textField.getCharBoundaries(beginIndex - 1);
				if (bounds == null) return; //edge case: textfield loses focus while selection occurs
				selectionShape.graphics.beginFill(0x333333, 0.2);
				selectionShape.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
				selectionShape.graphics.endFill();
			} else {
				selectionShape.graphics.clear();
				selectionShape.graphics.beginFill(0x333333, 0.2);
				var bounds:Rectangle;
				for (i in beginIndex...endIndex + 1) {
					bounds = textField.getCharBoundaries(i) != null ? textField.getCharBoundaries(i) : continue;
					selectionShape.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
				}
				selectionShape.graphics.endFill();
			}
		} else {
			selectionShape.graphics.clear();
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

	function set_caretIndex(index:Int):Int
	{
		setSelection(-1, -1);
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
		trace("caretY " + caret.y + " textFieldHeight " + textField.height);
		

		textField.setSelection(index, index);

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

	function set_selectable(selectable:Bool):Bool
	{
		if (!selectable)
		{
			selectionShape.graphics.clear();
			selectedRange = [-1, -1];
		}
		return this.selectable = selectable;
	}

	function get_textWidth():Float
	{
		return this.textField.textWidth;
	}

	function get_textHeight():Float
	{
		return this.textField.textHeight;
	}

	function get_maxChars():Int
	{
		return this.textField.maxChars;
	}

	function set_maxChars(value:Int):Int
	{
		return this.textField.maxChars = value;
	}

	function get_maxScrollH():Int
	{
		return this.textField.maxScrollH;
	}

	function get_maxScrollV():Int
	{
		return this.textField.maxScrollV;
	}

	function get_scrollH():Int
	{
		return this.textField.scrollH;
	}

	function set_scrollH(value:Int):Int
	{
		return this.textField.scrollH = value;
	}

	function get_scrollV():Int
	{
		return this.textField.scrollV;
	}

	function set_scrollV(value:Int):Int
	{
		return this.textField.scrollV = value;
	}

	function get_htmlText():String
	{
		return this.textField.htmlText;
	}

	function set_htmlText(value:String):String
	{
		return this.textField.htmlText = value;
	}

	function get_length():Int
	{
		return this.textField.length;
	}

	function get_embedFonts():Bool
	{
		return this.textField.embedFonts;
	}

	function set_embedFonts(value:Bool):Bool
	{
		return this.textField.embedFonts = value;
	}

	function set_markdownText(text:String):String
	{
		if (text == null || text == "") return "";
		this.text = text;
		Markdown.visualizeMarkdown(this);
		return text;
	}

	//----------------------------
	// overriden getters & setters
	//----------------------------

	override function set_width(value:Float):Float
	{
		textField.width = value;
		upperMask.scrollRect = new Rectangle(0, 0, textField.width, textField.height);
		lowerMask.scrollRect = new Rectangle(0, 0, textField.width, textField.height);
		selectionShape.scrollRect = new Rectangle(0, 0, textField.width, textField.height);

		return value;
	}

	override function set_height(value:Float):Float
	{
		textField.height = value;
		upperMask.scrollRect = new Rectangle(0, 0, textField.width, textField.height);
		lowerMask.scrollRect = new Rectangle(0, 0, textField.width, textField.height);
		selectionShape.scrollRect = new Rectangle(0, 0, textField.width, textField.height);
		return value;
	}
}

#end
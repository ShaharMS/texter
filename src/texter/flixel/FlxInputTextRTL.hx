package texter.flixel;

import flixel.util.FlxStringUtil;
#if flixel
#if js
import flixel.FlxG;
import flixel.text.FlxText.FlxTextAlign;
import haxe.Timer;
import openfl.geom.Rectangle;
#else
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import openfl.Lib;
import openfl.events.KeyboardEvent;
import texter.CharTools;
#end
import texter.flixel._internal.FlxInputText;
using StringTools;
#if js
/**
 * FlxInputText with support for RTL languages.
 */
class FlxInputTextRTL extends FlxInputText
{
	/**
	 * the input with which were going to capture key presses.
	 */
	var textInput:js.html.InputElement;

	/**
	 * Creates a new text input field with multilang support && multiline. 
	 * 
	 * for more info about supported features check the roadmap below:
	 * 
	 * https://github.com/ShaharMS/texter#roadmap
	 * 
	 * @param	X				The X position of the text.
	 * @param	Y				The Y position of the text.
	 * @param	Width			The width of the text object (height is determined automatically).
	 * @param	Text			The actual text you would like to display initially.
	 * @param   size			Initial size of the font
	 * @param	TextColor		The color of the text
	 * @param	BackgroundColor	The color of the background (FlxColor.TRANSPARENT for no background color)
	 * @param	EmbeddedFont	Whether this text field uses embedded fonts or not
	 */
	public function new(X:Float = 0, Y:Float = 0, Width:Int = 150, ?Text:String, size:Int = 8, TextColor:Int = flixel.util.FlxColor.BLACK,
			BackgroundColor:Int = flixel.util.FlxColor.WHITE, EmbeddedFont:Bool = true)
	{
		super(X, Y, Width, Text, size, TextColor, BackgroundColor, EmbeddedFont);
		wordWrap = true;
		getInput();
	}

	override function set_caretIndex(newCaretIndex:Int):Int
	{
		var offx:Float = 0;

		var alignStr:FlxTextAlign = getAlignStr();

		switch (alignStr)
		{
			case RIGHT:
				offx = textField.width - 2 - textField.textWidth - 2;
				if (offx < 0)
					offx = 0; // hack, fix negative offset.

			case CENTER:
				#if !js
				offx = (textField.width - 2 - textField.textWidth) / 2 + textField.scrollH / 2;
				#end
				if (offx <= 1)
					offx = 0; // hack, fix ofset rounding alignment.

			default:
				offx = 0;
		}

		caretIndex = newCaretIndex;

		// If caret is too far to the right something is wrong
		if (caretIndex > (text.length + 1))
		{
			caretIndex = -1;
		}

		// Caret is OK, proceed to position
		if (caretIndex != -1)
		{
			var boundaries:Rectangle = null;

			// Caret is not to the right of text
			if (caretIndex < text.length)
			{
				boundaries = getCharBoundaries(caretIndex);
				if (boundaries != null)
				{
					caret.x = offx + boundaries.left + x;
					caret.y = boundaries.top + y;
				}
			}
			// Caret is to the right of text
			else
			{
				boundaries = getCharBoundaries(caretIndex - 1);
				if (boundaries != null)
				{
					caret.x = offx + boundaries.right + x;
					caret.y = boundaries.top + y;
				}
				// Text box is empty
				else if (text.length == 0)
				{
					// 2 px gutters
					caret.x = x + offx + 2;
					caret.y = y + 2;
				}
			}
		}

		#if !js
		caret.x -= textField.scrollH;
		#end
		var trueWidth:Float = 0;
		var tWidth:Float = 0;
		// fix for RTL languages to implement correct caret positioning without actually altering caretIndex
		if (caretIndex > 0 && text.length > 0)
		{
			for (char in [for (i in 0...caretIndex + 1) getCharBoundaries(i).width])
				trueWidth += char;
			for (char in [for (i in 0...text.length + 1) getCharBoundaries(i).width])
				tWidth += char;
			if (CharTools.rtlLetterArray.contains(text.charAt(caretIndex - 1)))
				caret.x = tWidth - trueWidth + 2;
		}

		// Make sure the caret doesn't leave the textfield on single-line input texts
		if ((lines == 1) && (caret.x + caret.width) > (x + width))
		{
			caret.x = x + width - 2;
		}

		return caretIndex;
	}

	/**
		 The original `onKeyDown` from `FlxInputText` is replaced with four functions - 

		| Function | Job |
		| --- | --- |
		| **`getInput()`** | used to set up the input element with which were going to listen to text input from |
		| **`updateInput()`** | called every frame, selects the input element to continue listening for text input |
		| **`typeChar(String)`** | called when special keys (spacebar, backspace...) are pressed since `getInput()` can't listen to those |
		| **`update(Float)`** | called every frame, checks if one of the special keys (spacebar, backspace...) is pressed to call `typeChar(String)` |
	**/
	override function onKeyDown(e:flash.events.KeyboardEvent) {}

	/**
	 * Exists to set up the input element, with which
	 * were going to listen for text input
	 */
	function getInput()
	{
		textInput = cast js.Browser.document.createElement('input');
		textInput.type = 'text';
		textInput.style.position = 'absolute';
		textInput.style.opacity = "0";
		textInput.style.color = "transparent";
		textInput.value = String.fromCharCode(127);
		textInput.style.left = "0px";
		textInput.style.top = "50%";
		untyped textInput.style.pointerEvents = 'none';
		textInput.style.zIndex = "-10000000";
		js.Browser.document.body.appendChild(textInput);
		textInput.addEventListener('input', (e:js.html.InputEvent) ->
		{
			if (caretIndex < 0)
				caretIndex = 0;
			if (textInput.value.length > 0 && (maxLength == 0 || (text.length + textInput.value.length) < maxLength))
			{
				text = insertSubstring(text, textInput.value, caretIndex);
				caretIndex++;
				// text = WordWrapper.wrapVisual(this);
				text = text;
			}
		}, true);
	}

	/**
	 * Were getting the text from an invisible input text and it isnt openFL/flixel related.
	 * we have to keep it selected
	 */
	function updateFocus()
	{
		if (hasFocus)
		{
			textInput.focus();
			textInput.select();
		}
	}

	/**
		 Used to get special char inputs:

		| Type | Action |
		| --- | --- |
		| **`"bsp"`** | Backspace Action |
		| **`"del"`** | Delete Action |
		| **`" "`** | Spacebar Action |
		| **`"enter"`** | Enter Action |

		@param char Should be one of the `Type`s, not case sensitive
	**/
	function typeChar(?char:String = "")
	{
		char = char.toLowerCase();
		if (char == "bsp")
		{
			if (caretIndex > 0)
			{
				caretIndex--;
				text = text.substring(0, caretIndex) + text.substring(caretIndex + 1);
				onChange(FlxInputText.BACKSPACE_ACTION);
				text = text;
				if (text == "")
					refresh();
				Timer.delay(() ->
				{
					var t:Timer;
					t = new Timer(16);
					t.run = () ->
					{
						if (FlxG.keys.pressed.BACKSPACE)
						{
							caretIndex--;
							text = text.substring(0, caretIndex) + text.substring(caretIndex + 1);
							onChange(FlxInputText.BACKSPACE_ACTION);
							text = text;
							if (text == "")
								refresh();
						}
						else
							t.stop();
					};
				}, 500);
			}
		}
		else if (char == "del")
		{
			if (text.length > 0 && caretIndex < text.length)
			{
				text = text.substring(0, caretIndex) + text.substring(caretIndex + 1);
				onChange(FlxInputText.DELETE_ACTION);
				text = text;
				if (text == "")
					refresh();
				Timer.delay(() ->
				{
					var t:Timer;
					t = new Timer(16);
					t.run = () ->
					{
						if (FlxG.keys.pressed.DELETE)
						{
							text = text.substring(0, caretIndex) + text.substring(caretIndex + 1);
							onChange(FlxInputText.DELETE_ACTION);
							text = text;
							if (text == "")
								refresh();
						}
						else
							t.stop();
					};
				}, 500);
			}
		}
		else if (char == "enter" && wordWrap)
			text += "\n";
		else if (char == " ")
		{ // TODO - RTL spacebar logic on JS
			if (char.length > 0 && (maxLength == 0 || (text.length + char.length) < maxLength))
			{
				text = insertSubstring(text, char, caretIndex);
				caretIndex++;
				text = text;
			}
			Timer.delay(() ->
			{
				var t:Timer;
				t = new Timer(16);
				t.run = () ->
				{
					if (FlxG.keys.pressed.BACKSPACE)
					{
						if (char.length > 0 && (maxLength == 0 || (text.length + char.length) < maxLength))
						{
							text = insertSubstring(text, char, caretIndex);
							caretIndex++;
							text = text;
						}
					}
					else
						t.stop();
				};
			}, 500);
		}
	}

	/**
			 	JS FlxInputText has problems with the first char not disappearing
		when you delete all of the chars. a lazy and temporary solution is
		to just refresh the FlxInputTextRTL
	**/
	function refresh()
	{
		var nText = new FlxInputTextRTL(this.x, this.y, Std.int(this.width), "", this.size, this.color, this.backgroundColor, this.embedded);
		Timer.delay(() -> nText.hasFocus = true, 20);
		nText.passwordMode = this.passwordMode;
		nText.filterMode = this.filterMode;
		FlxG.state.insert(FlxG.state.members.indexOf(this) + 1, nText);
		FlxG.state.remove(this);
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);
		updateFocus();
		if (hasFocus)
		{
			if (FlxG.keys.justPressed.SPACE)
				typeChar(" ");
			if (FlxG.keys.justPressed.ENTER)
				typeChar("enter");
			else if (FlxG.keys.justPressed.BACKSPACE)
			{
				if (text == "")
					refresh()
				else
					typeChar("bsp");
			}
			else if (FlxG.keys.justPressed.DELETE)
				typeChar("del");
			if (FlxG.keys.justPressed.LEFT)
				if (caretIndex > 0)
					caretIndex--;
				else if (FlxG.keys.justPressed.RIGHT)
					if (caretIndex < text.length)
						caretIndex++;
			if (FlxG.keys.justPressed.UP && wordWrap) {}
			else if (FlxG.keys.justPressed.DOWN && wordWrap) {}
			if (FlxG.keys.justPressed.HOME)
				caretIndex = 0;
			else if (FlxG.keys.justPressed.END)
				caretIndex = text.length;
		}
	}
}
#else

/**
 * Reguar FlxInputText with extended support for:
 * - All languages
 * - Bi-directional text
 * - Multilne (Almost!)
 */
class FlxInputTextRTL extends FlxInputText
{

	/**
	    Whether the text is aligned according to the first typed character:
	    
	     - if the character is from a RTL language - `alignment` will be set to `RIGHT`
		 - if the character is from any othe language - `alignment` will be set to `LEFT`
	    
	**/
	public var autoAlign(default, set):Bool = true;

	/**
	 * Specifies the direction of the starting character inside this text input.
	 * 
	 * the text direction will only be set according to `openingDirection` if `autoAlign` is set to true.
	 * 
	 * `openingDirection` is decided after the first strongly typed character is typed. a table to help:
	 * 
	 * | Character Group | Type | Direction |
	 * |	   --- 	     | ---  |    ---    |
	 * | punctuation marks (see `CharTools.punctuationMarks`) | softly typed | UNDEFINED |
	 * | LTR languages (English, Spanish, French, German...) | strongly typed | LTR |
	 * | RTL languages (Arabic, Hebrew, Sorani, Urdu...) | strongly typed | RTL |
	 * 
	 */
	public var openingDirection(default, null):TextDirection = UNDETERMINED;

	var currentlyRTL:Bool = false;
	var startedTypingRTL:Bool = false;

	/**
	 * Creates a new text input with extra features & bug fixes that the regular `FlxInputText` doesnt have:
	 * 
	 * - multilne
	 * - multiple languages
	 * - LTR & RTL support both in the same text input
	 * - fully working caret
	 *
	 * @param	X				The X position of the text.
	 * @param	Y				The Y position of the text.
	 * @param	Width			The width of the text object (height is determined automatically).
	 * @param	Text			The actual text you would like to display initially.
	 * @param   size			Initial size of the font
	 * @param	TextColor		The color of the text
	 * @param	BackgroundColor	The color of the background (FlxColor.TRANSPARENT for no background color)
	 * @param	EmbeddedFont	Whether this text field uses embedded fonts or not
	 */
	public function new(X:Float = 0, Y:Float = 0, Width:Int = 150, ?Text:String, size:Int = 8, TextColor:Int = flixel.util.FlxColor.BLACK, BackgroundColor:Int = flixel.util.FlxColor.WHITE, EmbeddedFont:Bool = true)
	{
		super(X, Y, Width, Text, size, TextColor, BackgroundColor, EmbeddedFont);
		wordWrap = true;

		Lib.application.window.onTextInput.add(regularKeysDown, false, 1);
		Lib.application.window.onKeyDown.add(specialKeysDown, false, 2);
	}

	/**
		The original `onKeyDown` from `FlxInputText` is replaced with two functions - 

		| Function | Job |
		| --- | --- |
		| **`specialKeysDown(KeyCode, KeyModifier)`** | used to get "editing" keys (backspace, capslock, arrow keys...) |
		| **`regularKeysDown(String)`** | used to get "input" keys - regular letters of all languages and directions |
	**/
	override function onKeyDown(e:KeyboardEvent) return;

	/**
		This function replaces `onKeyDown` with support for `delete`, `backspace`, arrow keys and more.
		`specialKeysDown()` is one of two functions, and is utilizing `window.onKeyDown` to get button
		presses, so pay attention to that when overriding.

		@param key the keycode of the current key that was presses according to lime's `window.onKeyDown`
		@param modifier information about modifying buttons and if theyre on or not - `ctrl`, `shift`, `alt`, `capslock`...
	**/
	function specialKeysDown(key:KeyCode, modifier:KeyModifier)
	{
		// if the user didnt intend to edit the text, dont do anything
		if (!hasFocus) return;
		// those keys break the caret and place it in caretIndex -1
		if (modifier.altKey || modifier.shiftKey || modifier.ctrlKey || modifier.metaKey) return;

		// fix the caret if its broken
		if (caretIndex < 0)
			caretIndex = 0;
	
		if (key == KeyCode.RIGHT)
		{
			if (caretIndex < text.length)
			{
				caretIndex++;
			}
		}
		if (key == KeyCode.LEFT)
		{
			if (caretIndex > 0)
			{
				caretIndex--;
			}
		}
		if (key == KeyCode.DOWN)
		{ 
			// count the amount of letters in a line, and just add them to the caretIndex
			var lettersInTheLine = 0, caretIndexReference = caretIndex, startY = getCharBoundaries(caretIndexReference).y;
			// escape the caret reference to the first letter in the line, count from there
			while (getCharBoundaries(caretIndexReference).y == startY && caretIndexReference >= 0)
			{
				caretIndexReference--;
				if (getCharBoundaries(caretIndexReference).width == 0)
					lettersInTheLine++;
			}

			caretIndexReference++;

			while (getCharBoundaries(caretIndexReference).y == startY && caretIndexReference <= text.length)
			{
				caretIndexReference++;
				lettersInTheLine++;
			}
			caretIndex += lettersInTheLine;
			// now try to get the wanted caret index at the next line
		}
		if (key == KeyCode.UP)
		{
			// count the amount of letters in a line, and just subtract them from the caretIndex
			var lettersInTheLine = 0;
			var caretIndexReference = caretIndex;
			var startY = getCharBoundaries(caretIndexReference).y;
			// escape the caret reference to the first letter in the line, count from there
			while (getCharBoundaries(caretIndexReference).y == startY && caretIndexReference >= 0)
			{
				caretIndexReference--;
				if (getCharBoundaries(caretIndexReference).width == 0)
					lettersInTheLine++;
			}

			caretIndexReference++;

			while (getCharBoundaries(caretIndexReference).y == startY && caretIndexReference <= text.length)
			{
				caretIndexReference++;
				lettersInTheLine++;
			}

			caretIndex -= lettersInTheLine;
			// now try to get the wanted caret index at the previous line
		}


		else if (key == KeyCode.BACKSPACE)
		{
			if (caretIndex > 0)
			{
				if (CharTools.rtlLetters.match(text.charAt(caretIndex + 1)) || CharTools.rtlLetters.match(text.charAt(caretIndex)))
				{
					text = text.substring(0, caretIndex) + text.substring(caretIndex + 1);
				}
				else
				{
					caretIndex--;
					text = text.substring(0, caretIndex) + text.substring(caretIndex + 1);
				}

				onChange(FlxInputText.BACKSPACE_ACTION);
			}
		}
		else if (key == KeyCode.DELETE)
		{
			if (text.length > 0 && caretIndex < text.length)
			{
				if (CharTools.rtlLetters.match(text.charAt(caretIndex + 1)) || CharTools.rtlLetters.match(text.charAt(caretIndex)))
				{
					text = text.substring(0, caretIndex - 1) + text.substring(caretIndex);
					caretIndex--;
				}
				else
				{
					text = text.substring(0, caretIndex) + text.substring(caretIndex + 1);
				}
				onChange(FlxInputText.DELETE_ACTION);
			}
		}
		else if (key == 13)
		{
			caretIndex++;
			if (!currentlyRTL) {
				text = insertSubstring(text, "\n", caretIndex - 1);
			} else {
				var insertionIndex = caretIndex;
				//starts a search for the last RTL char and places the "\n" there
				//if the string ends and theres still no last RTl char, "\n" will be insterted at length.
				while (CharTools.rtlLetters.match(text.charAt(insertionIndex)) || text.charAt(insertionIndex) == " " && insertionIndex != text.length) insertionIndex ++;
				text = insertSubstring(text, "\n", insertionIndex);
				caretIndex = insertionIndex + 1;
			}
			onChange(FlxInputText.ENTER_ACTION);
		}
		else if (key == KeyCode.END) caretIndex = text.length;
		else if (key == KeyCode.HOME) caretIndex = 0;

	}

	/**
	 * This function replaces `onKeyDown` with support for RTL & LTR letter input
	 * `regularKeysDown()` is one of two functions, and is utilizing `window.onKeyDown` to get button
	 * presses, so pay attention to that when overriding.
	 * @param letter the letter outputted from the current key-press according to lime's `window.onTextInput`
	 */
	function regularKeysDown(letter:String)
	{
		// if the user didnt intend to edit the text, dont do anything
		if (!hasFocus) return;
		// if the caret is broken for some reason, fix it
		if (caretIndex < 0) caretIndex = 0;
		// set up the letter - remove null chars, add rtl mark to letters from RTL languages
		var t:String = "", hasConverted:Bool = false, addedSpace:Bool = false;
		if (letter != null)
		{
			if (CharTools.rtlLetters.match(letter) || (currentlyRTL && letter == " "))
			{
				t = CharTools.RLO + letter;
				currentlyRTL = true;
				if (text.length == 0) {
					if (autoAlign) alignment = RIGHT;
					openingDirection = RTL;
				}
			}
			else if (currentlyRTL)
			{
				t = CharTools.PDF + letter;
				currentlyRTL = false;
				hasConverted = true;

				// after conversion, the caret needs to move itself to he end of the RTL text.
				// the last spacebar also needs to be moved
				if (text.charAt(caretIndex) == " ") {
					t = CharTools.PDF + " " + letter;
					text = text.substring(0, caretIndex) + text.substring(caretIndex, text.length);
					addedSpace = true;
				}
				caretIndex++;
				
				while (CharTools.rtlLetters.match(text.charAt(caretIndex)) || text.charAt(caretIndex) == " " && caretIndex != text.length) caretIndex++; 
			}
			else {
				t = letter;
				if (text.length == 0) {
					if (autoAlign) alignment = LEFT;
					if (t.indexOf(",.<>/?:;'\\[]{}()!@#$%^&*`~|+=_-") != -1) openingDirection = UNDETERMINED else openingDirection = LTR;
				}
			}
		}
		else "";
		if (t.length > 0 && (maxLength == 0 || (text.length + t.length) < maxLength)) 
		{
			//TODO - better caret handling
			caretIndex++;

			text = insertSubstring(text, t, caretIndex - 1);
			if (hasConverted) caretIndex++;
			if (addedSpace) caretIndex++;

			onChange(FlxInputText.INPUT_ACTION);
		}
	}

	function set_autoAlign(value:Bool):Bool {
		if (!CharTools.rtlLetters.match(text.charAt(0))) {
			alignment = LEFT;
		} else {
			alignment = RIGHT;
		}
		return value;
	}
}
#end

enum TextDirection {
	RTL;
	LTR;
	UNDETERMINED;
}
#end

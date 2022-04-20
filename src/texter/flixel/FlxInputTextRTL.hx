#if flixel
package texter.flixel;


import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import openfl.events.KeyboardEvent;
import texter.general.CharTools;
import flixel.FlxG;
import openfl.desktop.Clipboard;
import texter.flixel._internal.FlxInputText;
import texter.general.TextTools.TextDirection;

using StringTools;

/**
 * Reguar FlxInputText with extended support for:
 * - Multilanguage
 * - Bi-directional text
 * - Copy/Paste
 * - Auto-align
 * - Multilne
 */
class FlxInputTextRTL extends FlxInputText
{
	/**
		Whether the text is aligned according to the first typed character:

		 - if the character is from a RTL language - `alignment` will be set to `RIGHT`.
		 - if the character is from any other language - `alignment` will be set to `LEFT`.
		 - if the character is not from any specific language - `alignment` will be set to `UNDETERMINED`.
		
		
		
		 **`autoAlign` does not default to a certine direction when set to `false`**. it will
		use the last direction it remembers when this `FlxInputTextRTL` was created/when `autoAlign` was still true;
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

	var currentlyRTL:Bool = false;
	var currentlyNumbers:Bool = false;
	/**
		Creates a new text input with extra features & bug fixes that the regular `FlxInputText` doesnt have:

		- multilne
		- multiple languages
		- LTR & RTL support both in the same text input
		- fully working caret

		@param	X				The X position of the text.
		@param	Y				The Y position of the text.
		@param	Width			The width of the text object (height is determined automatically).
		@param	Text			The actual text you would like to display initially.
		@param  size			Initial size of the font
		@param	TextColor		The color of the text
		@param	BackgroundColor	The color of the background (FlxColor.TRANSPARENT for no background color)
		@param	EmbeddedFont	Whether this text field uses embedded fonts or not
	**/
	public function new(X:Float = 0, Y:Float = 0, Width:Int = 150, ?Text:String, size:Int = 8, TextColor:Int = flixel.util.FlxColor.BLACK,
			BackgroundColor:Int = flixel.util.FlxColor.WHITE, EmbeddedFont:Bool = true)
	{
		super(X, Y, Width, Text, size, TextColor, BackgroundColor, EmbeddedFont);
		wordWrap = true;
		FlxG.stage.window.onTextInput.add(regularKeysDown, false, 1);
		FlxG.stage.window.onKeyDown.add(specialKeysDown, false, 2);
		#if js FlxG.stage.window.onFocusOut.add(() -> hasFocus = false); #end
		
	}

	#if js
	override function update(elapsed:Float) {
		if (FlxG.keys.justPressed.SPACE) {
			regularKeysDown(" ");
		}
		super.update(elapsed);
	}
	#end

	override function set_hasFocus(newFocus:Bool):Bool {
		FlxG.stage.window.textInputEnabled = true;
		FlxG.sound.soundTrayEnabled = !newFocus;
		return super.set_hasFocus(newFocus);
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
		if (!hasFocus)
			return;
		// handle copy-paste
		if (modifier.ctrlKey) {
			if (key == KeyCode.V) {
				//paste text
				var clipboardText = Clipboard.generalClipboard.getData(TEXT_FORMAT);
				if (clipboardText == null) return;
				if (currentlyRTL) {
					text = insertSubstring(text, clipboardText, caretIndex);
				} else {
					text = insertSubstring(text, clipboardText, caretIndex);
					caretIndex += clipboardText.length;
					if (caretIndex > text.length) caretIndex = text.length;
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
					text = text.substring(0, caretIndex) + text.substring(caretIndex + 1);
				}
				else
				{
					caretIndex--;
					text = text.substring(0, caretIndex) + text.substring(caretIndex + 1);
				}
				#else
				caretIndex--;
				text = text.substring(0, caretIndex) + text.substring(caretIndex + 1);
				#end

				onChange(FlxInputText.BACKSPACE_ACTION);
			}
		}
		else if (key == KeyCode.DELETE)
		{
			#if !js
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
			#else
			text = text.substring(0, caretIndex) + text.substring(caretIndex + 1);
			#end
		}
		else if (key == 13)
		{
			caretIndex++;
			if (!currentlyRTL)
			{
				text = insertSubstring(text, "\n", caretIndex - 1);
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
				text = insertSubstring(text, "\n", insertionIndex);
				caretIndex = insertionIndex + 1;
			}
			onChange(FlxInputText.ENTER_ACTION);
		}
		else if (key == KeyCode.END) {
			caretIndex = text.length;
			onChange(FlxInputText.END_ACTION);
		}
		else if (key == KeyCode.HOME) {
			caretIndex = 0;
			onChange(FlxInputText.HOME_ACTION);
		}
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
					if (autoAlign) alignment = RIGHT;
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

		#else t = letter; #end
		if (t.length > 0 && (maxLength == 0 || (text.length + t.length) < maxLength))
		{
			caretIndex += t.length;
			text = insertSubstring(text, t, caretIndex - 1);
			if (hasConverted) caretIndex++;
			if (addedSpace) caretIndex++;
			onChange(FlxInputText.INPUT_ACTION);
		}
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
}
#end
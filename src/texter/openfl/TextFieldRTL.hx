package texter.openfl;

#if openfl
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import openfl.Lib;
import openfl.desktop.Clipboard;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.MouseEvent;
import openfl.events.TimerEvent;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextLineMetrics;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;
import openfl.utils.ByteArray;
import openfl.utils.Timer;
import texter.general.CharTools;
import texter.general.TextTools.TextDirection;
import texter.general.markdown.Markdown;

/**
 * `TextFieldRTL` is an "extention" of `TextField` that adds support for multiple things:
 *  - right-to-left text
 *  - built-in markdown visualization
 * 
 * It also adds some convenience methods & fields for working with the object, that `TextField` doesn't have:
 * 
 *  - alignment
 *  - overlay
 *  - underlay
 *  - markdownText
 *  - editable `caretIndex`
 *  - hasFocus
 *  - insertSubstring()
 *  - getCaretIndexAtPoint()
 *  - getCaretIndexOfMouse()
 * 
 * And more.
 */
class TextFieldRTL extends Sprite
{
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
	 * This `Sprite` is a "mask" that exists above the actual text. You can 
	 * draw on it, add `DisplayObject`s to it, etc.
	 */
	public var overlay:Sprite;

	/**
	 * This `Sprite` is a "mask" that exists below the actual text. You can 
	 * draw on it, add `DisplayObject`s to it, etc.
	 * 
	 * **NOTICE** - setting the `background` property to `true` will hide the underlay.
	 */
	public var underlay:Sprite;

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
	 * **Note** - when using the `underlay` property, you might want to set the `background` property
	 * to false. this also means the color applied here wont do anything. If you want to color the `underlay`'s
	 * background, you can do this:
	 * ```haxe
	 * underlay.graphics.beginFill(yourColor);
	 * underlay.graphics.drawRect(0, 0, textField.width, textField.textHeight);
	 * underlay.graphics.endFill();
	 * ```
	 */
	public var backgroundColor(get, set):Int;

	/**
	 * Whether or not this `TextFieldRTL` has a background.
	 * 
	 * **Note** - when using the `underlay` property, you might want to set this property to false to avoid hiding the `underlay`.
	 */
	public var background(get, set):Bool;

	/**
	 * Whether or not the this textfield will try to escape words that are too long to fit in the textfield.
	 * 
	 * without wordWrap (whats outside of the textfield isnt visible):
	 * 
	 * ```txt
	 * ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
	 * ▏hello there everyone▎its your friend here
	 * ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔
	 * ```
	 * 
	 * with wordWrap:
	 * ```txt
	 * ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
	 * ▏hello there everyone▎
	 * ▏its your friend here▎
	 * ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔
	 * ```
	 */
	public var wordWrap(get, set):Bool;

	/**
	 * Whether or not this field of text will accept multiline
	 * input (make another line when adding a `\n`)
	 */
	public var multiline(get, set):Bool;

	/**
	 * Whether or not this field of text is currently in focus.
	 * 
	 * In INPUT mode, when the user clicks on the textfield, it will gain focus and the user can start typing.
	 * In STAIC and DYNAMIC modes, the textfield gains focus whenever the user clicks on it/starts selecting text.
	 */
	public var hasFocus(get, set):Bool;

	/**
		Specifies the format applied to newly inserted text, such as text entered
		by a user or text inserted with the `replaceSelectedText()`
		method.

		**Note:** When selecting characters to be replaced with
		`setSelection()` and `replaceSelectedText()`, the
		`defaultTextFormat` will be applied only if the text has been
		selected up to and including the last character. Here is an example:

		```haxe
		var textField:TextField = new TextField();
		textField.text = "Flash Macintosh version";
		var format:TextFormat = new TextFormat();
		format.color = 0xFF0000; 
		textField.defaultTextFormat = format;
		textField.setSelection(6,15); // partial text selected - defaultTextFormat not applied 
		textField.setSelection(6,23); // text selected to end - defaultTextFormat applied 
		textField.replaceSelectedText("Windows version");
		```

		When you access the `defaultTextFormat` property, the
		returned TextFormat object has all of its properties defined. No property
		is `null`.

		**Note:** You can't set this property if a style sheet is applied to
		the text field.
	**/
	public var defaultTextFormat(get, set):TextFormat;

	/**
		The type of the text field.
		| mode | description |
		| --- | --- |
		| `TextFieldType.DYNAMIC` | If you load text into the `TextField` by using the `text` or `htmlText` property and then you want to display the loaded text, set the `type` property of the `TextField` to `TextFieldType.DYNAMIC`.
		| `TextFieldType.INPUT` | If you do not want the text in the `TextField` to be editable, set the `type` property of the `TextField` to `TextFieldType.INPUT`.
	**/
	public var type(get, set):TextFieldType;

	/**
		Specifies whether the text field has a border. If `true`, the
		text field has a border. If `false`, the text field has no
		border. Use the `borderColor` property to set the border color.

		defaults to false.
	**/
	public var border(get, set):Bool;

	/**
		The color of the text field border. The default value is
		`0x000000`(black). This property can be retrieved or set, even
		if there currently is no border. the color is visible only
		if the text field has the `border` property set to `true`.
	**/
	public var borderColor(get, set):Int;

	/**
		A Boolean value that indicates whether the text field is selectable. The
		value `true` indicates that the text is selectable. The
		`selectable` property controls whether a text field is
		selectable, not whether a text field is editable. A dynamic text field can
		be selectable even if it is not editable. If a dynamic text field is not
		selectable, the user cannot select its text.

		If `selectable` is set to `false`, the text in
		the text field does not respond to selection commands from the mouse or
		keyboard, and the text cannot be copied with the Copy command. If
		`selectable` is set to `true`, the text in the text
		field can be selected with the mouse or keyboard, and the text can be
		copied with the Copy command. You can select text this way even if the
		text field is a dynamic text field instead of an input text field.

		defaults to true.
	**/
	public var selectable(default, set):Bool;

	/**
	 * Whether or not this field of text uses embedded fonts
	 */
	public var embedFonts(get, set):Bool;

	/**
	 * The width of the text, in pixels.
	 */
	public var textWidth(get, null):Float;

	/**
	 * The height of the text, in pixels.
	 */
	public var textHeight(get, null):Float;

	/**
	 * The maximum number of characters that the text field can contain, as entered
	 * by a user. A script can insert more text than
	 * `maxChars` allows; the `maxChars` property indicates only how much text a
	 * user can enter. If the value of this property is `0`, a user can enter an
	 * unlimited amount of text.
	 */
	public var maxChars(get, set):Int;

	/**
	 * The maximum value of `scrollH` - the maximum amount of horizontal scrolling.
	 */
	public var maxScrollH(get, never):Int;

	/**
	 * The maximum value of `scrollV` - the maximum amount of vertical scrolling.
	 */
	public var maxScrollV(get, never):Int;

	/**
		The current horizontal scrolling position. If the `scrollH`
		property is 0, the text is not horizontally scrolled. This property value
		is an integer that represents the horizontal position in pixels.

		The units of horizontal scrolling are pixels, whereas the units of
		vertical scrolling are lines. Horizontal scrolling is measured in pixels
		because most fonts you typically use are proportionally spaced; that is,
		the characters can have different widths. Flash Player performs vertical
		scrolling by line because users usually want to see a complete line of
		text rather than a partial line. Even if a line uses multiple fonts, the
		height of the line adjusts to fit the largest font in use.

		**Note: **The `scrollH` property is zero-based, not
		1-based like the `scrollV` vertical scrolling property.
	**/
	public var scrollH(get, set):Int;

	/**
		The vertical position of text in a text field. The `scrollV`
		property is useful for directing users to a specific paragraph in a long
		passage, or creating scrolling text fields.

		The units of vertical scrolling are lines, whereas the units of
		horizontal scrolling are pixels. If the first line displayed is the first
		line in the text field, scrollV is set to 1(not 0). Horizontal scrolling
		is measured in pixels because most fonts are proportionally spaced; that
		is, the characters can have different widths. Flash performs vertical
		scrolling by line because users usually want to see a complete line of
		text rather than a partial line. Even if there are multiple fonts on a
		line, the height of the line adjusts to fit the largest font in use.
	**/
	public var scrollV(get, set):Int;

	/**
	 * A shortcut to `text.length`.
	 */
	public var length(get, null):Int;

	/**
		Contains the HTML representation of the text field contents.
		Flash Player supports the following HTML tags:

		| Tag |  Description  |
		| --- | --- |
		| Anchor tag | The `<a>` tag creates a hypertext link and supports the following attributes:<ul><li>`target`: Specifies the name of the target window where you load the page. Options include `_self`, `_blank`, `_parent`, and `_top`. The `_self` option specifies the current frame in the current window, `_blank` specifies a new window, `_parent` specifies the parent of the current frame, and `_top` specifies the top-level frame in the current window.</li><li>`href`: Specifies a URL or an ActionScript `link` event.The URL can be either absolute or relative to the location of the SWF file that is loading the page. An example of an absolute reference to a URL is `http://www.adobe.com`; an example of a relative reference is `/index.html`. Absolute URLs must be prefixed with http://; otherwise, Flash Player or AIR treats them as relative URLs. You can use the `link` event to cause the link to execute an ActionScript function in a SWF file instead of opening a URL. To specify a `link` event, use the event scheme instead of the http scheme in your `href` attribute. An example is `href="event:myText"` instead of `href="http://myURL"`; when the user clicks a hypertext link that contains the event scheme, the text field dispatches a `link` TextEvent with its `text` property set to "`myText`". You can then create an ActionScript function that executes whenever the link TextEvent is dispatched. You can also define `a:link`, `a:hover`, and `a:active` styles for anchor tags by using style sheets.</li></ul> |
		| Bold tag | The `<b>` tag renders text as bold. A bold typeface must be available for the font used. |
		| Break tag | The `<br>` tag creates a line break in the text field. Set the text field to be a multiline text field to use this tag.  |
		| Font tag | The `<font>` tag specifies a font or list of fonts to display the text.The font tag supports the following attributes:<ul><li>`color`: Only hexadecimal color (`#FFFFFF`) values are supported.</li><li>`face`: Specifies the name of the font to use. As shown in the following example, you can specify a list of comma-delimited font names, in which case Flash Player selects the first available font. If the specified font is not installed on the local computer system or isn't embedded in the SWF file, Flash Player selects a substitute font.</li><li>`size`: Specifies the size of the font. You can use absolute pixel sizes, such as 16 or 18, or relative point sizes, such as +2 or -4.</li></ul> |
		| Image tag | The `<img>` tag lets you embed external image files (JPEG, GIF, PNG), SWF files, and movie clips inside text fields. Text automatically flows around images you embed in text fields. You must set the text field to be multiline to wrap text around an image.<br>The `<img>` tag supports the following attributes:<ul><li>`src`: Specifies the URL to an image or SWF file, or the linkage identifier for a movie clip symbol in the library. This attribute is required; all other attributes are optional. External files (JPEG, GIF, PNG, and SWF files) do not show until they are downloaded completely.</li><li>`width`: The width of the image, SWF file, or movie clip being inserted, in pixels.</li><li>`height`: The height of the image, SWF file, or movie clip being inserted, in pixels.</li><li>`align`: Specifies the horizontal alignment of the embedded image within the text field. Valid values are `left` and `right`. The default value is `left`.</li><li>`hspace`: Specifies the amount of horizontal space that surrounds the image where no text appears. The default value is 8.</li><li>`vspace`: Specifies the amount of vertical space that surrounds the image where no text appears. The default value is 8.</li><li>`id`: Specifies the name for the movie clip instance (created by Flash Player) that contains the embedded image file, SWF file, or movie clip. This approach is used to control the embedded content with ActionScript.</li><li>`checkPolicyFile`: Specifies that Flash Player checks for a URL policy file on the server associated with the image domain. If a policy file exists, SWF files in the domains listed in the file can access the data of the loaded image, for example, by calling the `BitmapData.draw()` method with this image as the `source` parameter. For more information related to security, see the Flash Player Developer Center Topic: [Security](http://www.adobe.com/go/devnet_security_en).</li></ul>Flash displays media embedded in a text field at full size. To specify the dimensions of the media you are embedding, use the `<img>` tag `height` and `width` attributes. <br>In general, an image embedded in a text field appears on the line following the `<img>` tag. However, when the `<img>` tag is the first character in the text field, the image appears on the first line of the text field.<br>For AIR content in the application security sandbox, AIR ignores `img` tags in HTML content in ActionScript TextField objects. This is to prevent possible phishing attacks. |
		| Italic tag | The `<i>` tag displays the tagged text in italics. An italic typeface must be available for the font used. |
		| List item tag | The `<li>` tag places a bullet in front of the text that it encloses.<br>**Note:** Because Flash Player and AIR do not recognize ordered and unordered list tags (`<ol>` and `<ul>`, they do not modify how your list is rendered. All lists are unordered and all list items use bullets. |
		| Paragraph tag | The `<p>` tag creates a new paragraph. The text field must be set to be a multiline text field to use this tag. The `<p>` tag supports the following attributes:<ul><li>align: Specifies alignment of text within the paragraph; valid values are `left`, `right`, `justify`, and `center`.</li><li>class: Specifies a CSS style class defined by a openfl.text.StyleSheet object.</li></ul> |
		| Span tag | The `<span>` tag is available only for use with CSS text styles. It supports the following attribute:<ul><li>class: Specifies a CSS style class defined by a openfl.text.StyleSheet object.</li></ul> |
		| Text format tag | The `<textformat>` tag lets you use a subset of paragraph formatting properties of the TextFormat class within text fields, including line leading, indentation, margins, and tab stops. You can combine `<textformat>` tags with the built-in HTML tags.<br>The `<textformat>` tag has the following attributes:<li>`blockindent`: Specifies the block indentation in points; corresponds to `TextFormat.blockIndent`.</li><li>`indent`: Specifies the indentation from the left margin to the first character in the paragraph; corresponds to `TextFormat.indent`. Both positive and negative numbers are acceptable.</li><li>`leading`: Specifies the amount of leading (vertical space) between lines; corresponds to `TextFormat.leading`. Both positive and negative numbers are acceptable.</li><li>`leftmargin`: Specifies the left margin of the paragraph, in points; corresponds to `TextFormat.leftMargin`.</li><li>`rightmargin`: Specifies the right margin of the paragraph, in points; corresponds to `TextFormat.rightMargin`.</li><li>`tabstops`: Specifies custom tab stops as an array of non-negative integers; corresponds to `TextFormat.tabStops`.</li></ul> |
		| Underline tag | The `<u>` tag underlines the tagged text. |

		Flash Player and AIR support the following HTML entities:

		| Entity | Description |
		| --- | --- |
		| &amp;lt; | < (less than) |
		| &amp;gt; | > (greater than) |
		| &amp;amp; | & (ampersand) |
		| &amp;quot; | " (double quotes) |
		| &amp;apos; | ' (apostrophe, single quote) |

		Flash Player and AIR also support explicit character codes, such as
		&#38; (ASCII ampersand) and &#x20AC; (Unicode € symbol).
	**/
	public var htmlText(get, set):openfl.text._internal.UTF8String;

	/**
	 * Contains a markdown formatted string.
	 * 
	 * When set, it will be parsed and the resulting text will be displayed with the corresponding markup
	 * 
	 * *more information in `Markdown` and `MarkdownVisualizer` classes*
	 */
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
	var surface:Sprite = new Sprite();

	public function new()
	{
		super();

		textField = new TextField();
		textField.type = TextFieldType.DYNAMIC;
		textField.selectable = false;

		underlay = new Sprite();
		surface.addChild(underlay);
		surface.addChild(textField);

		selectionShape = new Shape();
		surface.addChild(selectionShape);

		background = true;
		backgroundColor = 0xEEEEEE;

		overlay = new Sprite();
		caret = new Bitmap(new BitmapData(1, 1, false, 0x000000));
		caret.height = textField.defaultTextFormat.size;
		caret.x = caret.y = 2;
		caret.visible = false;
		caretTimer.addEventListener(TimerEvent.TIMER, caretBlink);

		surface.addChild(overlay);
		surface.addChild(caret);
		addChild(surface);
		Lib.application.window.onTextInput.add(regularKeysDown);
		Lib.application.window.onKeyDown.add(specialKeysDown);

		textField.addEventListener(FocusEvent.FOCUS_IN, (e) -> stage.focus = this);
		addEventListener(Event.EXIT_FRAME, onMouseWheel);
		overlay.addEventListener(FocusEvent.FOCUS_IN, (e) -> stage.focus = this);
		addEventListener(MouseEvent.MOUSE_DOWN, onFocusIn);
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(Event.ADDED_TO_STAGE, (e) ->
		{
			maskRect.graphics.beginFill();
			maskRect.graphics.drawRect(textField.x, textField.y, width, height);
			addChild(maskRect);
			surface.mask = maskRect;
		});
	}

	function caretBlink(e:TimerEvent)
	{
		caret.visible = !caret.visible;
	}

	function onMouseMove(e:MouseEvent)
	{
		if (!e.buttonDown)
		{
			hasMoved = false;
			return;
		}
		else if (hasMoved)
		{
			var lastBound = getCaretIndexOfMouse();
			setSelection(startSelect, lastBound);
		}
		else
		{
			startSelect = getCaretIndexOfMouse();
			hasMoved = true;
		}
	}

	function onFocusOut(e:FocusEvent)
	{
		if (stage == null)
			return;
		hasFocus = false;
	}

	function onFocusIn(e:MouseEvent)
	{
		trace("focus");
		stage.window.textInputEnabled = true;
		if (type != INPUT)
			return;
		hasFocus = true;
		caretIndex = getCaretIndexOfMouse();
	}

	function onMouseOver(e:MouseEvent)
	{
		Mouse.cursor = MouseCursor.IBEAM;
	}

	function onMouseOut(e:MouseEvent)
	{
		Mouse.cursor = MouseCursor.AUTO;
	}

	function onMouseWheel(e:Event)
	{
		var yVal = getCharBoundaries(0);

		for (o in [overlay, underlay, selectionShape])
		{
			o.y = yVal.y;
		}
	}

	public function getCaretIndexAtPoint(x:Float, y:Float):Int
	{
		if (text.length > 0)
		{
			for (i in 0...text.length)
			{
				var r = getCharBoundaries(i);
				// take scrolling into account
				if ((x >= r.x && x <= r.right && y >= r.y && y <= r.bottom))
					return i;
			}
			// the mouse might have been pressed between the lines
			var i = 0;
			while (i < text.length)
			{
				var r = getCharBoundaries(i),
					line = textField.getLineIndexOfChar(i + 1);
				if (r == null)
					return 0;
				if (y >= r.y && y <= r.bottom)
				{
					if (i == 0)
						i--;
					if (i != -1 && !StringTools.contains(text, "\n"))
						i -= 2;
					if (i + 1 + StringTools.replace(textField.getLineText(line), "\n", "").length == text.length - 1)
						i++;
					return i + (if (scrollV == 1) 1 else 0) + StringTools.replace(textField.getLineText(line), "\n", "").length;
				}
				i++;
			}
			return text.length;
		}
		// place caret at leftmost position
		return 0;
	}

	public function getCaretIndexOfMouse():Int
	{
		return getCaretIndexAtPoint(mouseX, mouseY);
	}

	public function getCharBoundaries(charIndex:Int):Rectangle
	{
		if (textField.getCharBoundaries(charIndex) != null)
		{
			final bounds = textField.getCharBoundaries(charIndex);
			bounds.y -= bounds.height * (scrollV - 1);
			return bounds;
		}

		if (charIndex <= 0)
			return new Rectangle(2, 2, 0, textField.defaultTextFormat.size);

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
			if (charBoundaries == null)
				charBoundaries = textField.getCharBoundaries(charIndex - 1);
			charBoundaries.x += widthDiff * charBoundaries.width
				- (width - 4) * (textField.getLineIndexOfChar(originalIndex) - textField.getLineIndexOfChar(charIndex));
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
		if (insert == "bsp" || insert == "del")
		{
			if (selectedRange[0] != -1)
			{
				text = text.substring(0, selectedRange[0]) + text.substring(selectedRange[1] + 1);
				caretIndex = if (insert == "bsp") selectedRange[0] + 1 else selectedRange[0];
				setSelection(-1, -1);
			}
			else
			{
				text = text.substring(0, index) + text.substring(index + 1);
			}
			dispatchEvent(new Event(Event.CHANGE));
			return this;
		}

		if (selectedRange[0] != -1)
		{
			text = text.substring(0, selectedRange[0]) + insert + text.substring(selectedRange[1] + 1);
			caretIndex = selectedRange[0];
		}
		else
			text = text.substring(0, index) + insert + text.substring(index);
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
			if (key == KeyCode.C && selectedRange[0] != -1)
			{
				// copy text
				var clipboardText = text.substring(selectedRange[0], selectedRange[1] + 1);
				Clipboard.generalClipboard.setData(TEXT_FORMAT, clipboardText);
			}
			if (key == KeyCode.X && selectedRange[0] != -1)
			{
				// cut text
				var clipboardText = text.substring(selectedRange[0], selectedRange[1] + 1);
				Clipboard.generalClipboard.setData(TEXT_FORMAT, clipboardText);
				insertSubstring("del", selectedRange[0]);
			}
			if (key == KeyCode.A)
			{
				// select all
				setSelection(0, text.length - 1);
			}
			if (key == KeyCode.L)
			{ // select the current line of text
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

		if (key == KeyCode.PAGE_DOWN)
			scrollV++;
		if (key == KeyCode.PAGE_UP)
			scrollV--;
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
				if (caretIndex != text.length)
					caretIndex--;
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
			if (hasConverted)
				caretIndex++;
			if (addedSpace)
				caretIndex++;
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

	public function setTextFormat(format:TextFormat, beginIndex:Int, endIndex:Int)
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
			if (beginIndex == endIndex)
			{
				selectionShape.graphics.clear();
				final bounds = textField.getCharBoundaries(beginIndex - 1);
				if (bounds == null)
					return; // edge case: textfield loses focus while selection occurs
				selectionShape.graphics.beginFill(0x333333, 0.2);
				selectionShape.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
				selectionShape.graphics.endFill();
			}
			else
			{
				selectionShape.graphics.clear();
				selectionShape.graphics.beginFill(0x333333, 0.2);
				var bounds:Rectangle;
				for (i in beginIndex...endIndex + 1)
				{
					bounds = textField.getCharBoundaries(i) != null ? textField.getCharBoundaries(i) : continue;
					selectionShape.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
				}
				selectionShape.graphics.endFill();
			}
		}
		else
		{
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
		textField.scrollV = value;
		caretIndex = caretIndex;
		return value;
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
		if (text == null || text == "")
			return "";
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
		return value;
	}

	override function set_height(value:Float):Float
	{
		textField.height = value;
		return value;
	}
}
#end

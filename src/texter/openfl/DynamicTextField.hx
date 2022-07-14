package texter.openfl;
#if openfl
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.display.Bitmap;
import openfl.geom.Point;
import openfl.display.BitmapData;
import openfl.text.TextField;
import lime.ui.MouseCursor;
import openfl.ui.Mouse;
import openfl.events.MouseEvent;
import openfl.text.TextFieldType;
import openfl.text.StyleSheet;
import openfl.text.TextFieldAutoSize;
import openfl.text.AntiAliasType;
import lime.text.UTF8String;
import openfl.text.TextFormat;
import openfl.text.GridFitType;
import openfl.display.Sprite;

import texter.openfl.JointGraphic.*;

/**
 * A normal `TextField` that offers many positional and visual controls.
 * 
 * Those controls can be dynamically managed by the user.
 */
class DynamicTextField extends Sprite {
    
	//privates
	var offsetX:Float = 0;
	var offsetY:Float = 0;
	var rm:JointManager;


    public var textField:TextField;

    /**
     * A container for all border sprites
     */
    public var borders:{
        left:Sprite,
        right:Sprite,
        top:Sprite,
        bottom:Sprite
    };

	/**
	 * A container for all joint sprites
	 */
    public var joints:{
        middleLeft:Sprite,
        middleRight:Sprite,
        middleTop:Sprite,
        middleBottom:Sprite,
        topLeft:Sprite,
        topRight:Sprite,
        bottomLeft:Sprite,
        bottomRight:Sprite,
		rotation:Sprite
    };

    /**
     * Whether or not the text field is dynamically resizable by the user:
     * 
     * When enabled, the user can extend the text field's size when pressing the corners/middles.
     */
    public var resizable(default, set):Bool = true;

    /**
     * Whether or not the text field has an interactive rotation button:
     * 
     * When enabled, the user can rotate the textfield by pressing the rotation button.
	 * 
	 * When disabled, the rotation button is hidden.
     */
    public var rotatable(default, set):Bool = true;


	/*
	 * Whether or not the text field can be dragged around
	 * by the user when pressing the borders.
	 */
	public var draggable(default, set):Bool = true;

    /**
     * This flag is flipped when the user starts dragging the text field.
	 * 
	 * the dragging operation starts when the textfield starts moving.

     */
	public var currentlyDragging(default, null):Bool = false;

    /**
     * Controls which sides are allowed to be dynamically resized by the user.
     */
    public var resizableSides(default, set) = {
        left: true,
        right: true,
        top: true,
        bottom: true
    };

	/**
	 * Whether or not the text field should automatically
	 * resize when the text changes, to match the dimensions 
	 * of the text.
	 *
	 * When set, the text field will automatically resize to
	 * match the current dimensions of the text.
	 *
	 * Notice - You can control the max/min dimensions
	 * of the text field by setting 
	 * `maxWidth`, `minWidth`, `maxHeight` and `minHeight`.
	 */
	public var matchTextSize(default, set):Bool = false;

    /**
     * An array of the `BitmapData` objects used to draw the text field's corners & middles.
     * 
     * - If the array contains only one element, the text field will use that element f
	 * or all corners & middles.
     */
    public var jointGraphics(default, null):JointGraphic;

	/**
	 * When the text field isnt selected (or, out of focus), 
	 * enabling this flag will hide the text field's handles.
	 */
	public var hideControlsWhenUnfocused(default, set):Bool = false;

	/**
	 * A shortcut for setting the focus to the text field:
	 *
	 * 		stage.focus = this;
	 *
	 * And checking if the text field is focused:
	 *
	 * 		stage.focus == this;
	 */
	public var hasFocus(get, set):Bool;
    
    public function new() {
        super();
        textField = new TextField();
        addChild(textField);

        borders = {
            left: new Sprite(),
            right: new Sprite(),
            top: new Sprite(),
            bottom: new Sprite()
        };

		jointGraphics = new JointGraphic(this);
		rm = new JointManager(this);

        for (b in [borders.left, borders.right, borders.top, borders.bottom]) {
            b.graphics.lineStyle(1, borderColor);
        }

        borders.top.graphics.moveTo(0,0);
        borders.top.graphics.lineTo(textField.width, 0);
        borders.top.x = borders.top.y = 0;
        addChild(borders.top);

        borders.bottom.graphics.moveTo(0, 0);
        borders.bottom.graphics.lineTo(textField.width, 0);
        borders.bottom.x = 0;
        borders.bottom.y = textField.height;
        addChild(borders.bottom);

        borders.left.graphics.moveTo(0,0);
        borders.left.graphics.lineTo(0, textField.height);
        borders.left.x = 0;
        borders.left.y = 0;
        addChild(borders.left);

        borders.right.graphics.moveTo(0, 0);
        borders.right.graphics.lineTo(0, textField.height);
        borders.right.x = textField.width;
        borders.right.y = 0;
        addChild(borders.right);

        for (b in [borders.left, borders.right, borders.top, borders.bottom]) {
			b.addEventListener(MouseEvent.MOUSE_OVER, mouseOverBorder);
            b.addEventListener(MouseEvent.MOUSE_DOWN, registerDrag);
        }

		joints = {
			middleLeft: new Sprite(),
			middleRight: new Sprite(),
			middleTop: new Sprite(),
			middleBottom: new Sprite(),
			topLeft: new Sprite(),
			topRight: new Sprite(),
			bottomLeft: new Sprite(),
			bottomRight: new Sprite(),
			rotation: new Sprite()
		};

		for (j in [joints.middleLeft, joints.middleRight, joints.middleTop, joints.middleBottom, joints.topLeft, joints.topRight, joints.bottomLeft, joints.bottomRight]) {
			j.addChild(new Bitmap(jointGraphics.defaultGraphic));
			j.addEventListener(MouseEvent.MOUSE_OVER, mouseOverJoint);
		}

		addChild(joints.topLeft);
		addChild(joints.topRight);
		addChild(joints.bottomLeft);
		addChild(joints.bottomRight);

		addChild(joints.middleLeft);
		addChild(joints.middleRight);
		addChild(joints.middleTop);
		addChild(joints.middleBottom);

		joints.topLeft.addEventListener(MouseEvent.MOUSE_DOWN, rm.startResizeTopLeft);
		joints.topRight.addEventListener(MouseEvent.MOUSE_DOWN, rm.startResizeTopRight);
		joints.bottomLeft.addEventListener(MouseEvent.MOUSE_DOWN, rm.startResizeBottomLeft);
		joints.bottomRight.addEventListener(MouseEvent.MOUSE_DOWN, rm.startResizeBottomRight);
		joints.middleLeft.addEventListener(MouseEvent.MOUSE_DOWN, rm.startResizeLeft);
		joints.middleRight.addEventListener(MouseEvent.MOUSE_DOWN, rm.startResizeRight);
		joints.middleTop.addEventListener(MouseEvent.MOUSE_DOWN, rm.startResizeTop);
		joints.middleBottom.addEventListener(MouseEvent.MOUSE_DOWN, rm.startResizeBottom);

        joints.rotation.addChild(new Bitmap(jointGraphics.rotationHandle));
		joints.rotation.addEventListener(MouseEvent.MOUSE_OVER, mouseOverJoint);
		joints.rotation.addEventListener(MouseEvent.MOUSE_DOWN, rm.startRotation);
		
		addChild(joints.rotation);

		textField.addEventListener(MouseEvent.MOUSE_OVER, mouseOverTextField);
        this.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);

		//call setters for positioning things correctly
		set_width(width);
		set_height(height);

		this.addEventListener(Event.ADDED_TO_STAGE, (e) -> {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, checkFocus);
		});
    }

	/**
		Called every time the positional configuration of the text field changes.
	**/
	function registerDrag(e:MouseEvent) {
		if (hideControlsWhenUnfocused) {
			showControls();
		}
		if (draggable && offsetX == 0) {
			offsetX = parent.mouseX - x;
			offsetY = parent.mouseY - y;
			for (b in [borders.left, borders.right, borders.top, borders.bottom]) {
				b.removeEventListener(MouseEvent.MOUSE_DOWN, registerDrag);
			}
			stage.addEventListener(MouseEvent.MOUSE_MOVE, drag);
		}
	}

	function drag(e:MouseEvent) {
		if (draggable && e.buttonDown) {
			currentlyDragging = true;
			x = parent.globalToLocal(new Point(e.stageX, e.stageY)).x - offsetX;
			y = parent.globalToLocal(new Point(e.stageX, e.stageY)).y - offsetY;
		} else {
			offsetX = offsetY = 0;
			currentlyDragging = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, drag);
			for (b in [borders.left, borders.right, borders.top, borders.bottom]) {
				b.addEventListener(MouseEvent.MOUSE_DOWN, registerDrag);
			}
		}
	}

	//--------------------------------------------------------------------------
	//FOCUS FUNCTIONS
	//--------------------------------------------------------------------------
	
	function checkFocus(e:MouseEvent) {
		if (this.hitTestPoint(e.stageX, e.stageY)) {
			if (hideControlsWhenUnfocused) {
				showControls();
			}
		}
		else {
			if (hideControlsWhenUnfocused) {
				hideControls();
			}
		}
	}
	
	function onFocusIn(e:FocusEvent) {
		trace("focus in");
		if (hideControlsWhenUnfocused) showControls();
	}
	function onFocusOut(e:FocusEvent) {
		trace("focus out");
		if (hideControlsWhenUnfocused) hideControls();
	}

	//--------------------------------------------------------------------------
	//CURSOR FUNCTIONS
	//--------------------------------------------------------------------------
    function mouseOverBorder(e:MouseEvent) {
        Mouse.cursor = MouseCursor.MOVE;
    }

	function mouseOverJoint(e:MouseEvent) {
		if (currentlyDragging) {
			Mouse.cursor = MouseCursor.MOVE;
			return;
		}
		Mouse.show();
		// i hate this too
		if (e.target == joints.topLeft) {
			Mouse.cursor = MouseCursor.RESIZE_NWSE;
		} else if (e.target == joints.topRight) {
			Mouse.cursor = MouseCursor.RESIZE_NESW;
		} else if (e.target == joints.bottomLeft) {
			Mouse.cursor = MouseCursor.RESIZE_NESW;
		} else if (e.target == joints.bottomRight) {
			Mouse.cursor = MouseCursor.RESIZE_NWSE;
		} else if (e.target == joints.middleLeft) {
			Mouse.cursor = MouseCursor.RESIZE_WE;
		} else if (e.target == joints.middleRight) {
			Mouse.cursor = MouseCursor.RESIZE_WE;
		} else if (e.target == joints.middleTop) {
			Mouse.cursor = MouseCursor.RESIZE_NS;
		} else if (e.target == joints.middleBottom) {
			Mouse.cursor = MouseCursor.RESIZE_NS;
		} 
	}

    function mouseOverTextField(e:MouseEvent) {
        Mouse.cursor = !currentlyDragging ? MouseCursor.TEXT : MouseCursor.MOVE;
    }

    function mouseOut(e:MouseEvent) {
        Mouse.cursor = !currentlyDragging ? MouseCursor.DEFAULT : MouseCursor.MOVE;
    }

	/**
		Hides everything, but the text field.

		Called when the user shifts the focus from the text field,
		and `hideControlsWhenUnfocused` is true.
	**/
	public function hideControls() {
		//hide everything but the text field
		for (j in [joints.topLeft, joints.topRight, joints.bottomLeft, joints.bottomRight, joints.middleLeft, joints.middleRight, joints.middleTop, joints.middleBottom, joints.rotation]) {
			j.visible = false;
		}

		//hide the borders
		for (b in [borders.left, borders.right, borders.top, borders.bottom]) {
			b.visible = false;
		}
	}

	/**
		Shows All of the joints and the borders.
	**/
	public function showControls() {
		for (j in [joints.topLeft, joints.topRight, joints.bottomLeft, joints.bottomRight, joints.middleLeft, joints.middleRight, joints.middleTop, joints.middleBottom, joints.rotation]) {
			j.visible = true;
		}
		for (b in [borders.left, borders.right, borders.top, borders.bottom]) {
			b.visible = true;
		}
	}

    //--------------------------------------------------------------------------
    //GETTERS & SETTERS
    //--------------------------------------------------------------------------

	function set_resizableSides(value):{left:Bool, right:Bool, top:Bool, bottom:Bool} {
		throw new haxe.exceptions.NotImplementedException();
	}

	function set_resizable(value:Bool):Bool {
		throw new haxe.exceptions.NotImplementedException();
	}

	function set_rotatable(value:Bool):Bool {
		if (value) {
			joints.rotation.visible = true;
		}
		else {
			joints.rotation.visible = false;
		}
		return value;
	}

	function set_draggable(value:Bool):Bool {
		if (currentlyDragging) currentlyDragging = false;

		return value;
	}

    //override setters for width and height
    override function set_width(value:Float) {
        textField.width = value;
		for (b in [borders.top, borders.bottom]) {
			b.graphics.clear();
			b.graphics.lineStyle(1, borderColor);
			b.graphics.moveTo(0,0);
			b.graphics.lineTo(value, 0);
		}
		borders.right.x = value;

		joints.topLeft.x = -JOINT_GUTTER;
		joints.topRight.x = textField.width -JOINT_GUTTER;
		joints.bottomLeft.x = 0 -JOINT_GUTTER;
		joints.bottomRight.x = textField.width -JOINT_GUTTER;

		joints.middleLeft.x = 0 -JOINT_GUTTER;
		joints.middleRight.x = textField.width -JOINT_GUTTER;
		joints.middleTop.x = textField.width / 2 - joints.middleTop.width / 2;
		joints.middleBottom.x = textField.width / 2 - joints.middleBottom.width / 2;

		joints.rotation.x = textField.width / 2 - joints.rotation.width / 2;
		
        return value;
    }

    override function set_height(value:Float) {
        textField.height = value;
		for (b in [borders.left, borders.right]) {
			b.graphics.clear();
			b.graphics.lineStyle(1, borderColor);
			b.graphics.moveTo(0,0);
			b.graphics.lineTo(0, value);
		}
		borders.bottom.y = value;

		joints.topLeft.y = 0 -JOINT_GUTTER;
		joints.topRight.y = 0 -JOINT_GUTTER;
		joints.bottomLeft.y = textField.height -JOINT_GUTTER;
		joints.bottomRight.y = textField.height -JOINT_GUTTER;

		joints.middleLeft.y = textField.height / 2 -JOINT_GUTTER;
		joints.middleRight.y = textField.height / 2 -JOINT_GUTTER;
		joints.middleTop.y = 0 -JOINT_GUTTER;
		joints.middleBottom.y = textField.height -JOINT_GUTTER;

		joints.rotation.y = -ROTATION_JOINT_GUTTER;

        return value;
    }

	function set_matchTextSize(value:Bool):Bool {
		if (value) {
			width = textField.textWidth + 4;
			height = textField.textHeight + 4;
		}

		return value;
	}

	function set_hideControlsWhenUnfocused(value:Bool) {
		
		if (!hasFocus) hideControls();

		return value;
	}

	function get_hasFocus():Bool {
		if (stage == null) return false;
		return stage.focus == this;
	}

	function set_hasFocus(value:Bool):Bool {
		if (stage == null) return value;
		if (value) {
			stage.focus = this;
			return value;
		}
		stage.focus = null;
		return value;
	}


























































    //--------------------------------------------------------------------------
    //TEXTFIELD COMPATIBILITY
    //--------------------------------------------------------------------------

	/**
		The type of anti-aliasing used for this text field. Use
		`openfl.text.AntiAliasType` constants for this property. You can
		control this setting only if the font is embedded(with the
		`embedFonts` property set to `true`). The default
		setting is `openfl.text.AntiAliasType.NORMAL`.

		To set values for this property, use the following string values:
	**/
	public var antiAliasType(get, set):AntiAliasType;

	/**
		Controls automatic sizing and alignment of text fields. Acceptable values
		for the `TextFieldAutoSize` constants:
		`TextFieldAutoSize.NONE`(the default),
		`TextFieldAutoSize.LEFT`, `TextFieldAutoSize.RIGHT`,
		and `TextFieldAutoSize.CENTER`.

		If `autoSize` is set to `TextFieldAutoSize.NONE`
		(the default) no resizing occurs.

		If `autoSize` is set to `TextFieldAutoSize.LEFT`,
		the text is treated as left-justified text, meaning that the left margin
		of the text field remains fixed and any resizing of a single line of the
		text field is on the right margin. If the text includes a line break(for
		example, `"\n"` or `"\r"`), the bottom is also
		resized to fit the next line of text. If `wordWrap` is also set
		to `true`, only the bottom of the text field is resized and the
		right side remains fixed.

		If `autoSize` is set to
		`TextFieldAutoSize.RIGHT`, the text is treated as
		right-justified text, meaning that the right margin of the text field
		remains fixed and any resizing of a single line of the text field is on
		the left margin. If the text includes a line break(for example,
		`"\n" or "\r")`, the bottom is also resized to fit the next
		line of text. If `wordWrap` is also set to `true`,
		only the bottom of the text field is resized and the left side remains
		fixed.

		If `autoSize` is set to
		`TextFieldAutoSize.CENTER`, the text is treated as
		center-justified text, meaning that any resizing of a single line of the
		text field is equally distributed to both the right and left margins. If
		the text includes a line break(for example, `"\n"` or
		`"\r"`), the bottom is also resized to fit the next line of
		text. If `wordWrap` is also set to `true`, only the
		bottom of the text field is resized and the left and right sides remain
		fixed.

		@throws ArgumentError The `autoSize` specified is not a member
							  of openfl.text.TextFieldAutoSize.
	**/
	public var autoSize(get, set):TextFieldAutoSize;

	/**
		Specifies whether the text field has a background fill. If
		`true`, the text field has a background fill. If
		`false`, the text field has no background fill. Use the
		`backgroundColor` property to set the background color of a
		text field.

		@default false
	**/
	public var background(get, set):Bool;

	/**
		The color of the text field background. The default value is
		`0xFFFFFF`(white). This property can be retrieved or set, even
		if there currently is no background, but the color is visible only if the
		text field has the `background` property set to
		`true`.
	**/
	public var backgroundColor(get, set):Int;

	/**
		Specifies whether the text field has a border. If `true`, the
		text field has a border. If `false`, the text field has no
		border. Use the `borderColor` property to set the border color.

		@default false
	**/
	public var border(default, set):Bool;

	/**
		The color of the text field border. The default value is
		`0x000000`(black). This property can be retrieved or set, even
		if there currently is no border, but the color is visible only if the text
		field has the `border` property set to `true`.
	**/
	public var borderColor(default, set):Int = 0x7A7A7A;

	/**
		An integer(1-based index) that indicates the bottommost line that is
		currently visible in the specified text field. Think of the text field as
		a window onto a block of text. The `scrollV` property is the
		1-based index of the topmost visible line in the window.

		All the text between the lines indicated by `scrollV` and
		`bottomScrollV` is currently visible in the text field.
	**/
	public var bottomScrollV(get, never):Int;

	/**
		The index of the insertion point(caret) position. If no insertion point
		is displayed, the value is the position the insertion point would be if
		you restored focus to the field(typically where the insertion point last
		was, or 0 if the field has not had focus).

		Selection span indexes are zero-based(for example, the first position
		is 0, the second position is 1, and so on).
	**/
	public var caretIndex(get, never):Int;

	/**
		A Boolean value that specifies whether extra white space (spaces, line
		breaks, and so on) in a text field with HTML text is removed. The
		default value is `false`. The `condenseWhite` property only affects
		text set with the `htmlText` property, not the `text` property. If you
		set text with the `text` property, `condenseWhite` is ignored.
		If `condenseWhite` is set to `true`, use standard HTML commands such
		as `<BR>` and `<P>` to place line breaks in the text field.

		Set the `condenseWhite` property before setting the `htmlText`
		property.
	**/
	public var condenseWhite:Bool = false;

	/**
		Specifies the format applied to newly inserted text, such as text entered
		by a user or text inserted with the `replaceSelectedText()`
		method.

		**Note:** When selecting characters to be replaced with
		`setSelection()` and `replaceSelectedText()`, the
		`defaultTextFormat` will be applied only if the text has been
		selected up to and including the last character. Here is an example:

		```
		var my_txt:TextField new TextField();
		my_txt.text = "Flash Macintosh version"; var my_fmt:TextFormat = new
		TextFormat(); my_fmt.color = 0xFF0000; my_txt.defaultTextFormat = my_fmt;
		my_txt.setSelection(6,15); // partial text selected - defaultTextFormat
		not applied my_txt.setSelection(6,23); // text selected to end -
		defaultTextFormat applied my_txt.replaceSelectedText("Windows version");
		```

		When you access the `defaultTextFormat` property, the
		returned TextFormat object has all of its properties defined. No property
		is `null`.

		**Note:** You can't set this property if a style sheet is applied to
		the text field.

		@throws Error This method cannot be used on a text field with a style
					  sheet.
	**/
	public var defaultTextFormat(get, set):TextFormat;

	/**
		Specifies whether the text field is a password text field. If the value of
		this property is `true`, the text field is treated as a
		password text field and hides the input characters using asterisks instead
		of the actual characters. If `false`, the text field is not
		treated as a password text field. When password mode is enabled, the Cut
		and Copy commands and their corresponding keyboard shortcuts will not
		function. This security mechanism prevents an unscrupulous user from using
		the shortcuts to discover a password on an unattended computer.

		@default false
	**/
	public var displayAsPassword(get, set):Bool;

	/**
		Specifies whether to render by using embedded font outlines. If
		`false`, Flash Player renders the text field by using device
		fonts.

		If you set the `embedFonts` property to `true`
		for a text field, you must specify a font for that text by using the
		`font` property of a TextFormat object applied to the text
		field. If the specified font is not embedded in the SWF file, the text is
		not displayed.

		@default false
	**/
	public var embedFonts(get, set):Bool;

	/**
		The type of grid fitting used for this text field. This property
		applies only if the `openfl.text.AntiAliasType` property of the text
		field is set to `openfl.text.AntiAliasType.ADVANCED`.
		The type of grid fitting used determines whether Flash Player forces
		strong horizontal and vertical lines to fit to a pixel or subpixel
		grid, or not at all.

		For the `openfl.text.GridFitType` property, you can use the following
		string values:

		| String value | Description |
		| --- | --- |
		| `openfl.text.GridFitType.NONE` | Specifies no grid fitting. Horizontal and vertical lines in the glyphs are not forced to the pixel grid. This setting is recommended for animation or for large font sizes. |
		| `openfl.text.GridFitType.PIXEL` | Specifies that strong horizontal and vertical lines are fit to the pixel grid. This setting works only for left-aligned text fields. To use this setting, the `openfl.dispaly.AntiAliasType` property of the text field must be set to `openfl.text.AntiAliasType.ADVANCED`. This setting generally provides the best legibility for left-aligned text. |
		| `openfl.text.GridFitType.SUBPIXEL` | Specifies that strong horizontal and vertical lines are fit to the subpixel grid on an LCD monitor. To use this setting, the `openfl.text.AntiAliasType` property of the text field must be set to `openfl.text.AntiAliasType.ADVANCED`. The `openfl.text.GridFitType.SUBPIXEL` setting is often good for right-aligned or centered dynamic text, and it is sometimes a useful trade-off for animation versus text quality. |

		@default pixel
	**/
	public var gridFitType(get, set):GridFitType;

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
	public var htmlText(get, set):UTF8String;

	/**
		The number of characters in a text field. A character such as tab
		(`\t`) counts as one character.
	**/
	public var length(get, never):Int;

	/**
		The maximum number of characters that the text field can contain, as
		entered by a user. A script can insert more text than
		`maxChars` allows; the `maxChars` property indicates
		only how much text a user can enter. If the value of this property is
		`0`, a user can enter an unlimited amount of text.

		@default 0
	**/
	public var maxChars(get, set):Int;

	/**
		The maximum value of `scrollH`.
	**/
	public var maxScrollH(get, never):Int;

	/**
		The maximum value of `scrollV`.
	**/
	public var maxScrollV(get, never):Int;

	/**
		A Boolean value that indicates whether Flash Player automatically scrolls
		multiline text fields when the user clicks a text field and rolls the mouse wheel.
		By default, this value is `true`. This property is useful if you want to prevent
		mouse wheel scrolling of text fields, or implement your own text field scrolling.
	**/
	public var mouseWheelEnabled(get, set):Bool;

	/**
		Indicates whether field is a multiline text field. If the value is
		`true`, the text field is multiline; if the value is
		`false`, the text field is a single-line text field. In a field
		of type `TextFieldType.INPUT`, the `multiline` value
		determines whether the `Enter` key creates a new line(a value
		of `false`, and the `Enter` key is ignored). If you
		paste text into a `TextField` with a `multiline`
		value of `false`, newlines are stripped out of the text.

		@default false
	**/
	public var multiline(get, set):Bool;

	/**
		Defines the number of text lines in a multiline text field. If
		`wordWrap` property is set to `true`, the number of
		lines increases when text wraps.
	**/
	public var numLines(get, never):Int;

	/**
		Indicates the set of characters that a user can enter into the text field.
		If the value of the `restrict` property is `null`,
		you can enter any character. If the value of the `restrict`
		property is an empty string, you cannot enter any character. If the value
		of the `restrict` property is a string of characters, you can
		enter only characters in the string into the text field. The string is
		scanned from left to right. You can specify a range by using the hyphen
		(-) character. Only user interaction is restricted; a script can put any
		text into the text field. <ph outputclass="flashonly">This property does
		not synchronize with the Embed font options in the Property inspector.

		If the string begins with a caret(^) character, all characters are
		initially accepted and succeeding characters in the string are excluded
		from the set of accepted characters. If the string does not begin with a
		caret(^) character, no characters are initially accepted and succeeding
		characters in the string are included in the set of accepted
		characters.

		The following example allows only uppercase characters, spaces, and
		numbers to be entered into a text field:
		`my_txt.restrict = "A-Z 0-9";`

		The following example includes all characters, but excludes lowercase
		letters:
		`my_txt.restrict = "^a-z";`

		You can use a backslash to enter a ^ or - verbatim. The accepted
		backslash sequences are \-, \^ or \\. The backslash must be an actual
		character in the string, so when specified in ActionScript, a double
		backslash must be used. For example, the following code includes only the
		dash(-) and caret(^):
		`my_txt.restrict = "\\-\\^";`

		The ^ can be used anywhere in the string to toggle between including
		characters and excluding characters. The following code includes only
		uppercase letters, but excludes the uppercase letter Q:
		`my_txt.restrict = "A-Z^Q";`

		You can use the `\u` escape sequence to construct
		`restrict` strings. The following code includes only the
		characters from ASCII 32(space) to ASCII 126(tilde).
		`my_txt.restrict = "\u0020-\u007E";`

		@default null
	**/
	public var restrict(get, set):UTF8String;

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

		@default true
	**/
	public var selectable(get, set):Bool;

	/**
		The zero-based character index value of the first character in the current
		selection. For example, the first character is 0, the second character is
		1, and so on. If no text is selected, this property is the value of
		`caretIndex`.
	**/
	public var selectionBeginIndex(get, never):Int;

	/**
		The zero-based character index value of the last character in the current
		selection. For example, the first character is 0, the second character is
		1, and so on. If no text is selected, this property is the value of
		`caretIndex`.
	**/
	public var selectionEndIndex(get, never):Int;

	/**
		The sharpness of the glyph edges in this text field. This property applies
		only if the `openfl.text.AntiAliasType` property of the text
		field is set to `openfl.text.AntiAliasType.ADVANCED`. The range
		for `sharpness` is a number from -400 to 400. If you attempt to
		set `sharpness` to a value outside that range, Flash sets the
		property to the nearest value in the range(either -400 or 400).

		@default 0
	**/
	public var sharpness(get, set):Float;

	/**
		Attaches a style sheet to the text field. For information on creating
		style sheets, see the StyleSheet class and the _ActionScript 3.0
		Developer's Guide_.
		You can change the style sheet associated with a text field at any
		time. If you change the style sheet in use, the text field is redrawn
		with the new style sheet. You can set the style sheet to `null` or
		`undefined` to remove the style sheet. If the style sheet in use is
		removed, the text field is redrawn without a style sheet.

		**Note:** If the style sheet is removed, the contents of both
		`TextField.text` and ` TextField.htmlText` change to incorporate the
		formatting previously applied by the style sheet. To preserve the
		original `TextField.htmlText` contents without the formatting, save
		the value in a variable before removing the style sheet.
	**/
	public var styleSheet(get, set):StyleSheet;

	/**
		A string that is the current text in the text field. Lines are separated
		by the carriage return character(`'\r'`, ASCII 13). This
		property contains unformatted text in the text field, without HTML tags.

		To get the text in HTML form, use the `htmlText`
		property.
	**/
	public var text(get, set):UTF8String;

	/**
		The color of the text in a text field, in hexadecimal format. The
		hexadecimal color system uses six digits to represent color values. Each
		digit has 16 possible values or characters. The characters range from 0-9
		and then A-F. For example, black is `0x000000`; white is
		`0xFFFFFF`.

		@default 0(0x000000)
	**/
	public var textColor(get, set):Int;

	/**
		The height of the text in pixels.
	**/
	public var textHeight(get, never):Float;

	/**
		The width of the text in pixels.
	**/
	public var textWidth(get, never):Float;

	/**
		The type of the text field. Either one of the following TextFieldType
		constants: `TextFieldType.DYNAMIC`, which specifies a dynamic
		text field, which a user cannot edit, or `TextFieldType.INPUT`,
		which specifies an input text field, which a user can edit.

		@default dynamic
		@throws ArgumentError The `type` specified is not a member of
							  openfl.text.TextFieldType.
	**/
	public var type(get, set):TextFieldType;

	/**
		A Boolean value that indicates whether the text field has word wrap. If
		the value of `wordWrap` is `true`, the text field
		has word wrap; if the value is `false`, the text field does not
		have word wrap. The default value is `false`.
	**/
	public var wordWrap(get, set):Bool;

    //getters and setters for TEXTFIELD COMPATIBILITY

    function get_antiAliasType():openfl.text.AntiAliasType {
        return textField.antiAliasType;
    }   
    function set_antiAliasType(value:openfl.text.AntiAliasType):openfl.text.AntiAliasType {
        return textField.antiAliasType = value;
    }
    function get_autoSize():openfl.text.TextFieldAutoSize {
        return textField.autoSize;
    }
    function set_autoSize(value:openfl.text.TextFieldAutoSize):openfl.text.TextFieldAutoSize {
        return textField.autoSize = value;
    }
    function get_background():Bool {
        return textField.background;
    }
    function set_background(value:Bool):Bool {
        return textField.background = value;
    }
    function get_backgroundColor():Int {
        return textField.backgroundColor;
    }
    function set_backgroundColor(value:Int):Int {
        return textField.backgroundColor = value;
    }
    function set_border(value:Bool):Bool {
        for (b in [borders.left, borders.right, borders.top, borders.bottom]) {
			b.visible = value;
		}
		return value;
    }
    function set_borderColor(value:Int):Int {
        return textField.borderColor = value;
    }
    function get_bottomScrollV():Int {
        return textField.bottomScrollV;
    }
    function get_caretIndex():Int {
        return textField.caretIndex;
    }
    function get_condenseWhite():Bool {
        return textField.condenseWhite;
    }
    function set_condenseWhite(value:Bool):Bool {
        return textField.condenseWhite = value;
    }
    function get_defaultTextFormat():openfl.text.TextFormat {
        return textField.defaultTextFormat;
    }
    function set_defaultTextFormat(value:openfl.text.TextFormat):openfl.text.TextFormat {
        return textField.defaultTextFormat = value;
    }
    function get_displayAsPassword():Bool {
        return textField.displayAsPassword;
    }
    function set_displayAsPassword(value:Bool):Bool {
        return textField.displayAsPassword = value;
    }
    function get_embedFonts():Bool {
        return textField.embedFonts;
    }
    function set_embedFonts(value:Bool):Bool {
        return textField.embedFonts = value;
    }
    function get_gridFitType():openfl.text.GridFitType {
        return textField.gridFitType;
    }
    function set_gridFitType(value:openfl.text.GridFitType):openfl.text.GridFitType {
        return textField.gridFitType = value;
    }
    function get_htmlText():String {
        return textField.htmlText;
    }
    function set_htmlText(value:String):String {
        return textField.htmlText = value;
    }
    function get_length():Int {
        return textField.length;
    }
    function get_maxChars():Int {
        return textField.maxChars;
    }
    function set_maxChars(value:Int):Int {
        return textField.maxChars = value;
    }
    function get_maxScrollH():Int {
        return textField.maxScrollH;
    }
    function get_maxScrollV():Int {
        return textField.maxScrollV;
    }
    function get_mouseWheelEnabled():Bool {
        return textField.mouseWheelEnabled;
    }
    function set_mouseWheelEnabled(value:Bool):Bool {
        return textField.mouseWheelEnabled = value;
    }
    function get_multiline():Bool {
        return textField.multiline;
    }
    function set_multiline(value:Bool):Bool {
        return textField.multiline = value;
    }
    function get_numLines():Int {
        return textField.numLines;
    }
    function get_restrict():String {
        return textField.restrict;
    }
    function set_restrict(value:String):String {
        return textField.restrict = value;
    }
    function get_scrollH():Int {
        return textField.scrollH;
    }
    function set_scrollH(value:Int):Int {
        return textField.scrollH = value;
    }
    function get_scrollV():Int {
        return textField.scrollV;
    }
    function set_scrollV(value:Int):Int {
        return textField.scrollV = value;
    }
    function get_selectable():Bool {
        return textField.selectable;
    }
    function set_selectable(value:Bool):Bool {
        return textField.selectable = value;
    }
    function get_selectionBeginIndex():Int {
        return textField.selectionBeginIndex;
    }
    function get_selectionEndIndex():Int {
        return textField.selectionEndIndex;
    }
    function get_sharpness():Float {
        return textField.sharpness;
    }
    function set_sharpness(value:Float):Float {
        return textField.sharpness = value;
    }
    function get_text():String {
        return textField.text;
    }
    function set_text(value:String):String {
        return textField.text = value;
    }
    function get_textColor():Int {
        return textField.textColor;
    }
    function set_textColor(value:Int):Int {
        return textField.textColor = value;
    }
    function get_textHeight():Float {
        return textField.textHeight;
    }
    function get_textWidth():Float {
        return textField.textWidth;
    }
    function get_type():openfl.text.TextFieldType {
        return textField.type;
    }
    function set_type(value:openfl.text.TextFieldType):openfl.text.TextFieldType {
        return textField.type = value;
    }
    function get_wordWrap():Bool {
        return textField.wordWrap;
    }
    function set_wordWrap(value:Bool):Bool {
        return textField.wordWrap = value;
    }

	function get_styleSheet():StyleSheet {
		return textField.styleSheet;
	}

	function set_styleSheet(value:StyleSheet):StyleSheet {
		return textField.styleSheet = value;
	}
}
#end

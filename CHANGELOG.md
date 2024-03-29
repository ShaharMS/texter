2.4.0
===

**TextTools:**

 - added `insert()`
 - deprecated `indexesFromArray()`
 - added `indexesOfSubs()` as a replacement - replaced for a cleaner, more understandable name.
 - added `fonts` field, containing sans & serif, multilingual fonts.
 - fixes `loremIpsum()`not taking the extra `length` argument into account
 - fixed documentation formatting & typos
 - added missing documentation to `remove()`, `replace()`, `contains()`, `reverse()`


**MathTextField - new Class!**

this class provides the ability to display mathematical forms of strings. no special syntax is required (e.g. this: `f(x) = 2x + 5` is valid)

**MathLexer - new Class!**

`MathLexer` is an "internal" class, used by mathematical displays inside the `texter` library to display mathematical expressions in a more advanced and natural way. Theres nothing preventing you from using it yourself, but it might not be as straight forward as just getting some text and putting it through a function. If you want to make a mathematical expression display of your own, you can look at the implementations that already exist inside this library.

 - added `getMathAttributes`
 - added `splitBlocks`
 - added `reorderAttributes`
 - added `resetAttributesOrder`
 - added `removeDuplicates`
 - added `condenseWhitespaces`
 - added `extractTextFromAttributes`


**DynamicTextField:**

 - added `borderSize`
 - added `virtualBorderSize`
 - added missing implementation for `resizable`
 - fixed weird behavior when dragging the sides of the text field, while its rotated

**TextFieldRTL**

 - removed deprecation notice. this class is repurposed :)
 - all selection related bugs should not appear anymore.
 - now relies on an external, BiDi algorithm.

2.3.2 (September 5th, 2022)
===

 - fixed allRtlLetters containing whitespaces
 - fixed FlxInputTextRTL assuming RTL direction
 - fixed FlxInputTextRTL backspace not working correctly
 - fixed FlxInputTextRTL typing getting messy after typing a whitespaces

2.3.1 (September 4th, 2022)
===

 - fix for FlxInputTextRTL and TextFieldRTL typing letters incorrectly

2.3.0 (August 26th, 2022)
===

**Bidi - new class!**

The `Bidi` class provides methods that help getting directional information from a string:

 - `process(text:String)` - runs the Bidi algorithm on `text`. if the resulting string will be re-processed by the algorithm, the text should still remain correct.
 - `unbidify(text:String)` - runs the Bidi algorithms with some changes, "reversing" the effect on the initial Bidi processing.
 - `getTextAttributes(text:String)` - more of an internal function, but can be used to get an "AST" of the text's directional components.
 - `processTextAttributes(attributes:Array<TextAttribute>)` - takes an array of attributes (the AST) itself, and gets the correctly bidified text out of it.


**TextAttribute**

In addition to the `Bidi` class, this enum was added:

 - `Bidified`
 - `LineDirection(letterType:TextDirection);`
 - `Rtl(string:String)`
 - `Ltr(string:String)`
 - `SoftChar(string:String, generalDirection:TextDirection)`
 - `LineEnd()`

`Bidified` serves no purpose, but to tell the bidi processor which text has been processed and which text has'nt.


**BidiTools - new class!**

BidiTools is a class containing cross framework tools to work with Bidi texts. currently, only OpenFL is supported, but more frameworks will be added in the future
if requested/PRed. it currently has 2 methods:

 - `bidifyString()` - similar to `Bidi.process()`
 - `attachBidifier()` ` + 2 overloads` - attaches an engine, which eases working with Bidi texts in text fields. currently supports text fields of type:
    - `openfl.text.TextField`
    - `texter.openfl.DynamicTextField`
    - `texter.openfl.DynamicTextField`


**CharTools**

 - added `allRtlLetters` - an array of all letters written RTL. this also contains more "obscure" languages, like aramaic.
 - added `softChars`
 - added `isRTL()`
 - added `isSoft()` - checks if a char is whithout a specific direction


**TextTools**

 - added `remove()`
 - added `replace()`
 - added `reverse()`

**DynamicTextField**

 - added `onDragged` - a callback, triggered whenever the textfield stopped dragging. contains previous, and current position.
 - added `onResized` - a callback, triggered whenever the textfield has been resized. contains previous, and current dimensions & position.
 - added `onRotated` - a callback, triggered whenever the textfield has been rotated. contains previous and current rotation, in degrees. Notice - this accounts for rotation around center.
 - added conversion methods from textField sizes to object sizes:
    - `textFieldWidthToObjectWidth()`
    - `textFieldHeightToObjectWidth()`
    - `objectWidthToTextFieldWidth()`
    - `objectHeightToOTextFieldWidth()`
 - rotation joint now has a better graphic. if not rendered, copy it from `assets/DynamicTextField` into you project, at `assets/texter/DynamicTextField`

2.2.0 (August 16, 2022)
===

**DynamicTextField - new class!**

`DynamicTextField` is a new class that allows you to create a text field that can dynamically resize, move, and rotate. This class is kind of a superset of the TextField class.

properties:

 - `resizable`
 - `draggable`
 - `rotatable`
 - `currentlyDragging`
 - `matchTextSize`
 - `jointGraphics`
 - `hasFocus`
 - `textFieldWidth`
 - `textFieldHeight`
 - `textField`
 - `hideControlsWhenUnfocused`
 - (other `TextField` properties and functions)

**MarkdownVisualizer**

 - added `darkMode` property to `VisualConfig`


2.1.0 (May 5, 2022)
===

**TextTools:**

 - added `splitOnParagraph()` 
 - added `multiply()` to repeat a string a number of times
 - added `subtract()` to remove the last occurrence of a string from a string
 - added `sortByLength()` to sort a list of strings by their length
 - added `sortByValue()` to sort a list of floats by their value
 - added `sortByIntValue()` to sort a list of integers by their value
 - added `getLineIndexOfChar()` to get the line index of a substring in a string
 - added `contains()` to check if a string contains a substring
 - added `countOccurrencesOf()` to count the number of occurrences of a substring in a string
 - added `loremIpsumText` property to `TextTools`
 - moved `src.texter.general.TextTools` to `src.TextTools`

2.0.4 (April 18, 2022)
===

 - fixed inability to compile to c++
 - renovated FlxInputText, should now uniformly support multiline text across platforms 
 - fixed visual glitches when visualizing markdown alignment

2.0.2 & 2.0.3 (April 13, 2022)
===

**Markdown:**

added more supported markup to the markdown interpreter:

 - `\t` - tab
 - `<align=""></align>` - alignment
 - `  ` or `\` at the end of the line - newline character

fixed interpreter faults with `ParagraphGap`

**MarkdownPatterns:**

added a couple more patterns to match markdown's markup:

 - `doubleSpaceNewlineEReg`
 - `backslashNewlineEReg`
 - `alignmentEReg`
 - `linkEReg` (fix)

**TextFieldRTL**
 
 - removed unused imports

2.0.1 (April 13, 2022)
===

 - fixed some README markup issues & mistakes
 - minimal re-write of FlxInputText, should now fully work with touch devices
 - removed framework specific import from MarkdownVIsualizer, preventing the library from working without OpenFL
 - fixed documentation


2.0.0 (April 12, 2022) - Major Update!
===
I promised for every major update to have a new framework supported, and the new framework is  
### 🥁  
### 🥁
### 🥁
**OpenFL!**
### **New Features:**

**TextFieldRTL - new class!**
`TextFieldRTL` is an "extention" of `TextField` that adds support for multiple things, such as **right-to-left text** and **built-in markdown visualization**.

It also adds some convenience methods & fields for working with the object, that `TextField` doesn't have.

 - added `autoAlign` property - aligns the text according to the first strongly typed character
 - added `openingDirection` (read-only) - specifies the base direction of the text
 - added `alignment` property, similar to `autoSize` but more understandable
 - added `overlay` property, you can now draw on top of the text
 - added `underlay` property, you can now draw below the text
 - added `markdownText` property - you can set this to make the text display things in markdown format
 - `caretIndex` is now an editable property
 - added `hasFocus` property for easy focus access
 - added `insertSubstring()`
 - added `getCaretIndexAtPoint()`
 - added `getCaretIndexOfMouse()`
 - RTL text input is now supported on platforms other then the web
 - the text selection's background now has a nicer & more natural look
 - extended markdown visualization support. also supports:
    - Horizontal Rules
    - Code Background
    - Strikethrough


**CharTools:**

 - added `charFromValue` map
 - added `charToValue` map
 - `fromCharArray` and `toCharArray` now use `Char`s instead of `String`s


**Markdown - new class! features:**

 - added a field that gives access to the visualizer - `visualizer`
 - added access to all markdown patterns via `Markdown.patterns`. more information in `MarkdownPatterns`
 - added `syntaxBlocks` field - you can redefine highlight parsers there.
 - added `interpret()` - a cross-platform, cross-framework markdown interpreter based on ADTs (algebric data types) from `MarkdownEffect.hx`
 - added `visualizeMarkdown` - a (soon to be) cross-framework method to display markdown visuals

**MarkdownPatterns - new class!**

`MarkdownPatterns` is a class consisting of the following markdown patterns: (more will be added in the future)

 - `hRuledTitleEReg`
 - `linkEReg`
 - `codeEReg`
 - `codeblockEReg`
 - `tildeCodeblockEReg`
 - `tabCodeblockEReg`
 - `imageEReg`
 - `listItemEReg`
 - `unorderedListItemEReg`
 - `titleEReg`
 - `hRuleEReg`
 - `astBoldEReg`
 - `boldEReg`
 - `strikeThroughEReg`
 - `italicEReg`
 - `astItalicEReg`
 - `mathEReg`
 - `parSepEReg`
 - `emojiEReg`
 - `indentEReg`

**MarkdownVisualizer - new class!**

`MarkdownVisualizer` is a class consisting of the framework-specific markdown visualization methods. For now, only supports visualization for:

 - OpenFL (via `TextField`, `TextFieldRTL`)

**MarkdownBlocks - new class!**

`MarkdownBlocks` is the class that handles the code block's syntax highlighting in markdown.
It provides a user friendly way to edit the syntax, and all syntax handlers can be redefined with `MarkdownBlocks.parseLang = function(...)`

For now, syntax highlighting is only available (out-of-the-box) for theses languages:

 - JSON
 - Haxe
 - C#
 - C

More will be added in the future :)

**TextTools - new class!**

`TextTools` is a class containing static methods for manipulating text. it contains:

 - `replaceFirst()` - replaces the first occurrence of a substring inside a string
 - `replaceFirst()` - replaces the last occurrence of a substring inside a string
 - `filter()` - filters a string according to the `EReg` or `String` supplied
 - `multiply()` - multiplies a string by `X` times
 - `indexesOf()` finds and reports all occurrences of a substring inside a string
 - `indexesFromArray()` finds and reports all occurrences of the supplied substrings inside a string
 - `indexesFromEReg()` finds and reports all occurences of the findings of a regex pattern in a string.
 
**Emoji - new class!**

the `Emoji` class is pretty simple, yet powerful. it has mapping for very single emoji that github support:

 - :joy: turns into 😂
 - :flushed: turns into 😳


etc.

I want to thank **PXShadow** for providing the map itself and making this possible

### Bug Fixes:

**FlxInputTextRTL:**

 - removed bulky and old code
 - fixed lag spikes when the textfield is selected for a long time

**FlxInputText**
 - fixed first char nor disappearing after deleting all of the text (JS)
 - fixed multiline crashing the app on JS
 - fixed weird bugs with the height's consistency
 - fixed horizontal scrolling behaving weirdly on multiline text

1.1.4 (March 20, 2022)
===
### **Bug Fix:**
 - fixed pasting an image/empty text from the clipboard adding `null` to the text

1.1.3 (March 20, 2022)
===
### **New Features:**

 - moved `CharTools` and `WordWrapper` into the folder `general`

### FlxInputTextRTL

 - added support for pasting text from the clipboard (LTR text only)
 - added event dispatching for when `home` and `end` buttons are pressed
 - `getCharBoundaries` is now a public field, and was optimized a bit more to report more acurate bounds
 - `getCaretIndexAtPoint` is now a public field and should be more accurate 


### **Bug Fixes:**

### FlxInputTextRTL

 - fixed sound tray activating when pressing `-` or `=` while having focus
 - fixed `getCharBoundaries` crashing when the text contains only `space` chars & `enter`s


1.1.2 (February 29, 2022)
===

### **Bug Fixes:**

- removed testing files 
- fixed incorrect markdown syntax in CHANGELOG
- `About Copying` in `README.md` has been removed since it isn't relevant
- `LICENSE` file was changed to `LICENSE.md`

1.1.1 (February 28, 2022)
===

### **New Features:**

### FlxInputTextRTL

- Added field `openingDirection` to get the base direction of the text. is not related to `alignment`

### CharTools

- Added an `generalMarks` - an `Array<String>` of all **common** text marks (math/grammer characters)


### **Bug Fixes:**

### FlxInputTextRTL

- Fixed `getCaretIndexAtPoint()` reporting incorrect index when pressing between the lines of text
- Fixed a crash where `getCharBoundaries()` reports null for `rect.width`
- Fixed a crash after trying to wordwrap lots of `spacebar`s
- Fixed enter alignment being incorrect when the text is aligned to the right
- Fixed `spacebar` not moving when switching between languages of different direction
- Fixed `getCharBoundaries()` reporting inaccurate dimensions when pressing `spacebar`
- Fixed text aligning & "sticking" to the left when softly typed chars are being typed
- Fixed a crash when pressing between word-wrapped lines
- Fixed misplacing of punctuation marks in RTL languages
- Fixed caret sticking to the outline of the input text when `text = ""`
- Fixed `up` & `down` keys behaving incorrectly
- Fixed caret being **graphically** misplaces when lots of `spacebar`s are being typed
- Fixed textbox cutting "tall" letters (`l`, `j`, `f`, `t`...)

### CharTools

- Changed `numericChars`'s `EReg` to `~/[0-9]/g`


1.1.0 (February 24, 2022)
===
### **New Features:**

### CharTools

- added chars for text direction manipulation.
- added more regular chars
- added documentation

### FlxTextButton

- class has been reworked and extra fields were added
- documentation has been added to all class methods & fields
- now extends `FlxSpriteGroup` to support more label types.
- will also use `FlxInputTextRTL` at its core to support input for the button's text.

### FlxInputTextRTL

- added `autoAlign` field to enable alignment based on the first char
- text background now matches the size of the font isntead of being a fixed size

### README

- fixed typos
- moved the roadmap to `Roadmaps.md`
    

### **Bug Fixes:**

### FlxInputTextRTL

- didnt support `enter` callback, now supported.
- `enter` button on RTL languages now behaves correctly.
- BiDi on non-JS platform now behaves correctly
- fixed caret positioning reseting to (0,0) when pressing enter
- fixed caret positioning reseting to (0,0) when pressing spacebar twice in a row
- fixed a crash when pressing spacebar twice and then enter
- fixed text background expanding too far vertically when pressing enter
- `getCharBoundaries()` is now supposed to report accurate boundaries for the specified char
- fixed text input slowdown when many chars are displayed


1.0.0 (February 21, 2022) - **Official Release!**
===
### **New Features:**

### CharTools - new class! features:

- added an EReg of RTL letters
- added an EReg of numeric chars

### FlxInputTextRTL** - new class! features:

- added multi-language support
- added RTL support
- added BiDi support (Bi-Directional text support)
- added support for more unicodes

### FlxTextButton** - **new class!** features:

- simplified button methods & fields with FlxText base
- easy button disabling/enabling



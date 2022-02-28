1.1.1 (February 28, 2022)
---

### **New Features:**

### FlxInputTextRTL

- Added field `openingDirection` to get the base direction of the text. is not related to `alignment`


### **Bug Fixes:**

### FlxInputTextRTL

- Fixed `getCaretIndexAtPoint()` reporting incorrect index when pressing between the lines of text
- Fixed a crash where `getCharBoundaries()` reports null for `rect.width`
- Fixed enter alignment being incorrect when the text is aligned to the right
- Fixed `spacebar` not moving when switching between languages of different direction
- Fixed `getCharBoundaries()` reporting inaccurate dimensions when pressing `spacebar`
- Fixed text aligning & "sticking" to the left when softly typed chars are being typed
- Fixed a crash when pressing between word-wrapped lines
- added support for punctuation marks with RTL languages
- Fixed caret sticking to the outline of the input text when `text = ""`

1.1.0 (February 24, 2022)
--- 
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
---
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



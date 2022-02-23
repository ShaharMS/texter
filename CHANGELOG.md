1.1.0 (February 24, 2022)
--- 
### New Features:

- **CharTools** 
    - added chars for text direction manipulation.
    - added more regular chars
    - added documentation

- **FlxTextButton** 
    - class has been reworked and extra fields were added
    - documentation has been added to all class methods & fields
    - now extends `FlxSpriteGroup` to support more label types.
    - will also use `FlxInputTextRTL` at its core to support input for the button's text.

- **FlxInputTextRTL**
    - added `inputMode` field to enable/disable text input
    - text background now matches the size of the font

### Bug Fixes:

- **FlxInputTextRTL**
    - didnt support `enter` callback, now supported.
    - `enter` button on RTL languages now behaves correctly.
    - BiDi on non-JS platform now behaves correctly
    - fixed caret positioning reseting to (0,0) when pressing enter
    - fixed caret positioning reseting to (0,0) when pressing spacebar twice in a row
    - fixed a crash when pressing spacebar twice and then enter
    - fixed text background expanding too far vertically when pressing enter
    - `getCharBoundaries()` is now supposed to report accurate boundaries for the specified char
    - fixed text input slowdown when many chars displayed


1.0.0 (February 21, 2022) - **Official Release!**
---
### New Features:

- **CharTools**
    - added an EReg of RTL letters
    - added an EReg of numeric chars

- **FlxInputTextRTL**
    - added multi-language support
    - added RTL support
    - added BiDi support (Bi-Directional text support)
    - added support for more unicodes

- **FlxTextButton** - **new class!** features:
    - simplified button methods & fields with FlxText base
    - easy button disabling/enabling



1.1.0 (February 22, 2022)
--- 
### New Features:

- **CharTools** 
    - added chars for text direction manipulation.
    - added documentation

- **FlxTextButton** 
    - class has been reworked and extra fields were added
    - documentation has been added to all class methods & fields
    - now extends `FlxSpriteGroup` to support more label types.
    - will also use `FlxInputTextRTL` at its core to support input for the button's text.

- **FlxInputTextRTL**
    - added `inputMode` field to enable/disable text input

### Bug Fixes:

- **FlxInputTextRTL**
    - didnt support `enter` callback, now supported.
    - `enter` button on RTL languages now behaves correctly.
    - BiDi on non-JS platform now behaves correctly
    - fixed caret positioning reseting to (0,0) when pressing enter
    - fixed caret positioning reseting to (0,0) when pressing spacebar twice in a row
    - fixed a crash when pressing spacebar twice and then enter
    -




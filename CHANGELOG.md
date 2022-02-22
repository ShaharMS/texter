1.1.0 (February 22, 2022)
--- 
### New Features:

- **CharTools** 
    - added documentation and chars for text direction manipulation.

- **FlxTextButton** 
    - class has been reworked and extra fields were added
    - documentation has been added to al class methods & fields
    - now extends `FlxSpriteGroup` to support more label types.
    - will also use `FlxInputTextRTL` at its core to support input for the button's text.

### Bug Fixes:

- **FlxInputTextRTL**
    - didnt support `enter` callback, now supported.
    - `enter` button on RTL languages now behaves correctly.
    - BiDi on non-JS platform now behaves correctly



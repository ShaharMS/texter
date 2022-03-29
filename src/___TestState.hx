package;
import texter.flixel.FlxInputTextRTL;
import openfl.events.KeyboardEvent;
import texter.general.markdown.Markdown;
import texter.general.markdown.MarkdownEffects;
import texter.general.Char;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;
class ___TestState extends FlxState {
    override function create() {
        super.create();
        //Markdown.interpret(md4, callback);
        add(new FlxInputTextRTL(10, 10, 400, "", 40));
    }

    function callback(text:String, effects:Array<MarkdownEffects>) {
		trace(text);
        trace(effects);
    }

	var md = "# texter

## I'll start with a story

About 5 month ago, just a month after I started programming in haxeflixel, I wanted to make an app that needed text input, specificly of type RTL.

for about 2 months I tried to find some existing (decent) RTL support, but didnt find any that were good enough.

### It was the time I decided to take this duty upon myself - to add more support for text input (in that time - only in haxeflixel)

It might seem like I'm exaggerating, but trust me, it took me a **while** to make progress. but when I did start making (good) progress,
I figured I'm not the only person that needs those fixes, **and thats how and why I created this library.**

### **Can I Help/Contribute?**
Of course! Any help is greatly appreciated! You can help with: 
 - fixing bugs
 - writing/fixing documentation
 - making code more readable/simpler & shorter (don't worry, I think my code is pretty understandable ;) )
 - writing code for the library
 - adding projects that you think are useful 

And more that pops up in you mind!

# Installation

#### to install the stable version:
```
haxelib install texter
```

#### to install the newer - but maybe unstable git version - 
```
haxelib git texter https://github.com/ShaharMS/texter.git
```
";
    var md2 = "***hey***";
	var md3 = "### *bob* **tim** *jim* ***bobjim*** ***jimbob***";
    var md4 = '2.0.0 (Month X, 2022) - Major Update!
===
### **Bug Fixes:**

**FlxInputTextRTL:**

 - removed unnecesarry field from `getCharBoundaries`
 - fixed issues with caret positioning
 - fixed offcentered caret in very large/very small font sizes
 - fixed lag spikes when focus is being repetitively given to the text.

### **New Features:**

**FlxInputTextRTL**

 - added `getAlignment()` method
 - added `getCaretIndexAtPoint()` method
 - added `HOME_ACTION` and `END_ACTION`

**Char - new type! features:**

 - extends `String` to report the character\'s `charCode`
 - can be instantiated with a `String` or `Int`

**CharTools:**

 - added `charFromValue` map
 - added `charToValue` map
 - `fromCharArray` and `toCharArray` now use `Char`s instead of `String`s

**Markdown - new class! features:**

 - added an array of markdown ERegs - `markdownRules`
 - added access to all markdown patterns via `Markdown.patterns`. more information in `MarkdowPatterns`
 - added `interpret()` - a cross-platform, cross-framework markdown interpreter based on ADTs (algebric data types) from `MarkdownEffects.hx`

**MarkdownPatterns - new class!**

`MarkdownPatterns` is a class consisting of the following markdown patterns: (more will be added in the future)
 - `hRuleEReg`
 - `boldEReg`
 - `italicEReg`
 - `mathEReg`
 - `parSepEReg`
 - `emojiEReg`
 - `titleEReg`
 - `listItemEReg`
 - `imageEReg`
 - `codeblockEReg`
 - `linkEReg`

**Emoji - new class!**

`Emoji` is a class that contains every single emoji supported by github. it contains:
 - `emojiToString()` - a function to convert an emoji into a string
 - `emojiFromString()` - a function to convert a string into an emoji
 - `extractEmojis()` - a function to extract all emojis present in a string of text

**TextTools - new class!**

`TextTools` is a class containing static methods for manipulating text. it contains:
 - `replaceFirst()` - replaces the first occurrence of a string inside another string
 - `replaceFirst()` - replaces the last occurrence of a string inside another string
 
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
 - fixed `getCharBoundraies` crashing when the text contains only `space` chars & `enter`s


1.1.2 (February 29, 2022)
===

### **Bug Fixes:**

- removed testing files 
- fixed incorrect markdown syntax in CHANGELOG
- `About Copying` in `README.md` has been removed since it isn\'t relevant
- `LICENSE` file was chaned to `LICENSE.md`

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

- Changed `numericChars`\'s `EReg` to `~/[0-9]/g`


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
- will also use `FlxInputTextRTL` at its core to support input for the button\'s text.

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


';
}
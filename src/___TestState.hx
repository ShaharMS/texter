package;
import texter.general.markdown.Markdown;
import texter.general.markdown.MarkdownEffects;
import texter.flixel.FlxInputTextRTL;
import texter.general.Char;
import texter.flixel.FlxTextButton;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;
class ___TestState extends FlxState {
	var t:FlxInputTextRTL;
    override function create() {
        super.create();
        Markdown.interpret(md, callback);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
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
}
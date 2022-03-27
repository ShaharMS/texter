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

    var md = "### **bold text** sussy **quick *test*** $some math$ and also `CODE`";
}
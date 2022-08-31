package;

#if openfl
import texter.openfl.TextFieldRTL;
import texter.openfl.DynamicTextField;
import openfl.text.TextField;
import openfl.events.FocusEvent;
import openfl.events.Event;
#end
import texter.general.CharTools;
import texter.general.bidi.Bidi;
using TextTools;

/**
    This class provides useful tools to add support for Right-to-Left Texts.

    to use it, you need to add the following line to the top of your file:
    
        using BidiTools;
**/
class BidiTools {
    

    /**
        Returns the correct form a bidirectional text script should be represented:

        | Expression | Becomes |
        | ---------- | ------- |
        | "ltr"       | "ltr"     |
        | "לאמשל ןימי" | "ימין לשמאל" |
        | " - לאמשל ןימי" | "ימין לשמאל - " |

        #### Things to know
        - you can combine rtl and ltr text
        - You can process the same text twice, prefixed or postfixed, and you will get the same result, or a corrected one for the extra chars. insertions and deletions are not corrected.
        - numbers might change position, but that happens to make the text more readable

        @param text the text to be processed.
    **/
    public static function bidifyString(text:String) {
        return Bidi.process(text);
    }

    #if openfl
    public static function __attachOpenFL(textfield:TextField):Void {

        function getBidified(text:String):String {
            var processed = text;
            //var offset = 0;
            //for (i in 1...text.length) {
            //    var previousCharPos = textfield.getCharBoundaries(i + offset - 1);
            //    var charPos = textfield.getCharBoundaries(i + offset);
            //    if (charPos.y > previousCharPos.y && text.charAt(i + offset - 1) != "\n") {
            //        processed.insert("\n", i + offset);
            //        offset++;
            //    }
            //}
            return Bidi.process(processed);
        }

        var unbidified:String = textfield.text;
        var nText = new TextField();
        function displayChanges(e:Event) {
            nText.defaultTextFormat = textfield.defaultTextFormat;
            nText.width = textfield.width;
            nText.x = textfield.x;
            nText.y = textfield.y + textfield.height;
            nText.height = textfield.height;
            nText.text = getBidified(textfield.text);
        }

        function displayBidifiedBelow(e) {
            var tf = textfield.defaultTextFormat;
            tf.align = if (CharTools.isRTL(textfield.text.charAt(0)) && tf.align != "center") "right" else tf.align;
            textfield.text = unbidified;
            nText.defaultTextFormat = textfield.defaultTextFormat;
            nText.width = textfield.width;
            nText.x = textfield.x;
            nText.y = textfield.y + textfield.height;
            nText.height = textfield.height;
            nText.multiline = textfield.multiline;
            nText.wordWrap = textfield.wordWrap;
            nText.text = getBidified(textfield.text);
            textfield.parent.addChild(nText);
            textfield.addEventListener(Event.CHANGE, displayChanges);
        }

        function applyBidified(e) {
            unbidified = textfield.text;
            textfield.text = nText.text;
            textfield.parent.removeChild(nText);
        }

        function invoke(fromEvent = false, e:Event) {
            if (fromEvent) textfield.removeEventListener(Event.ADDED_TO_STAGE, invoke.bind(true));
            textfield.addEventListener(FocusEvent.FOCUS_IN, displayBidifiedBelow);
            textfield.addEventListener(FocusEvent.FOCUS_OUT, applyBidified);
        
        }
        
        if (textfield.stage == null) {
            textfield.addEventListener(Event.ADDED_TO_STAGE, invoke.bind(true));
        } else {
            invoke(false, null);
        }
    }

    public static function __attachLiveOpenFL(textfield:TextField):Void {
        
        var unbidified:String = textfield.text;
        var outsideStage = new TextField();
        function displayChanges(e:Event) {
            outsideStage.text = textfield.text.contains(CharTools.RLM) ? Bidi.unbidify(textfield.text) : textfield.text;
            var prevc = textfield.caretIndex;
            textfield.text = bidifyString(outsideStage.text);
            var relCaretIndex = prevc + textfield.text.substring(0, prevc).countOccurrencesOf(CharTools.RLM);
            while (textfield.text.charAt(relCaretIndex - 1) == " ") relCaretIndex--;
            trace(textfield.text.charAt(relCaretIndex));
            textfield.setSelection(relCaretIndex, relCaretIndex);
            trace(textfield.text.indexesOf(CharTools.RLM));
            trace(textfield.text.countOccurrencesOf("\n"));
        } 

        function invoke(fromEvent = false, e:Event) {
            if (fromEvent) textfield.removeEventListener(Event.ADDED_TO_STAGE, invoke.bind(true));
            outsideStage = new TextField();
            outsideStage.x = outsideStage.y = -200;
            outsideStage.width = outsideStage.height = 100;
            textfield.stage.addChild(outsideStage);
            textfield.addEventListener(Event.CHANGE, displayChanges);
        }
        
        if (textfield.stage == null) {
            textfield.addEventListener(Event.ADDED_TO_STAGE, invoke.bind(true));
        } else {
            invoke(false, null);
        }
    }

    public static overload extern inline function attachBidifier(textfield:TextField):Void {
        __attachLiveOpenFL(textfield);
    }

    public static overload extern inline function attachBidifier(textfield:DynamicTextField):Void {
        __attachOpenFL(textfield.textField);
    }

    public static overload extern inline function attachBidifier(textfield:TextFieldRTL) {
        __attachOpenFL(textfield.textField);
    }
    #end

}
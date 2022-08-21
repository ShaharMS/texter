package;

import flash.events.TextEvent;
import openfl.text.TextField;
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
    public static overload extern inline function attachBidifier(textfield:TextField) {
        textfield.addEventListener(TextEvent.TEXT_INPUT, (event) -> {
            var letterAtCaretIndex = textfield.text.charAt(textfield.caretIndex - 1 > 0 ? textfield.caretIndex - 1 : 0);
            if (CharTools.isRTL(letterAtCaretIndex)) {
                textfield.text = Bidi.process(textfield.text);
            }
        });
    }
    #end

}
package texter.openfl;

import texter.general.math.MathAttribute;
import texter.general.math.MathLexer;
import openfl.events.Event;
import openfl.display.Sprite;
import openfl.text.TextField;
import texter.openfl._internal.TextFieldCompatibility;

/**
 * A TextField that specializes in displaying mathematical
 * forms of string.
 * 
 * For example, this equation: `f(x) = 2x + 5`  
 * will display as: `$f(x) = 2x + 5$`
 */
class MathTextField extends TextFieldCompatibility {

    var textFields:Array<TextField> = [];

    public function new() {
        super();
        textField.addEventListener(Event.CHANGE, render);
    }

    function render(e:Event) {
        var currentText = text;
        var mathProps:Array<MathAttribute> = MathLexer.splitBlocks(
            MathLexer.reorderAttributes(
                MathLexer.getMathAttributes(currentText)
            )
        );
        
    }
     
}
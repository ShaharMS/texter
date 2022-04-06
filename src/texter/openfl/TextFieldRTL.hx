package texter.openfl;

import openfl.text.*;
import openfl.text._internal.*;

@:access(openfl.text._internal.TextEngine)
class TextFieldRTL extends TextField {
    
    /**
     * The internal TextEngine used to render the text.
     */
    public var engine(default, null):TextEngine;

    public function new() {
        super();
        engine = __textEngine;
        engine.__textLayout.direction = RIGHT_TO_LEFT;
        engine.__textLayout.script = HEBREW;

    }
}
package texter.haxeui;

import haxe.ui.core.TextInput;
import haxe.ui.components.TextField;

class TextFieldRTL extends TextInput {

    @:isVar public var useMarkdown(default, set):Bool;
    
    function set_useMarkdown(useMarkdown:Bool):Bool {
        throw "Not implemented";
    }

    public function new() {
        super();
    }
}
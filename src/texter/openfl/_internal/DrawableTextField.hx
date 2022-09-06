package texter.openfl._internal;

import openfl.display.Shape;
import openfl.events.Event;
import openfl.display.Sprite;

/**
 * A regular textfield with a sprite baclground. will get released in the future when more feature-rich
 */
class DrawableTextField extends TextFieldCompatibility {
    

    public var backgroundSprite = new Sprite();
    var m = new Shape();
    
    public function new() {
        super();
        addChild(textField);
        m.graphics.drawRect(0,0,textField.width, textField.height);
        addChild(m);
        backgroundSprite.mask = m;
        addChild(backgroundSprite);
        addEventListener(Event.ENTER_FRAME, render);
    }

    function render(e:Event) {
        m.graphics.drawRect(0,0,textField.width, textField.height);
        backgroundSprite.x = textField.scrollH;
    }
}
package texter.openfl;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.text.TextFormat;
import texter.general.math.MathAttribute;
import texter.general.math.MathLexer;
import openfl.events.Event;
import openfl.display.Sprite;
import openfl.text.TextField;
import texter.openfl._internal.TextFieldCompatibility;
import texter.openfl._internal.DrawableTextField;

/**
 * A TextField that specializes in displaying mathematical
 * forms of string.
 * 
 * For example, this equation: `f(x) = 2x + 5`  
 * will display as: `$f(x) = 2x + 5$`
 */
class MathTextField extends TextFieldCompatibility {

    	var textFields:Array<DrawableTextField> = [];

    	var baseBackground:Bitmap;

    	public function new() {
        	super();
        	textField = new TextField();
        	textField.addEventListener(Event.CHANGE, render);
        	textField.x = textField.y = -100;
        	textField.defaultTextFormat.size = 16;
        	addEventListener(Event.ADDED_TO_STAGE, e -> {
            		stage.addChild(textField);
        	});
        	baseBackground = new Bitmap(new BitmapData(100, 100, true));
        	addChild(baseBackground);
    	}

    	public function render(e:Event) {
        	trace("called with", text);
        	var currentText = text;
        	var mathProps:Array<MathAttribute> = MathLexer.resetAttributesOrder(
            		MathLexer.splitBlocks(
                		MathLexer.getMathAttributes(
                    			text
                		)
            		)	
        	);

        	//TODO: #9 Better Implementation for rendering in MathTextField
        	trace("before removal");
        	for (t in textFields) if (t != null) removeChild(t);
        	trace("after removal");
        	textFields = [];
        	var smallClosure = false;
        	for (element in mathProps) {
            		trace(element);
            		switch element {
                		case FunctionDefinition(index, letter): {
                    			var t = new DrawableTextField();
                    			t.defaultTextFormat = new TextFormat(null, textField.defaultTextFormat.size + 4);
                    			t.text = letter;
                    			textFields.push(t);
                    			smallClosure = true;
                    			continue;
                		}
                		case Division(index, upperHandSide, lowerHandSide): {
                    			var uhsText = MathLexer.extractTextFromAttributes([upperHandSide]);
                    			var lhsText = MathLexer.extractTextFromAttributes([lowerHandSide]);
                    			var t = new DrawableTextField();
                    			t.defaultTextFormat = new TextFormat(null, textField.defaultTextFormat.size, null, null, null, null, null, null, "center");
                    			t.text = '$uhsText\n$lhsText';
                    			textFields.push(t);
                		}
                		case Variable(index, letter) | Number(index, letter) | Sign(index, letter) | StartClosure(index, letter) | EndClosure(index, letter): {
                    			var t = new DrawableTextField();
                    			t.defaultTextFormat = new TextFormat(null, textField.defaultTextFormat.size);
                    			t.text = letter;
                    			textFields.push(t);
                		}
                		case Closure(index, letter, content): {
                    			var t = new DrawableTextField();
                    			t.defaultTextFormat = new TextFormat(null, smallClosure ? Std.int(textField.defaultTextFormat.size / 2) : textField.defaultTextFormat.size);
                    			var prefix = if (letter == ")") "(" else if (letter == "]") "[" else "{";
                    			var postfix = letter;
                    			var c = MathLexer.extractTextFromAttributes(content);
                    			t.text = '$prefix$c$postfix';
                    			textFields.push(t);
                		}
                		case Null(index):
            		}
            		smallClosure = false;
        	}
        	trace("gets to line 108");
        	var xPos = 0.;
        	trace(textFields);
        	for (t in textFields) {
            		addChild(t);
            		if (defaultTextFormat.bold) t.defaultTextFormat = new TextFormat("assets/texter/MathTextField/math-bold.ttf", 40, 0x000000);
            		else  t.defaultTextFormat = new TextFormat("assets/texter/MathTextField/math-regular.ttf", 40, 0x000000);
            		t.width = t.textWidth + 4;
            		t.height = t.textHeight + 4;
            		t.x = xPos;
            		xPos += t.width;
            		t.y = t.height > textField.height ? 0 : textField.height / 2 - t.height / 2;
        	}
        	trace(x, y, textField.width, textField.height, textFields);
    	}
     
}

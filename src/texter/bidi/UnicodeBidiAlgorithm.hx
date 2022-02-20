package texter.bidi;
import lime.text.UTF8String;
import texter.bidi.algorithm.*;

/**
 * The actual algorithm class that combines all of the `Bidi`ing tools.
 * 
 * usage:
 * ```haxe
 * 	var text = UnicodeBidiAlgorithm.display(yourText);
 * ```
 */
class UnicodeBidiAlgorithm {

  	public static function displayParagraph(paragraph:UTF8String):UTF8String {
    	var data = Statics.getDataStructure();

    	data.chars = Paragraph.preprocessText(paragraph);
    	data.level = Paragraph.getParagraphLevel(data.chars);

    	Explicit.explicitLevelsAndDirections(data);
    	PrepareImplicit.preparations_for_implicit_processing(data);
    	ResolveWeak.resolve_weak_types(data);
    	ResolveNeutral.resolve_neutral_and_isolate_formatting_types(data);
    	ResolveImplicit.resolveImplicitLevels(data);

    	// acording to UAX #9, at this point, we can inser shaping & paragraph wrapping.
    	// up to this point, no actual reordering happened. Just metadata juggling.

    	ReorderResolved.reorder_resolved_levels(data);

    	var result:UTF8String = "";
    	for (dataChar in data.chars) {
    	  	result += dataChar.char;
    	}

    	return result;
 	}

  	public static function display(text:UTF8String):UTF8String {
    	var result = [];

    	for (line in text.split("\n")) {
    	  	result.push(displayParagraph(line));
    	}

    	return result.join("\n");
  	}

}
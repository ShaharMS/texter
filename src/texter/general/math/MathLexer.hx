package texter.general.math;

import flash.utils.QName;

using TextTools;
using StringTools;
using texter.general.CharTools;

class MathLexer {

    public static var numbers:String = '0123456789';

    public static var startClosures:String = '{[(';

    public static var endClosures:String = '}])';

    /**
     * Returns a simplified array of mathematical attributes. to further
     * process this array, you can use the rest of the functions in this class.
     * @param text the text to be lexed and "trransformed" into an attribute array
     * @return Array<MathAttribute>
     */
    public static function getMathAttributes(text:String):Array<MathAttribute> {
        var attributes:Array<MathAttribute> = [];
        text = text.trim().remove(" ").replace("sqrt", "√");

        for (i in 0...text.length) {
            var char = text.charAt(i);

            if (numbers.contains(char)) {
                attributes.push(Number(i, char));
            }
            else if (startClosures.contains(char)) {
                attributes.push(StartClosure(i, char));
            }
            else if (endClosures.contains(char)) {
                attributes.push(EndClosure(i, char));
            }
            else if ('${CharTools.generalMarks.join("")}√'.contains(char)) {
                attributes.push(Sign(i, char));
            }
            else if (char.isRTL() || char.isLTR()) {
                attributes.push(Variable(i, char));
            }

        }

        return attributes;
    }

    /**
     * Fixes the order of elements in the array to match the one in the string representation.
     * @param attributes an array of maybe incorreectly ordered attributes
     * @return Array<MathAttribute>
     */
    public static function reorderAttributes(attributes:Array<MathAttribute>):Array<MathAttribute> {
        var at = attributes.copy();

        for (item in attributes) {
            switch item {
                case Sign(index, _) | Variable(index, _) | Number(index, _) | StartClosure(index, _) | EndClosure(index, _) | Null(index) | FunctionDefinition(index, _): at[index] = item;
                default:
            }
        }
        return at;
    }

    /**
     * Fixes the output of `splitBlocks` to correctly print to a string.
     * 
     * takes in an array of attributes and resets their order to actually make sense:
     * 
     * this
     * ```
     * [Variable(6, "x"), Closure(")", 19, [Number(3, "123")])]
     * ```
     * becomes this:
     * ```
     * [Variable(0, "x"), Closure(")", 1, [Number(0, "123")])]
     * ```
     * 
     * `Null`s will always have an index of -1.
     */
    public static function resetAttributesOrder(attributes:Array<MathAttribute>):Array<MathAttribute> {
        var copy = attributes.copy();
        for (i in 0...copy.length) {
            var element = attributes[i];
            switch element {
                case FunctionDefinition(_, letter): copy[i] = FunctionDefinition(i, letter);
                case Variable(index, letter): copy[i] = Variable(i, letter);
                case Number(index, letter): copy[i] = Number(i, letter);
                case Sign(index, letter): copy[i] = Sign(i, letter);
                case StartClosure(index, letter): copy[i] = StartClosure(i, letter);
                case EndClosure(index, letter): copy[i] = EndClosure(i, letter);
                case Closure(index, letter, content): {
                    var contentCopy = resetAttributesOrder(content);
                    copy[i] = Closure(i, letter, contentCopy);
                }
                case Division(index, upperHandSide, lowerHandSide): {
                    var uhs = resetAttributesOrder([upperHandSide]);
                    var lhs = resetAttributesOrder([lowerHandSide]);
                    copy[i] = Division(i, uhs[0], lhs[0]);
                }
                case Null(index): copy[i] = Null(-1);
            }
        }
        return copy;
    }

    /**
     * Removes completely duplicate elements (elements with the same arguments & type). The first element of the similar
     * ones will be the only one "saved"
     * @param attributes the array that mioght contain duplicates
     * @return Array<MathAttribute>
     */
    public static function removeDuplicates(attributes:Array<MathAttribute>):Array<MathAttribute> {
        var copy = [];
        for (a in attributes) if (!copy.contains(a)) copy.push(a);

        return copy;
    }

    /**
     * Removes whitespaces from a geven array of mathematical attributes. Whitespaces shouldnt appear in the first place.
     * if you need to call this, you might have done something wrong, but this function can still save you from yourself :)
     * @param attributes the attributes that may ot may not contain whitespace ones
     * @return an array empties of whitespace elements
     */
    public static function condenseWhitespaces(attributes:Array<MathAttribute>):Array<MathAttribute> {
        var whitespaced:Array<MathAttribute> = reorderAttributes(attributes);

        //first, remove all whitespaces
        for (a in whitespaced) {
            if (a == null) continue;
            switch a {
                case Variable(index, " ") | Number(index, " ") | Sign(index, " "):
                    whitespaced[index] = Null(index);
                default:
            }
        }
        trace(whitespaced);
        return whitespaced;
    }

    /**
     * Gets an array of `MathAttribute`s and returns their text representation. `Null` elements will be ignored, correctly.
     * @param attributes the mathematical attributes
     * @return The attributes' text representation
     */
    public static function extractTextFromAttributes(attributes:Array<MathAttribute>):String {
        var a = [];
        for (item in attributes) {
            switch item {
                case FunctionDefinition(index, letter): a[index] = letter;
                case Division(index, upperHandSide, lowerHandSide): {
                    a[index] = '${extractTextFromAttributes([upperHandSide])}/${extractTextFromAttributes([lowerHandSide])}';
                }
                case Variable(index, letter): a[index] = letter;
                case Number(index, letter): a[index] = letter;
                case Sign(index, letter): a[index] = letter;
                case Closure(index, letter, content): {
                    final start = if (letter.contains("{") || letter.contains("}")) "{" else if (letter.contains("[") || letter.contains("]")) "[" else "(";
                    final end = switch start {case "{": "}"; case "[": "]"; default: ")";};
                    a[index] = '${start}${extractTextFromAttributes(content)}${end}';
                }
                case StartClosure(index, letter): a[index] = letter;
                case EndClosure(index, letter): a[index] = letter;
                case Null(index): 
                
            }
        }
        return a.join("").replace("null", "");
    }

    /**
        Gets an array of Mathematical Atributes and groups related elements to be more "useful":

         - Multiple numbers grouped together will become one element
         - StartClosure and EndClosure should be merged into one `Closure`
         - Division hand sides will be merged into one `Division` element
         - The resulting array will be in order, but element indices will get messed up. before extracting the text, use `resetAttributesOrder()`
    **/
    public static function splitBlocks(attributes:Array<MathAttribute>):Array<MathAttribute> {
        //first, merge numbers
        var numbersMerged = attributes.copy();
        attributes.push(Null(-1));
        var currentNum = "";
        var startIndex = -1;
        for (a in attributes) {
            switch a {
                case Number(index, letter): {
                    if (startIndex == -1) startIndex = index;
                    currentNum += letter;
                }
                default: {
                    if (currentNum.length != 0) {
                        //set the other items to `Null(-1)` to be removed later.
                        for (i in startIndex...startIndex + currentNum.length) {
                            numbersMerged[i] = Null(-1);
                        }
                        numbersMerged[startIndex] = Number(startIndex, currentNum);
                        currentNum = "";
                        startIndex = -1;
                    }
                }
            }
        }
        numbersMerged = numbersMerged.filter(a -> !Type.enumEq(a, Null(-1)));

        //TODO: #8 More efficient implementation of parenthesis grouping in SplitBlocks
        //Closure grouping - iterative scan from the begining of the array for Start & End Closure elements
        var closuresMerged = numbersMerged.copy();
        trace(closuresMerged);
        var i = 0;
        var start:Int = -1, end:Int = -1;
        var elements:Array<MathAttribute> = [];
        while (i < numbersMerged.length) {
            var element = closuresMerged[i];
            switch element {
                case StartClosure(index, letter): {
                    elements = [];
                    start = i;
                }
                case EndClosure(index, letter): {
                    end = i;
                    for (id in start...end) {
                        closuresMerged[id] = Null(-1);
                    }
                    closuresMerged[i] = Closure(end, letter, elements);
                    start = end = -1;
                    i = 0;
                    continue;
                }
                case Null(index): //dont push nulls
                default: {
                    if (start != -1) {
                        elements.push(element);
                    }
                }
            }
            i++;
        }
        closuresMerged = closuresMerged.filter(a -> !Type.enumEq(a, Null(-1)));

        var divisionsCondensed = closuresMerged.copy();
        //if we go end -> start, we would be able to scan everything, and still nest correctly
        var i = divisionsCondensed.length;
        while (--i > 0) {
            var element = divisionsCondensed[i];
            switch element {
                case Sign(index, "/") | Sign(index, "\\") | Sign(index, "÷"):{
                    var uhs = divisionsCondensed[i - 1];
                    var lhs = divisionsCondensed[i + 1];
                    divisionsCondensed[i] = Division(i, uhs, lhs);
                    divisionsCondensed[i - 1] = divisionsCondensed[i + 1] = Null(-1);
                }
                default:
            }
        }

        return divisionsCondensed.filter(a -> !Type.enumEq(a, Null(-1)));
    }
}

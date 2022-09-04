package texter.general.math;

using TextTools;
using texter.general.CharTools;
class MathLexer {
    
    public static function getMathAttributes(text:String):Array<MathAttribute> {
        var attributes:Array<MathAttribute> = [];

        for (i in 0...text.length) {
            var char = text.charAt(i);

            if (CharTools.generalMarks.contains(char)) {
                attributes.push(Sign(i, char));
            }

            if (CharTools.numbers.contains(char)) {
                attributes.push(Number(i, char));
            }

            if (char.isRTL() || char.isLTR()) {
                attributes.push(Variable(i, char));
            }

        }

        return attributes;
    }

    public static function reorderAttributes(attributes:Array<MathAttribute>):Array<MathAttribute> {
        var at = attributes.copy();

        for (item in attributes) {
            switch item {
                case Sign(index, _) | Variable(index, _) | Number(index, _): at[index] = item;
                default:
            }
        }
        return at;
    }

    public static function condenseAttributes(attributes:Array<MathAttribute>):Array<MathAttribute> {
        var condensed:Array<MathAttribute> = reorderAttributes(attributes);

        //go over the reordered attributes, and check if the pattern of `Letter + ( + Content + )` exists. if so, type it as a FunctionLetter.
        for (i in 0...condensed.length - 2) {
            var item = condensed[i];
            var _item = condensed[i + 1];
            switch [item, _item] {
                case [Variable(index, letter), Sign(_, "(")]: {
                    for (f in index + 2...condensed.length) {
                        if (condensed[f] == Sign(f, ")")) {
                            condensed[i] = FunctionDefinition(i, letter);
                        }
                    }
                }
                default:
            }
        }

        var copy = condensed.copy();
        //iterate again, but now try to group divisions. This is the hardest part, and the array will be rewritten.
        for (i in 1...copy.length - 1) {
            var item = condensed[i - 1];
            var _item = condensed[i];
            var __item = condensed[i];

            switch _item {
                case Sign(i, "/") | Sign(i, "\\") | Sign(i, "÷"): {
                    switch [item, __item] {
                        case [Sign(inb, ")"), Sign(ina, "(")]: {

                        }
                        case 
                        [Variable(_, _), Variable(_, _)] | 
                        [Number(_, _), Variable(_, _)] | 
                        [Variable(_, _), Number(_, _)] | 
                        [Number(_, _), Number(_, _)]: 
                        {
                            condensed[i] = Division([item], [__item]);
                            condensed[i - 1] = null;
                            condensed[i + 1] = null;
                        }
                        default:
                    }
                }
                default:
            }
        }

        return condensed;
    }
}
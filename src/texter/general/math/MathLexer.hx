package texter.general.math;

using TextTools;
using texter.general.CharTools;
class MathLexer {
    
    public static function getMathAttributes(text:String):Array<MathAttribute> {
        var attributes:Array<MathAttribute> = [];
        text.remove(" ");

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
        var whitespaced:Array<MathAttribute> = reorderAttributes(attributes);

        //first, remove all whitespaces
        for (a in whitespaced) {
            switch a {
                case Variable(index, " "): whitespaced[index] = null;
                case Number(index, " "): whitespaced[index] = null;
                case Sign(index, " "): whitespaced[index] = null;
                default: a;
            }
        }

        var condensed = whitespaced.filter(a -> a != null);

        //go over the reordered attributes, and check if the pattern of `Letter + ( + Content + )` exists. if so, type it as a FunctionLetter.
        for (i in 0...condensed.length - 2) {
            var item = condensed[i];
            var _item = condensed[i + 1];
            switch [item, _item] {
                default:
                case [Variable(index, letter), Sign(_, "(")]: {
                    for (f in index + 2...condensed.length) {
                        if (Type.enumEq(condensed[f], Sign(f, ")"))) {
                            condensed[i] = FunctionDefinition(i, letter);
                        }
                    }
                }
            }
        }

        //iterate again, but now try to group divisions. This is the hardest part, and the array will be rewritten.
        for (i in 1...condensed.length - 1) {
            var item = condensed[i - 1];
            var _item = condensed[i];
            var __item = condensed[i + 1];
            if (_item == null) continue;
            switch _item {
                case Sign(i, "/") | Sign(i, "\\") | Sign(i, "÷"): {
                    switch [item, __item] {
                        case [Sign(inb, ")"), Sign(ina, "(")]: {
                            //search from the first index, backwards for an opening (
                            var ind = inb;
                            var attributesOnUpperHandSide = [];
                            while (!Type.enumEq(condensed[ind], Sign(ind, "(")) && ind > 0) {
                                ind--;
                                attributesOnUpperHandSide.push(condensed[ind]);
                            }

                            //search from the first index, backwards for an opening (
                            var ind2 = ina;
                            var attributesOnLowerHandSide = [];
                            while (!Type.enumEq(condensed[ind2], Sign(ind2, ")")) && ind2 < condensed.length - 1) {
                                ind2++;
                                attributesOnLowerHandSide.push(condensed[ind2]);
                            }

                            var indexSetter = attributesOnUpperHandSide.copy();
                            trace(indexSetter);
                            for (a in indexSetter) {
                                switch a {
                                    case FunctionDefinition(index, letter): condensed[index] = null;
                                    case Variable(index, letter): condensed[index] = null;
                                    case Number(index, letter): condensed[index] = null;
                                    case Sign(index, letter): condensed[index] = null;
                                    default:
                                }
                            }

                            var offset = i + attributesOnLowerHandSide.length;

                            condensed[i - 1] = condensed[i + 1] = null;
                            condensed[i] = Division(i, attributesOnUpperHandSide, attributesOnLowerHandSide);
                            for (a in i + 1...offset + 1) {condensed[a] = null;}
                            condensed[i + 2] = condensed[i + 3] = condensed[i + 4] = null;
                        }
                        case [Sign(ina, ")"), Variable(index, letter)] | [Sign(ina, ")"), Number(index, letter)]: {
                            //search from the first index, backwards for an opening (
                            var ind2 = ina;
                            var attributesOnLowerHandSide = [];
                            while (!Type.enumEq(condensed[ind2], Sign(ind2, ")")) && ind2 < condensed.length - 1) {
                                ind2++;
                                attributesOnLowerHandSide.push(condensed[ind2]);
                            }

                            var indexSetter = attributesOnLowerHandSide.copy();
                            indexSetter.push(Variable(index, letter)); //it doesnt matter the type, its used just for indexing.
                            for (a in indexSetter) {
                                switch a {
                                    case FunctionDefinition(index, letter): condensed[index] = null;
                                    case Variable(index, letter): condensed[index] = null;
                                    case Number(index, letter): condensed[index] = null;
                                    case Sign(index, letter): condensed[index] = null;
                                    default:
                                }
                            }
                            condensed[i] = Division(i, if (CharTools.numbers.contains(letter)) [Number(index, letter)] else [Variable(index, letter)], attributesOnLowerHandSide);
                        }
                        case [Variable(index, letter), Sign(inb, "(")] | [Number(index, letter), Sign(inb, "(")]: {
                            //search from the first index, backwards for an opening (
                            var ind = inb;
                            var attributesOnUpperHandSide = [];
                            while (!Type.enumEq(condensed[ind], Sign(ind, "(")) && ind > 0) {
                                ind--;
                                attributesOnUpperHandSide.push(condensed[ind]);
                            }

                            var indexSetter = attributesOnUpperHandSide.copy();
                            indexSetter.push(Variable(index, letter)); //it doesnt matter the type, its used just for indexing.
                            for (a in indexSetter) {
                                switch a {
                                    case FunctionDefinition(index, letter): condensed[index] = null;
                                    case Variable(index, letter): condensed[index] = null;
                                    case Number(index, letter): condensed[index] = null;
                                    case Sign(index, letter): condensed[index] = null;
                                    default:
                                }
                            }
                            condensed[i] = Division(i, attributesOnUpperHandSide, if (CharTools.numbers.contains(letter)) [Number(index, letter)] else [Variable(index, letter)]);
                        }
                        case 
                        [Variable(index, _), Variable(inde, _)] | 
                        [Number(index, _), Variable(inde, _)] | 
                        [Variable(index, _), Number(inde, _)] | 
                        [Number(index, _), Number(inde, _)]: 
                        {
                            condensed[i] = Division(index, [item], [__item]);
                            condensed[i - 1] = null;
                            condensed[i + 1] = null;
                        }
                        default: trace([item, __item]);
                    }
                }
                default:
            }
        }

        return condensed.filter((a) -> a != null);
    }

    public static function getAttributeText(attributes:Array<MathAttribute>):String {
        var a = [];
        for (item in attributes) {
            switch item {
                case FunctionDefinition(index, letter): a[index] = letter;
                case Division(index, upperHandSide, lowerHandSide): {
                    a[index] = '${getAttributeText(upperHandSide)})/(${getAttributeText(lowerHandSide)}';
                }
                case Variable(index, letter): a[index] = letter;
                case Number(index, letter): a[index] = letter;
                case Sign(index, letter): a[index] = letter;
            }
        }
        return a.join("").replace("null", "");
    }
}
package texter.general.bidi;

import openfl.display.Preloader.DefaultPreloader;
import texter.general.CharTools;
import texter.general.Char;
using TextTools;

class Bidi {
    
    public static function getTextAttributes(text:String, ?convCheck = true) {
       
        var attributes:Array<TextAttribute> = [Bidified];
        text.remove("\r");
        if (text.contains(CharTools.RLM) && convCheck) {
            //get the first RLM
            var rlmIndex = text.indexOf(CharTools.RLM);
            //get the last RLM
            var rlmEndIndex = text.lastIndexOf(CharTools.RLM);
            //get the text between the two RLM
            var rlmText = text.substring(rlmIndex + 1, rlmEndIndex);
            //get the text before the first RLM
            var rlmPreText = text.substring(0, rlmIndex);
            //get the text after the last RLM
            var rlmPostText = text.substring(rlmEndIndex + 1);
            //combine with unbifiy
            text = rlmPreText + unbidify(rlmText) + rlmPostText;
        }

        var rtlString = "";
        var ltrString = "";
        var processedNewLine = true;
        var currentLineDir = UNDETERMINED;

        function endOfStringCheck(i:Int) {
            if (i == text.length - 1) {
                if (rtlString.length > 0) {
                    attributes.push(Rtl(rtlString));
                    rtlString = "";
                } else if (ltrString.length > 0) {
                    attributes.push(Ltr(ltrString));
                    ltrString = "";
                }
                attributes.push(LineEnd);
            }
        }
        for (i in 0...text.length) {
            var char = text.charAt(i);
            if (CharTools.softChars.contains(char)) {
                if (i != text.length - 1) {
                    var ti = i;
                    var nextChar = if (convCheck) text.charAt(++ti) else text.charAt(--ti);
                    while (CharTools.softChars.contains(nextChar)) {
                        if (ti == if (convCheck) text.length - 1 else 0) {
                            if (rtlString.length > 0) {
                                rtlString += char;
                            } else if (ltrString.length > 0) {
                                ltrString += char;
                            }
                            if (convCheck) endOfStringCheck(i);
                            break;
                        }
                        nextChar = if (convCheck) text.charAt(++ti) else text.charAt(--ti);
                    }
                    if (char == CharTools.NEWLINE) {
                        if (rtlString.length > 0) {
                            attributes.push(Rtl(rtlString));
                            rtlString = "";
                        } else if (ltrString.length > 0) {
                            attributes.push(Ltr(ltrString));
                            ltrString = "";
                        }
                        attributes.push(LineEnd);
                        processedNewLine = true;
                    }
                    else if (CharTools.numbers.contains(nextChar)) {
                        if (rtlString.length > 0) {
                            rtlString += char;
                        } else if (ltrString.length > 0) {
                            ltrString += char;
                        }
                    } 
                    else if (CharTools.isRTL(nextChar)) {
                        //if the direction is RTL, spacebars should be added to the RTL string
                        if (currentLineDir == RTL) {
                            if (ltrString.length > 0) {
                                attributes.push(Ltr(ltrString));
                                ltrString = "";
                            }
                            rtlString += char;
                        } 
                        // the direction is LTR, spacebats should be added the the ltr strings
                        else {
                            if (ltrString.length > 0) {
                                ltrString += char;
                                attributes.push(Ltr(ltrString));
                                ltrString = "";
                            } else {
                                rtlString += char;
                            }
                        }
                    } else {
                        //if the direction is RTL, spacebars should be added to the RTL string
                        if (currentLineDir == RTL) {
                            if (rtlString.length > 0) {
                                rtlString += char;
                                attributes.push(Rtl(rtlString));
                                rtlString = "";
                            } else {
                                ltrString += char;
                            }
                        } 
                        // the direction is LTR, spacebats should be added the the ltr strings
                        else {
                            if (rtlString.length > 0) {
                                attributes.push(Rtl(rtlString));
                                rtlString = "";
                            } 
                            ltrString += char;
                        }
                    }
                    endOfStringCheck(i);
                    continue;
                }
                if (ltrString.length > 0) {
                    ltrString += char;
                    endOfStringCheck(i);
                    continue;
                } else if (rtlString.length > 0) {
                    rtlString += char;
                    endOfStringCheck(i);
                    continue;
                } else {
                    attributes.push(SoftChar(char, UNDETERMINED));
                    endOfStringCheck(i);
                    continue;
                }
            } 

            if (char == CharTools.NEWLINE) {
                if (rtlString.length > 0) {
                    attributes.push(Rtl(rtlString));
                    rtlString = "";
                } else if (ltrString.length > 0) {
                    attributes.push(Ltr(ltrString));
                    ltrString = "";
                }
                attributes.push(LineEnd);
                processedNewLine = true;
                currentLineDir = UNDETERMINED;

                endOfStringCheck(i);

                continue;
            }

            if (CharTools.numbers.contains(char)) {
                if (ltrString.length > 0) {
                    ltrString += char;
                    endOfStringCheck(i);
                    continue;
                } else {
                    rtlString += char;
                    endOfStringCheck(i);
                    continue;
                }
            }

            if (CharTools.isRTL(char)) {
                if (processedNewLine) {
                    attributes.push(LineDirection(RTL));
                    currentLineDir = RTL;
                    processedNewLine = false;
                }
                if (ltrString.length > 0) {
                    attributes.push(Ltr(ltrString));
                    ltrString = "";
                }
                rtlString += char;

                endOfStringCheck(i);
                
                continue;
            } else {
                if (rtlString.length > 0) {
                    attributes.push(Rtl(rtlString));
                    rtlString = "";
                }
            }

            // we have an LTR char
            if (processedNewLine) {
                attributes.push(LineDirection(LTR));
                currentLineDir = LTR;
                processedNewLine = false;
            }
            if (rtlString.length > 0) {
                attributes.push(Rtl(rtlString));
                rtlString = "";
            }
            ltrString += char;

            endOfStringCheck(i);
        }
        attributes.push(Bidified);
        return attributes;
    }

    public static function unbidify(text:String) {
        return process(text, false);
    }

    public static function process(text:String, ?convCheck:Bool = true):String {
        var attributes:Array<TextAttribute> = getTextAttributes(text, convCheck);
        return processAttributes(attributes);
    }

    public static function processAttributes(attributes:Array<TextAttribute>):String {
        var result = "";

        var currentLineDirection = UNDETERMINED;
        for (a in attributes) {
            
            switch a {
                case Bidified: result += CharTools.RLM;
                case LineDirection(letterType): continue;
                case Rtl(string): {
                    //we want to find all number groups in the string, reverse them, and then reverse the whole string
                    var numberEreg = ~/\d+/;
                    var groups = string.indexesFromEReg(numberEreg);
                    for (i in 0...groups.length) {
                        var group = groups[i];
                        var groupStr = string.substring(group.startIndex, group.endIndex);
                        var reversed = groupStr.reverse();
                        string = string.replace(groupStr, reversed);
                    }
                    result += string.reverse();

                }
                case Ltr(string): result += string;
                case SoftChar(string, generalDirection): result += string;
                case LineEnd: result += "\n";
            }
        }
        return result;
    }

    public static function stringityAttributes(array:Array<TextAttribute>):String {
        var result = "";
        for (a in array) {
            result += Std.string(a) + "\n";
        }
        return result;
    }
}
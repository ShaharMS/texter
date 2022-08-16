package texter.general.bidi;

import texter.general.CharTools;
import texter.general.Char;
using TextTools;

class Bidi {
    
    public static function getTextAttributes(text:String) {
       
       var attributes:Array<TextAttribute> = [Bidified];

        if (text.contains(CharTools.RLM)) {
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
        for (i in 0...text.length) {
            var char = text.charAt(i);
            trace(char);
            if (CharTools.softChars.contains(char)) {
                if (ltrString.length > 0) {
                    ltrString += char;
                    //END OF STRING CHECK
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

                    continue;
                } else if (rtlString.length > 0) {
                    rtlString += char;
                    //END OF STRING CHECK
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
                    continue;
                } else {
                    attributes.push(SoftChar(char, UNDETERMINED));
                    //END OF STRING CHECK
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

                //END OF STRING CHECK
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

                continue;
            }

            if (CharTools.rtlLetters.match(char)) {
                if (processedNewLine) {
                    attributes.push(LineDirection(RTL));
                    processedNewLine = false;
                }
                if (ltrString.length > 0) {
                    attributes.push(Ltr(ltrString));
                    ltrString = "";
                }
                rtlString += char;

                //END OF STRING CHECK
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
                processedNewLine = false;
            }
            if (rtlString.length > 0) {
                attributes.push(Rtl(rtlString));
                rtlString = "";
            }
            ltrString += char;

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
        attributes.push(Bidified);
        return attributes;
    }

    public static function unbidify(text:String) {
        return text;
    }

}
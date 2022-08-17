package texter.general.bidi;

import TextTools.TextDirection;

enum TextAttribute {
    Bidified;
    LineDirection(letterType:TextDirection);
    Rtl(string:String);
    Ltr(string:String);
    SoftChar(string:String, generalDirection:TextDirection);
    LineEnd();
}
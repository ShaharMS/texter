package texter.general.math;

enum MathAttribute {
    FunctionLetter(letter:String);
    Variable(letter:String);
    Number(numbers:String);
    Operator(op:String);
    Division(upperHandSide:Array<MathAttribute>, lowerHandSide:Array<MathAttribute>);
    CustomSign(char:String);
}
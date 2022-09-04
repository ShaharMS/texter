package texter.general.math;

enum MathAttribute {
    FunctionDefinition(index:Int, letter:String);
    Division(upperHandSide:Array<MathAttribute>, lowerHandSide:Array<MathAttribute>);
    Variable(index:Int, letter:String);
    Number(index:Int, letter:String);
    Sign(index:Int, letter:String);
}
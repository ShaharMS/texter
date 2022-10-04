package texter.general.math;

enum MathAttribute
{
	FunctionDefinition(index:Int, letter:String);
	Division(index:Int, upperHandSide:MathAttribute, lowerHandSide:MathAttribute);
	Variable(index:Int, letter:String);
	Number(index:Int, letter:String);
	Sign(index:Int, letter:String);
	StartClosure(index:Int, letter:String);
	EndClosure(index:Int, letter:String);
	Closure(index:Int, letter:String, content:Array<MathAttribute>);
	Null(index:Int); // fill in removed characters with this
}
